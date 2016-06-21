



#define TAG_ALER_NETSTATE 1300

#import "ResourceIPhoneBrowserViewController.h"
#import "LookInfoAlertView.h"
#import "UIApplication+MS.h" // 检测网络（3G/4G/Wifi...）
#import "FileUtil.h"
#import "UIWebViewController.h" // 启动提醒
#import "RepairAppViewController.h" // 应用修复列表
#import "MarketServerManage.h"
//#import "DidiWebViewController.h"
#import "WYInstallKKKView.h"
#import "WYNotBindingAlertView.h"
#import "WYAccountInfoAlertView.h"


@interface ResourceIPhoneBrowserViewController ()<MarketServerDelegate,UIWebViewControllerDelegate>{
    NSMutableDictionary *distriPlistDic;
    BOOL isInitClick;
    //
    UIImageView *repairBgImageView;
    // 快用更新loading界面
    UIView *updateBGView;
    UIView *updateView;
    UIActivityIndicatorView *activityView;
    UILabel *activityLabel;
    AuthorizationGuideViewController *authPageViewController;
    
    PopViewController *pop;
    BOOL ifPopView;
    LookInfoAlertView *_lookInfoAlertView;
    UIWebViewController *remindWebVC;
    RepairAppViewController *repairAppVC; // 下载管理中显示的修复应用列表
//    DidiWebViewController *didiWebView;

    
    AppidAlert *appidAlert;//账号赋值提示

    
    WYInstallKKKView *installKKK;
    
    WYNotBindingAlertView *nbindingAView;
    WYAccountInfoAlertView *listAView;
    

}
@end

@implementation ResourceIPhoneBrowserViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor blackColor];
        isInitClick = NO;
        distriPlistDic = [[NSMutableDictionary alloc]init];
        
        tmpPopView = [[AfterLaunchPopView alloc]initWithFrame:[UIScreen mainScreen].bounds andRemoveAfterDelay:3];
        //[self initViewFrame];
    }
    return self;
}

- (void)makeViews{
    //首页控制器
    _homePageViewController = [[ResourceHomePageViewController alloc]init];
    
    _homePageViewController.view.backgroundColor = [UIColor whiteColor];

    _homePageViewController.mainVCDelegate = self;
    [self.view addSubview:_homePageViewController.view];
    _homePageViewController.view.alpha = 1.0;
    
    // 快用已是最新版本
    boxView = [[PromptBoxView alloc] init];
    boxView.hidden = YES;
    [self.view addSubview:boxView];
    
    // 发现快用有新版本
    boxView_newVersion = [[PromptBoxView_newVersion alloc]init];
    boxView_newVersion.hidden = YES;
    [self.view addSubview:boxView_newVersion];
    
    //10s后请求开屏图
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestRealtimeShowNew) userInfo:nil repeats:NO];

    
    _dowloadCompetAlertView = [[dowloadCompetAlertView alloc]init];
    _dowloadCompetAlertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _dowloadCompetAlertView.alpha = 0.0;
    _dowloadCompetAlertView.delegate = self;
    [self.view addSubview:_dowloadCompetAlertView];
    
    {
        
        backgroundDownloadAlertView = [[BackgroundDownloadAlertView alloc]init];
        backgroundDownloadAlertView.alpha = 0.0;
        backgroundDownloadAlertView.userInteractionEnabled = YES;
        [self.view addSubview:backgroundDownloadAlertView];
    }
    
    
    repairBgImageView = [[UIImageView alloc]init];
    repairBgImageView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    repairBgImageView.alpha = 0.0;
    repairBgImageView.userInteractionEnabled = YES;
    [self.view addSubview:repairBgImageView];
    
    //闪退修复页面
    flashQuitRepairView = [[FlashQuitRepairView alloc]init];
    flashQuitRepairView.userInteractionEnabled = YES;
    
    flashQuitRepairView.backgroundColor = [UIColor clearColor];
    [flashQuitRepairView.repairBtn addTarget:self action:@selector(startRepair:) forControlEvents:UIControlEventTouchUpInside];
    [flashQuitRepairView.repairCloseBtn addTarget:self action:@selector(closeRepair:) forControlEvents:UIControlEventTouchUpInside];
    flashQuitRepairView.hidden = YES;
    flashQuitRepairView.lessonDelegate = self;
    [self.view addSubview:flashQuitRepairView];

    // 检测快用版本&清理缓存 loading页面
    updateBGView = [[UIView alloc] init];
    updateBGView.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:0.8];
    updateBGView.hidden = YES;
    
    updateView = [[UIView alloc] init];
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.cornerRadius = 10.0f;
    updateView.hidden = YES;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.hidden = YES;
    activityLabel = [[UILabel alloc] init];
    activityLabel.backgroundColor = [UIColor clearColor];
    activityLabel.textColor = OTHER_TEXT_COLOR;
    activityLabel.textAlignment = NSTextAlignmentCenter;
    activityLabel.hidden = YES;
    
    authPageViewController = [[AuthorizationGuideViewController alloc]init];
    authPageViewController.delegate= self;
    authPageViewController.view.hidden = YES;
    
    if ([[FileUtil instance] checkAuIsCanLogin] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您当前为体验版用户,仅能安装几万款应用,升级成为正式版几十万款应用终身免费"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"如何升级", nil];
        alert.tag = 7659;
        [alert show];
    }
    
    
    [updateView addSubview:activityView];
    [updateView addSubview:activityLabel];
    [updateBGView addSubview:updateView];
    [self.view addSubview:updateBGView];
    [self.view addSubview:authPageViewController.view];
    
    // 闪退修复教程
    pop = [[PopViewController alloc] init];
    [self.view addSubview:pop.view];
    
    repairAppVC = [[RepairAppViewController alloc] init];
    repairAppVC.repairListType = repairApp_DownloadManage;
    
