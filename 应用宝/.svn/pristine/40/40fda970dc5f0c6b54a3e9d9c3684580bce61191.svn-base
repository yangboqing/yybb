//
//  AppStoreDownload.m
//  testLoginAppStore
//
//  Created by liull on 13-10-15.
//  Copyright (c) 2013年 kydesktop. All rights reserved.
//

#import "AppStoreDownload.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

#import "encry.h"
#import "NSDictionary+noNIL.h"


#import "DownloadReport.h"
#import "NSString+Hashing.h"
#import "CJSONDeserializer.h"

#import "TMCache.h"

//快用sinf文件扩展名
#define SINF_KY         @"sinf.ky"
//苹果sinf文件扩展名
#define SINF_APPLE      @"sinf.apple"
//patch文件拓展名
#define PATCH_KY @"patch.ky"

//登陆URL
#define AUTHENTICATE_URL    "-buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/authenticate"
//购买URL
#define BUY_PRODUCT_URL     "-buy.itunes.apple.com/WebObjects/MZBuy.woa/wa/buyProduct"
//购买完成URL
#define BUY_COMPLETE_URL    "-buy.itunes.apple.com/WebObjects/MZFastFinance.woa/wa/songDownloadDone?"

#define	USER_AGENT	"iTunes/11.0.5 (Windows; Microsoft Windows 7 Ultimate Edition Service Pack 1 (Build 7601)) AppleWebKit/536.30.1"


@interface AppStoreDownload (){
}


/**登陆AppStore
 
 @return BOOL 是否登陆成功
 */
-(BOOL)loginAppStore;


/**获取ipa下载链接
 
 1.获取下载链接以及cookie
 2.获取并保存sinf文件，~/Documents/AU/$appid$.sinf
 
 @param ipaBuyInfoDic 通过getBuyAppInfo返回的信息
 @return 购买App成功后返回的信息
 */
-(NSDictionary *)buyApp:(NSDictionary*)ipaBuyInfoDic;



/**读取登陆需要的配置文件
 
 主要获取登陆账号信息
 kbsynData
 X_Apple_ActionSignature
 */
-(void)InitAppStoreAccountInfo;


/**
 查询购买信息
 
 从快用服务器查询一个应用的购买信息，用于后期购买流程。
 严格验证返回值，为nil则失败,终止后续流程。
 */
-(NSDictionary*)getBuyAppInfo:(NSString*)appid;







/**
 分析ipainfo
 
 把输入信息为key=value类型的多行信息，转换为NSDictionary
 */
-(NSDictionary *)getIpaInfo:(NSString*)ipaInfo;


/**为IPA包添加sinf文件
 
 通过购买下载的IPA里面缺少sinf文件，需要在下载后添加sinf文件
 
 @param ipaPath 需要添加sinf文件的ipa
 @param sinf sinf文件的数据
 */
-(BOOL)addsinf:(NSString*)ipaPath sinf:(NSData*)sinfdata;


/**app购买完成
 
 通知appstore:该应用已经被下载完毕
 */
-(void)buyAppComplete:(NSDictionary*)songInfo;



/**下载ipa
 根据buyApp返回信息购买app
 
 @param songInfo    从appStore返回的购买信息
 @param ipabuyinfo  从快用返回的购买信息
 */

-(void)downloadIPA:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader
           appInfo:(NSDictionary*)songInfo
        ipaBuyInfo:(NSDictionary*)ipabuyinfo;



@property(nonatomic, retain) NSString * pod;

//登陆请求头部
@property(nonatomic, retain) NSString * x_apple_actionsignature;

//登陆成功后获取的信息
@property(nonatomic, retain) NSString * xtoken;
@property(nonatomic, retain) NSString * clearToken;
@property(nonatomic, retain) NSString * xDsid;

//登陆, 购买，购买完成
@property(nonatomic, retain) NSString * guid;
@property(nonatomic, retain) NSString * machineName;

//购买
@property(nonatomic, retain) NSData * kbsync;

@property(nonatomic, retain) NSString * username;
@property(nonatomic, retain) NSString * password;

//AU目录存储根目录
@property(nonatomic, retain) NSString * auBasePath;

//存放IpaMD5
@property (nonatomic, retain) NSMutableDictionary *ipamdDict;

@end

@implementation AppStoreDownload

@synthesize pod;

@synthesize xtoken;
@synthesize clearToken;
@synthesize xDsid;

@synthesize guid;
@synthesize machineName;

@synthesize kbsync;

@synthesize username;
@synthesize password;

@synthesize x_apple_actionsignature;

@synthesize auBasePath;


@synthesize md5Str;


@synthesize isLogin,isBuy,isClean,isgetInfo;

@synthesize currentAppid;
@synthesize ipamdDict;

-(id)init {
    
    self = [super init];
    if (self) {
        self.ipamdDict = [NSMutableDictionary dictionary];
        [self InitAppStoreAccountInfo];
    }
    
    return self;
}


