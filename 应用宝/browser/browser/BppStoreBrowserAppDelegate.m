//
//  BppStoreBrowserAppDelegate.m
//  browser
//
//  Created by 毅 王 on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BppStoreBrowserAppDelegate.h"
#import "ServiceManage.h"
#import "FileUtil.h"
#import "BppDistriPlistManager.h"
#import "AppStatusManage.h"
#import "ResourceIPhoneBrowserViewController.h"
#import "BackgroundAudio.h"
#import "BppDownloadToLocal.h"
#import "SearchManager.h"

#import "RealtimeShowAdvertisement.h"
#import "DownloadReport.h"
#import "AfterLaunchPopView.h"
#import "Reachability.h"
#import "ApplicationChangedNotifi.h"
#import "MobClick.h" // UM SDK
#import "UIApplication+MS.h" // 3/4G/WiFi...

#import "SSLServer.h"

#import "NSDictionary+noNIL.h"
#import<AssetsLibrary/AssetsLibrary.h>//访问相册
#import "YindaoViewController.h"
#import <objc/runtime.h>
#import "webserver.h"
#import "webserver_notifications.h"



#define  ALERTVIEW_TAG_INSTALL_ON_IPAD  100


@interface BppStoreBrowserAppDelegate () <IPadPlistProtoccal, BppDistriPlistManagerControlDelegate> {
    
    BOOL isBackGround;
    NSInteger pcToIOSMediaNum;
    
    Reachability  *hostReach;
    
    webServer * httpServer;
}

@property (nonatomic, retain) SSLServer * sslServ;


@end



@implementation BppStoreBrowserAppDelegate

@synthesize window = _window;
@synthesize sslServ;