//    didiWebView = [[DidiWebViewController alloc] init];
//    didiWebView.view.frame = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
//    [self.view addSubview:didiWebView.view];
    
    //推荐成功信息
    _lookInfoAlertView = [[LookInfoAlertView alloc] init];
    _lookInfoAlertView.alpha = 0.0;
    [self.view addSubview:_lookInfoAlertView];
    
    // 置于最上层(启动提醒)
    remindWebVC = [[UIWebViewController alloc] initWithWebType:webView_BootRemindType];
    remindWebVC.delegate = self;
    [self.view addSubview:remindWebVC.view];
    
    loginCancellationView = [LoginCancellationView new];
    loginCancellationView.frame = self.view.bounds;
    [loginCancellationView.cannelBtn addTarget:self action:@selector(hiddenLoginCancellation:) forControlEvents:UIControlEventTouchUpInside];
    [loginCancellationView.cancellationBtn addTarget:self action:@selector(CancellationAccount:) forControlEvents:UIControlEventTouchUpInside];
    loginCancellationView.hidden = YES;
    [self.view addSubview:loginCancellationView];
    
    
    mumView = [MumView new];
    mumView.frame = self.view.bounds;
    mumView.hidden = YES;
    mumView.delegate = self;
    [self.view addSubview:mumView];
    
    

    
    

//弃用的新引导图
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"guideView"]) {
//        [self showGuide];
//        guideView = [[GuideView alloc] initWithFrame:self.view.bounds];
//        guideView.backgroundColor = WHITE_COLOR;
//        [self.view addSubview:guideView];
//
//    }
    
    installKKK = [WYInstallKKKView new];
    installKKK.hidden = YES;
    [self.view addSubview:installKKK];
    
    nbindingAView = [WYNotBindingAlertView new];
    nbindingAView.hidden = YES;
    [self.view addSubview:nbindingAView];
    
    listAView = [WYAccountInfoAlertView new];
    listAView.hidden = YES;
    [self.view addSubview:listAView];

}


- (void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
#define newBoyPage_y [[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ?10:0

    boxView.frame = [UIScreen mainScreen].bounds;
    boxView_newVersion.frame = [UIScreen mainScreen].bounds;
    updateBGView.frame = [UIScreen mainScreen].bounds;
    updateView.frame = CGRectMake(0, 0, 150, 100);
    updateView.center = updateBGView.center;
    activityView.frame = CGRectMake(55, 20, 40, 40);
    activityLabel.frame = CGRectMake(0, 60, updateView.frame.size.width, 25);
    
    _homePageViewController.view.frame = self.view.bounds;
    authPageViewController.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height);
    repairBgImageView.frame = _homePageViewController.view.frame;

    backgroundDownloadAlertView.frame = CGRectMake((self.view.frame.size.width - 210)/2, (self.view.frame.size.height - 140)/2, 210, 140);

    flashQuitRepairView.frame = self.view.frame;
    if (INT_SYSTEMVERSION >= 7) {
        _dowloadCompetAlertView.frame = CGRectMake(0, MainScreen_Height - 49 - 31, MainScreen_Width, 31);
    }else{
        _dowloadCompetAlertView.frame = CGRectMake(0, MainScreen_Height - 20- 49 - 31, MainScreen_Width, 31);
    }
    if (!ifPopView) {
        pop.view.frame = CGRectMake(0, MainScreen_Height, MainScreen_Width, MainScreen_Height);
    }
    
    //市场-分类 遮黑视图
    if (IOS7) {
            blackCover = [[BlackCoverBackgroundView alloc]initWithFrame:CGRectMake(0, MainScreen_Height - BOTTOM_HEIGHT, MainScreen_Width, BOTTOM_HEIGHT)];
    }else{
            blackCover = [[BlackCoverBackgroundView alloc]initWithFrame:CGRectMake(0, MainScreen_Height  - 20- BOTTOM_HEIGHT, MainScreen_Width, BOTTOM_HEIGHT)];
    }
    [self.view addSubview:blackCover];
    
    //
    _lookInfoAlertView.frame = CGRectMake(0, 0, 200, 80);
    CGSize tmpSize = self.view.frame.size;
    _lookInfoAlertView.center = CGPointMake(tmpSize.width/2, tmpSize.height/2);
    remindWebVC.view.frame = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
    installKKK.frame = MainScreeFrame;
    nbindingAView.frame = MainScreeFrame;
    listAView.frame = MainScreeFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开屏图测试数据
