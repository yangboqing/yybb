//
//  ResourceHomeViewController.m
//  MyAssistant
//
//  Created by liguiyang on 14-11-18.
//  Copyright (c) 2014年 myAssistant. All rights reserved.
//

#import "ResourceHomeViewController.h"
#import "MyNavigationController.h"
#import "MLNavigationController.h"
#import "ResourceHomeToolBar.h" // 底端导航按钮
#import "ChoiceViewController_my.h" //精品
#import "MarketAppGameViewController_my.h" // 应用、游戏
#import "SearchViewController_my.h" // 搜索
#import "FindViewController.h" // 发现
#import "UIImageEx.h"
#import "MoreManageViewController.h"//我的
#import "ClassificationBackView.h"//分类
#import "dowloadCompetAlertView.h" // 小黑框提示
#import "LookInfoAlertView.h"
#import "AppidAlert.h"
#import "WYNotBindingAlertView.h"
#import "WYAccountInfoAlertView.h"


#define statusbar_height [UIApplication sharedApplication].statusBarFrame.size.height

@interface ResourceHomeViewController ()<ResourceHomeToolBarDelegate,MarketAppGameDelegate,ClassificationBackViewDelegate,downAlertViewDelegate>
{
    MyNavigationController *choiceNav;// 精选
    ChoiceViewController_my *choiceVC;
    MyNavigationController *appNav;// 应用
    MarketAppGameViewController_my *appVC;
    MyNavigationController *gameNav;// 游戏
    MarketAppGameViewController_my *gameVC;
    MyNavigationController *searchNav; // 搜索
    SearchViewController_my *searchVC;
    MyNavigationController *myNav; // 我的
    MoreManageViewController *myVC;
    
    ResourceHomeToolBar *bottomToolBar; // 底部导航
    
    NSMutableDictionary *distriPlistDic; // 跳转需要的数据
    dowloadCompetAlertView *_downloadCompetAlertView; // 小黑框
    
    // 应用游戏分类
    UIView *categoryWhiteView;
    ClassificationBackView *classifyGAVC;
    MyNavigationController *classifyGANav;
    
    
    LookInfoAlertView *_lookInfoAlertView;
    
    
    AppidAlert *appidAlert;//账号赋值提示
    
    
    WYNotBindingAlertView *nbindingAView;
    WYAccountInfoAlertView *listAView;
}


@end


@implementation ResourceHomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        distriPlistDic = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

#pragma mark - Utility
//状态栏发生高度变化时响应
- (void)changeFrame{
    self.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height - statusbar_height + 20 );
    
}

-(void)hideBottomToolBar:(NSNotification *)notification
{ // 隐藏底部导航
    BOOL hideFlag = [notification.object boolValue];
    bottomToolBar.hidden = hideFlag;
}

- (void)backToHomeViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