- (id)init{
    
    self = [super init];
    if(self){
        isBackGround = NO;
        
        self.sslServ = nil;
        
        //设置控制流程代理
        [BppDistriPlistManager getManager].controlDelegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    hostReach = nil;
}
#pragma mark - 保存log日志
- (void)redirectNSlogToDocumentFolder
{

    NSString *documentDirectory = [[FileUtil instance] getDocumentPath];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:@"log.log"];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    {
        NSLog(@"launchOptions:%@", launchOptions);
        NSLog(@"BundlePath: %@", [NSBundle mainBundle].bundlePath);
        NSLog(@"DocumentsPath: %@", [@"~/Documents" stringByExpandingTildeInPath] );
    }
    
    /*
    // 当真机连接Mac调试的时候把这些注释掉，否则log只会输入到文件中，而不能从xcode的监视器中看到。
    // 如果是真机就保存到Document目录下的drm.log文件中
    UIDevice *device1 = [UIDevice currentDevice];
    NSRange range=[[device1 model] rangeOfString:@"Simulator"];
    if (range.location == NSNotFound) {
        // 开始保存日志文件
        [self redirectNSlogToDocumentFolder];
    }
    */
    
    // 清理网页内存
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // 友盟sdk数据统计
    [MobClick startWithAppkey:UMKEY reportPolicy:SEND_INTERVAL   channelId:@"正式版"]; // 友盟
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [MobClick setAppVersion:version];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    isBackGround = NO;
    
    //进入前台
    [self applicationWillEnterForeground:nil];

    //汇报启动日志
    [[ServiceManage instance] ReportLaunch];

    
    [[SettingPlistConfig getObject] checkIphonePlistFile];
    [[DownloadReport getObject] checkPlistFile];
    {
        self.sslServ = [[SSLServer alloc] init];
        self.sslServ.basePath = [@"~/Documents" stringByExpandingTildeInPath];
        [self.sslServ start:4443];
        //ssl server通知: OTA请求plist
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotification:)
                                                     name:HTTPS_SERVER_REQUEST_PLIST_OK_NOTIFICATION
                                                   object:nil];
        
    }
    
    //启动照片导入服务
    server = [[PCServer alloc] init];
    [server start:9000];
    server.serverDelegate = self;
    
    {
        httpServer = [[webServer alloc] init];
        BOOL lbOK = [httpServer startServer];
        if(!lbOK){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"端口被其他程序占用，如需安装应用请务必关闭其他应用程序然后重启快用"
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:@"确认",
                                       nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView show];
            });
        }
        //webserver通知: 点击了安装按钮
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotification:)
                                                     name:WEBSERVER_NOTIFICATION_CLICK_ON_INSTALL
                                                   object:nil];
        //webserver通知: IPA下载完毕
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotification:)
                                                     name:WEBSERVER_NOTIFICATION_LOCAL_DOWONLOAD_IPA_COMPLETE
                                                   object:nil];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UIViewController * controller = [[ResourceIPhoneBrowserViewController alloc] init];
    controller.view.frame = self.window.bounds;
    controller.view.autoresizesSubviews = YES;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.window.rootViewController = controller;
    
    AfterLaunchPopView *tmpPopView = [[AfterLaunchPopView alloc]initWithFrame:self.window.frame andRemoveAfterDelay:3];
    [tmpPopView showWithDic:nil];

    
    NSDictionary*currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *device = [UIDevice currentDevice].model;
    NSString * userAgent = [NSString stringWithFormat:
                                @"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/%@ Mobile/9B179 kuaiyongbrowser/%@",
                                device,device,
                            [UIDevice currentDevice].systemVersion,
                            [UIDevice currentDevice].systemVersion,
                            currentVersion];
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
    //自动下载IPA
    NSURL * launchOptionsURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(launchOptionsURL) {
        //示例数据
        //kybrowser:itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/21/58/net.crimoon.pm.ky/dizigui_zhouyi_net.crimoon.pm.ky_1402329600_1.0.0.plist
        
        NSString *distriPlistURL = launchOptionsURL.resourceSpecifier;
        if( [distriPlistURL hasPrefix:@"itms-services"] ) {
            [self downloadIPAByPlistURL:distriPlistURL];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
    
    [self.window makeKeyAndVisible];
    [WXApi registerApp:WXAppID];
    [WeiboSDK registerApp:kAppKey];
    
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"];
    if (!obj){
        yindao = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        yindao.windowLevel = UIWindowLevelAlert+1;
        yindao.backgroundColor = [UIColor clearColor];
        yindao.rootViewController = [YindaoViewController new];
        [yindao makeKeyAndVisible];
    }
    
    
    //如果被安装到了IPad上，提示用户安装HD版本
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        [[UpdateAppManager getManager] RequestIPadPlistURL:self];
    }
    

    //BppDistriPlistManager 通知: 点击了安装或开始下载按钮
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_3GDataPrompt:)
                                                 name: DISTRI_PLIST_MANAGER_NOTIFICATION_ADD_OR_START_DOWNLOAD
                                               object: nil];
    


    
    return YES;
}


//itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/21/58/net.crimoon.pm.ky/dizigui_zhouyi_net.crimoon.pm.ky_1402329600_1.0.0.plist?appid=test.com&appname=%E6%88%91%E4%BB%AC&appversion=2.1.0.0&appiconurl=http%3A%2F%2Fwww.kuaiyong.com%2F1.png&dlfrom=123
//快速添加需要附带参数
//必须: appid 唯一标示符, appname 名称, appversion 版本, appiconurl 图标URL
//可选: dlfrom 来源
//说明: 所有参数值必须URL编码
- (void)downloadIPAByPlistURL:(NSString*)distriPlist {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        
        NSString * plistURL = [distriPlist firstMatch:RX(@"(?<=&url=)https\\://.*?\\.plist")];
        if(plistURL.length <= 0)
            return ;
        
        NSString * appid = [distriPlist firstMatch:RX(@"(?<=appid=)[^\\&]*")];
        appid = [[FileUtil instance] urlDecode:appid];
        if(!appid)
            appid = @"";
        
        NSString *appname = [distriPlist firstMatch:RX(@"(?<=appname=)[^\\&]*")];
        appname = [[FileUtil instance] urlDecode:appname];
        if(!appname)
            appname = @"";
        
        NSString *appversion = [distriPlist firstMatch:RX(@"(?<=appversion=)[^\\&]*")];
        appversion = [[FileUtil instance] urlDecode:appversion];
        if(!appversion)
            appversion = @"";
        
        NSString *appiconurl = [distriPlist firstMatch:RX(@"(?<=appiconurl=)[^\\&]*")];
        appiconurl = [[FileUtil instance] urlDecode:appiconurl];
        if(!appiconurl)
            appiconurl = @"";

        NSString *dlfrom = [distriPlist firstMatch:RX(@"(?<=dlfrom=)[^\\&]*")];
        dlfrom = [[FileUtil instance] urlDecode:dlfrom];
        if(!dlfrom)
            dlfrom = @"";

        
        NSDictionary * AppInfo = nil;
        //参数信息全， 快速添加下载
        if(appid.length > 0 &&
           appname.length > 0 &&
           appversion.length > 0 &&
           appiconurl.length > 0 ) {
            
            AppInfo = [NSDictionary dictionaryWithObjectsAndKeys:appid, DISTRI_APP_ID,
                                      appversion, DISTRI_APP_VERSION,
                                      appname, DISTRI_APP_NAME,
                                      appiconurl, DISTRI_APP_IMAGE_URL,
                                      dlfrom, DISTRI_APP_FROM, nil];
        }else {
            //参数信息不全， 慢速添加下载
            
            //下载plist
            NSDictionary * dicInfo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:plistURL]];
            if(!dicInfo) {
                return ;
            }
            //分析plist
            __block NSString * imageURL = nil;
            NSArray *assets = [[[dicInfo objectForKey:@"items"] objectAtIndex:0] objectForKey:@"assets"];
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [[obj objectForKey:@"kind"] hasSuffix:@"image"] ) {
                    imageURL = [obj objectNoNILForKey:@"url"];
                }
            }];
            
            //获取应用信息
            NSDictionary * metadata = [[[dicInfo objectForKey:@"items"] objectAtIndex:0] objectForKey:@"metadata"];
            NSString * bundleIdentifier = [metadata objectNoNILForKey:@"bundle-identifier"];
            NSString * bundleVersion = [metadata objectNoNILForKey:@"bundle-version"];
            NSString * title = [metadata objectNoNILForKey:@"title"];
            
            
            AppInfo = [NSDictionary dictionaryWithObjectsAndKeys:bundleIdentifier, DISTRI_APP_ID,
                                      bundleVersion, DISTRI_APP_VERSION,
                                      title, DISTRI_APP_NAME,
                                      imageURL, DISTRI_APP_IMAGE_URL,
                                      dlfrom, DISTRI_APP_FROM, nil];
        }
        
        [self addDistriPlistURL:distriPlist appInfo:AppInfo];

    });
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (self.shareID == 1)
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
        //return 1;
    }
    else if (self.shareID == 2)
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        return 1;
    }

}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        NSString * str = nil;
        if (response.statusCode == 0)
        {
            str = @"新浪微博分享成功!";
        }
        else
        {
            str = @"新浪微博分享失败";
        }
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }
}


- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
        NSString * str = nil;
        if (resp.errCode == 0)
        {
            str = @"微信分享成功!";
        }
        else
        {
            str = @"微信分享失败!";
        }
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }
}