//    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"123",@"imgid",@"http://www.52nx.net/article/UploadPic/2011-6/20116515525066373.png",@"imgurl",@"2000-10-10 12:00:00",@"starttime",@"2015-10-10 12:00:00",@"endtime", nil];
//    [tmpPopView showWithDic:tmpDic];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tmpPopView hide]; //开始倒计时隐藏开屏图
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![[FileUtil instance] GetCurrntNet]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:2]];
    }
    
    [self makeViews];
    
    
    [[BppDistriPlistManager getManager] addListener:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downLoadCompleteAlertView:)
												 name:DOWNLOADCOMPLETE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNewDownLoadItemAlertView:)
												 name:ADD_NEW_DOWNLOAD_ITEM
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundDownloadAlertVIew:)
												 name:BACKGROUND_DOWNLOAD_ALERTVIEW
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlreadyJoinDowningList:)
												 name:SHOW_ALREADY_JOIN_DOWNING_LIST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openPromptView:)
                                                 name:@"openPromptView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePromptView)
                                                 name:@"closePromptView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingViewIsHide:) name:@"LoadingViewIsHide" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBlack) name:@"datu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadyDownedList:)
												 name: @"alreadyDownedList"
                                               object:nil];
////未激活用户点击搜索列表上的激活提示接收通知/闪退修复教程（未激活用户）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openLesson)
												 name: OPENLESSON
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePopView:)
                                                 name:@"closePopView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickRepairBtn)
                                                 name:@"RepairCrashAction"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showNewVersionContent:)
                                                name:@"newVersionContent"
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGif) name:@"hiddenGif" object:nil];
    // 应用修复列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRepairAppList:) name:OPEN_REPAIRAPP_DOWNLOAD object:nil];

    //推荐成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(promoteInforShow:)
                                                 name:PROMOTE_INFO_SHOW
                                               object:nil];
    // 跳转到“管理”-下载中页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToDownloadingView:) name:JUMP_DOWNLOADING object:nil];
    
    //市场-分类全屏遮黑界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBlackCover:) name:@"showBlackCover" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fadeBlackCover:) name:@"fadeBlackCover" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAccount) name:CLICK_ACCOUNT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLoginLoading:) name:SHOW_HIDDEN_LOGIN_LOADING object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDidiWeb:) name:OPEN_CLOSE_DIDI_WEB object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(installKKK:) name:KKK_DOWNLOAD_ADDRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitbingdingpage:) name:IS_QUIT_BINDING_PAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountList:) name:SHOW_ACCOUNT_LIST object:nil];
    //请求appid结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAppidResult:) name:REQUEST_APPID_RESULT object:nil];
    //au下载应用时复制账号弹框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountCopyAlert:) name:COPY_ACCOUNT_INFOR object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGuide) name:@"yibujihuochangjiaocheng" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLockPage:) name:@"openLockPage" object:nil];
    
    // 启动提醒请求
    [self requestRemindData];
    
    //模拟返回appid结果
//    [self receiveAppidResult:nil];
    
    
}


- (void)requestRealtimeShowNew{
    [RealtimeShowAdvertisement getObject].delegate = self;
    [[RealtimeShowAdvertisement getObject] requestRealtimeShowNew];
}
- (void)showGuide{
    guideView = [[GuideView alloc] initWithFrame:self.view.bounds];
    guideView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:guideView];
    
}
- (void)showAccountCopyAlert:(NSNotification *)noti{
    appidAlert  = [[AppidAlert alloc] initWithFrame:self.view.frame];
    if (noti.object) {
        [appidAlert setAppDistri:noti.object];
    }
    [appidAlert makeKeyAndVisible];
    
}

