//
//  DownloadReport.m
//  browser
//
//  Created by 王毅 on 13-12-25.
//
//

#import "DownloadReport.h"
#import "NSString+Hashing.h"
#import "NSDictionary+noNIL.h"
#import "FileUtil.h"
#import "XXLog.h"

@interface DownloadReport (){
    
}
@property (nonatomic , retain) NSString *usernameMD5;

@property (nonatomic) NSMutableArray *appInfoArray;

@end

@implementation DownloadReport

@synthesize usernameMD5 = _usernameMD5;
@synthesize appInfoArray;


+ (DownloadReport *)getObject{
    
    @synchronized(@"DownloadReport") {
        
        static DownloadReport *getObject = nil;
        if (getObject == nil){
            getObject = [[DownloadReport alloc] init];
        }
        return getObject;
    }
}

- (id) init {
    
    if ( self=[super init] ) {
    }
    return self;
}

- (void)downloadReportByDistriPlist:(NSString *)distriPlist {
    NSMutableDictionary *dic = [self getReportFileDicByDistriPlist: distriPlist];
    NSString * appID = [dic objectNoNILForKey:REPORT_APPID];
    
    //通过AppID汇报日志
    [self downloadReportByAppId:appID];
}

//快用下载管理方式的下载日志
- (void)downloadReportByAppId:(NSString *)appID{
    
    NSMutableDictionary *dic = [self getReportFileDicByAppID:appID];

    //通用格式化
    NSMutableDictionary * formatDic = [NSMutableDictionary dictionary];
    
    //添加所有字段
    [formatDic addEntriesFromDictionary:dic];

    //助手属性
    //项目名称
    formatDic[@"programme"] = @"mobile_nav";
    
    //下载来源
    formatDic[@"channel"] = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];

    //助手版本
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    formatDic[@"clientVer"] = OBJ_NOT_NIL(clientVer);
    
    //2).设备属性
    //UDID
    formatDic[@"udid"] = OBJ_NOT_NIL( [[FileUtil instance] getDeviceFileUdid] );

    //DEVMAC
    formatDic[@"devmac"] = OBJ_NOT_NIL( [[FileUtil instance] macaddress] );
    //IDFA
    formatDic[@"idfa"] = OBJ_NOT_NIL( [[FileUtil instance] getDeviceIDFA] );

    //设备类型
    formatDic[@"devicetype"] = OBJ_NOT_NIL( [[UIDevice currentDevice] localizedModel] );
    formatDic[@"deviceinfotype"] = OBJ_NOT_NIL( [[FileUtil instance] platform] );
    //设备版本
    formatDic[@"osVer"] = OBJ_NOT_NIL( [[UIDevice currentDevice] systemVersion] );
    //是否越狱
    formatDic[@"jailbreak"] = OBJ_NOT_NIL( [[FileUtil instance] isJailbroken] == YES?@"y":@"n" );
    //网络运营商
    formatDic[@"telcom"] = OBJ_NOT_NIL( [[FileUtil instance] checkChinaMobile] );
    //设备品牌
    NSString *devBrand = @"apple";
    formatDic[@"devBrand"] = OBJ_NOT_NIL(devBrand);
    //设备屏幕分辨率
    formatDic[@"screenR"] = @"";
    

    //下载行为扩展的其他属性：
    
    //苹果设备是否被AU授权过
    formatDic[@"auaccredit"] = OBJ_NOT_NIL( [[FileUtil instance] checkAuIsCanLogin] == YES?@"y":@"n" );

    //账号的Md5值
    NSString *auaccount = nil;
    if ([[FileUtil instance] checkAuIsCanLogin] == NO) {
        auaccount = @"";
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *mDic = [user objectForKey:@"AuPersonInfo"];
        NSString *loginAppid = [mDic objectForKey:@"appleId"];
        auaccount = [loginAppid MD5Hash];
    }
    formatDic[@"auaccount"] = OBJ_NOT_NIL(auaccount);
    formatDic[@"product"] = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];
    formatDic[@"productname"] = [[FileUtil instance] channelInfoForKey:PRODUCT_NAME];
    
    formatDic[@"pseudoappid"] =  [DecryAppID getPseudoAppID:appID];
    
    //格式化字符
    __block NSMutableArray * formats = [NSMutableArray array];
    [formatDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [ formats addObject:[NSString stringWithFormat:@"%@=%@", key, obj] ];
    }];
    NSString *reportString = [formats componentsJoinedByString:@"&"];
    
