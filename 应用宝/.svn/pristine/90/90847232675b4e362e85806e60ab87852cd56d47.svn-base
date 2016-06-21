

#import "ReportManage.h"
#import "CJSONDeserializer.h"
#import "AppStatusManage.h"
#import "FileUtil.h"
#import "stdio.h"
#import "JSONKit.h"
#import "NSString+Hashing.h"
#import "IphoneAppDelegate.h"
#import "NSDictionary+noNIL.h"


static ReportManage * instance = nil;
@implementation ReportManage

+(ReportManage *)instance{
    @synchronized(@"ReportManage") {
        if(instance == nil){
            instance = [[ReportManage alloc]init];
        }
        return instance;
    }
}

-(id)init{
    self = [super init];
    if(self){

    }
    return self;
}


//需要修改 report字段类型
-(NSMutableDictionary* )baseInfo {
    
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    
    //1).助手属性
    //项目名称
    NSString *programme = @"mobile_nav";
    [info setObjectNoNIL:programme forKey:@"programme"];
    
    //产品名
    [info setObjectNoNIL:[[FileUtil instance] channelInfoForKey:PRODUCT_NAME]
                  forKey:@"productname"];
    
    //下载来源
    NSString *channel = @"";
    [info setObjectNoNIL:channel forKey:@"channel"];
    
    //助手版本
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [info setObjectNoNIL:clientVer forKey:@"clientVer"];
    
    //2).设备属性
    //UDID
    NSString *udid = [[FileUtil instance] getDeviceFileUdid];
    [info setObjectNoNIL:udid forKey:@"udid"];
    
    //DEVMAC
    NSString *devmac = [[FileUtil instance] macaddress];
    [info setObjectNoNIL:devmac forKey:@"devmac"];
    
    //IDFA
    NSString *idfa = [[FileUtil instance] getDeviceIDFA];
    [info setObjectNoNIL:idfa forKey:@"idfa"];
    
    //设备类型
    NSString *devicetype = [[UIDevice currentDevice] localizedModel];
    [info setObjectNoNIL:devicetype forKey:@"devicetype"];
    
    NSString *deviceinfotype = [[FileUtil instance] platform];
    [info setObjectNoNIL:deviceinfotype forKey:@"deviceinfotype"];
    //设备版本
    NSString *osVer = [[UIDevice currentDevice] systemVersion];
    [info setObjectNoNIL:osVer forKey:@"osVer"];
    
    //是否越狱
    NSString *jailbreak = [[FileUtil instance] isJailbroken] == YES?@"y":@"n" ;
    [info setObjectNoNIL:jailbreak forKey:@"jailbreak"];
    
    //网络运营商
    NSString *telcom = [[FileUtil instance] checkChinaMobile];
    [info setObjectNoNIL:telcom forKey:@"telcom"];
    
    //设备品牌
    NSString *devBrand = @"apple";
    [info setObjectNoNIL:devBrand forKey:@"devBrand"];
    
    //设备屏幕分辨率
    NSString *screenR = @"";
    [info setObjectNoNIL:screenR forKey:@"screenR"];
    
    //3).行为属性
    //行为类型,下载行为填download 安装行为为install
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *report = @"start";
//        [info setObjectNoNIL:report forKey:@"report"];
//    });
    
    
    
    
    NSString *auaccount = nil;
    if ([[FileUtil instance] checkAuIsCanLogin] == NO) {
        auaccount = @"";
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *mDic = [user objectForKey:@"AuPersonInfo"];
        NSString *loginAppid = [mDic objectForKey:@"appleId"];
        auaccount = [loginAppid MD5Hash];
        
    }
    [info setObjectNoNIL:auaccount forKey:@"auaccount"];
    
    NSString *product = [[FileUtil instance] channelInfoForKey:CHANNEL_ID];
    [info setObjectNoNIL:product forKey:@"product"];
    
    return info;
}



-(void)reportData:(NSDictionary*)info{
    
    NSMutableString *reportString = [NSMutableString string];
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [reportString appendFormat:@"%@=%@&",key, obj];
    }];
//暂时关闭
//    NSLog(@"上报日志:%@",reportString);
    [reportString deleteCharactersInRange: NSMakeRange(reportString.length-1, 1) ];

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



//启动日志
-(void)ReportLaunch{
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"start" forKey:@"report"];
    
    //添加账号绑定日志
    NSString *hasBindAppid = [[FileUtil instance] hasBindAppleID]?@"yes":@"no";
    NSString *isBindingFreeAppid = [[FileUtil instance] isBingingFreeAppleID]?@"yes":@"no";
    [baseInfo setObjectNoNIL:hasBindAppid forKey:HAS_BIND_APPLEID];
    [baseInfo setObjectNoNIL:isBindingFreeAppid forKey:IS_BINDING_FREE_APPLEID];
    [self reportData:baseInfo];
}

//汇报php接口错误问题
-(void)reportPHPRequestError:(NSDictionary*)errorInfo {
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"phperror" forKey:@"report"];
    
    
    [baseInfo addEntriesFromDictionary:errorInfo];
    
    [self reportData:baseInfo];
}