- (void)promoteInforShow:(NSNotification *)noti{
    _lookInfoAlertView.userInteractionEnabled = NO;
    _lookInfoAlertView.alpha = 1.0;
    [_lookInfoAlertView setAlertLabelText:noti.object];
    [self performSelector:@selector(promoteInforHide) withObject:nil afterDelay:1];
}
- (void)promoteInforHide{
    [UIView animateWithDuration:1 animations:^(void){         //无->有 0.4s
        _lookInfoAlertView.alpha = 0;
        
    } completion:^(BOOL finished){
        
    }];
}
- (void)showBlackCover:(NSNotification *)noti{
    if (noti.object) {
        [blackCover showWithoutAnimation];
    }else{
        [blackCover show];
    }
}

- (void)fadeBlackCover:(NSNotification *)noti{
    if ([noti.object isEqualToString:@"withAnimation"]) {
        [blackCover fade];
    }else{
        [blackCover fade_withoutAnimation];
    }
}
- (void)showNewVersionContent:(NSNotification *)noti{
    NSDictionary *dic  = noti.object;
    boxView_newVersion.contentTF.text = [dic objectForKey:@"content"];
    boxView_newVersion.titile.text = [dic objectForKey:@"title"];

}

- (void)openPromptView:(NSNotification *)noti
{
    [self loadingViewIsHide:[NSNotification notificationWithName:@"loadingViewIsHide" object:@{@"bool":@"yes"}]];
    boxView.hidden = NO;
//    _homePageViewController.view.userInteractionEnabled = NO;
    
    NSString  * str = (NSString *)noti.object;
    if ([str isEqualToString:@""] || str == nil||[str isEqualToString:@"当前已是最新版本!"])
    {
        if (str == nil) {
            boxView.labelString = [NSMutableString stringWithString:@""];
        }else{
            boxView.labelString = [NSMutableString stringWithString:str];
        }
        [boxView.confirmBtn addTarget:self action:@selector(updateCancel) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([str isEqualToString:@"检测到新版本是否更新"]) {
        boxView.hidden = YES;
        boxView_newVersion.hidden = NO;
        [boxView_newVersion.confirmBtn addTarget:self action:@selector(updateConfirm) forControlEvents:UIControlEventTouchUpInside];
        [boxView_newVersion.cancelBtn addTarget:self action:@selector(updateCancel) forControlEvents:UIControlEventTouchUpInside];
        boxView_newVersion.userInteractionEnabled = YES;
    }else{
        boxView.labelString = (NSMutableString *)str;
        if ([str isEqualToString:@"请转换下载模式至其他\n模式在尝试下载"]) {

        }

    }
}

- (void)updateConfirm{
    boxView.hidden = YES;
    [_homePageViewController startUpdata];
}
- (void)updateCancel{
    boxView.hidden = YES;
    boxView_newVersion.hidden =  YES;
}

- (void)closePromptView
{
    [self loadingViewIsHide:[NSNotification notificationWithName:@"LoadingViewIsHide" object:@{@"bool":@"yes"}]];
    _homePageViewController.view.userInteractionEnabled = YES;
    boxView.hidden = YES;
}



-(void)loadingViewIsHide:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    if ([[dic objectForKey:@"bool"] isEqualToString:@"yes"]) {
        
        [activityView stopAnimating];
        
        activityLabel.hidden = YES;
        activityView.hidden = YES;
        updateView.hidden = YES;
        updateBGView.hidden = YES;
    }
    else
    {
        updateBGView.hidden = NO;
        updateView.hidden = NO;
        activityView.hidden = NO;
        activityLabel.hidden = NO;
        
        activityLabel.text = [dic objectForKey:@"content"];
        [activityView startAnimating];
    }
}

-(void)showBootRemindByFlag:(BOOL)flag
{
    CGRect startRect = CGRectZero;
    CGRect endRect = CGRectZero;
    if (flag) {
        startRect = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
        endRect = CGRectMake(0, 0, MainScreen_Width, MainScreeFrame.size.height);
    }
    else
    {
        startRect = CGRectMake(0, 0, MainScreen_Width, MainScreeFrame.size.height);
        endRect = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        remindWebVC.view.frame = startRect;
        remindWebVC.view.frame = endRect;
    } completion:^(BOOL finished) {
        remindWebVC.view.frame = endRect;
    }];
}