-(void)dealloc {
    
    self.currentAppid = nil;
    self.pod = nil;
    
    self.xtoken = nil;
    self.clearToken = nil;
    self.xDsid = nil;
    
    self.guid = nil;
    self.machineName = nil;
    
    self.kbsync = nil;
    
    self.username = nil;
    self.password = nil;
    
    self.x_apple_actionsignature = nil;
}


/**
 通过AU的方式下载
 */
-(NSUInteger)downloadIPAByAU:(NSString*)appid downloadType:(NSString *)type download:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader {
    
    isgetInfo = YES;
        
    do {
        self.currentAppid = appid;
        //获取appid信息
        NSDictionary * ipaBuyInfo = [self getBuyAppInfo:appid downloadType:type];
        if (!ipaBuyInfo) {
            isgetInfo = NO;
            return GET_BUYINFO_ERROR;
        }
        //登录
        if ( [self loginAppStore] ) {
            isLogin = YES;
            //购买
            NSDictionary * songInfo = [self buyApp:ipaBuyInfo];
            self.md5Str = [songInfo objectForKey:@"md5"];
            if (!self.md5Str&&[type isEqualToString:@"2"]) {
                self.md5Str = [ipaBuyInfo objectForKey:@"cleanipamd5"];
            }
            if (songInfo){
                //从appstore下载
                isBuy = YES;
                
                NSString *login = isLogin == YES?@"yes":@"no";
                NSString *buy = isBuy == YES?@"yes":@"no";

                [self saveFileToSendIslogin:login isBuy:buy isClean:nil appid:self.currentAppid];
                
                [self downloadIPA:downloader appInfo:songInfo ipaBuyInfo:ipaBuyInfo];
                break;
            }else{
                isBuy = NO;
            }
        }else{
            isLogin = NO;
        }
        
//        NSString *getInfo = isgetInfo == YES?@"成功":@"失败";
        NSString *login = isLogin == YES?@"yes":@"no";
        NSString *buy = isBuy == YES?@"yes":@"no";
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"获取信息:%@-登陆:%@-购买:%@",getInfo,login,buy);
//        }) ;
        [self saveFileToSendIslogin:login isBuy:buy isClean:nil appid:self.currentAppid];
        
        //从快用下载
        [self downloadIPA:downloader appInfo:nil ipaBuyInfo:ipaBuyInfo];
        
        break;
    } while (0);
    
    return DOWNLOAD_AU_SUCCESS;
}



