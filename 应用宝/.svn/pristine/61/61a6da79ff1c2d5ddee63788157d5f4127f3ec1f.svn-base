
//
//  ResourceHomePageViewController.m
//  browser
//
//  Created by 王 毅 on 13-6-3.
//
//

#import "ResourceHomePageViewController.h"
#import "UITextFieldEx.h"
#import "UIImageEx.h"
#import "ReportManage.h"
#import "FileUtil.h"
#import "Reachability.h"
#import "IphoneAppDelegate.h"
#import "BppDownloadToLocal.h"
#import "JSONKit.h"
#import <objc/runtime.h>
#import "KyMarketNavgationController.h"
#import "SearchResult_DetailViewController.h"
#import "AppUpdateNewVersion.h"

#import "MLNavigationController.h"

#define DATA_TITLE @"dataTitle"
#define DATA_ARRAY @"dataArray"


@interface MyNavigationBar : UINavigationBar{
    @private
    UIImageView * myImageView;
    CAShapeLayer * myLayer;
}

@end

@implementation MyNavigationBar

- (id)init
{
    self = [super init];
    if (self) {
        
        myImageView = [[[[self subviews] firstObject] subviews] firstObject];
        
        if (!IOS7) {
            self.tintColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
                //新春版 白色
//            self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont systemFontOfSize:16.0f],UITextAttributeFont, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, nil];
            self.backgroundColor = self.tintColor;
            myImageView.backgroundColor = [UIColor redColor];
        }else{
            myLayer = [CAShapeLayer layer];
            myLayer.backgroundColor = [UIColor redColor].CGColor;
            [self.layer addSublayer:myLayer];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!IOS7) {
        myImageView.frame = CGRectMake(0, 44, self.bounds.size.width, 0.5);
        [self.subviews.firstObject setFrame:CGRectZero];
    }else{
        //顶部按钮和轮播图中间的红线
        //新春版
//        myLayer.frame = CGRectMake(0, 44, self.bounds.size.width, 0.5);
    }
}

@end

BOOL _nav = NO;
@interface MyNavgationController : MLNavigationController

@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, strong) MyNavigationBar * navigationBar;

@end

@implementation MyNavgationController

- (void)setIsClick:(BOOL)isClick{
    _nav = isClick;
    _isClick = isClick;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    if (_isClick) return;
    
    [super pushViewController:viewController animated:animated];
    //新春版 白色
    
//    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont systemFontOfSize:16.0],UITextAttributeFont, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset , nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [MyNavigationBar new];
    //禁用或启用右滑返回
    if (IOS7) self.interactivePopGestureRecognizer.enabled = YES;
}

@end



@interface ResourceHomePageViewController () <UINavigationControllerDelegate, AppUpdateNewVersionProtocol>{
    NSMutableDictionary *requestDic;
    MyNavgationController * _marketNaViewController;
    KyMarketNavgationController * _marketViewController;
    BOOL searchLock;//搜索按钮锁,用于禁用双击搜索按钮
    
    UIImageView *leaderImgView; // 应用修复列表 引导图 引导至设置应用修复列表中
}
@property (nonatomic , strong) NSString *myUpdataUrl;
@end
@implementation ResourceHomePageViewController
@synthesize mainVCDelegate = _mainVCDelegate;
@synthesize saveBottomFlagDictionary = _saveBottomFlagDictionary;

#pragma mark
#pragma mark Check ConfigPath
//检查剩余空间是否够50MB
- (void) checkFreeSize:(NSTimer*)timer {
    
#define CHECK_FREE_SIZE  50
    
    int64_t fressSize = (int64_t)[[FileUtil instance] getFreeDiskspace]/1024.0/1024.0;
    if (fressSize < CHECK_FREE_SIZE) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"系统剩余空间不足！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate = self;
        [alertView show];
        
        //停止所有下载
        [[BppDistriPlistManager getManager] stopAllPlistURL];
        
        
        [timer invalidate];
        return ;
    }
    
}



#pragma mark -
#pragma ResourceHomeBottomDelegate

//打开搜索页面
- (void)openSearchPage:(id)sender
{
    if (searchLock) {
        return;
    }
    searchLock = YES;
    [self performSelector:@selector(unlockSearchButton) withObject:nil afterDelay:0.5];
    if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:SEARCH_FALG]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HOT_WORDS object:nil];
    }
    
    [searchViewController requestTheHotWord];
    
    [resourceHomeBottom setHomeBottomSelectButton:CLICK_SEARCH_BUTTON];
    
    [self changeShowPage:SEARCHVIEW_SHOE];
    
    [self.saveBottomFlagDictionary setObject:SEARCH_FALG forKey:BOTTOM_FLAG];
    
    
}

