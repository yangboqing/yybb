//
//  AppStoreNewDownload.m
//  browser
//
//  Created by 王毅 on 15/1/26.
//
//

#import "AppStoreNewDownload.h"
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
#import "LoginServerManage.h"
#import "TMCache.h"

@interface AppStoreNewDownload ()

@property(nonatomic, strong) NSString * pod;
//AU目录存储根目录
@property(nonatomic, strong) NSString * auBasePath;
//登陆请求头部
@property(nonatomic, strong) NSString * x_apple_actionsignature;
//登陆成功后获取的信息
@property(nonatomic, strong) NSString * xtoken;
@property(nonatomic, strong) NSString * clearToken;
@property(nonatomic, strong) NSString * xDsid;
//登陆, 购买，购买完成
@property(nonatomic, strong) NSString * guid;
@property(nonatomic, strong) NSString * machineName;
//购买
@property(nonatomic, strong) NSData * kbsync;
@property(nonatomic, strong) NSString * username;
@property(nonatomic, strong) NSString * password;
@property(nonatomic, strong) NSString *postString;

@property(nonatomic, strong) NSString *creditString;

@end





@implementation AppStoreNewDownload


-(id)init {
    
    self = [super init];
    if (self) {
        [self InitAppStoreAccountInfo];
    }
    
    return self;
}