-(void)InitAppStoreAccountInfo {

    self.pod = @"27";

    
    NSData *data = [self getLoginFileContent:[self getPath:@"kyconfig.plist"]];
    
    if (!data) {
        return;
    }
    
    NSPropertyListFormat _format;
    NSDictionary * di = [NSPropertyListSerialization propertyListFromData:data
                                                                   mutabilityOption:NSPropertyListImmutable
                                                                             format:&_format
                                                                   errorDescription:nil];
    NSMutableDictionary *appleAU = [NSMutableDictionary dictionaryWithDictionary:di];

    
    
    self.guid = [appleAU objectForKey:@"guid"];
    self.machineName = [appleAU objectForKey:@"machinename"];
    self.username = [appleAU objectForKey:@"username"];
    self.password = [appleAU objectForKey:@"password"];
    //获取NSData格式的kbsync
    NSString * temp = [appleAU objectForKey:@"kbsync"];
    NSString * plistStr = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict><key>kbsync</key><data>$kbsync$</data></dict></plist>";
    plistStr = [plistStr stringByReplacingOccurrencesOfString:@"$kbsync$" withString:temp];
    NSString *error = nil;
    NSPropertyListFormat format;
    NSDictionary* dataplist = [NSPropertyListSerialization propertyListFromData:
                               [plistStr dataUsingEncoding:NSUTF8StringEncoding]
                                                               mutabilityOption:NSPropertyListImmutable
                                                                         format:&format
                                                               errorDescription:&error ];
    self.kbsync = [dataplist objectForKey:@"kbsync"];
    
    self.x_apple_actionsignature = [appleAU objectForKey:@"x_apple_actionsignature"];
    
    
    
    //创建路径，确保路径存在
    self.auBasePath = [@"~/Documents/Apple/AU" stringByExpandingTildeInPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.auBasePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSDictionary *dataInfo = [self getLoginAccountInfo];
    if (dataInfo&&[dataInfo allKeys].count>0) {
        self.x_apple_actionsignature = [dataInfo objectForKey:@"SIGNATURE"];
        self.guid = [dataInfo objectForKey:@"GUID"];
        self.kbsync = [dataInfo objectForKey:@"KBDATA"];
        self.machineName = [dataInfo objectForKey:@"MACHINENAME"];
    }

    
    
}


-(NSDictionary*)getBuyAppInfo:(NSString*)appid downloadType:(NSString *)type{
    
    NSString * postData = @"appid=";
    postData = [postData stringByAppendingString:
                [appid stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //请求购买信息
    NSURL *url = [NSURL URLWithString:@"http://fcn_21.kuaiyong.com/Interface/i_get_au_download_url.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [ASIFormDataRequest setDefaultTimeOutSeconds:20];
    [request setValidatesSecureCertificate:NO];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request setPostBody:[NSMutableData dataWithData:[postData dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startSynchronous];
    NSError * error = [request error];
    if (error){
//        NSLog(@"getBuyAppInfo error:%@", [error description]);
        return nil;
    }
    
    /*
     {"VERSION":0,"TIME":600,"RESULT":0},{"DATALIST":[{"appid":"com.tencent.ipadqzone","inforurl":"http:\/\/pic.wanmeiyueyu.com\/Data\/APPINFOR\/29\/22\/com.tencent.ipadqzone\/ipainfo_1379174400","sinfurl":"http:\/\/pic.wanmeiyueyu.com\/Data\/APPINFOR\/29\/22\/com.tencent.ipadqzone\/sinf_1379174400"}]}
     */
    
    //返回信息为Json格式，解析数据
//    NSLog(@"%@", [request responseString]);
    
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSArray * array = [jd objectWithData:request.responseData];
    jd = nil;
    if (array.count <= 1){
        return nil;
    }

    NSDictionary *appInfoDic = [array objectAtIndex:1];
    //ipainfo下载URL
    NSString * infourl = [appInfoDic objectForKey:@"INFORURL"];
    //sinf文件下载URL
    NSString * sinfurl = [appInfoDic objectForKey:@"SINFURL"];
    
    NSString *kyDownload = [appInfoDic objectForKey:@"DOWNLOADURL"];
    
    NSString *patchurl = [appInfoDic objectForKey:@"PATCHURL"];
    
    NSString *patchMd5 = [appInfoDic objectForKey:@"PATCHMD5URL"];
    
    NSString *ipaMd5 = [appInfoDic objectForKey:@"IPAMD5URL"];
    
    
    
    [ipamdDict setObject:ipaMd5 forKey:appid];
    
    //下载ipainfo
    {
        NSURL *url = [NSURL URLWithString:infourl];
        if (!url){
            return nil;
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [ASIHTTPRequest setDefaultTimeOutSeconds:20];
        [request startSynchronous];
        NSError * error = [request error];
        if (error){
            return nil;
        }
        
        NSString * ipaInfo = [[NSString alloc] initWithData:request.responseData
                                                    encoding:NSUTF8StringEncoding];
        
//      NSLog(@"ipa info:\r\n%@", ipaInfo);
        
        //测试用
//      ipaInfo = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ipainfo" ofType:@""]
//                                          encoding:NSUTF8StringEncoding
//                                             error:nil];
        

        //分析文件，转换成字典形式
        NSMutableDictionary *dicIpaInfo = [NSMutableDictionary dictionaryWithDictionary:[self getIpaInfo:ipaInfo]];
        //增加sinfurl字段
        [dicIpaInfo setObject:sinfurl forKey:@"sinfurl"];
        //增加appid字段
        [dicIpaInfo setObject:appid forKey:@"auAppID"];
        
        [dicIpaInfo setObject:kyDownload forKey:@"cleanipa"];
        
        
        
        if( ![[dicIpaInfo allKeys] containsObject:@"price"] ) {
            [dicIpaInfo setObject:@"0" forKey:@"price"];
        }
        //判断字典的所有Key中是否包含后面字符串所代表的key，包含返回true不包含返回false
        if( ![[dicIpaInfo allKeys] containsObject:@"pricingParameters"] ) {
            [dicIpaInfo setObject:@"STDQ" forKey:@"pricingParameters"];
        }
        if( ![[dicIpaInfo allKeys] containsObject:@"productType"] ) {
            [dicIpaInfo setObject:@"C" forKey:@"productType"];
        }
        if( ![[dicIpaInfo allKeys] containsObject:@"pageName"] ) {
            [dicIpaInfo setObject:@"Genre-CN-Mobile Software Applications-29099" forKey:@"pageName"];
        }
        if( ![[dicIpaInfo allKeys] containsObject:@"products"] ) {
            [dicIpaInfo setObject:@"Mobile Software Applications-main" forKey:@"products"];
        }
        if( ![[dicIpaInfo allKeys] containsObject:@"location"] ) {
            [dicIpaInfo setObject:@"Search-CN" forKey:@"location"];
        }
        if( ![[dicIpaInfo allKeys] containsObject:@"channel"] ) {
            [dicIpaInfo setObject:@"Software Pages" forKey:@"channel"];
        }
        if ( ![[dicIpaInfo allKeys] containsObject:@"appExtVrsId"] ) {
//            NSLog(@"Error! >>>>>>>>>>>>>>>>>>>  没有 appExtVrsId 字段!!");
            return nil;
        }
        
        
        //下载快用sinf文件
        {
            NSError * error = nil;
            NSString *downloadType;
            if ([dicIpaInfo objectForKey:@"downloadtype"]) {
                downloadType = [dicIpaInfo objectForKey:@"downloadtype"];
            }else{
                downloadType = type;
            }
            NSData * singData;
            if ([type isEqualToString:@"2"]) {
                singData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sinfurl]
                                                          options:NSDataReadingUncached
                                                            error:&error];
                
                
                
                singData = [NSData dataWithContentsOfURL:[NSURL URLWithString:patchurl]
                                                 options:NSDataReadingUncached
                                                   error:&error];
                //下载patch文件的Md5验证文件
                NSData *da = [NSData dataWithContentsOfURL:[NSURL URLWithString:ipaMd5]
                                                   options:NSDataReadingUncached
                                                     error:&error];
                //取patch md5验证文件里的Md5值
                NSString * st = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
                NSDictionary *di = [self analysisJSONToDictionary:st];
                NSString *cleanipamd5 = [di objectForKey:@"MD5"];
                [dicIpaInfo setObject:cleanipamd5 forKey:@"cleanipamd5"];
                
            }else if ([type isEqualToString:@"3"]){
                //下载patch文件
                singData = [NSData dataWithContentsOfURL:[NSURL URLWithString:patchurl]
                                                          options:NSDataReadingUncached
                                                            error:&error];
                //下载patch文件的Md5验证文件
                NSData *da = [NSData dataWithContentsOfURL:[NSURL URLWithString:patchMd5]
                                                   options:NSDataReadingUncached
                                                     error:&error];
                //取patch md5验证文件里的Md5值
                NSString * st = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
                NSDictionary *di = [self analysisJSONToDictionary:st];
                //获取patch文件的md5值
                NSString *patchmd5Str = [NSString dataMD5:singData];
                NSString *_patchmdtStr = [di objectForKey:@"MD5"];
                //比较Patch文件的MD5和校验文件里的md5是否一致
                if (![patchmd5Str isEqualToString:_patchmdtStr]) {
                    return nil;
                }
                
            }
            
            
            if (singData) {
                if ([type isEqualToString:@"2"]) {
                    [singData writeToFile:
                     [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_KY]]
                               atomically:YES];
                }else if ([type isEqualToString:@"3"]){
                    [singData writeToFile:
                     [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:PATCH_KY]]
                               atomically:YES];
                }
                
            }else{
                NSLog(@"%@", [error localizedDescription]);
                
            }
        }
        return dicIpaInfo;
    }
    
}


-(BOOL)loginAppStore {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://p%@%@", self.pod, @AUTHENTICATE_URL] ];
    
    do {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [ASIFormDataRequest setDefaultTimeOutSeconds:20];
        [request setRequestMethod:@"POST"];
        
        //清空指定URL的Cookie
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = [cookies cookiesForURL:url];
        for (NSHTTPCookie* cookie in facebookCookies) {
            [cookies deleteCookie:cookie];
        }
        //不能清除所有的Cookie
        //[ASIFormDataRequest setSessionCookies:nil];
        
        NSData *postString =[self getLoginFileContent:[self getPath:@"kyconfig.data"]];
        NSDictionary *dataInfo = [self getLoginAccountInfo];
        if (dataInfo) {
            NSString *posteStr = [dataInfo objectForKey:@"POSTE"];
            postString = [posteStr dataUsingEncoding:NSUTF8StringEncoding];
        }

        //关闭自动重定向
        //request.shouldRedirect = NO;
        //忽略证书认证
        [request setValidatesSecureCertificate:NO];
        //设置请求头部
        [request addRequestHeader:@"User-Agent"
                            value:@USER_AGENT];
        [request addRequestHeader:@"Content-Type"
                            value:@"application/x-apple-plist"];//;charset=UTF-8"];
        [request addRequestHeader:@"Referer"
                            value:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewGrouping?cc=cn&id=29099&mt=8"];
        [request addRequestHeader:@"Accept-Language"
                            value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
        [request addRequestHeader:@"Connection" value:@"close"];
        [request addRequestHeader:@"X-Apple-Tz" value:@"28800"];
        [request addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
        [request addRequestHeader:@"X-Apple-ActionSignature" value:self.x_apple_actionsignature];
        
        
        //构建post数据
        //        NSString * postString = [NSString stringWithContentsOfFile:
                                //[[NSBundle mainBundle] pathForResource:@"authenticate_post_data" ofType:@"txt"]
                                //                        encoding:NSUTF8StringEncoding error:nil];
//        postString = [NSString stringWithFormat:postString, [self.username cStringUsingEncoding:NSUTF8StringEncoding],
//                      [self.guid cStringUsingEncoding:NSUTF8StringEncoding],
//                      [self.machineName cStringUsingEncoding:NSUTF8StringEncoding],
//                      [self.password cStringUsingEncoding:NSUTF8StringEncoding] ];

        //直接从文件读取
//        NSString * postString = [NSString stringWithContentsOfFile:[@"~/Documents/login_post_data.txt" stringByExpandingTildeInPath]
//                                                          encoding:NSUTF8StringEncoding error:nil];
        
        
//        NSData *_p = [postString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request appendPostData:postString];
        
        
        //发送请求
        [request startSynchronous];
        NSError *error = [request error];
        if (error) {
//            NSLog(@"%@", [request error]);
            return NO;
        }
//        NSDictionary *dict = [request responseHeaders];
        //请求成功,获取返回信息
        self.pod = [[request responseHeaders] objectForKey:@"pod"];
        
        NSPropertyListFormat format;
        
//        NSString *str = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",str);
        
        NSDictionary * responseDic = [NSPropertyListSerialization propertyListFromData:[request responseData] mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
        
        self.xtoken = [responseDic objectForKey:@"passwordToken"];
        self.clearToken = [responseDic objectForKey:@"clearToken"];
        self.xDsid = [responseDic objectForKey:@"dsPersonId"];
        
        if (self.xtoken == nil || self.clearToken == nil || self.xDsid == nil) {
            return NO;
        }
        
        self.xDsid = [dataInfo objectForKey:@"NUMID"];
        
        
        if ( [[request.responseHeaders allKeys] containsObject:@"Location"] ) {
            //重新赋值URL
            url = [NSURL URLWithString: [request.responseHeaders objectForKey:@"Location"] ];
            continue;
        }
        
        //中断
        break;
        
    } while (TRUE);
    

    return  YES;
}

-(NSDictionary *)getIpaInfo:(NSString*)ipaInfo {
    
    NSMutableDictionary * dicIpaInfo = [NSMutableDictionary dictionary];
    
    //按行切分字符串，使其变成数组
    NSArray * lines = [ipaInfo componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for ( NSString * line in lines ) {
        //找到=号位置
        NSRange equalPos = [line rangeOfString:@"=" options:NSCaseInsensitiveSearch];
        if (equalPos.location != NSNotFound) {
            //获取Key值
            NSString * name  = [line substringToIndex:equalPos.location];
            //去除空格
            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //获取value
            NSString * value = [line substringFromIndex: equalPos.location+equalPos.length];
            //用@""替代最后一位
            value = [value stringByReplacingCharactersInRange:NSMakeRange(value.length-1, 1) withString:@""];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (value && name) {
                //保存到字典中
                [dicIpaInfo setObject:value forKey:name];
            }
        }
    }
    
    /*
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=appname=).*?;"
     options:NSRegularExpressionCaseInsensitive error:nil];
     if (regex != nil) {
     NSRange resultRange = [regex rangeOfFirstMatchInString:ipaInfo
     options:0 range:NSMakeRange(0, [ipaInfo length])];
     
     NSString *result = [ipaInfo substringWithRange:resultRange];
     result = [result stringByReplacingCharactersInRange:NSMakeRange(result.length-1, 1) withString:@""];
     NSLog(@"%@",result);
     }
     */
    return dicIpaInfo;
}

-(NSDictionary *)buyApp:(NSDictionary*)ipaBuyInfoDic {
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://p%@%@", self.pod, @BUY_PRODUCT_URL] ];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [ASIFormDataRequest setDefaultTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    //忽略证书认证
    [request setValidatesSecureCertificate:NO];
    //设置请求头部
    [request addRequestHeader:@"Referer"
                        value:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app//id%@?mt=8",
                               [ipaBuyInfoDic objectForKey:@"id"]] ];
    [request addRequestHeader:@"User-Agent" value:@USER_AGENT];
    [request addRequestHeader:@"Content-Type" value:@"application/x-apple-plist;charset=UTF-8"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
    [request addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
    //登陆成功后获取
    [request addRequestHeader:@"X-Dsid" value: self.xDsid ];
    [request addRequestHeader:@"X-Token" value: self.xtoken ];
    
    //设置POST数据
    NSMutableDictionary * postDataDic = [NSMutableDictionary dictionary];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"appExtVrsId"] forKey:@"appExtVrsId"];
    [postDataDic setObject:self.guid forKey:@"guid"];
    [postDataDic setObject:self.kbsync forKey:@"kbsync"];
    [postDataDic setObject:self.machineName forKey:@"machineName"];
    [postDataDic setObject:@"0" forKey:@"needDiv"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"location"] forKey:@"origPage"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"pageName"] forKey:@"origPage2"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"products"] forKey:@"origPageCh"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"channel"] forKey:@"origPageCh2"];
    //    [postDataDic setObject:@"" forKey:@"origPage"];
    //    [postDataDic setObject:@"" forKey:@"origPage2"];
    //    [postDataDic setObject:@"" forKey:@"origPageCh"];
    //    [postDataDic setObject:@"" forKey:@"origPageCh2"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"price"] forKey:@"price"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"pricingParameters"] forKey:@"pricingParameters"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"productType"] forKey:@"productType"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"id"] forKey:@"salableAdamId"];
    [postDataDic setObject:@"true" forKey:@"hasAskedToFulfillPreorder"];
    [postDataDic setObject:@"true" forKey:@"hasDoneAgeCheck"];
    //NSDictionary --> NSData
    NSMutableData * data = [NSMutableData dataWithData:
                            [NSPropertyListSerialization dataFromPropertyList: postDataDic
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:nil]];
    [request appendPostData:data];
    
    
    //发送请求
    [request startSynchronous];
    NSError *error = [request error];
    if (error) {
//        NSLog(@"%@", [request error]);
        return nil;
    }
    
    //NSLog(@"post body:\r\n%@", postString);
    //NSLog(@"post cookies:%@", request.requestCookies);
    //NSLog(@"buy app respond:\r\n%@", request.responseString);
    NSPropertyListFormat format;
    NSDictionary * buyResultDic = [NSPropertyListSerialization propertyListFromData:request.responseData
                                                                   mutabilityOption:NSPropertyListImmutable
                                                                             format:&format
                                                                   errorDescription:nil];
//    NSLog(@"%@", [buyResultDic description]);
    
    //检测成功还是失败
    if ( ![[buyResultDic objectForKey:@"jingleDocType"] isEqualToString:@"purchaseSuccess" ] ) {
//        NSLog(@"购买失败");
        return nil;
    }
    
    
    //购买完成,获取该app对应的信息
    NSArray * songList = [buyResultDic objectForKey:@"songList"];
    NSDictionary * songInfo = nil;
    for (NSDictionary * song in songList) {
        if ( [[[song objectForKey:@"songId"] stringValue] isEqualToString: [ipaBuyInfoDic objectForKey:@"id"]] ) {
            songInfo = song;
            break;
        }
    }
    
    if (songInfo) {
        //保存sinf文件
        NSString *appid = [ipaBuyInfoDic objectForKey:@"auAppID"];
        NSData * sinfdata = [[[songInfo objectForKey:@"sinfs"] objectAtIndex:0] objectForKey:@"sinf"];
        [sinfdata writeToFile:[self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_APPLE]]
                   atomically:YES];
        
        //通知已经购买完成
        [self buyAppComplete:songInfo];
    }
    
    return  songInfo;
}


-(void)buyAppComplete:(NSDictionary*)songInfo {
    
    
    NSURL * url = [NSURL URLWithString:
                   [NSString stringWithFormat:@"https://p%@%@guid=%@&download-id=%@",
                    self.pod,@BUY_COMPLETE_URL, self.guid, [songInfo objectForKey:@"download-id"]] ];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [ASIFormDataRequest setDefaultTimeOutSeconds:20];
    //忽略证书认证
    [request setValidatesSecureCertificate:NO];
    
    
    [request addRequestHeader:@"User-Agent" value:@USER_AGENT];
    [request addRequestHeader:@"Accept-Language" value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
    [request addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
    [request addRequestHeader:@"Connection" value:@"close"];
    [request addRequestHeader:@"X-Apple-Tz" value:@"28800"];
    
    [request addRequestHeader:@"Referer"
                        value:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app//id%@?mt=8",
                               [[songInfo objectForKey:@"songId"] stringValue] ]];
    [request addRequestHeader:@"X-Dsid" value:self.xDsid];
    [request addRequestHeader:@"X-Token" value:self.xtoken];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (error){
//        NSLog(@"downComplete error:%@", [error description]);
        return;
    }
    
//    NSString *response = [request responseString];
//    NSLog(@"downComplete response:\r\n%@", response);
    
//    NSLog(@"downComplete responseHeaders:\r\n%@", [request responseHeaders]);
    
}


-(void)downloadIPA:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader
           appInfo:(NSDictionary*)songInfo
        ipaBuyInfo:(NSDictionary*)ipabuyinfo {
    
    NSDictionary * dicHttpHeaders = nil;
    if (songInfo)
        dicHttpHeaders = [NSDictionary dictionaryWithObjectsAndKeys:
                          @USER_AGENT, @"User-Agent",
                          @"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25", @"Accept-Language",
                          [@"downloadKey=" stringByAppendingString:[songInfo objectForKey:@"downloadKey"]],
                          @"Cookie",
                          nil];
    

    
    NSString * ipaURL = [songInfo objectForKey:@"URL"];
    isClean = YES;
    if (!ipaURL) {
        //从快用下载
        isClean = NO;
        ipaURL = [ipabuyinfo objectForKey:@"cleanipa"];
    }
    
    
    NSString *clean = isClean == YES?@"yes":@"no";
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"%@-纯净包",clean);

//    });
    [self saveFileToSendIslogin:nil isBuy:nil isClean:clean appid:self.currentAppid];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        downloader(dicHttpHeaders, ipaURL);
    });
    
}