//    NSLog(@"%@", reportString);
    
    reportString = [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:reportString key:@"HBSMY4yFB"]];

    //上传日志
    {
        NSString * urlString = [NSString stringWithFormat:@"%@%@",DOWN_LOG_URL, reportString];
        
        NSURL * _url = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
        request.HTTPMethod = @"GET";
        request.timeoutInterval = 5;
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        }];
    }
    
}

//safari方式下载的下载日志
- (void)localdownloadReportByAppId:(NSString *)appID appVersion:(NSString *)version dlfrom:(NSString *)dlfr appUrl:(NSString *)appUrl{
    
    
    //1).助手属性
    //项目名称
    NSString *programme = @"mobile_nav";
    //下载来源
    NSString *channel = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];
    //助手版本
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    //2).设备属性
    //UDID
    NSString *udid = [[FileUtil instance] getDeviceFileUdid];
    //DEVMAC
    NSString *devmac = [[FileUtil instance] macaddress];
    //IDFA
    NSString *idfa = [[FileUtil instance] getDeviceIDFA];
    //设备类型
    NSString *devicetype = [[UIDevice currentDevice] localizedModel];
    NSString *deviceinfotype = [[FileUtil instance] platform];
    //设备版本
    NSString *osVer = [[UIDevice currentDevice] systemVersion];
    //是否越狱
    NSString *jailbreak = [[FileUtil instance] isJailbroken] == YES?@"y":@"n" ;
    //网络运营商
    NSString *telcom = [[FileUtil instance] checkChinaMobile];
    //设备品牌
    NSString *devBrand = @"apple";
    //设备屏幕分辨率
    NSString *screenR = @"";
    
    //3).行为属性
    //行为类型,下载行为填download 安装行为为install
    NSString *report = @"download";
    //行为的内容
    NSString *value = @"";
    //行为结果，可以根据服务结果填写，比如填success、fail或者pause
    NSString *result = @"click";
    //助手中行为发生的位置
    NSString *dlfrom = dlfr;
    
    //下载行为扩展的其他属性：
    //APPID
    NSString *appid = appID;
    //APPVersion
    NSString *appVer = version;
    //下载开始时间的unix时间戳
    NSString *btick = [NSString stringWithFormat:@"%d",(NSUInteger)[[NSDate date] timeIntervalSince1970]];
    //下载结束时间的unix时间戳，包括下载暂定、完成和失败等情况
    NSString *etick = @"";
    //下载应用的开始字节位置，续传从续传点开始计数
    NSString *b = @"0";
    //下载应用的结束字节位置，包括下载暂定、完成和失败等情况
    NSString *e = @"";
    //下载应用的url
    NSString *url = appUrl;
    
    //AU相关
    //	AU账号登录是否成功
    NSString *AULogin = @"";
    //	AU账号是否购买成功
    NSString *AUBuy = @"";
    //	安装完成的应用是否为通过苹果服务器购买的应用，如果不是则为咱们目前线上的应用
    NSString *AUClean = @"";
    //苹果设备是否被AU授权过
    NSString *AUAccredit = [[FileUtil instance] checkAuIsCanLogin] == YES?@"y":@"n";
    //账号的Md5值
    //账号的Md5值
    NSString *auaccount = nil;
    if ([[FileUtil instance] checkAuIsCanLogin] == NO) {
        auaccount = @"";
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *mDic = [user objectForKey:@"AuPersonInfo"];
        NSString *loginAppid = [mDic objectForKey:@"appleId"];
        auaccount = [loginAppid MD5Hash];
        
    }

    NSString * productname = [[FileUtil instance] channelInfoForKey:PRODUCT_NAME];

    NSString * downloadtype = @"ota";
    
    NSString *product = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];
    
    NSString *reportString = [NSString stringWithFormat:@"programme=%@&channel=%@&clientVer=%@&udid=%@&devmac=%@&idfa=%@&devicetype=%@&osVer=%@&jailbreak=%@&telcom=%@&devBrand=%@&screenR=%@&report=%@&value=%@&result=%@&dlfrom=%@&appid=%@&appVer=%@&btick=%@&etick=%@&b=%@&e=%@&url=%@&aulogin=%@&aubuy=%@&auclean=%@&auaccredit=%@&auaccount=%@&product=%@&downloadtype=%@&deviceinfotype=%@&productname=%@",programme,channel,clientVer,udid,devmac,idfa,devicetype,osVer,jailbreak,telcom,devBrand,screenR,report,value,result,dlfrom,appid,appVer,btick,etick,b,e,url,AULogin,AUBuy,AUClean,AUAccredit,auaccount,product, downloadtype,deviceinfotype,productname];

    NSString* _reportString = [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:reportString key:@"HBSMY4yFB"]];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",DOWN_LOG_URL, _reportString];
    
    NSURL * _url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 5;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}