- (void)unlockSearchButton{
    searchLock  = NO;
}
//打开下载管理
- (void)openDownloadPage{
    [self changeShowPage:DOWNLOADPAGE_SHOW];
    [downMangerViewController showDownloadPage:@"downing"];
    [self.saveBottomFlagDictionary setObject:DOWNLOAD_FLAG forKey:BOTTOM_FLAG];
}

//打开发现页面
- (void)openUpdataPage{
    
    // 启动后第一次点击按钮请求发现数据
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [findViewController initilizationChoiceRequest];
    });
    
    // 点击底部导航一次返回根目录
    if (resourceHomeBottom.flag == CLICK_UPDATA_BUTTON){
        if (findNavController.viewControllers.count > 1){
            for (UIViewController *vc in findNavController.viewControllers) {
                if ([vc isMemberOfClass:[FindDetailViewController class]]) {
                    // 移除监听（立即调用dealloc）
                    [((FindDetailViewController*)vc) removeObserverAndListener];
                }
            }
            
            [findNavController popToRootViewControllerAnimated:YES];
        }
    }
    
    // 显示发现页面
    [self changeShowPage:UPDATAPAGE_SHOW];
    [self.saveBottomFlagDictionary setObject:UPDATA_FLAG forKey:BOTTOM_FLAG];
    
}

// 3G免流页面
- (void)show3GFreeFlowView
{

        [self _marketNavpopToRootViewController:NO];
        
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_HOME_BUTTON];
        [self.saveBottomFlagDictionary setObject:HOME_FLAG forKey:BOTTOM_FLAG];
        [self changeShowPage:HOMEPAGE_SHOW];
        KyMarketViewController * _vc = (KyMarketViewController *)self->_marketViewController->_marketViewController;
        [_vc.topbar setMarket_top_barClickWithIndex:0];
    
}

//点击了更多，弹出pop视图
- (void)openMorePage:(UIButton *)sender{
    
    if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:MORE_FLAG]) {
        [self morePopToRootViewController:YES];
    }
    else
    {
        [self morePopToRootViewController:NO];
        MoreManageViewController *viewController = (MoreManageViewController *)moreNavController.viewControllers[0];
        [viewController scrollToTop];
    }
    //
    [resourceHomeBottom setHomeBottomSelectButton:CLICK_MORE_BUTTON];
    [self.saveBottomFlagDictionary setObject:MORE_FLAG forKey:BOTTOM_FLAG];
    [self changeShowPage:MOREMANAGE_SHOW];

}