-(void)showBootRemindView
{
    [self showBootRemindByFlag:YES];
}

#pragma mark - 闪退修复
//点击了闪退修复按钮
- (void)clickRepairBtn{
    if (flashQuitRepairView.hidden == YES) {
        flashQuitRepairView.hidden = NO;
        [flashQuitRepairView isShowReadyOrIng:0];
        [self showOrHiddenRepairView:0];

    }
    
}

//闪退修复弹出效果
- (void)animationStoped
{
//    NSLog(@"弹出动画显示完毕");
}


#pragma mark
#pragma mark Repair
//点击了开始闪退修复按钮
- (void)startRepair:(id)sender{
    
    NSString *osVersion = [[UIDevice currentDevice]systemVersion];
    
    NSString * netType = [[FileUtil instance] GetCurrntNet];
    if ([netType isEqualToString:@"wifi"]) {
        if ([osVersion hasPrefix:@"4"] || [osVersion hasPrefix:@"3"]) {
            [self showOrHiddenRepairView:1];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"闪退修复不支持5.0以下苹果操作系统,请升级您的苹果操作系统." message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 100;
            [alertView show];
        }else{
            [flashQuitRepairView isShowReadyOrIng:1];
            [_homePageViewController isCanNotUse:NO];
            flashQuitRepairView.userInteractionEnabled = NO;
            
    
//            NSString * LnsLibraryPath = [NSString stringWithFormat:@"/var/mobile/Media/iTunes_Control/iTunes"];
            //闪退修复时屏幕长亮
//            [[UIApplication sharedApplication] setIdleTimerDisabled:YES ];
//            [IOSTransProxy Start:@"f_mproxy.bppstore.com"
//                      ServerPort:18000
//                        ExServer:@"f-mproxy.kuaiyong.net"
//                    ExServerPort:18000
//                  ConfigFileName:[NSString stringWithFormat:@"%@/kyflag.cfg", LnsLibraryPath]
//                    SignFileName:[NSString stringWithFormat:@"%@/kyflag.plist", LnsLibraryPath]
//                        CallBack:self
//                        UserData:(__bridge void *)(self)];
            
        }
        
        
    }else if ([netType isEqualToString:@"3g"]){
        [self showOrHiddenRepairView:1];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"网络不稳定,修复失败,请使用wifi连接修复确保成功." message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self showOrHiddenRepairView:1];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请保持您的设备处于wifi连接状态" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
//点击了关闭闪退修复按钮
- (void)closeRepair:(id)sender{

    [self showOrHiddenRepairView:1];
//    [_homePageViewController changeSelectToHomeFlag];

}
//显示和隐藏闪退修复界面
- (void)showOrHiddenRepairView:(NSInteger)index{
    // 0:show  1:hidden
    if (index == 0) {
        [UIView animateWithDuration:0.5 animations:^(void){
            flashQuitRepairView.alpha = 1.0;
            repairBgImageView.alpha = 1.0;
        } completion:^(BOOL finished){
            [self isEnableAll:NO];
            [flashQuitRepairView isShowReadyOrIng:0];
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^(void){
            flashQuitRepairView.alpha = 0.0;
            repairBgImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            flashQuitRepairView.hidden = YES;
            [self isEnableAll:YES];
        }];
    }
}

- (void)isEnableAll:(BOOL)bl{

    _homePageViewController.view.userInteractionEnabled = bl;

}

//闪退修复完成的回调
-(void)OnTransProxyResult:(int)aRet error:(int)aError userdata:(void*)aUserData{
    
    [_homePageViewController isCanNotUse:YES];
    flashQuitRepairView.userInteractionEnabled = YES;
    
    [flashQuitRepairView showRepairingResult:aRet];
    
    NSString *str = nil;
    str = [NSString stringWithFormat:@"f_stat.bppstore.com:7659/Interface/browserreport.php?devuid=%@&devmac=%@&client=%@&report=wifiath&result=%d&error=%d",@"",[[FileUtil instance]macaddress],[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleVersionKey],aRet,aError];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"GET"];
    
    [request startAsynchronous];
    
    //闪退修复完毕后取消屏幕长亮
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
//闪退修复日志回调
-(void)OnTransProxyLog:(NSString*)aLog userdata:(void*)aUserData{
    
}
//闪退修复保存管理数据
-(void)OnProxyManagerSaveData:(NSString*)astrTitle buff:(const char *)aszbuff bufflen:(int)aibufflen  userdata:(void*)aUserData{
    
}

#pragma mark -
- (void)downAlertClickItselfStaut:(NSString *)str{
    
    [_homePageViewController openDownloadPage];
    [_homePageViewController changeSelectToHomeFlag];
    
    NSString *distriPlist = nil;
    NSString *vc = nil;
    distriPlist = [distriPlistDic objectForKey:@"distriPlist"];
    vc = [distriPlistDic objectForKey:@"tableViewController"];
    
    if (distriPlist != nil && vc != nil) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:distriPlist];
        [array addObject:vc];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickLookInfoBtn"  object:array];
    }
    
}