//接受本地通知
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if (application.applicationState == UIApplicationStateActive){
        
    }else if (application.applicationState == UIApplicationStateInactive){
        if (isBackGround == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"localPushClickOk" object:nil];
            [self appBackGroundBadge];
        }

    }else if (application.applicationState == UIApplicationStateBackground){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"localPushClickOk" object:nil];
        [self appBackGroundBadge];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    if( [url.scheme isEqualToString:@"kybrowser"] ) {
        //示例数据
        //kybrowser:itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/21/58/net.crimoon.pm.ky/dizigui_zhouyi_net.crimoon.pm.ky_1402329600_1.0.0.plist
        NSString *distriPlistURL = url.resourceSpecifier;
        if( [distriPlistURL hasPrefix:@"itms-services"] ) {
            [self downloadIPAByPlistURL:distriPlistURL];
        }
        
    }else{
        if (self.shareID == 1)
        {
            return [WeiboSDK handleOpenURL:url delegate:self];
        }
        else if (self.shareID == 2)
        {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    
    return YES;
}

//程序被挂起时调用
- (void)applicationWillResignActive:(UIApplication *)application
{
//    NSLog(@"\n ===> 程序暂行 !"); 
}
//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    isBackGround = YES;
    
    if ([[BackgroundAudio getObject] isPlaying] == NO ) {
        [[BackgroundAudio getObject] firstEnableMainAudioStrength];
    }
    
//     NSLog(@"\n ===> 程序进入后台 !"); 
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        exit(0);
    }];
    
    
    [self appBackGroundBadge];
    
}
//进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{        
        NSArray * appIDs = [[AppStatusManage getObject] getAppList:TRUE];
        //设置初始appids
        if( !application ) {
            //请求更新应用列表
            [[UpdateAppManager getManager] RequestUpdateAppList];
            
            [[ApplicationChangedNotifi getobject] setOldAppidsList:appIDs];
        }
    });
    
    isBackGround = NO;
    
}
//挂起后恢复、程序启动在didFinishLaunchingWithOptions之后
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rushLIst" object:nil]; // 下载管理安装完成程序数字更改
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callMotionEndedAction" object:nil]; // 解决热词菊花后台到前台不停转bug
//    NSLog(@"\n ===> 程序重新激活 !"); 
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//程序终止（如果长主按钮强制退出则不会调用）
- (void)applicationWillTerminate:(UIApplication *)application
{
//    NSLog(@"\n ===> 程序意外暂行 !"); 
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //收到内存警告，删除所有缓存
    NSLog(@"收到内存警告: 清空TMCache");
    [[TMCache sharedCache] removeAllObjects];
}

- (NSString *)getSystemLanguage{
    //判断系统语言
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == ALERTVIEW_TAG_INSTALL_ON_IPAD) {
        if (buttonIndex == 1) {
            //openurl Ipad 安装
            NSDictionary * info = objc_getAssociatedObject(alertView, @"info");
            NSString * distriPlist = [info objectForKey:@"plist"];
            objc_setAssociatedObject(alertView, @"info", nil, OBJC_ASSOCIATION_RETAIN);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:distriPlist ]];
        }
    }
}

- (void) appBackGroundBadge{
    NSString *strLanguage = nil;
    strLanguage = [self getSystemLanguage];
    
    if ([strLanguage isEqualToString:@"zh-Hans"] || [strLanguage isEqualToString:@"zh-Hant"]){
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UpdateAppManager getManager].distriUpdataPlists.count;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showUpdataCountImage"  object:[NSNumber numberWithBool:YES]];
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

//主线程
//PC端的链接通知
-(void)onPCConnected {
    
    NSLog(@"%s", __FUNCTION__);
}

//主线程
//PC端断开链接通知
-(void)onPCDisConnected {
    NSLog(@"%s", __FUNCTION__);
}

//非主线程
//接收到PC端数据
BOOL ifsuddess = TRUE;
NSMutableArray *successArray;
-(BOOL)onRecvPCCommand:(NSDictionary*)cmd {
    
    //此处：根据客户端的命令，导入图片
    //NSLog(@"%@", cmd);
    
    successArray = [NSMutableArray array];
    [successArray removeAllObjects];
    
    //[self performSelectorInBackground:@selector(saveTheImage:) withObject:cmd];
    
    photosAlbumManager = [[PhotosAlbumManager alloc] initWithDelegate:self];
    
    ALBUMVISITSTATE state = [photosAlbumManager ifCanVisitTheAlbum];
    
    NSMutableDictionary * infoDic;
    [infoDic removeAllObjects];
    infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"ImageAuthority", @"message",
                              [NSNumber numberWithInt:state], @"AuthorityType", nil];
    //发送状态
    [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic];
    
    if (state==CHOOCESTATE || state==VISIABLESTATE) {
        //去同步
        [self saveTheImage:cmd];
    }else{
        
        [infoDic removeAllObjects];
        infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   @"syncEnd", @"message",
                   successArray, @"NameArray",
                   [NSNumber numberWithBool:NO], @"Result", nil];
        
        //不可访问，返回失败
        [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic];
        
        UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"访问相册失败" message:@"请在“设置-隐私-照片”中允许“快用”，重新尝试即可" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tmpAlertView show];
    }
    
    return ifsuddess;
}