- (void)makeViews{
    
    _marketViewController = [[KyMarketNavgationController alloc] init];
    
    _marketNaViewController = [[MyNavgationController alloc] initWithRootViewController:_marketViewController];
    _marketNaViewController.navDelegate = self;
    
    _marketNaViewController.delegate = self;
    
    [self.view addSubview:_marketNaViewController.view];
    
    requestDic = [[NSMutableDictionary alloc]init];
    
    self.saveBottomFlagDictionary = [[NSMutableDictionary alloc]init];
    
    //下载页面
    downMangerViewController = [[DownLoadManageViewController alloc]init];
    downLoadNaViewController = [[MLNavigationController alloc] initWithRootViewController:downMangerViewController];
    [downLoadNaViewController cancelRightPanGestureFunction];
    downLoadNaViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:downLoadNaViewController.view];
    
    //搜索页面
    searchViewController = [[SearchViewController alloc]init];
    searchNaViewController = [[MLNavigationController alloc] initWithRootViewController:searchViewController];
    searchNaViewController.navDelegate = self;
    searchNaViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    searchNaViewController.delegate = self;
    [self.view addSubview:searchNaViewController.view];
    
    // 发现页面
    findViewController = [[FindViewController alloc] init];
    findNavController = [[MLNavigationController alloc] initWithRootViewController:findViewController];
    findNavController.navDelegate = self;
    [self.view addSubview:findNavController.view];
    
    // 更多页面
    moreManageVC = [[MoreManageViewController alloc] init];
    moreNavController = [[MLNavigationController alloc] initWithRootViewController:moreManageVC];
    moreNavController.navDelegate = self;
    [moreNavController cancelRightPanGestureFunction];
    [self.view addSubview:moreNavController.view];
    
    //资源站底部5个按钮
    {
        resourceHomeBottom = [[ResourceHomeBottom alloc]init];
        resourceHomeBottom.backgroundColor = [UIColor clearColor];
        [self.view addSubview:resourceHomeBottom];
        resourceHomeBottom.delegate_ = self;
        [resourceHomeBottom.shareBtn addTarget:self action:@selector(openSearchPage:) forControlEvents:UIControlEventTouchUpInside];
        [resourceHomeBottom.homeBtn addTarget:self action:@selector(showResourcessHomePage:) forControlEvents:UIControlEventTouchUpInside];
        [resourceHomeBottom.moreBtn addTarget:self action:@selector(openMorePage:) forControlEvents:UIControlEventTouchUpInside];
    }

        [self changeToHomeFlag];
        [self changeShowPage:HOMEPAGE_SHOW];

    
    //设置尺寸
    [self setViewFrameOnInit];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkFreeSize:) userInfo:nil repeats:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self makeViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickLocalPushLookBtn:)
												 name:LOCAL_PUSH_CLICK_OK
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDownloadCount:)
												 name:RELOADDOWNLOADCOUNT
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openCheckUpdataSelfPage:)
												 name:@"openCheckUpdataSelfPage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideTabBar:)
                                                 name:HIDETABBAR
                                               object:nil];
    // mainVCDelegate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMainVCDelegateMethodAlertPopvpView:) name:@"mainVCDelegateAlertMethod" object:nil];
    // 切换至资源首页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResourcessHomePage:) name:JUMP_HOMEPAGE object:nil];
    [self openCheckUpdataSelfPage:nil];

    
}

//本地推送的确认按钮事件，按钮tag == 1
- (void)clickLocalPushLookBtn:(NSNotification *)note{
    
    return;
    
    [self changeShowPage:DOWNLOADPAGE_SHOW];
     [downMangerViewController showDownloadPage:@"downed"];
    
}

- (void)changeSelectToHomeFlag{
    if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:HOME_FLAG]) {
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_HOME_BUTTON];
    }else if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:SEARCH_FALG]){
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_SEARCH_BUTTON];
    }else if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:DOWNLOAD_FLAG]){
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_DOWNLOAD_BUTTON];
    }else if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:UPDATA_FLAG]){
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_UPDATA_BUTTON];
    }else if ([[self.saveBottomFlagDictionary objectForKey:BOTTOM_FLAG] isEqualToString:MORE_FLAG]){
        [resourceHomeBottom setHomeBottomSelectButton:CLICK_MORE_BUTTON];
    }
    
}

- (void)changeToHomeFlag{
     [resourceHomeBottom setHomeBottomSelectButton:CLICK_HOME_BUTTON];
    [self.saveBottomFlagDictionary setObject:HOME_FLAG forKey:BOTTOM_FLAG];
}

- (void)setViewFrameOnInit {
    

    _marketNaViewController.view.frame = self.view.bounds;
    
    
    leaderImgView.frame = CGRectMake(0, 0, MainScreeFrame.size.width, MainScreeFrame.size.height);
    downLoadNaViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    searchNaViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
//    _updataViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 46.0f);
    findNavController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    moreNavController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    resourceHomeBottom.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - BOTTOM_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT);
    
//    bgTapImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - resourceHomeBottom.frame.size.height);
}

#pragma mark -
#pragma mark navDelegate

- (void)lockBottomTabbar{
    resourceHomeBottom.userInteractionEnabled = NO;
}
- (void)unlockBottomTabbar{
    resourceHomeBottom.userInteractionEnabled = YES;
}
#pragma mark -
#pragma mark -
#pragma mark 底部操作
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (animated) _marketNaViewController.isClick = YES;
//    viewController.view.userInteractionEnabled = NO;
//    resourceHomeBottom.userInteractionEnabled = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
     _marketNaViewController.isClick = NO;
//    viewController.view.userInteractionEnabled = YES;
//    resourceHomeBottom.userInteractionEnabled = YES;
}