-(BOOL)addsinf:(NSString*)ipaPath sinf:(NSData*)sinfdata type:(downloadType)_type{
    
    NSString * suppPath = nil;

    //遍历zip文件，找到sinf保存的路径
    
    @try {
        ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:ipaPath
                                                          mode:ZipFileModeUnzip];
        NSArray *infos= [unzipFile listFileInZipInfos];
        for (FileInZipInfo *info in infos) {

            if( [info.name hasSuffix:@"supp"] &&
               [[info.name stringByDeletingLastPathComponent] hasSuffix:@"SC_Info"]
               ){
                
                suppPath = info.name;
                break;
            }
        }
        
        if (unzipFile) {
            [unzipFile close];
            unzipFile = nil;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
    }
    

    //添加sinf文件
    @try {
        
        NSString * sinfPath;
        
        sinfPath = [[suppPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"sinf"];
        //写入sinf文件
        ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ipaPath mode:ZipFileModeAppend];
        ZipWriteStream *stream1= [zipFile writeFileInZipWithName:sinfPath compressionLevel:ZipCompressionLevelDefault];
        [stream1 writeData:sinfdata];
        [stream1 finishedWriting];
        
        
        [zipFile close];
        zipFile = nil;
        
        
        
    }
    @catch (NSException *exception) {
//        NSLog(@"%@", [exception description]);
        return NO;
    }
    @finally {
        
    }

    return YES;
}