- (void)saveTheImage:(NSDictionary *)cmd
{
    NSMutableArray *fileNamesArray = [cmd objectForKey:@"NameArray"];
    pcToIOSMediaNum = [fileNamesArray count];
    
    if ([fileNamesArray count]) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if (*stop) {
                    //点击“好”回调方法
                    
                    NSMutableDictionary * infoDic1;
                    [infoDic1 removeAllObjects];
                    infoDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"syncBegin", @"message", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic1];
                    
                    [photosAlbumManager saveImageToNewAlbum:fileNamesArray AlbumName:@"快用"];//导入自定义相册
                    return;
                }
            } failureBlock:^(NSError *error) {
                //点击“不允许”回调方法
                ifsuddess = FALSE;
                
                NSMutableDictionary * infoDic1;
                [infoDic1 removeAllObjects];
                infoDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"syncEnd", @"message",
                            successArray, @"NameArray",
                            [NSNumber numberWithBool:NO], @"Result", nil];
                
                //不可访问，返回失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic1];
                
                return ;
                
            }];
        }else
        {
            NSMutableDictionary * infoDic1;
            [infoDic1 removeAllObjects];
            infoDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"syncBegin", @"message", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic1];
            [photosAlbumManager saveImageToNewAlbum:fileNamesArray AlbumName:@"快用"];//导入自定义相册
        }
    }else
    {
        
    }
}


#pragma mark -
#pragma mark SaveUtilDelegate

- (void)mediaItemCopiedIsSuccess:(BOOL)success andPath:(NSString *)path
{
    static int failedcount = 0;
    static int successcount = 0;
    
    if (!success) {
        //统计失败个数
        NSLog(@"faild one");
        failedcount += 1;
        NSLog(@"失败个数%i",failedcount);
    }else
    {
        NSLog(@"success one");
        successcount += 1;
        NSLog(@"成功个数%i",successcount);
        [successArray addObject:path];
    }
    if (failedcount+successcount == pcToIOSMediaNum) {
        NSLog(@"所有传输完成 成功%i个  失败%i个",successcount,failedcount);
        
        if (failedcount>0) {
            ifsuddess = FALSE;
        }else
        {
            ifsuddess = TRUE;
        }
        
        NSMutableDictionary * infoDic;
        [infoDic removeAllObjects];
        infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   @"syncEnd", @"message",
                   successArray, @"NameArray",
                   [NSNumber numberWithBool:ifsuddess], @"Result", nil];
        
        //返回传输结果
        [[NSNotificationCenter defaultCenter] postNotificationName:@"respondMessage" object:infoDic];
        
        failedcount = 0;
        successcount = 0;
    }
}

#pragma mark 实时判断网络变化
- (void)reachabilityChanged:(NSNotification *)note {
    
    static NetworkStatus beforeState=kNotReachable;
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSLog(@"%i   %i",beforeState,status);
    if (beforeState!=status)
    {
        if (status == NotReachable)
        {
            NSLog(@"NotReachable");
        }else if (status == ReachableViaWiFi)
        {
            
        }else if (status == ReachableViaWWAN)
        {
            //旧状态:WIFI, 当前状态是3G,4G            
//          if(beforeState == ReachableViaWiFi){
                static BOOL  lbShow = NO;
                if(!lbShow) {
                    lbShow = YES;
                    // 3/4G切换弹出框
                    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_3GALERTVIEW object:nil];
                }
//            }
        }
        
        beforeState = status;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.09) {
            beforeState = status;
        }
    }
}