-(void)InitAppStoreAccountInfo {
    
    self.pod = @"27";

    //创建路径，确保路径存在
    self.auBasePath = [@"~/Documents/Apple/AU" stringByExpandingTildeInPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.auBasePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSDictionary *dataInfo = [self getLoginAccountInfo];
    if (dataInfo) {
        self.x_apple_actionsignature = [dataInfo objectForKey:@"SIGNATURE"];
        self.guid = [dataInfo objectForKey:@"GUID"];
        self.kbsync = [dataInfo objectForKey:@"KBDATA"];
        self.machineName = [dataInfo objectForKey:@"MACHINENAME"];
        self.postString = [dataInfo objectForKey:@"POSTE"];
        self.xDsid = [dataInfo objectForKey:@"NUMID"];
    }

}

/**
 通过AU的方式下载
 */
-(NSUInteger)downloadIPAByAU:(NSString*)appid download:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader {
    
    isgetInfo = YES;
    
    do {
        self.currentAppid = appid;
        //获取appid信息
        NSDictionary * ipaBuyInfo = [self getIpaInfo:appid];
        if (!ipaBuyInfo) {
            NSLog(@"新AU获取信息失败");
            isgetInfo = NO;
            return GET_BUYINFO_ERROR;
        }
        NSLog(@"开始登录");
        //登录
        if ( [self loginAppStore:appid] ) {
            NSLog(@"登录成功");
            isLogin = YES;
            //购买
            NSLog(@"开始购买");
            NSDictionary * songInfo = [self buyApp:ipaBuyInfo];
            self.md5Str = [ipaBuyInfo objectForKey:@"cleanipamd5"];
            if (!songInfo) {
                NSLog(@"购买失败");
                isBuy = NO;
                return GET_BUYINFO_ERROR;
            }else{
                NSLog(@"购买成功,从appstore下载");
                //从appstore下载
                isBuy = YES;
                self.md5Str = [songInfo objectForKey:@"md5"];
                NSString *login = isLogin == YES?@"yes":@"no";
                NSString *buy = isBuy == YES?@"yes":@"no";
                
                [self saveFileToSendIslogin:login isBuy:buy isClean:nil appid:self.currentAppid];
                
                [self downloadIPA:downloader appInfo:songInfo ipaBuyInfo:ipaBuyInfo];
                break;
            }
            
        }else{
            NSLog(@"登录失败,去企签下载");
            isLogin = NO;
        }
        
        NSString *login = isLogin == YES?@"yes":@"no";
        NSString *buy = isBuy == YES?@"yes":@"no";

        [self saveFileToSendIslogin:login isBuy:buy isClean:nil appid:self.currentAppid];
         /*****
          
          My助手去掉 AU下载失败返回企签下载
          
        *****/
        
//        //从快用下载
//        NSLog(@"从快用下载企签版");
//        [self downloadIPA:downloader appInfo:nil ipaBuyInfo:ipaBuyInfo];
        
        break;
    } while (0);
    
    return DOWNLOAD_AU_SUCCESS;
}

-(NSDictionary *)getIpaInfo:(NSString*)appid{
    NSDictionary *dic = @{};
    
    NSString *headStr = GET_AU_APPINFO_HEAD;
    
    NSString *urlhead = @"appid=";//@"r=settings/getEuInfo&appid=";
    urlhead = [urlhead stringByAppendingString:appid];
    urlhead = [self getDESString:urlhead];
    urlhead = [headStr stringByAppendingString:urlhead];
    //请求购买信息
    NSURL *url = [NSURL URLWithString:urlhead];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    NSError * error = [request error];
    if (error){
        return nil;
    }
        NSString *responseString = [request responseString];
        NSMutableDictionary * dataMap = [NSMutableDictionary dictionaryWithDictionary:[[FileUtil instance] analysisJSONToDictionary:responseString]];

    if (!dataMap || ![dataMap objectForKey:@"data"]) {
        return nil;
    }

    NSString *requestUrl = [dataMap objectForKey:@"data"];
    
    NSString *plistUrlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestUrl] encoding:NSUTF8StringEncoding error:nil];
    dic = [self getDictionaryFromString:plistUrlStr];
    
    if ( ![[dic allKeys] containsObject:@"appExtVrsId"] ) {
            NSLog(@"Error! >>>>>>>>>>>>>>>>>>>  没有 appExtVrsId 字段!!");
        return nil;
    }
    return dic;
}
-(BOOL)loginAppStore:(NSString*)appid{

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
        
        NSData *poste =[self.postString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request appendPostData:poste];
        
        
        //发送请求
        [request startSynchronous];
        NSError *error = [request error];
        if (error) {
            NSLog(@"%@", [request error]);
            return NO;
        }
        //请求成功,获取返回信息
        self.pod = [[request responseHeaders] objectForKey:@"pod"];
        
        NSPropertyListFormat format;
        
        NSDictionary * responseDic = [NSPropertyListSerialization propertyListFromData:[request responseData] mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
        
        self.creditString = [responseDic objectForKey:@"creditDisplay"]?[responseDic objectForKey:@"creditDisplay"]:nil;
        
        self.xtoken = [responseDic objectForKey:@"passwordToken"];
        self.clearToken = [responseDic objectForKey:@"clearToken"];
        
        if (self.xtoken == nil || self.clearToken == nil) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[LoginServerManage getManager] reportAccountError:[responseDic objectForKey:@"failureType"]?[responseDic objectForKey:@"failureType"]:@"" loginMessage:[responseDic objectForKey:@"customerMessage"]?[responseDic objectForKey:@"customerMessage"]:@"" loginText:[responseDic objectForKey:@"customerMessage"]?[responseDic objectForKey:@"customerMessage"]:@"" buyCode:@"" buyMessage:@"" buyText:@"" isDelete:NO];
            });
            
            return NO;
        }
        
        
        {
            NSString *appleid = [[responseDic objectForKey:@"accountInfo"] objectForKey:@"appleId"];
            NSString *firstName = [[[responseDic objectForKey:@"accountInfo"] objectForKey:@"address"] objectForKey:@"firstName"];
            NSString *lastName = [[[responseDic objectForKey:@"accountInfo"] objectForKey:@"address"] objectForKey:@"lastName"];
            
            NSString* userName = [firstName stringByAppendingString:lastName];
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:appleid,@"appleId",userName,@"userName", nil];
            
            [self writeMetaDataToLocal:appid info:info];
        }
        
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