-(BOOL)addPatch:(NSString*)ipaPath sinf:(NSData*)sinfdata type:(downloadType)_type{
    NSString *_Path = nil;

    NSString *appid = [[ipaPath lastPathComponent] stringByDeletingPathExtension];
    NSString *patchPath = [appid stringByAppendingPathExtension:PATCH_KY];
    patchPath = [self.auBasePath stringByAppendingPathComponent:patchPath];
    ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:patchPath
                                                      mode:ZipFileModeUnzip];
    
    NSMutableArray *array = [NSMutableArray array];
    BOOL  lbOK = [unzipFile goToFirstFileInZip];
    
    while (lbOK) {
        FileInZipInfo *info = [unzipFile currentFileInZipInfo];
        NSString *fileInfo= [NSString stringWithFormat:@"- %@ ||| %@ ||| %lu ||| (%d)",
                             info.name, info.date, (unsigned long)info.size, info.level];
        
        if (info.size > 0) {
            ZipReadStream *readStream = [unzipFile readCurrentFileInZip];
            NSData * data = readFile(readStream);
            NSMutableDictionary *_dict = [NSMutableDictionary dictionary];
            [_dict setObject:info.name forKey:@"name"];
            [_dict setObject:data forKey:@"data"];
            [array addObject:_dict];
        }

        lbOK = [unzipFile goToNextFileInZip];
    }

    
    //遍历zip文件，找到保存的路径
    
    @try {
        ZipFile *_unzipFile = [[ZipFile alloc] initWithFileName:ipaPath
                                                          mode:ZipFileModeUnzip];
        NSArray *_infos= [_unzipFile listFileInZipInfos];
        for (FileInZipInfo *_info in _infos) {

            if( [_info.name hasSuffix:@"CodeResources"] &&
               [[_info.name stringByDeletingLastPathComponent] hasSuffix:@"_CodeSignature"]
               ){
                
                NSUInteger index = [array indexOfObjectPassingTest:^ BOOL (id tr,NSUInteger index, BOOL *te){
                    NSString *name = [(NSMutableDictionary*)tr  objectForKey:@"name"];
                    if( [[name lastPathComponent] isEqualToString:[_info.name lastPathComponent]] &&
                       [[[name stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:[[_info.name stringByDeletingLastPathComponent] lastPathComponent]]
                       )
                    {
                        [self writeFileToPath:_info.name ipapath:ipaPath fileData:[(NSMutableDictionary*)tr objectForKey:@"data"]];
                        return YES;
                    }
                    return NO;
                }];
                
                [array removeObjectAtIndex:index];

                _Path = [[_info.name stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
                
                break;
            }

        }

        for (NSMutableDictionary *_dict in array) {
            NSString *filePath = [_Path stringByAppendingPathComponent:[[_dict objectForKey:@"name"] lastPathComponent]];
            [self writeFileToPath:filePath ipapath:ipaPath fileData:[_dict objectForKey:@"data"]];
        }

        if (unzipFile) {
            [unzipFile close];
            unzipFile = nil;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
    }
    
    

    return YES;

}




/**组装ipa
 
 ipa下载完毕后，需要进一步处理，增加sinf  或 patch文件。
 
 @param ipaPath ipa的路径
 @param appid ipa的appid
 */
-(BOOL)packageIPA:(NSString*)ipaPath appid:(NSString*)appid type:(downloadType)dtype{
    
    NSString * sinfPath = nil;
    if (dtype == DOWNLOAD_AU) {
        
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_APPLE]];
        //是否存在苹果sinf
        if ( ![[NSFileManager defaultManager] fileExistsAtPath: sinfPath] ) {
            sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_KY]];
            if ( ![[NSFileManager defaultManager] fileExistsAtPath: sinfPath] ) {

                return FALSE;
            }
        }
        
    }else if (dtype == DOWNLOAD_EU){
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:PATCH_KY]];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath: sinfPath] ) {
            return FALSE;
        }

        NSData*ipaData = [NSData dataWithContentsOfFile:ipaPath];
        
        //下载ipa文件的Md5验证文件
        NSData *da = [NSData dataWithContentsOfURL:[NSURL URLWithString:[ipamdDict objectForKey:appid]]
                                           options:NSDataReadingUncached
                                             error:nil];
        //取patch md5验证文件里的Md5值
        NSString * st = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
        NSDictionary *di = [self analysisJSONToDictionary:st];
        //获取patch文件的md5值
        NSString *patchmd5Str = [NSString dataMD5:ipaData];
        NSString *_patchmdtStr = [di objectForKey:@"MD5"];
        //比较Patch文件的MD5和校验文件里的md5是否一致
        if (![patchmd5Str isEqualToString:_patchmdtStr]) {
            
            sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:PATCH_KY]];
            [[NSFileManager defaultManager] removeItemAtPath:sinfPath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:ipaPath error:nil];
            
            return FALSE;
        }

    }else if (dtype == DOWNLOAD_CU){
        
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:@".sinf"]];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath: sinfPath] ) {
            return FALSE;
        }
    }
    
    NSData * sinfdata = [NSData dataWithContentsOfFile: sinfPath ];
    BOOL bRet;
    if (dtype == DOWNLOAD_EU) {
        bRet = [self addPatch:ipaPath sinf:sinfdata type:dtype];
    }else{
        bRet = [self addsinf:ipaPath sinf:sinfdata type:dtype];
    }
    
    //合并完成后清理sinf文件
    {
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_APPLE]];
        [[NSFileManager defaultManager] removeItemAtPath:sinfPath error:nil];
        
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_KY]];
        [[NSFileManager defaultManager] removeItemAtPath:sinfPath error:nil];
        
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:PATCH_KY]];
        [[NSFileManager defaultManager] removeItemAtPath:sinfPath error:nil];
    }
    
    return bRet;
    
}