-(void)onNotification:(NSNotification*)notify {

    if ( [notify.name isEqualToString:HTTPS_SERVER_REQUEST_PLIST_OK_NOTIFICATION] ) {
        NSDictionary * dic = notify.userInfo;
        NSString * localPath = [dic objectForKey:@"LocalPath"];
        if( [localPath hasSuffix:@"plist"] ) {
            NSLog(@"plist下载完毕:%@", localPath);
            //删除临时plist文件
            [[NSFileManager defaultManager] removeItemAtPath:[self.sslServ.basePath stringByAppendingPathComponent:localPath]
                                                       error:nil];
            //系统弹框 被点击了"安装"，AppID
            //NSString * appID = [[localPath lastPathComponent] stringByDeletingPathExtension];
            
            
        }else if( [localPath hasSuffix:@"png"] ){
            NSLog(@"png 下载完毕:%@", localPath);
            
            //删除临时png文件
            [[NSFileManager defaultManager] removeItemAtPath:[self.sslServ.basePath stringByAppendingPathComponent:localPath]
                                                       error:nil];
        }
    }else if ([notify.name isEqualToString:WEBSERVER_NOTIFICATION_CLICK_ON_INSTALL]){
        
        //系统弹框, 点击了"安装"按钮
        
        NSDictionary * dic = notify.userInfo;
        NSString * localPath = [dic objectForKey:@"LocalPath"];
        //删除路径前的 /
        localPath = [localPath substringFromIndex:1];
        
        //        NSDictionary * attrInfo = [self ItemInfoByAttriName:DISTRI_APP_IPA_LOCAL_PATH value:localPath];
        //
        //        //上报安装日志
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //            NSString *appName = [attrInfo objectNoNILForKey:DISTRI_APP_NAME];
        //            NSString *appVer = [attrInfo objectNoNILForKey:DISTRI_APP_VERSION];
        //            NSString * appID = [attrInfo objectForKey: DISTRI_APP_ID];
        //
        //            [[GetDevIPAddress getObject] reportInstallAPPID:appID appName:appName appVersion:appVer];
        //        });
        
    }else if ( [notify.name isEqualToString:WEBSERVER_NOTIFICATION_LOCAL_DOWONLOAD_IPA_COMPLETE] ) {
        
        //IPA 下载完毕
        
        NSDictionary * dic = notify.userInfo;
        NSString * localPath = [dic objectForKey:@"LocalPath"];
        //删除路径前的
        localPath = [localPath substringFromIndex:1];
        NSDictionary * attrInfo = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_APP_IPA_LOCAL_PATH value:localPath];
        if(attrInfo){
            NSLog(@"%@", attrInfo);
            
            //上报安装日志
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *appName = [attrInfo objectNoNILForKey:DISTRI_APP_NAME];
                NSString *appVer = [attrInfo objectNoNILForKey:DISTRI_APP_VERSION];
                NSString * appID = [attrInfo objectForKey: DISTRI_APP_ID];
                
                [[GetDevIPAddress getObject] reportInstallAPPID:appID appName:appName appVersion:appVer];
            });
            
        }
    }
}