//新添加了一个下载后弹出框告知
- (void)addNewDownLoadItemAlertView:(NSNotification *)note{
    _downloadCompetAlertView.appid = nil;
    
    //新添加到正在下载中
    NSMutableArray *array = note.object;
    
    NSString *distriPlist = nil;
    
    NSString *nameStr = [array objectAtIndex:0];
    distriPlist = [array objectAtIndex:1];
    [_downloadCompetAlertView setAppNameLabelFrame:nameStr fixedText:ALREADY_ADD];
    [distriPlistDic removeAllObjects];
    [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
    [distriPlistDic setObject:[NSString stringWithFormat:@"downing"] forKey:@"tableViewController"];
    [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
        _downloadCompetAlertView.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
    if (_downloadCompetAlertView.alpha == 1.0) {
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
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
    [_downloadCompetAlertView setAppNameLabelFrame:nameStr fixedText:DOWN_COMPET];
    [distriPlistDic removeAllObjects];
    [distriPlistDic setObject:distriPlist forKey:@"distriPlist"];
    [distriPlistDic setObject:[NSString stringWithFormat:@"downover"] forKey:@"tableViewController"];
    //    _homePageViewController.mainWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
        _downloadCompetAlertView.alpha = 1.0;
    } completion:^(BOOL finished){
        
        //下载完成后根据需要弹出复制账号信息框
        if (![[NSUserDefaults standardUserDefaults] objectForKey:COPY_ACCOUNT_INFOR]) {
            [self showAccountCopyAlert:nil];
        }
        
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
    
}
- (void)bottomAlertViewDisappear{
    [UIView animateWithDuration:0.4 animations:^(void){ //有-->无 0.4s
        _downloadCompetAlertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        datu = NO;
        
    }];
}

- (void)AUDownloadFail:(NSNotification *)noti{
    NSDictionary *infor = (NSDictionary *)noti.object;
    
    [_downloadCompetAlertView setAppNameLabelFrame:[infor objectForKey:@"name"] fixedText:@"下载失败!"];
    _downloadCompetAlertView.appid = [infor objectForKey:@"appid"];
    
//    [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:[infor objectForKey:@"appid"]];
    
    [UIView animateWithDuration:0.4 animations:^(void){         //无->有 0.4s
        _downloadCompetAlertView.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
    if (_downloadCompetAlertView.alpha == 1.0) {
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bottomAlertViewDisappear) userInfo:nil repeats:NO];
    }
}

////点击绑定Apple ID弹框
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        [self homeBottomToolBarItemClick:homeToolBar_MyType];
//        [myNav popToRootViewControllerAnimated:NO];
//        [myVC selectRow:[NSIndexPath indexPathForRow:0 inSection:1]];
//    }
//}
#pragma mark - 处理请求appid结果
- (void)receiveAppidResult:(NSNotification*)noti{
    
    //是否只显示一次
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:REQUEST_APPID_RESULT]) {
    //        return;
    //    }
    appidResultView = [[RequestAppidResultView alloc] initWithFrame:self.view.frame];
    appidResultView.appidResultDelegate = self;
    [self.view addSubview:appidResultView];
    
    CGFloat type = [noti.object integerValue];
    
    [appidResultView  showRequestAppidResultViewWithType: type];
}



- (void)handleAppidResult:(int)type{
    //待续
    
    [self homeBottomToolBarItemClick:homeToolBar_MyType];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:REQUEST_APPID_RESULT];
    
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
    [self homeBottomToolBarItemClick:homeToolBar_MyType];
}

#pragma mark - MarketAppGameDelegate
-(void)presentClassifyViewController:(NSString *)classifyName{
    
    static BOOL couldTouch = YES;
    if (couldTouch) {
        
        couldTouch = NO;
        
        // 游戏、应用分类（必须在最高层）
        classifyGAVC = [[ClassificationBackView alloc] init];
        classifyGANav = [[MyNavigationController alloc] initWithRootViewController:classifyGAVC];
        classifyGAVC.delegate = self;
        [categoryWhiteView addSubview:classifyGANav.view];
        [self.view addSubview:categoryWhiteView];
        classifyGANav.view.frame = self.view.bounds;
        categoryWhiteView.frame  = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        
        [UIView animateWithDuration:0.25 animations:^{
            categoryWhiteView.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            
            couldTouch = YES;
            categoryWhiteView.frame = self.view.bounds;
            // 请求
            if ([classifyName isEqualToString:@"app"]) {
                [classifyGAVC AppRequrtManager];
            }else{
                [classifyGAVC GameRequrtManager];
            }
        }];
    }
}

#pragma mark - ClassificationBackViewDelegate
- (void)dismissCategoryViewController:(UIViewController *)categoryVC
{
    CGRect endRect = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        categoryWhiteView.frame = endRect;
    } completion:^(BOOL finished) {
        categoryWhiteView.frame = endRect;
        
        if ([classifyGAVC.view superview]) {
            [classifyGAVC.view removeFromSuperview];
        }
        if (classifyGANav.view.superview) {
            [classifyGANav.view removeFromSuperview];
        }
        
        classifyGAVC = nil;
        classifyGANav = nil;
    }];
}

#pragma mark -getDigitalIdDelegate

-(void)selfDigitalIdRequestSuccess:(NSDictionary *)dataDic isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if ([dataDic objectForKey:@"data"]) {
        [Context defaults].digID = [dataDic objectForKey:@"data"];
    }
    else
    {
        [Context defaults].digID = nil;
    }
}

-(void)selfDigitalIdRequestFailed:(BOOL)isUseCache userData:(id)userData
{
        [Context defaults].digID = nil;
}


#pragma mark - ResourceHomeToolBarDelegate