- (void)alreadyDownedList:(NSNotification *)note{
    NSString *str = nil;
    str = note.object;
    [self AlertPopvpView:STATUS_ALREADY_IN_DOWNLOADED_LIST distriPlist:str];
    
}

//弹出框的那个可能：已经在下载列表中和已经完成了下载
- (void)AlertPopvpView:(DOWNLOAD_STATUS)status distriPlist:(NSString *)distriPlist{
    

    if (status == STATUS_ALREADY_IN_DOWNLOADING_LIST) {
        [distriPlistDic removeAllObjects];
        [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
        [distriPlistDic setObject:[NSString stringWithFormat:@"downing"] forKey:@"tableViewController"];

    }else if (status == STATUS_ALREADY_IN_DOWNLOADED_LIST){
        [distriPlistDic removeAllObjects];
        [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
        [distriPlistDic setObject:[NSString stringWithFormat:@"downover"] forKey:@"tableViewController"];
        
    }
    
}
extern BOOL datu;
//下载完成后回调弹出框告知
- (void)downLoadCompleteAlertView:(NSNotification *)note{
    
    if (datu) return;
    datu = YES;
    
    //到已下载中查看
    NSMutableArray *array = note.object;
    
    NSString *nameStr = [array objectAtIndex:0];
    NSString *distriPlist = [array objectAtIndex:1];
    [_dowloadCompetAlertView setAppNameLabelFrame:nameStr fixedText:DOWN_COMPET];
    [distriPlistDic removeAllObjects];
    [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
    [distriPlistDic setObject:[NSString stringWithFormat:@"downover"] forKey:@"tableViewController"];
    //    _homePageViewController.mainWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
        _dowloadCompetAlertView.alpha = 1.0;
    } completion:^(BOOL finished){
        
        //下载完成后根据需要弹出复制账号信息框
        if (![[NSUserDefaults standardUserDefaults] objectForKey:COPY_ACCOUNT_INFOR]) {
            [self showAccountCopyAlert:nil];
        }
        
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
    
}
- (void)hiddenBlack{
    _dowloadCompetAlertView.alpha = 0;
}
//新添加了一个下载后弹出框告知
- (void)addNewDownLoadItemAlertView:(NSNotification *)note{
    if (datu) return;
    datu = YES;
    //新添加到正在下载中
    NSMutableArray *array = note.object;
    
    NSString *distriPlist = nil;

    NSString *nameStr = [array objectAtIndex:0];
    distriPlist = [array objectAtIndex:1];
    [_dowloadCompetAlertView setAppNameLabelFrame:nameStr fixedText:ALREADY_ADD];
    [distriPlistDic removeAllObjects];
    [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
    [distriPlistDic setObject:[NSString stringWithFormat:@"downing"] forKey:@"tableViewController"];
    [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
        _dowloadCompetAlertView.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
    if (_dowloadCompetAlertView.alpha == 1.0) {
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
    }
    
}

- (void)bottomAlertViewDisappear{
    [UIView animateWithDuration:0.4 animations:^(void){ //有-->无 0.4s
        _dowloadCompetAlertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        datu = NO;

    }];
}

- (void)downloadFailCause:(NSString*)distriPlist failCause:(NSString *)failCause {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dowloadCompetAlertView setDownloadFailMessage:failCause];
        [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
            _dowloadCompetAlertView.alpha = 1.0;
        } completion:^(BOOL finished){
            
        }];
        if (_dowloadCompetAlertView.alpha == 1.0) {
            [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
        }

    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 7659) {
         if(buttonIndex == 1)
//             authPageViewController.view.hidden = NO;
             [self openLesson];

    }else if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [_homePageViewController changeSelectToHomeFlag];
        }
    }
}

- (void)backgroundDownloadAlertVIew:(NSNotification *)note{
    int index = 0;
    index = [note.object intValue];
    
    [backgroundDownloadAlertView setUseMainAudioAlertLabelText:index];
    backgroundDownloadAlertView.alpha = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(disappearBGDalertview:) userInfo:nil repeats:NO];
    
}