-(void)addDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        if (!distriPlistURL) {
            return ;
        }
        if (!appInfo) {
            return;
        }
        NSString*appid = [appInfo objectForKey:@"appid"];
        if(!appid){
            appid = [appInfo objectForKey:DISTRI_APP_ID];
        }
        if(!appid)
            return;
        

        
        NSString*appversion = [appInfo objectForKey:@"appversion"];
        if(!appversion){
            appversion = [appInfo objectForKey:DISTRI_APP_VERSION];
        }
        if(!appversion)
            return;
        
        
        
        NSString*appname = [appInfo objectForKey:@"appname"];
        if(!appname){
            appname = [appInfo objectForKey:DISTRI_APP_NAME];
        }
        if(!appname)
            return;
        
        NSString*appiconurl = [appInfo objectForKey:@"appiconurl"];
        if(!appiconurl){
            appiconurl = [appInfo objectForKey:DISTRI_APP_IMAGE_URL];
        }
        if(!appiconurl)
            return;
        
        
        NSString*dlfrom = [appInfo objectForKey:@"dlfrom"];
        if(!dlfrom){
            dlfrom = [appInfo objectForKey:DISTRI_APP_FROM];
        }
        if(!dlfrom)
            return;


        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:appid, DISTRI_APP_ID,appversion,DISTRI_APP_VERSION,appname,DISTRI_APP_NAME,appiconurl,DISTRI_APP_IMAGE_URL,dlfrom,DISTRI_APP_FROM,nil];
        
        NSString *netState = [[FileUtil instance] GetCurrntNet];        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //不用下载到下载管理中
            if (![[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL])
            {
                
                if ([netState isEqualToString:@"wifi"]) {
                    [[BppDownloadToLocal getObject] downLoadPlistFile:distriPlistURL];
                    
                }else if ([netState isEqualToString:@"3g"]){
                    
                    if ([[[SettingPlistConfig getObject] getWifiModelAndBrowseModel:DOWN_ONLY_ON_WIFI] isEqualToString:SWITCH_YES]) {
                        UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:@"快用" message:ON_WIFI_DOWN_TIP delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                        [netAlert show];
                        
                    }else{
                        [[BppDownloadToLocal getObject] downLoadPlistFile:distriPlistURL];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            //下载到下载管理中
            else
            {
                DOWNLOAD_STATUS status = [[BppDistriPlistManager getManager]getPlistURLStatus:distriPlistURL];
                
                if (status == STATUS_ALREADY_IN_DOWNLOADING_LIST) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainVCDelegateAlertMethod" object:@{@"state":[NSNumber numberWithInt:STATUS_ALREADY_IN_DOWNLOADING_LIST],@"url":distriPlistURL}];
                    
                }else if (status == STATUS_ALREADY_IN_DOWNLOADED_LIST){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainVCDelegateAlertMethod" object:@{@"state":[NSNumber numberWithInt:STATUS_ALREADY_IN_DOWNLOADED_LIST],@"url":distriPlistURL}];
                }else if (status == STATUS_NONE){
                    
                    if ([netState isEqualToString:@"3g"]){
                        
                        //仅WIFI下载?
                        if ([[[SettingPlistConfig getObject] getWifiModelAndBrowseModel:DOWN_ONLY_ON_WIFI] isEqualToString:SWITCH_YES])
                        {
                            UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:@"快用" message:ON_WIFI_DOWN_TIP delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                            [netAlert show];
                        }
                        else{
                            [[BppDistriPlistManager getManager] addPlistURL:distriPlistURL appInfoDic:infoDic];
                        }
                        
                    }else //if ([netState isEqualToString:@"wifi"])
                    {
                        //WIFI下
                        [[BppDistriPlistManager getManager] addPlistURL:distriPlistURL appInfoDic:infoDic];
                    }
                }
            }

        });
    });
}