-(void)homeBottomToolBarItemClick:(HomeToolBarItemType)barItemType
{
    //
    [Context defaults].currentBarTag = barItemType;
    //
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    switch (barItemType) {
        case homeToolBar_ChoiceType:{ // 精选
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//            NSLog(@"精选Click");
            choiceNav.view.hidden = NO;
            appNav.view.hidden = YES;
            gameNav.view.hidden = YES;
            searchNav.view.hidden = YES;
            myNav.view.hidden = YES;
            
            // 初次请求（once）
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [choiceVC requestData:YES];
            });
            // 设置全局标记
            [Context defaults].currentNavTag = tagNav_choice;
        }
            break;
        case homeToolBar_AppType:{ // 应用
//            NSLog(@"应用Click");
            choiceNav.view.hidden = YES;
            appNav.view.hidden = NO;
            gameNav.view.hidden = YES;
            searchNav.view.hidden = YES;
            myNav.view.hidden = YES;

            // 初次请求（once）
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [appVC requestAll];
            });
            
            [Context defaults].currentNavTag = tagNav_app;
        }
            break;
        case homeToolBar_GameType:{ // 游戏
//            NSLog(@"游戏Click");
            choiceNav.view.hidden = YES;
            appNav.view.hidden = YES;
            gameNav.view.hidden = NO;
            searchNav.view.hidden = YES;
            myNav.view.hidden = YES;

            // 初次请求（once）
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [gameVC requestAll];
            });
            
            [Context defaults].currentNavTag = tagNav_game;
        }
            break;
        case homeToolBar_SearchType:{
            DeLog(@"搜索Click");
            choiceNav.view.hidden = YES;
            appNav.view.hidden = YES;
            gameNav.view.hidden = YES;
            searchNav.view.hidden = NO;
            myNav.view.hidden = YES;

            // 初次请求（once）
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
//                [wallPaperVC initRequest];
            });

            [Context defaults].currentNavTag = tagNav_search;
            [searchNav.topViewController becomeFirstResponder];
        }
            break;
        case homeToolBar_MyType:{
            DeLog(@"我的Click");
            choiceNav.view.hidden = YES;
            appNav.view.hidden = YES;
            gameNav.view.hidden = YES;
            searchNav.view.hidden = YES;
            myNav.view.hidden = NO;

            // 初次请求（once）
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                //                [wallPaperVC initRequest];
            });
            
            [Context defaults].currentNavTag = tagNav_my;
            [myNav.topViewController becomeFirstResponder];
            // 更新更多界面缓存数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCacheSizeLabel" object:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark downAlertViewDelegate