- (void)_marketNavpopToRootViewController:(BOOL)_animation{
    NSInteger index = _marketNaViewController.viewControllers.count-1;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideCategoryViewController" object:nil];
    [_marketNaViewController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (idx) {
            if (idx == index) {
                
                CATransition *animation = [CATransition animation];
                
                [animation setDuration:0.3];
                
                [animation setType: kCATransitionPush];
                
                [animation setSubtype: kCATransitionFromLeft];
                
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                [obj viewWillDisappear:NO];
                [_marketNaViewController popViewControllerAnimated:NO];
                [obj viewDidDisappear:NO];
                if (_animation) [_marketNaViewController.view.layer addAnimation:animation forKey:nil];
            }else{
                [obj viewWillAppear:NO];
                [obj viewDidAppear:NO];
                [obj viewWillDisappear:NO];
                [_marketNaViewController popViewControllerAnimated:NO];
                [obj viewDidDisappear:NO];
            }
        }
    }];
}

//资源站首页
- (void)showResourcessHomePage:(id)sender{

//    if (_marketNaViewController.isClick) return;
    if (resourceHomeBottom.flag == CLICK_HOME_BUTTON){
        if (_marketNaViewController.viewControllers.count > 1){
            _marketNaViewController.isClick = YES;
            
            [CATransaction begin];
            [self _marketNavpopToRootViewController:YES];
            [CATransaction setCompletionBlock:^{
                KyMarketViewController * _vc = (KyMarketViewController *)self->_marketViewController->_marketViewController;
                [_vc.topbar setMarket_top_barClickWithIndex:0];
                _marketNaViewController.isClick = NO;
            }];
            [CATransaction commit];
            
        }
    }
    
    
    [resourceHomeBottom setHomeBottomSelectButton:CLICK_HOME_BUTTON];
    [self.saveBottomFlagDictionary setObject:HOME_FLAG forKey:BOTTOM_FLAG];
    [self changeShowPage:HOMEPAGE_SHOW];
    
}


//返回下载中的数量了于气泡显示
- (NSString *)badgeCountStr{
    return [NSString stringWithFormat:@"%d",[[BppDistriPlistManager getManager] countOfDownloadingItem]];
}

//闪退修复弹框的动画
- (void)repairClick:(id)sender{

}
//刷新界面上下载管理按钮右上角的气泡数字
- (void)reloadDownloadCount:(NSNotification*)note{

}

- (void)changeShowPage:(PAGE_SHOW_STATUS)showPage{
    
    _marketViewController.view.hidden = YES;
    downLoadNaViewController.view.hidden = YES;
    searchNaViewController.view.hidden = YES;
    findNavController.view.hidden = YES;
    moreNavController.view.hidden = YES;
    
    switch (showPage) {
        case HOMEPAGE_SHOW:
            _marketViewController.view.hidden = NO;
            break;
        case SEARCHVIEW_SHOE:
            searchNaViewController.view.hidden = NO;
            break;
        case DOWNLOADPAGE_SHOW:
            downLoadNaViewController.view.hidden = NO;
            break;
        case UPDATAPAGE_SHOW:
            findNavController.view.hidden = NO;
            break;
        case MOREMANAGE_SHOW:
            moreNavController.view.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)hideUpdateNotice:(UIButton *)button{
    [button removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"showUpdateNotice"];
}

- (void)isCanNotUse:(BOOL)bl{
    resourceHomeBottom.userInteractionEnabled = bl;
    downLoadNaViewController.view.userInteractionEnabled = bl;
    findViewController.view.userInteractionEnabled = bl;
}

-(void)morePopToRootViewController:(BOOL)flag
{
    if (moreNavController.viewControllers.count != 1) {
        [moreNavController popToRootViewControllerAnimated:flag];
    }
}

- (void)leaderImgViewClick:(id)sender
{ // 修复应用列表
    leaderImgView.hidden = YES;
    [moreManageVC selectRow:[NSIndexPath indexPathForRow:3 inSection:0]]; // 应用修复页面
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 5) {
        if (buttonIndex ==0) {
            [[BppDownloadToLocal getObject] downLoadPlistFile:[requestDic objectForKey:@"requestUrl"]];
        }
    }
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self changeSelectToHomeFlag];
        }
    }
}

#pragma mark -
#pragma mark KY_UpdataSDK_Delegate

//note == nil 为程序自动检测， !=nil 为用户点击按钮触发
- (void)openCheckUpdataSelfPage:(NSNotification *)note{
    
    //note非空:用户手动触发
    NSNumber * userTriger = [NSNumber numberWithBool:note?YES:NO];
    
    [[AppUpdateNewVersion shareInstance] udpateNewVersion:self
                                                 userinfo:userTriger];
    if (note) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingViewIsHide" object:@{@"bool":@"no",@"content":@"正在检查更新..."}];
    }
}