- (void)disappearBGDalertview:(NSTimer *)timer{
    [UIView animateWithDuration:1 animations:^(void){
        backgroundDownloadAlertView.alpha = 0.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void)showAlreadyJoinDowningList:(NSNotification *)note{
    
    NSString * PlistUrl = note.object;
    
    [self AlertPopvpView:STATUS_ALREADY_IN_DOWNLOADING_LIST distriPlist:PlistUrl];
}

-(void)jumpToDownloadingView:(NSNotification *)notification
{
    // 点击事件来自 下载管理页的修复列表情况
    [self openRepairAppList:nil];
    //
    NSString *distriPlist = notification.object;
    [distriPlistDic removeAllObjects];
    [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
    [distriPlistDic setObject:[NSString stringWithFormat:@"downing"] forKey:@"tableViewController"];
    
    // 跳转
    [self downAlertClickItselfStaut:nil];
}

#pragma mark - 3/4G网络判断

-(NSInteger)getNetWorkState
{ // 2:3G，3:4G，4:LTE，5:Wifi
    
    NSNumber *number = [UIApplication dataNetworkTypeFromStatusBar];
    return [number integerValue];
}

-(void)show3GFreeFlowAlertView
{
#define ALREADY_SHOW_ALERT_VIEW_KEY @"ALREADY_SHOW_ALERT_VIEW_KEY"
    
    NSNumber * show3GAlert = [[NSUserDefaults standardUserDefaults] objectForKey:ALREADY_SHOW_ALERT_VIEW_KEY];
    if( [show3GAlert boolValue] )
        return ; //已经显示过，不再显示

    
    // 2:3G，3:4G，4:LTE，5:Wifi
    NSInteger stateValue = [self getNetWorkState];
    NSString *chineseOperator = [[FileUtil instance] checkChinaMobile];
    
    if ((stateValue==2 || stateValue==3) && [chineseOperator isEqualToString:@"中国联通"]) { // 3/4G

        //已经显示过了
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:ALREADY_SHOW_ALERT_VIEW_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (stateValue == 5)
    {// Wifi
        NSLog(@"当前Wifi网络");
    }
    
}

#pragma mark - lesson delegate/ NSNotification method
- (void)openLesson{
    ifPopView = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    pop.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height);
    [self.view bringSubviewToFront:pop.view];
    
    [UIView commitAnimations];
    
    [self closeRepair:nil];
}
- (void)closeLesson{
}

- (void)closePopView:(id)sender
{
    ifPopView = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    pop.view.frame = CGRectMake(0, MainScreen_Height, MainScreen_Width, MainScreen_Height);
    [UIView commitAnimations];
    //[_homePageViewController changeToHomeFlag];
}

#pragma mark - Open RepairApp List

-(void)openRepairAppList:(NSNotification *)notification
{
    NSLog(@"open repair applist");
    
    if ([repairAppVC.view superview] == nil) {
        repairAppVC.view.frame = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
        [self.view addSubview:repairAppVC.view];
    }
    
    if ([notification.object isEqualToString:@"open"]) {
        // animaiton
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        repairAppVC.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreeFrame.size.height);
        [self.view bringSubviewToFront:repairAppVC.view];
        
        [UIView commitAnimations];
    }
    else
    {
        // animaiton
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        repairAppVC.view.frame = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
        [self.view bringSubviewToFront:repairAppVC.view];
        
        [UIView commitAnimations];
    }
    
}


//#pragma mark - Open DIDI WEB
//
//-(void)openDidiWeb:(NSNotification *)notification
//{
//    
//    if ([notification.object isEqualToString:@"open"]) {
//        // animaiton
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        didiWebView.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreeFrame.size.height);
//        [self.view bringSubviewToFront:didiWebView.view];
//        
//        [UIView commitAnimations];
//    }
//    else
//    {
//        // animaiton
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        didiWebView.view.frame = CGRectMake(0, MainScreeFrame.size.height, MainScreen_Width, MainScreeFrame.size.height);
//        [self.view bringSubviewToFront:didiWebView.view];
//        
//        [UIView commitAnimations];
//    }
//    
//}


#pragma mark - Life Cycle

- (void) dealloc{
    [[BppDistriPlistManager getManager] removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _homePageViewController.mainVCDelegate = nil;
    authPageViewController.delegate = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{ // 禁用横屏
    return YES;
}

#pragma mark -- requestRealtimeShowDelegate
- (void)requestRealtimeShowsuccessWithDic:(NSDictionary *)dic
{
    if (!dic) {
        //删除缓存
        [tmpPopView deleteTheImage];
        
    }else{
        [tmpPopView showWithDic:dic];
    }
    
    [RealtimeShowAdvertisement getObject].delegate = nil;
}

- (void)requestRealtimeShowFaild
{
    [RealtimeShowAdvertisement getObject].delegate = nil;
}
- (void)openAuthorizationPage{
    authPageViewController.view.hidden = YES;

}

#pragma mark - UIWebViewControllerDelegate

-(void)hideBootRemindView
{
    [self showBootRemindByFlag:NO];
}


#pragma mark - 处理请求appid结果
- (void)receiveAppidResult:(NSNotification*)noti{

    //是否只显示一次
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:REQUEST_APPID_RESULT]) {
//        return;
//    }
    appidResultView = [[RequestAppidResultView alloc] initWithFrame:self.view.frame];
    appidResultView.appidResultDelegate = self;
    [self.view addSubview:appidResultView];
    
    int type = [noti.object integerValue];
    
    [appidResultView  showRequestAppidResultViewWithType: type];
}

- (void)handleAppidResult:(int)type{
    //待续
    
    [_homePageViewController openMoreSettingPage];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:REQUEST_APPID_RESULT];
    
}
#pragma mark - 启动提醒

-(void)requestRemindData
{
    [[MarketServerManage getManager] addListener:self];
    [[MarketServerManage getManager] requestEnableRemind:nil];
}

-(void)EnableRemindRequestSucess:(NSDictionary *)dataDic userData:(id)userData
{
    if ([self checkBootRemindDataValid:dataDic]) {
        [remindWebVC navigation:[dataDic objectForKey:@"detailUrl"]];
        [remindWebVC setCustomNavTitle:[dataDic objectForKey:@"title"]];
        [self performSelector:@selector(showBootRemindView) withObject:nil afterDelay:5.0];
    }
}

-(void)EnableRemindRequestFail:(id)userData
{
}

-(BOOL)checkBootRemindDataValid:(NSDictionary *)remindDic
{
    BOOL flag = NO;
    
    if (!IS_NSDICTIONARY(remindDic)) return flag;
    
    if (IS_NSSTRING([remindDic objectForKey:@"detailUrl"]) && IS_NSSTRING([remindDic objectForKey:@"detailUrl"])) {
        flag = YES;
    }
    
    return flag;
}

- (void)clickAccount{
    loginCancellationView.hidden = NO;
}

- (void)hiddenLoginCancellation:(UIButton*)sender{
    
    loginCancellationView.hidden = YES;
    
}
-(void)CancellationAccount:(UIButton*)sender{
    
    loginCancellationView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNTPASSWORD];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLICK_CANCELLATION object:nil];
}