- (void)downAlertClickItselfStaut:(NSString *)str
{
    //跳store同时删除下载中列表的cell
    if (_downloadCompetAlertView.appid) {
        [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:_downloadCompetAlertView.appid];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_APP_BECAUSE_DOWNLOAD_FAIL object:_downloadCompetAlertView.appid];
        _downloadCompetAlertView.appid = nil;
        return;
    }
    
    [bottomToolBar bottomToolBarSelectItemType:homeToolBar_MyType];
    [myVC pushDownloadViewController];
    
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

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // 精选
    choiceVC = [ChoiceViewController_my new];
    choiceNav = [[MyNavigationController alloc] initWithRootViewController:choiceVC];
    choiceNav.tag = tagNav_choice;
    [choiceVC setleftClickBlock:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:choiceNav.view];
    choiceVC.navigationController = choiceNav;
    choiceNav.view.hidden = YES;
    
    // 应用
    appVC = [[MarketAppGameViewController_my alloc] initWithMarketType:marketType_App];
    appVC.delegate=self;
    appNav = [[MyNavigationController alloc] initWithRootViewController:appVC];
    appNav.tag = tagNav_app;
    [self.view addSubview:appNav.view];
    appVC.navigationController = appNav;
    appNav.view.hidden = YES;
    
    // 游戏
    gameVC = [[MarketAppGameViewController_my alloc] initWithMarketType:marketType_Game];
    gameVC.delegate=self;
    gameNav = [[MyNavigationController alloc] initWithRootViewController:gameVC];
    gameNav.tag = tagNav_game;
    [self.view addSubview:gameNav.view];
    gameVC.navigationController = gameNav;
    gameNav.view.hidden = YES;
    
    // 搜索
    searchVC = [[SearchViewController_my alloc] initWithSearchType:searchType_self];
    searchNav = [[MyNavigationController alloc] initWithRootViewController:searchVC];
    searchNav.tag = tagNav_search;
    [self.view addSubview:searchNav.view];
    searchNav.view.hidden = YES;
    
    // 我的
    if ([Context defaults].homeToolBarBtnCount == 5) {
        myVC = [[MoreManageViewController alloc] init];
        myNav = [[MyNavigationController alloc] initWithRootViewController:myVC];
        myNav.tag = tagNav_my;
        [self.view addSubview:myNav.view];
        myNav.view.hidden = YES;
    }
    
    // 底端导航
    bottomToolBar = [[ResourceHomeToolBar alloc] init];
    bottomToolBar.RHBardelegate = self;
    [self.view addSubview:bottomToolBar];
    
    // 小黑框提示
    _downloadCompetAlertView = [[dowloadCompetAlertView alloc]init];
    _downloadCompetAlertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _downloadCompetAlertView.alpha = 0.0;
    _downloadCompetAlertView.delegate = self;
    [self.view addSubview:_downloadCompetAlertView];
    
    categoryWhiteView = [[UIView alloc] initWithFrame:self.view.bounds];
    categoryWhiteView.backgroundColor = [UIColor whiteColor];
    
    // 初始设置
    [bottomToolBar bottomToolBarSelectItemType:homeToolBar_ChoiceType];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottomToolBar:) name:HIDETABBAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewDownLoadItemAlertView:) name:ADD_NEW_DOWNLOAD_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downLoadCompleteAlertView:)
                                                 name:DOWNLOADCOMPLETE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AUDownloadFail:) name:AU_DOWNLOAD_FAIL object:nil];
    
    //检测状态栏高度
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [[MyServerRequestManager getManager]addListener:self];
    [[MyServerRequestManager getManager] getSelfDigitalId:NO userData:nil];
    
    
    //推荐成功信息
    _lookInfoAlertView = [[LookInfoAlertView alloc] init];
    _lookInfoAlertView.alpha = 0.0;
    [self.view addSubview:_lookInfoAlertView];
    
    
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
    
    
    
    nbindingAView = [WYNotBindingAlertView new];
    nbindingAView.hidden = YES;
    [self.view addSubview:nbindingAView];
    
    listAView = [WYAccountInfoAlertView new];
    listAView.hidden = YES;
    [self.view addSubview:listAView];
    
    
    //推荐成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(promoteInforShow:)
                                                 name:PROMOTE_INFO_SHOW
                                               object:nil];
    // 跳转到“管理”-下载中页面
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToDownloadingView:) name:JUMP_DOWNLOADING object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAccount) name:CLICK_ACCOUNT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLoginLoading:) name:SHOW_HIDDEN_LOGIN_LOADING object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitbingdingpage:) name:IS_QUIT_BINDING_PAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountList:) name:SHOW_ACCOUNT_LIST object:nil];
    //请求appid结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAppidResult:) name:REQUEST_APPID_RESULT object:nil];
    //au下载应用时复制账号弹框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountCopyAlert:) name:COPY_ACCOUNT_INFOR object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGuide) name:@"yibujihuochangjiaocheng" object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLockPage:) name:@"openLockPage" object:nil];

    //添加绑定Apple ID提示
    
    BOOL hasShowBindingIDView = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasShowBindingIDView"] boolValue];
    if (!hasShowBindingIDView) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"绑定Apple ID就不用反复输入账号密码啦,一次绑定省心持久" delegate:self cancelButtonTitle:@"已有Apple ID" otherButtonTitles:@"木有Apple ID", nil];
//        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"hasShowBindingIDView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillLayoutSubviews
{
    CGRect bounds = self.view.bounds;
    choiceVC.view.frame = bounds;
    appVC.view.frame = bounds;
    gameVC.view.frame = bounds;
    searchVC.view.frame = bounds;
    myVC.view.frame = bounds;
    bottomToolBar.frame = CGRectMake(0, bounds.size.height-BOTTOM_HEIGHT, bounds.size.width, BOTTOM_HEIGHT);
    _downloadCompetAlertView.frame = CGRectMake(0, bounds.size.height-BOTTOM_HEIGHT-31, bounds.size.width, 31);
    
    _lookInfoAlertView.frame = CGRectMake(0, 0, 200, 80);
    CGSize tmpSize = self.view.frame.size;
    _lookInfoAlertView.center = CGPointMake(tmpSize.width/2, tmpSize.height/2);
    nbindingAView.frame = MainScreeFrame;
    listAView.frame = MainScreeFrame;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDETABBAR object:nil];
}


@end