//请求最新版本信息成功
-(void)AppUpdateNewVersionSuccess:(NSDictionary*)data userinfo:(id)userinfo {
    
    if (![data getNSDictionaryObjectForKey:@"appinfo"] || ![data getNSArrayObjectForKey:@"updatemsg"] || ![[data getNSDictionaryObjectForKey:@"appinfo"] getNSStringObjectForKey:@"plist"] || ![[data getNSDictionaryObjectForKey:@"appinfo"] getNSStringObjectForKey:@"appversion"]) {
        return;
    }
    
    NSString * appversion  = [[data getNSDictionaryObjectForKey:@"appinfo"] getNSStringObjectForKey:@"appversion"];
    self.myUpdataUrl = [[data getNSDictionaryObjectForKey:@"appinfo"] getNSStringObjectForKey:@"plist"];
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if( NSOrderedDescending == [appversion compare:clientVer] ){
        //应该升级

        //触发类型
        if( [userinfo boolValue] ){
            //用户点击的升级, 忽略强制升级字段，直接提示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openPromptView"
                                                                object:@"检测到新版本是否更新"];
            
        }else{
            //是否是强制升级
            if( [[data objectForKey:@"forceupdate"] isEqualToString:@"y"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"openPromptView"
                                                                    object:@"检测到新版本是否更新"];
            }
        }
        
        //界面显示更新内容
        NSString *title = [NSString stringWithFormat:@"发现新版本%@",appversion];
        NSMutableString *contentText = [NSMutableString stringWithFormat:@"更新内容\n"];
        NSArray *array = [data getNSArrayObjectForKey:@"updatemsg"];
        NSString *updateString = @"";
        for (int i = 0; i < array.count; i ++) {
            updateString = [NSString stringWithFormat:@"%@%@\n",updateString,[array objectAtIndex:i]];
        }
        
        [contentText appendString:updateString];
        if([contentText hasSuffix:@"\n"])  { //删除最后一个\n
            [contentText deleteCharactersInRange:NSMakeRange(contentText.length-1, 1)];
        }
        
        NSDictionary *updateInfor = [NSDictionary dictionaryWithObjects:@[title,contentText] forKeys:@[@"title",@"content"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newVersionContent" object:updateInfor];
        
    }else{
        //不用升级

        //用户触发的才显示"无版本更新提示"
        if([userinfo boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openPromptView"
                                                                object:@"当前已是最新版本!"];
        }
    }
    
}

//请求失败
-(void)AppUpdateNewVersionFail:(NSDictionary*)data userinfo:(id)userinfo {
    
    if( ![userinfo boolValue] ) {
        return ; //非用户触发
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closePromptView" object:nil];
        
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"检查更新失败，请检查网络后重试"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [av show];
    });
}


#pragma mark - InvokeMainDelegateMethods
-(void)callMainVCDelegateMethodAlertPopvpView:(NSNotification*)notifi
{ // state url
    NSDictionary *dic = notifi.object;
    NSLog(@"state: %d, url: %@",[[dic objectForKey:@"state"] intValue], [dic objectForKey:@"url"]);
    if (self.mainVCDelegate && [self.mainVCDelegate respondsToSelector:@selector(AlertPopvpView:distriPlist:)]) {
        [self.mainVCDelegate AlertPopvpView:(DOWNLOAD_STATUS)[[dic objectForKey:@"state"] intValue] distriPlist:[dic objectForKey:@"url"]];
    }
}

#pragma mark - 更多页面操作

-(void)hideTabBar:(NSNotification *)notification
{
    BOOL hiddenFlag = [notification.object boolValue];
    resourceHomeBottom.hidden = hiddenFlag;
}

- (void)startUpdata{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.myUpdataUrl]];
}

#pragma mark - Life Cycle
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)setSaveBottomFlagKey:(NSString *)key Value:(NSString *)value{
    [self.saveBottomFlagDictionary setObject:key forKey:value];
}

- (void)openMoreSettingPage{
    [self openMorePage:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openlockappleidpage" object:nil];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _marketNaViewController.delegate = nil;
    resourceHomeBottom.delegate_ = nil;

    self.saveBottomFlagDictionary = nil;
}

@end