-(NSDictionary *)buyApp:(NSDictionary*)ipaBuyInfoDic{
    
    NSDictionary *buyResultDic = [self requestBuyInfo:ipaBuyInfoDic isAgain:NO];
    
    //如果没有通过购买
    if ( ![[buyResultDic objectForKey:@"jingleDocType"] isEqualToString:@"purchaseSuccess" ] ) {
        NSString *_failStr = [buyResultDic objectForKey:@"customerMessage"];
        //因为已经购买过并未下载导致的没通过购买
        if ([_failStr isEqualToString:@"正在下载项目"]) {
            
            //用再次购买的地址，修正购买未成功的问题
            buyResultDic = [self requestBuyInfo:ipaBuyInfoDic isAgain:YES];
            //依然没有通过购买流程
            if ( ![[buyResultDic objectForKey:@"jingleDocType"] isEqualToString:@"pendingSongsSuccess"] ) {
                        NSLog(@"购买失败");
                [self sendBuyErrorReport:buyResultDic isDelete:NO];
                return nil;
            }

        }else if ([_failStr isEqualToString:@"发生未知错误"]){
            //用再次购买的地址，修正购买未成功的问题
            buyResultDic = [self requestBuyInfo:ipaBuyInfoDic isAgain:NO];
            //依然没有通过购买流程
            if ( ![[buyResultDic objectForKey:@"jingleDocType"] isEqualToString:@"pendingSongsSuccess"] ) {
                NSLog(@"购买失败");
                [self sendBuyErrorReport:buyResultDic isDelete:NO];
                return nil;
            }

        }else if ([_failStr isEqualToString:@"您的点数余额已过期"]){
            NSLog(@"您的点数余额已过期");
            [self sendBuyErrorReport:buyResultDic isDelete:NO];
            return nil;
        }else if (!_failStr) {
            NSLog(@"无错误码,可能是未同意协议等原因");
//            [self sendBuyErrorReport:buyResultDic isDelete:NO];
            return nil;
        }else if ([_failStr rangeOfString:@"已被停用"].location !=NSNotFound){
            [self sendBuyErrorReport:buyResultDic isDelete:YES];
            return nil;
        }

    }else if (!buyResultDic){
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
    
    NSMutableDictionary *infoDic = [[songList objectAtIndex:0] objectForKey:@"metadata"];
    [self writeMetaDataToLocal:[infoDic objectForKey:@"softwareVersionBundleId"] info:infoDic];
    
    if (songInfo) {
        //保存sinf文件
        NSString *appid = [ipaBuyInfoDic objectForKey:@"auAppID"]?[ipaBuyInfoDic objectForKey:@"auAppID"]:self.currentAppid;
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



//把文件里的字符串解析成字典格式
- (NSDictionary*)getDictionaryFromString:(NSString *)fileString{
    
    NSMutableDictionary * dicIpaInfo = [NSMutableDictionary dictionary];
    
    //按行切分字符串，使其变成数组
    NSArray * lines = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
            value = [FileUtil replaceUnicode:value];
            if (value && name) {
                //保存到字典中
                [dicIpaInfo setObject:value forKey:name];
            }
        }
    }
    
    return (NSDictionary*)dicIpaInfo;
}

- (NSDictionary *)getLoginAccountInfo{
    
    NSDictionary *dataDic = [[FileUtil instance] getLoginKey];
    
    return dataDic;
    
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
//        ipaURL = [ipabuyinfo objectForKey:@"cleanipa"];
        ipaURL = nil;
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

- (NSString *)getDESString:(NSString *)string{
    return [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:string key:@"i2.0908o"]];
}

- (NSDictionary*)requestBuyInfo:(NSDictionary*)ipaBuyInfoDic isAgain:(BOOL)isAgain{
    NSURL *url;
    
    BOOL hasiTunesLicenseChanged = NO;
    
    if (![ipaBuyInfoDic objectForKey:@"id"] || ![ipaBuyInfoDic objectForKey:@"appExtVrsId"]) {
        NSLog(@"id 或 appExtVrsId 为假");
        return nil;
    }

    if (isAgain) {
        //已经购买过并未下载后，再次进行购买
        url = [NSURL URLWithString: [NSString stringWithFormat:@"https://p%@%@", self.pod, @BUY_AGAIN_URL] ];
    }else{
        //首次购买地址
        url = [NSURL URLWithString: [NSString stringWithFormat:@"https://p%@%@", self.pod, @BUY_PRODUCT_URL] ];
    }
    
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
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"pageName"]?[ipaBuyInfoDic objectForKey:@"pageName"]:@"Genre-CN-Mobile Software Applications-29099" forKey:@"origPage"];
//    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"pageName"] forKey:@"origPage2"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"channel"]?[ipaBuyInfoDic objectForKey:@"channel"]:@"Software Pages" forKey:@"origPageCh"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"location"]?[ipaBuyInfoDic objectForKey:@"location"]:@"Buy" forKey:@"origPageLocation"];
    [postDataDic setObject:@"0" forKey:@"price"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"pricingParameters"]?[ipaBuyInfoDic objectForKey:@"pricingParameters"]:@"STDQ" forKey:@"pricingParameters"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"productType"]?[ipaBuyInfoDic objectForKey:@"productType"]:@"C" forKey:@"productType"];
    [postDataDic setObject:[ipaBuyInfoDic objectForKey:@"id"] forKey:@"salableAdamId"];

    if (self.creditString) {
        [postDataDic setObject:self.creditString forKey:@"creditDisplay"];
    }
    
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
        return nil;
    }
    
    NSPropertyListFormat format;
    NSDictionary * buyResultDic = [NSPropertyListSerialization propertyListFromData:request.responseData
                                                                   mutabilityOption:NSPropertyListImmutable
                                                                             format:&format
                                                                   errorDescription:nil];
    //解决协议变更的问题
    
    if (![buyResultDic objectForKey:@"customerMessage"]) {
        
        [self openLicensePageWithIpaInfor:ipaBuyInfoDic andbuyResult:buyResultDic];
    }

    return buyResultDic;
}