//检查plist文件是否存在
- (BOOL)checkPlistFile{
    NSString *path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"downloadReport.plist"];
    BOOL isDirExist = [[FileUtil instance] isExistFile:path];
    if(!isDirExist){
            [self creatPlistFile];
        return NO;
    }else{
        return YES;
    }
}

//创建plist文件
 - (void)creatPlistFile{

     [[NSFileManager defaultManager] createFileAtPath:[[DownloadReport getObject] getReportFilePath] contents:nil attributes:nil];
     NSMutableArray *array = [NSMutableArray array];
     [self writePListToFile:array];
 
 }

//保存数组
- (void) writePListToFile:(NSArray *)updatalist{    
    @synchronized(self) {
        NSString *path = [self getReportFilePath];
        [updatalist writeToFile:path atomically:YES];
    }
    
}

//获取文件路径
- (NSString *)getReportFilePath{
    return [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"downloadReport.plist"];
}

//获取文件夹的最外层数组
- (NSMutableArray *)getReportFileArray{
    
    if( !self.appInfoArray )
        self.appInfoArray = [NSMutableArray arrayWithContentsOfFile:[self getReportFilePath]];
    
    if(!self.appInfoArray){
        self.appInfoArray = [NSMutableArray array];
    }
    
    return self.appInfoArray;
}

//通过appid删除
-(void)deleteItemInfoByAppID:(NSString *)appid{
    
    NSMutableArray *array = [self getReportFileArray];
    
    for ( NSMutableDictionary *dic in array) {
        if ([[dic objectForKey:REPORT_APPID] isEqualToString:appid]) {
            [array removeObject:dic];
            break;
        }
    }
    
    [self writePListToFile:array];
    
}

//获取相应的字典
- (NSMutableDictionary *)getReportFileDicByAppID:(NSString *)appid{
    
    NSMutableArray *array = [self getReportFileArray];
    
    for ( NSMutableDictionary *dic in array) {
        if ([[dic objectForKey:REPORT_APPID] isEqualToString:appid]) {
            return dic;
        }
    }
    return nil;
}

//通过distriPlist删除
-(void)deleteItemInfoByDistriPlist:(NSString *)distriPlist{

    NSMutableArray *array = [self getReportFileArray];
    
    for ( NSMutableDictionary *dic in array) {
        if ([[dic objectForKey:REPORT_URL] isEqualToString:distriPlist]) {
            [array removeObject:dic];
            break;
        }
    }
    
    [self writePListToFile:array];
}

//获取相应的字典， 通过distriPlist
- (NSMutableDictionary *)getReportFileDicByDistriPlist:(NSString *)distriPlist {
    
    NSMutableArray *array = [self getReportFileArray];
    
    for ( NSMutableDictionary *dic in array) {
        NSString * temp = [dic objectForKey:REPORT_URL];
        temp = [[FileUtil instance] distriPlistURLNoArg:temp];
        
        distriPlist = [[FileUtil instance] distriPlistURLNoArg:distriPlist];
        
        if ([temp isEqualToString:distriPlist]) {
            return dic;
        }
    }
    return nil;
}

-(void)updateReportFile:(NSDictionary*)dicFileInfo {
    
    NSMutableArray *array = [self getReportFileArray];
    if(NSNotFound == [array indexOfObject:dicFileInfo] ) {
        if (dicFileInfo) {
            [array addObject:dicFileInfo];
        }
    }
    
    [self writePListToFile:array];
}

-(BOOL)deleteDownloadedAppID:(NSString*)appid {
    
    BOOL lbOK = NO;
    
    NSMutableArray *array = [self getReportFileArray];
    
    NSUInteger index = [self IndexOfDownloadedAppid:appid];
    if( index != NSNotFound ) {
       [array removeObjectAtIndex:index];
        lbOK = YES;
    }
    
    [self writePListToFile:array];
    
    return lbOK;
}

- (NSUInteger) IndexOfDownloadedAppid:(NSString*)appid {
    
    BOOL find = NO;
    NSUInteger index = 0;
    
    NSMutableArray *array = [self getReportFileArray];
    
    for ( NSMutableDictionary *dic in array) {
        if ([[dic objectForKey:REPORT_APPID] isEqualToString:appid]) {
            find = YES;
            break;
        }
        
        index++;
    }
    
    if(find)
        return index;
    
    return NSNotFound;
    
    
}

- (NSString *)getUnixTime{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];//精确到秒 *1000精确到毫秒
    return [NSString stringWithFormat:@"%.0f", a];//转为字符型
}



@end
