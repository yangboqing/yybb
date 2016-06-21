//
//  GetDevIPAddress.m
//  browser
//
//  Created by 王 毅 on 13-7-22.
//
//

#import "GetDevIPAddress.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "FileUtil.h"
#import "DownloadReport.h"
#import "NSString+Hashing.h"

@interface GetDevIPAddress (){
    
}
@property (nonatomic , retain) NSString *usernameMD5;
@end


@implementation GetDevIPAddress
@synthesize usernameMD5 = _usernameMD5;
static GetDevIPAddress *getObject=nil;

+ (GetDevIPAddress *)getObject
{
    if (getObject == nil)
    {
        getObject = [[GetDevIPAddress alloc] init];
    }
    return getObject;
}

- (id)init{
    
    self = [super init];
    if (self) {

    }
    
    return self;
}


//快用下载管理方式的安装日志
- (void)reportInstallAPPID: (NSString *)appId appName:(NSString *)appName appVersion:(NSString *)appVer{
    
    NSMutableDictionary *dic = [[DownloadReport getObject] getReportFileDicByAppID:appId];
    
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
    NSString *report = @"install";
    //行为的内容
    NSString *value = @"";
    //助手中行为发生的位置
    NSString *dlfrom = [dic objectForKey:REPORT_DLFROM];
    
    //下载行为扩展的其他属性：
    //APPID
    NSString *appid = appId;
    //APPVersion
    NSString *appVersion = appVer;
    //下载应用的url
    NSString *url = [dic objectForKey:REPORT_URL];
    
    //AU相关
    //	AU账号登录是否成功
    NSString *AULogin = [dic objectForKey:REPORT_AULOGIN];
    //	AU账号是否购买成功
    NSString *AUBuy = [dic objectForKey:REPORT_AUBUY];
    //	安装完成的应用是否为通过苹果服务器购买的应用，如果不是则为咱们目前线上的应用
    NSString *AUClean = [dic objectForKey:REPORT_AUCLEAN];
    //苹果设备是否被AU授权过
    NSString *AUAccredit = [[FileUtil instance] checkAuIsCanLogin]==YES?@"y":@"n";

    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //AU账号信息
    NSString *userName = nil;
    //AU密码信息
    NSString *userPassWord = nil;
    NSMutableDictionary *userDic = [userDefaults objectForKey:@"AuPersonInfo"];

    userName = @"";
    userPassWord = @"";
    if (userDic) {
        if ([userDic objectForKey:@"appleId"]) {
            userName = [userDic objectForKey:@"appleId"];
        }
        if ([userDic objectForKey:@"password"]) {
            userPassWord = [userDic objectForKey:@"password"];
        }
        
    }
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
    NSString *product = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];
    NSString *productname = [[FileUtil instance] channelInfoForKey:PRODUCT_NAME];
    
    //添加账号绑定日志
    NSString *hasBindAppid = [[FileUtil instance] hasBindAppleID]?@"yes":@"no";
    NSString *isBindingFreeAppid = [[FileUtil instance] isBingingFreeAppleID]?@"yes":@"no";
    
   
    NSString *installReportStr = [NSString stringWithFormat:@"programme=%@&channel=%@&clientVer=%@&udid=%@&devmac=%@&idfa=%@&devicetype=%@&osVer=%@&jailbreak=%@&telcom=%@&devBrand=%@&screenR=%@&report=%@&value=%@&dlfrom=%@&appid=%@&appVer=%@&url=%@&aulogin=%@&aubuy=%@&auclean=%@&auaccredit=%@&auusername=%@&auuserpassword=%@&auaccount=%@&product=%@&deviceinfotype=%@&productname=%@&hasbindappid=%@&isbindingfreeappid=%@",programme,channel,clientVer,udid,devmac,idfa,devicetype,osVer,jailbreak,telcom,devBrand,screenR,report,value,dlfrom,appid,appVersion,url,AULogin,AUBuy,AUClean,AUAccredit,userName,userPassWord,auaccount,product,deviceinfotype, productname,hasBindAppid,isBindingFreeAppid];

//    NSLog(@"安装日志:%@", installReportStr);
    NSString* _installReportStr = [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:installReportStr key:@"HBSMY4yFB"]];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",DOWN_LOG_URL, _installReportStr];

    NSURL * _url = [NSURL URLWithString:urlString];

     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
     request.HTTPMethod = @"GET";
     request.timeoutInterval = 5;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];

    
}