- (void)openLicensePageWithIpaInfor:(NSDictionary *)ipaBuyInfoDic andbuyResult:(NSDictionary *)buyResultDic{
    
    
    //首次请求同意协议的url地址
    ASIHTTPRequest *request_= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[buyResultDic objectForKey:@"action"] objectForKey:@"url"]]];
    [ASIFormDataRequest setDefaultTimeOutSeconds:20];
    [request_ setRequestMethod:@"GET"];
    //忽略证书认证
    [request_ setValidatesSecureCertificate:NO];
    //设置请求头部
    [request_ addRequestHeader:@"Referer"
                         value:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app//id%@?mt=8",
                                [ipaBuyInfoDic objectForKey:@"id"]] ];
    [request_ addRequestHeader:@"User-Agent" value:@USER_AGENT];
    [request_ addRequestHeader:@"Content-Type" value:@"application/x-apple-plist;charset=UTF-8"];
    [request_ addRequestHeader:@"Accept-Language" value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
    [request_ addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
    //登陆成功后获取
    [request_ addRequestHeader:@"X-Dsid" value: self.xDsid ];
    [request_ addRequestHeader:@"X-Token" value: self.xtoken ];
    
    [request_ startSynchronous];
    NSString *response =  request_.responseString;
    
    
    //模拟提交同意
    [self commitLicensePageWithIpaInfor:ipaBuyInfoDic andbuyResult:buyResultDic andResponse:response];
}


- (void)commitLicensePageWithIpaInfor:(NSDictionary *)ipaBuyInfoDic andbuyResult:(NSDictionary *)buyResultDic andResponse:(NSString *)response{
    
    //是否包含可用的url
    if ([[response componentsSeparatedByString:@"<key>url</key><string>"] count]) {
        
        
        //拼接url
        NSRange range = [response rangeOfString:@"action=\""];
        NSString *actionString = [response substringWithRange:NSMakeRange(range.location + range.length, 100)];
        actionString = [actionString componentsSeparatedByString:@"\""][0];
        
        //PC端请求首位数字为0
        //            actionString = @"/WebObjects/MZFinance.woa/wo/0.2.0.1.1.3.1.7.11.3";
        
        
        NSString *agreeURLString = [NSString stringWithFormat:@"https://p%@%@%@",self.pod,@"-buy.itunes.apple.com",actionString];
        
        
        //id="iagree"
        // id="continue"
        
        range = [response rangeOfString:@"id=\"iagree"];
        NSString *checkBoxString = [response substringWithRange:NSMakeRange(range.location + range.length, 100)];
        checkBoxString = [checkBoxString componentsSeparatedByString:@"name=\""][1];
        checkBoxString = [checkBoxString componentsSeparatedByString:@"\""][0];
        
        range = [response rangeOfString:@"id=\"continue"];
        NSString *submitString = [response substringWithRange:NSMakeRange(range.location + range.length, 100)];
        submitString = [submitString componentsSeparatedByString:@"name=\""][1];
        submitString = [submitString componentsSeparatedByString:@"\""][0];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:agreeURLString]];
        [ASIFormDataRequest setDefaultTimeOutSeconds:20];
        [request setRequestMethod:@"POST"];
        //忽略证书认证
        [request setValidatesSecureCertificate:NO];
        //设置请求头部
        [request addRequestHeader:@"Referer"
                            value:[[buyResultDic objectForKey:@"action"] objectForKey:@"url"]];

        [request addRequestHeader:@"User-Agent" value:@USER_AGENT];
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [request addRequestHeader:@"Accept-Language" value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
        [request addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
        //登陆成功后获取
        [request addRequestHeader:@"X-Dsid" value: self.xDsid ];
        [request addRequestHeader:@"X-Token" value: self.xtoken ];
        
        
        //设置POST数据

        [request setPostValue:checkBoxString forKey:checkBoxString];
        [request setPostValue:@"%E5%90%8C%E6%84%8F" forKey:submitString];
//        
//        NSMutableDictionary * postDataDic = [NSMutableDictionary dictionary];
//        [postDataDic setObject:checkBoxString forKey:checkBoxString];
//        [postDataDic setObject:@"%E5%90%8C%E6%84%8F" forKey:submitString];
//        
//        
//        NSMutableData * data_ = [NSMutableData dataWithData:
//                                 [NSPropertyListSerialization dataFromPropertyList: postDataDic
//                                                                            format:NSPropertyListXMLFormat_v1_0
//                                                                  errorDescription:nil]];
//        
//        
//        
//        [request appendPostData:data_];
        sleep(1);
        [request startSynchronous];
        NSString *response_ = request.responseString;
        
        
        NSLog(@"%@",response_);
    }
    

}

-(BOOL)addsinf:(NSString*)ipaPath sinf:(NSData*)sinfdata{
    
//    NSString * suppPath = nil;
    
    NSMutableArray *infonames = [[NSMutableArray alloc] init];
    
    //遍历zip文件，找到sinf保存的路径
    
    @try {
        ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:ipaPath
                                                          mode:ZipFileModeUnzip];
        NSArray *infos= [unzipFile listFileInZipInfos];
        for (FileInZipInfo *info in infos) {
            
            if( [info.name hasSuffix:@"supp"] &&
               [[info.name stringByDeletingLastPathComponent] hasSuffix:@"SC_Info"]){
                
//                suppPath = info.name;
                [infonames addObject:info.name];
//                break;
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
    
    
    if (infonames.count > 0) {
        //添加sinf文件
        @try {
            
            for (NSString *_suppPath in infonames) {
                NSString * sinfPath;
                
                sinfPath = [[_suppPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"sinf"];
                //写入sinf文件
                ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ipaPath mode:ZipFileModeAppend];
                ZipWriteStream *stream1= [zipFile writeFileInZipWithName:sinfPath compressionLevel:ZipCompressionLevelDefault];
                [stream1 writeData:sinfdata];
                [stream1 finishedWriting];
                [zipFile close];
                zipFile = nil;
            }

        }
        @catch (NSException *exception) {
            //        NSLog(@"%@", [exception description]);
            return NO;
        }
        @finally {
            
        }

    }
    
    
    
    return YES;
}
/**组装ipa
 
 ipa下载完毕后，需要进一步处理，增加sinf文件。
 
 @param ipaPath ipa的路径
 @param appid ipa的appid
 */
-(BOOL)packageIPA:(NSString*)ipaPath appid:(NSString*)appid{
    
    NSString * sinfPath = nil;
    
    
    sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_APPLE]];
    //是否存在苹果sinf
    if ( ![[NSFileManager defaultManager] fileExistsAtPath: sinfPath] ) {
        
        return FALSE;
        
    }
    
    NSData * sinfdata = [NSData dataWithContentsOfFile: sinfPath ];
    BOOL bRet;
    
    bRet = [self addsinf:ipaPath sinf:sinfdata];
    
    NSString *path = [NSString stringWithFormat:@"%@/META/%@.plist",[[FileUtil instance] getDocumentsPath],appid];
    NSData * metadata = [NSData dataWithContentsOfFile: path ];
    bRet = [self addMetaPlist:ipaPath plistPath:path meta:metadata];
    
    
    
    //合并完成后清理sinf文件
    {
        sinfPath = [self.auBasePath stringByAppendingPathComponent:[appid stringByAppendingPathExtension:SINF_APPLE]];
        [[NSFileManager defaultManager] removeItemAtPath:sinfPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
    }
    
    return bRet;
    
}

- (void)writeMetaDataToLocal:(NSString*)appid info:(NSMutableDictionary*)info{
    
    NSString *path = [NSString stringWithFormat:@"%@/META/%@.plist",[[FileUtil instance] getDocumentsPath],appid];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([[FileUtil instance] isExistFile:path]) {
        dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [dic addEntriesFromDictionary:info];
    }else{
        dic = info;
    }
    
    [dic writeToFile:path atomically:NO];
    
}

-(BOOL)addMetaPlist:(NSString*)ipaPath plistPath:(NSString*) plistPath meta:(NSData*)data{
    

        //添加sinf文件
        @try {

            
            ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:ipaPath
                                                              mode:ZipFileModeUnzip];
            NSArray *infos= [unzipFile listFileInZipInfos];
            BOOL isPath = NO;
            for (FileInZipInfo *info in infos) {
                
                if( [info.name hasSuffix:@"iTunesMetadata.plist"]){
                    
                    isPath = YES;
                    break;
                }
            }
            
            if (isPath == NO) {
                //写入sinf文件
                ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ipaPath mode:ZipFileModeAppend];
                ZipWriteStream *stream1= [zipFile writeFileInZipWithName:@"iTunesMetadata.plist" compressionLevel:ZipCompressionLevelDefault];
                [stream1 writeData:data];
                [stream1 finishedWriting];
                [zipFile close];
                zipFile = nil;
            }

            
        }
        @catch (NSException *exception) {
            //        NSLog(@"%@", [exception description]);
            return NO;
        }
        @finally {
            
        }

    
    
    
    return YES;
}

- (void)sendBuyErrorReport:(NSDictionary *)buyResultDic isDelete:(BOOL)isDelete{
    
    NSString *textInfo = [[buyResultDic objectForKey:@"dialog"] objectForKey:@"explanation"];
    if (!textInfo) {
        textInfo = @"";
    }else{
        if (textInfo.length > 200) {
            textInfo = [textInfo substringToIndex:200];
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[LoginServerManage getManager] reportAccountError:@"" loginMessage:@"" loginText:@"" buyCode:[buyResultDic objectForKey:@"failureType"]?[buyResultDic objectForKey:@"failureType"]:@"" buyMessage:[buyResultDic objectForKey:@"customerMessage"]?[buyResultDic objectForKey:@"customerMessage"]:@"" buyText:textInfo isDelete:isDelete];
    });
    
    
}


@end