//汇报曝光量
-(void)ReportAppBaoGuang:(NSString*)column appids:(NSArray*)apps {
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"baoguang" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"baoguang_column"];
    [tmp setObjectNoNIL:[apps componentsJoinedByString:@","] forKey:@"baoguang_appids"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

//汇报曝光量
- (void)reportAppBaoGuang:(NSString*)column appids:(NSArray*)apps digitalIds:(NSArray *)digitalIds
{
    //NSLog(@"曝光来源：%@\n应用信息：%@",column,apps);
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"baoguang" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"baoguang_column"];
    [tmp setObjectNoNIL:[apps componentsJoinedByString:@","] forKey:@"baoguang_appids"];
    [tmp setObjectNoNIL:[digitalIds componentsJoinedByString:@","] forKey:@"baoguang_digitalids"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

//汇报点击量（应用、游戏）
- (void)reportAppDetailClick:(NSString*)column contentDic:(NSDictionary *)contentDic
{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_detail" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:[contentDic objectForKey:@"appid"] forKey:@"click_appid"];
    [tmp setObjectNoNIL:[contentDic objectForKey:@"appdigitalid"] forKey:@"click_digitalid"];
    [tmp setObjectNoNIL:[contentDic objectForKey:@"installtype"] forKey:@"appServer"]; // appstore/local
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

// 汇报点击量（发现、专题、轮播）
- (void)reportOtherDetailClick:(NSString*)column appid:(NSString *)appid
{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_detail" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:appid forKey:@"click_id"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

// 壁纸大图
- (void)reportWallPaperClick:(NSString *)column ImageUrl:(NSString *)imgUrl
{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_detail" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:imgUrl forKey:@"imageurl"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

// 发现详情点赞
- (void)reportDiscoveryDetailRecommend:(NSString *)column appid:(NSString *)appid
{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_zan" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:appid forKey:@"click_appid"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

// 搜索词日志
- (void)reportSearchKeyWord:(NSString *)keyWord
{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"search" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:@"search" forKey:@"report"];
    [tmp setObjectNoNIL:keyWord forKey:@"value"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}

//汇报点击量
-(void)ReportAppDetailClick:(NSString*)column appid:(NSString*)app{
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_detail" forKey:@"report"];
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:app forKey:@"click_appid"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}
//汇报下载按钮点击量
-(void)ReportAppClickDownload:(NSString*)column appid:(NSString*)app {
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"click_download" forKey:@"report"];
    
    
    //添加账号绑定日志
    NSString *hasBindAppid = [[FileUtil instance] hasBindAppleID]?@"yes":@"no";
    NSString *isBindingFreeAppid = [[FileUtil instance] isBingingFreeAppleID]?@"yes":@"no";
    [baseInfo setObjectNoNIL:hasBindAppid forKey:HAS_BIND_APPLEID];
    [baseInfo setObjectNoNIL:isBindingFreeAppid forKey:IS_BINDING_FREE_APPLEID];
    
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
    [tmp setObjectNoNIL:column forKey:@"click_column"];
    [tmp setObjectNoNIL:app forKey:@"click_appid"];
    
    [baseInfo addEntriesFromDictionary:tmp];
    
    [self reportData:baseInfo];
}



//上报关键词日志
- (void)reportKeyWord:(NSString *)keyWord{

    NSMutableDictionary * baseInfo = [self baseInfo];

    [baseInfo setObject:@"search" forKey:@"report"];
    [baseInfo setObject:[[FileUtil instance] urlEncode:keyWord] forKey:@"value"];

    [self reportData:baseInfo];
}

//上报点赞汇报
- (void)reportClickZan:(NSString *)type typeid:(NSString*)aid{
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    
    [baseInfo setObject:@"click_zan" forKey:@"report"]; //点赞上报
    [baseInfo setObject:type forKey:@"zan_type"];       //赞的类型，发现或者应用
    [baseInfo setObject:aid forKey:@"zan_id"];          //赞ID
    
    [self reportData:baseInfo];
}

//上报手机点击分页
- (void)reportEnterPage:(int)page{
    
    if (page >3 || page < 0) return;
    
    NSArray *array = [NSArray arrayWithObjects:@"savemoneypage",@"activitiespage",@"giftbagpage",@"necessarypage", nil];
    
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObjectNoNIL:@"click" forKey:@"report"];
    [baseInfo setObjectNoNIL:[array objectAtIndex:page] forKey:@"position"];
    
    [self reportData:baseInfo];
}
//上报登录成功信息
- (void)reportLoginInfo:(NSString*)appleID{
    NSMutableDictionary * baseInfo = [self baseInfo];
    
    [baseInfo setObject:@"login" forKey:@"report"];
    [baseInfo setObject:appleID forKey:@"type"];
    
    [self reportData:baseInfo];
}

//上报开屏启动
- (void)reportKaipingLaunchedWithType:(NSString *)type andImgid:(NSString *)imgid{
    NSMutableDictionary * baseInfo = [self baseInfo];
    
    [baseInfo setObject:@"kaipinglaunched" forKey:@"report"];
    [baseInfo setObjectNoNIL:type forKey:@"type"];
    [baseInfo setObjectNoNIL:imgid forKey:@"imgid"];
    [self reportData:baseInfo];
}

//上报开屏点击
- (void)reportKaipingClickedWithType:(NSString *)type andContentid:(NSString *)contentid{
    NSMutableDictionary * baseInfo = [self baseInfo];
    
    [baseInfo setObject:@"kaipingclicked" forKey:@"report"];
    [baseInfo setObjectNoNIL:type forKey:@"type"];
    [baseInfo setObjectNoNIL:contentid forKey:@"contentid"];
    [self reportData:baseInfo];
}

//上报远程推送点击
- (void)reportRemoteNotificationClickedWithType:(NSString *)type andContentid:(NSString *)contentid{
    NSMutableDictionary * baseInfo = [self baseInfo];
    [baseInfo setObject:@"remotenotificationclicked" forKey:@"report"];
    [baseInfo setObjectNoNIL:type forKey:@"type"];
    [baseInfo setObjectNoNIL:contentid forKey:@"contentid"];
    [self reportData:baseInfo];
    NSLog(@"notification_report = %@ %@",type,contentid);
}
-(void)dealloc{

}
@end