//safari下载后立刻安装的安装日志
- (void)localReportInstallAPPID: (NSString *)appId appName:(NSString *)appName appVersion:(NSString *)appVer dlfrom:(NSString *)dlfr downloadUrl:(NSString *)downloadUrl{


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
    NSString *report = @"install";
    //行为的内容
    NSString *value = @"";
    //助手中行为发生的位置
    NSString *dlfrom = dlfr;
    
    //下载行为扩展的其他属性：
    //APPID
    NSString *appid = appId;
    //APPVersion
    NSString *appVersion = appVer;
    //下载应用的url
    NSString *url = downloadUrl;
    
    //AU相关
    //	AU账号登录是否成功
    NSString *AULogin = @"";
    //	AU账号是否购买成功
    NSString *AUBuy = @"";
    //	安装完成的应用是否为通过苹果服务器购买的应用，如果不是则为咱们目前线上的应用
    NSString *AUClean = @"";
    //苹果设备是否被AU授权过
    NSString *AUAccredit = [[FileUtil instance] checkAuIsCanLogin]==YES?@"y":@"n";
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
    NSString *product = [[FileUtil instance] channelInfoForKey:PRODUCT_NAME];
    NSString *productname = [[FileUtil instance] channelInfoForKey:PRODUCT_NAME];
    
    NSString *installReportStr = [NSString stringWithFormat:@"programme=%@&channel=%@&clientVer=%@&udid=%@&devmac=%@&idfa=%@&devicetype=%@&osVer=%@&jailbreak=%@&telcom=%@&devBrand=%@&screenR=%@&report=%@&value=%@&dlfrom=%@&appid=%@&appVer=%@&url=%@&aulogin=%@&aubuy=%@&auclean=%@&auaccredit=%@&auaccount=%@&product=%@&deviceinfotype=%@&productname=%@",programme,channel,clientVer,udid,devmac,idfa,devicetype,osVer,jailbreak,telcom,devBrand,screenR,report,value,dlfrom,appid,appVersion,url,AULogin,AUBuy,AUClean,AUAccredit,auaccount,product,deviceinfotype,productname];

    NSString* _installReportStr = [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:installReportStr key:@"HBSMY4yFB"]];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",DOWN_LOG_URL, _installReportStr];
    
    NSURL * _url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 5;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];

    
}

//更新日志
- (void)reportUpdataAppID:(NSString *)appId AppName:(NSString *)appName AppVersion:(NSString *)appVersion{
    
    NSString * _appId = nil;
    NSString * _appName = nil;
    NSString * _appVersion = nil;
    NSString * _columnId = nil;
    NSString * _subcolumnId = nil;
    NSString * _domainType = nil;
    NSString * _browserType = nil;
    NSString * _kuaiyongUdid = nil;
    NSString * _ip = nil;
    NSString * _isCrack = nil;
    NSString * _iOSVersion = nil;
    NSString * _from = nil;
    NSString * _devMac = nil;
    NSString * _idfa = nil;
    NSString *_deviceinfotype = nil;
    
    
    @synchronized( self ) {
        _appId = [[FileUtil instance] urlEncode:appId];
        _appName = [[FileUtil instance] urlEncode:appName];
        _appVersion = [[FileUtil instance] urlEncode:appVersion];
        _columnId = @"17";
        _subcolumnId = @"0";
        _domainType = [[FileUtil instance] urlEncode:[[UIDevice currentDevice]model]];
        _deviceinfotype = [[FileUtil instance] urlEncode:[[FileUtil instance] platform]];
        _browserType = @"1";
        _kuaiyongUdid = [[FileUtil instance] getDeviceFileUdid];
        _ip = [[FileUtil instance] urlEncode:[[FileUtil instance] deviceIPAdress]];
        
        if([[FileUtil instance] isJailbroken])
            _isCrack = @"1";
        else
            _isCrack = @"2";
        
        _iOSVersion = [[FileUtil instance] urlEncode:[[UIDevice currentDevice] systemVersion]];
        _from = @"";
        _devMac = [[FileUtil instance] urlEncode:[[FileUtil instance] macaddress]];
        _idfa = [[FileUtil instance] urlEncode:[[FileUtil instance] getDeviceIDFA]];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPDATA_REPORT_ADDRESS]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        [request setValue:_appId forHTTPHeaderField:@"stat_app_id"];
        [request setValue:_appName forHTTPHeaderField:@"stat_app_name"];
        [request setValue:_appVersion forHTTPHeaderField:@"stat_app_version"];
        [request setValue:_columnId forHTTPHeaderField:@"stat_column_id"];
        [request setValue:_subcolumnId forHTTPHeaderField:@"stat_subcolumn_id"];
        [request setValue:_domainType forHTTPHeaderField:@"stat_domian_type"];
        [request setValue:_browserType forHTTPHeaderField:@"stat_browser_type"];
        [request setValue:_kuaiyongUdid forHTTPHeaderField:@"stat_kuaiyong_udid"];
        [request setValue:_ip forHTTPHeaderField:@"stat_ip"];
        [request setValue:_isCrack forHTTPHeaderField:@"stat_iscrack"];
        [request setValue:_iOSVersion forHTTPHeaderField:@"stat_iosver"];
        [request setValue:_from forHTTPHeaderField:@"from"];
        [request setValue:_devMac forHTTPHeaderField:@"stat_devmac"];
        [request setValue:_idfa forHTTPHeaderField:@"stat_idfa"];
        [request setValue:_deviceinfotype forHTTPHeaderField:@"stat_deviceinfotype"];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        }];
        
    }
    
}

//删除上报统计数据
- (BOOL)deleteInstallReportData:(NSString *)appid{
        
    return [[DownloadReport getObject] deleteDownloadedAppID:appid];
}

@end