- (NSString *)getLocalLoginFilePath{
    
    /*
     以下文件安装应用和闪退修复时写入
     /iTunes_Control/iTunes/kyconfig.plist
     /iTunes_Control/iTunes/kyconfig.data
     加密秘钥
     #define KYAP_CRYPT_DEFAULTK_DOC_KY 0xE7A35409
     
     
     基本内容
     plist内容
     
     guid
     machinename
     username
     password
     kbsync
     x_apple_actionsignature
     group （这个目前没用）
     
     data为POST信息
     */
    
    
    NSString *_path = [self getPath:@"kyconfig.data"];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:_path] ) {
        return _path ;
    }
    
    return nil;
    
}

- (NSData *)getLoginFileContent:(NSString *)str{
    
    NSString *dataFile = str;//[self getLocalLoginFilePath];
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    if (dataFile == nil) {
        return nil;
    }else{
        if (data) {
            char * decBuf = (char *)malloc(data.length+1);
            memset(decBuf, 0, data.length+1);
            int decLength=0;
            kyap_crypt( (char *)data.bytes, data.length, KYAP_CRYPT_DEFAULTK_DOC_KY, decBuf, &decLength);
//            NSMutableString * strJson = [NSMutableString stringWithCString:decBuf encoding:NSUTF8StringEncoding];
            NSData * data = [NSData dataWithBytes:decBuf length:decLength];
            free(decBuf);
            return data;
            
//            NSMutableString * strJson = [NSMutableString stringWithCString:decBuf encoding:NSUTF8StringEncoding];
//            if (!strJson || strJson.length <= 0) {
//                free(decBuf);
//                return nil;
//            }else{
//                return strJson;
//            }
            
        }
    }
    
    
    
    return nil;
}