-(void)add3GFreeFlowDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (!distriPlistURL) {
            return ;
        }
        if (!appInfo) {
            return;
        }
        
        NSString*appid = [appInfo objectForKey:@"appid"];
        if(!appid) {
            appid = [appInfo objectForKey:DISTRI_APP_ID];
        }
        if(!appid)
            return ;
        
        
        NSString*appversion = [appInfo objectForKey:@"appversion"];
        if(!appversion) {
            appversion = [appInfo objectForKey:DISTRI_APP_VERSION];
        }
        if(!appversion)
            return ;

        
        NSString*appname = [appInfo objectForKey:@"appname"];
        if(!appname) {
            appname = [appInfo objectForKey:DISTRI_APP_NAME];
        }
        if(!appname)
            return ;

        
        NSString*appiconurl = [appInfo objectForKey:@"appiconurl"];
        if(!appiconurl) {
            appiconurl = [appInfo objectForKey:DISTRI_APP_IMAGE_URL];
        }
        if(!appiconurl)
            return ;

                
        NSString*dlfrom = [appInfo objectForKey:@"dlfrom"];
        if(!dlfrom) {
            dlfrom = [appInfo objectForKey:DISTRI_APP_FROM];
        }
        if(!dlfrom)
            return ;
        
        
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:appid, DISTRI_APP_ID,
                                 appversion,DISTRI_APP_VERSION,
                                 appname,DISTRI_APP_NAME,
                                 appiconurl,DISTRI_APP_IMAGE_URL,
                                 dlfrom,DISTRI_APP_FROM,
                                 nil];
        
        NSString *netState = [[FileUtil instance] GetCurrntNet];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //不用下载到下载管理中
            if (![[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL])
            {
                if ([netState isEqualToString:@"wifi"]) {
                    [[BppDownloadToLocal getObject] downLoadPlistFile:distriPlistURL];
                }
                else if ([netState isEqualToString:@"3g"]){
                    
                    //直接安装
                    [[BppDownloadToLocal getObject] downLoadPlistFile:distriPlistURL];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[GetDevIPAddress getObject] reportUpdataAppID:appid AppName:appname AppVersion:appversion];
                    });
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            //下载到下载管理中
            else
            {
                DOWNLOAD_STATUS status = [[BppDistriPlistManager getManager]getPlistURLStatus:distriPlistURL];
                if (status == STATUS_ALREADY_IN_DOWNLOADING_LIST) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainVCDelegateAlertMethod" object:@{@"state":[NSNumber numberWithInt:STATUS_ALREADY_IN_DOWNLOADING_LIST],@"url":distriPlistURL}];
                    
                }else if (status == STATUS_ALREADY_IN_DOWNLOADED_LIST){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainVCDelegateAlertMethod" object:@{@"state":[NSNumber numberWithInt:STATUS_ALREADY_IN_DOWNLOADED_LIST],@"url":distriPlistURL}];
                    
                }else if (status == STATUS_NONE){
                    
                    if ([netState isEqualToString:@"3g"]
                        || [netState isEqualToString:@"wifi"]){
                        [[BppDistriPlistManager getManager] addPlistURL:distriPlistURL appInfoDic:infoDic];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
            }
            
        });
    });
}


-(void)onIPadDistriPlistResponse:(NSDictionary *)Info{

    NSLog(@"%@", Info);
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"快用"
                                                         message:@"请您安装适配于iPad设备的快用HD"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确认",
                               nil];
    alertView.tag = ALERTVIEW_TAG_INSTALL_ON_IPAD;
    objc_setAssociatedObject(alertView, @"info", Info, OBJC_ASSOCIATION_RETAIN);
    
    [alertView show];
}


-(void)_3GDataPrompt:(NSNotification*)notifi {
    

        static BOOL  lbFirst = NO;
        if(!lbFirst) {

            if( [[[FileUtil instance] GetCurrntNet] isEqualToString:@"3g"] )
            {
                lbFirst = YES;
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"您目前在非WiFi环境下，下载应用将耗费手机流量"
                                                                    delegate:self
                                                           cancelButtonTitle:@"知道了"
                                                           otherButtonTitles:nil, nil];
                [alertView show];
                
                //3秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
            }
        }

}


//流程控制代理
#pragma mark BppDistriPlistManagerControlDelegate
//获得当前最大同时下载数
-(NSInteger)maxDowndingCount {
    return [[SettingPlistConfig getObject] getPlistObject_downCount:DOWNLOADCOUNT];
}

@end