- (void)hiddenLoginLoading:(NSNotification *)note{
    
    NSString *stateStr = note.object;
    if ([stateStr isEqualToString:@"loginloading"]) {
        mumView.hidden = NO;
        [mumView isShowState:0];
    }else if([stateStr isEqualToString:@"loginsucess"]){

        NSString*account = [[[FileUtil instance] getAccountPasswordInfo] objectForKey:SAVE_ACCOUNT];
        
        if ([[LoginServerManage getManager] isRepeatLogin:account] == NO) {
            [mumView isShowState:1];
        }else{
            [self hideMumView];
        }
        mumView.hidden = YES;
        
    }else if([stateStr isEqualToString:@"loginfail"]){
        mumView.hidden = NO;
        [mumView isShowState:2];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hiddenLoginAlert:) userInfo:nil repeats:NO];
    }else if([stateStr isEqualToString:@"no_account"]){
        mumView.hidden = YES;
    }else if ([stateStr isEqualToString:@"moreThanTwo"]){
        mumView.hidden = YES;
    }

}
- (void)hideMumView{
    mumView.hidden = YES;
    [mumView isShowState:99];
}
- (void)hiddenLoginAlert:(NSTimer *)timer{
    mumView.hidden = YES;
    [mumView isShowState:99];
    
}

- (void)installKKK:(NSNotification*)note{
    installKKK.kInstallString = [note.userInfo objectForKey:@"plist"];
    
    installKKK.hidden = NO;
    
    
}
- (void)quitbingdingpage:(NSNotification*)note{
    
    nbindingAView.hidden = NO;
    
}

- (void)showAccountList:(NSNotification*)note{
    listAView.hidden = NO;
    [listAView reloadList];
}
- (void)hiddenGif{
    [self hideMumView];
}
- (void)openLockPage:(NSNotification*)note{
    [_homePageViewController openMoreSettingPage];
}


@end