- (NSString *)getPath:(NSString *)path{
    
    NSString *_path = [NSString stringWithFormat:@"/var/mobile/Media/iTunes_Control/iTunes/%@",path];
    return _path;
    
}
- (void)saveFileToSendIslogin:(NSString *)localLogin isBuy:(NSString *)localBuy isClean:(NSString *)localClean appid:(NSString *)localappid{
    
    NSMutableDictionary *dic = [[DownloadReport getObject] getReportFileDicByAppID:localappid];
    if (!dic)
        dic = [NSMutableDictionary dictionary];

    
    [dic setObjectNoNIL:localLogin forKey:REPORT_AULOGIN];
    [dic setObjectNoNIL:localBuy forKey:REPORT_AUBUY];
    [dic setObjectNoNIL:localClean forKey:REPORT_AUCLEAN];
    
    [[DownloadReport getObject] updateReportFile:dic];
}

-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSDICTIONARY(root))
        return nil;
    
    return root;
}

NSData* readFile(ZipReadStream *readStream) {
    
    //预分配5M
    NSMutableData * data = [NSMutableData dataWithCapacity:1024*1024*5];
    while (YES) {
        @autoreleasepool {
            NSData *data1 = [readStream readDataOfLength:1024*1024];
            if(data1.length < 1024*1024) {
                [data appendData:data1];
                break;
            }
            [data appendData:data1];
        }
    }
    [readStream finishedReading];
    return data;
}

- (void)writeFileToPath:(NSString*)filepath ipapath:(NSString *)ipapath fileData:(NSData*)data{
    //添加文件
    @try {

        //写入文件
        ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ipapath mode:ZipFileModeAppend];
        ZipWriteStream *stream1= [zipFile writeFileInZipWithName:filepath compressionLevel:ZipCompressionLevelDefault];
        [stream1 writeData:data];
        [stream1 finishedWriting];
        
        
        [zipFile close];
        zipFile = nil;

    }
    @catch (NSException *exception) {


    }
    @finally {
        
    }

}

- (NSDictionary *)getLoginAccountInfo{

    NSDictionary *dataDic = [[FileUtil instance] getLoginKey];
    
    return dataDic;
    
}


@end