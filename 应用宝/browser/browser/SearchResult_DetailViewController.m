//
//  SearchResult_DetailViewController.m
//  browser
//
//  Created by caohechun on 14-4-9.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "SearchResult_DetailViewController.h"
#import "SearchResult_DetailTableViewController.h"
#import "SearchServerManage.h"
#import "AppInforView.h"
#import "AppTestDetailViewController.h"
#import "FindDetailViewController.h"
#import "AppTestTableViewController.h"
#import "KyShared.h"
#import "CustomNavigationBar.h"
#import "CollectionViewBack.h"

@interface SearchResult_DetailViewController ()
{
    SearchResult_DetailTableViewController *detailTableViewController;
     AppTestDetailViewController *appTestDetailViewController;
    UIImageView *boarderView ;
    NSDictionary *appInforDic;
    UIView * loadFailedView;
    UIImageView *failedImgView;//加载失败view
    UILabel *failedLabel;//加载失败文字
    int failedTimes;//加载失败次数
    NSString *share_url;
    CustomNavigationBar *navBar;
    CollectionViewBack * _backView;//加载中
    BOOL clearLock;//是否清除数据:1上锁,不能清除
}
@end

@implementation SearchResult_DetailViewController

- (void)dealloc{
//    [backButton release];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
        boarderView  = [[UIImageView alloc]init];
        boarderView.backgroundColor = WHITE_BACKGROUND_COLOR;
        boarderView.userInteractionEnabled  = YES;
        [self.view addSubview:boarderView];
        
        
        detailTableViewController  =[[SearchResult_DetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
        detailTableViewController.parentVC = self;

        [self.view addSubview:detailTableViewController.view];

        appTestDetailViewController = [[AppTestDetailViewController alloc]init];
        appTestDetailViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 500);
        [self.view addSubview:appTestDetailViewController.view];
        

        //加载中
        __weak typeof(self) mySelf = self;
        _backView = [CollectionViewBack new];
        [self.view addSubview:_backView];
        [_backView setClickActionWithBlock:^{
            [mySelf performSelector:@selector(loadFailedViewHasBeenTap) withObject:nil afterDelay:delayTime];
        }];
        self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
        
        //右滑返回手势
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBackVC)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.view addGestureRecognizer:swipe];
    }
    return self;
}

//设置来源
- (void)setAppSoure:(NSString *)soure{
    self.detailSource = soure;
    detailTableViewController.detailSource = APP_DETAIL(soure);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启iOS7的滑动返回效果
//    MyNavigationController *nav = (MyNavigationController *)self.navigationController;
//    [nav cancelSlidingGesture];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    clearLock = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:YES]];
    
    [self lockView];
    [self performSelector:@selector(unlockView) withObject:nil afterDelay:0.5];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

//锁定界面,关闭边缘右滑,防止界面未完全显示时就右滑返回产生的bug
- (void)lockView{
    self.view.userInteractionEnabled = NO;
    if(IOS7){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//解锁界面,开启边缘右滑
- (void)unlockView{
    self.view.userInteractionEnabled = YES;
    if(IOS7){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    clearLock = [self.navigationController.topViewController isMemberOfClass:[FindDetailViewController class]];
    int viewControllersCount  = (int)[self.navigationController.viewControllers count];
    if (!clearLock&&(viewControllersCount ==0 || viewControllersCount ==3) && ![self.navigationController.topViewController isMemberOfClass:[SearchResult_DetailViewController class]]) {//0,3
        [self clearData];
    }
    clearLock = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAnotherApp:) name:@"loadAnotherApp" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSource:) name:@"loadAnotherApp_source" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOrHideRotation:) name:@"showOrHideRotation" object:nil];
    // Do any additional setup after loading the view.
    navBar = [[CustomNavigationBar alloc] init];
    [navBar.praiseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    [navBar.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = navBar;
    addNavgationBarBackButton(self,goBackVC);
}

- (void)viewWillLayoutSubviews{

    //是否从分类推入
    float tabHeight = self.isPushByClassification?0:49;
    
    if (IOS7) {
        detailTableViewController.tableView.frame = CGRectMake(0, 20 + 44, MainScreen_Width, MainScreen_Height - 20  - 44 - tabHeight);
    }else{
        detailTableViewController.tableView.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height - 20  - 44 - tabHeight );
    }
    _backView.frame = detailTableViewController.view.frame;
}

//重新加载一个app的内容
- (void)loadAnotherApp:(NSNotification *)noti{
    NSDictionary *dic  =noti.object;
    appInforDic = dic;
    [self checkPraiseButtonState];

//    [detailTableViewController initDetailPage];
    //将详情页所有的图片置空,防止在切换app时看到上个app的图片
    [detailTableViewController.appDetailView setIntroImagesNil];
    //截图调整标志置否
    detailTableViewController.isPreviewSizeFixed = NO;
    //相关应用置空
    [detailTableViewController setRelevantAppsNil];
    
    [detailTableViewController.appDetailView setDetailContent:nil];
    detailTableViewController.tableView.contentOffset = CGPointZero;
    [detailTableViewController.headView setIconImage:_StaticImage.icon_60x60];
    NSString *pos = [dic objectForKey:@"pos"];
    if ([pos isEqualToString:@""]) {
        pos = nil;
    }
    [detailTableViewController prepareAppContent:[dic objectForKey:@"appid"] pos:pos];
    detailTableViewController.appDetailView.promoteButton.enabled = YES;
    [detailTableViewController.appDetailView recoverDetailLabel];
    //恢复相关应用frame
    [detailTableViewController setRelevantSizeZero];
    [detailTableViewController showDetailsPage];
}

//变更来源
- (void)changeSource:(NSNotification *)noti{
    [self setAppSoure:noti.object];
}

#pragma mark - 准备数据
- (void)beginPrepareAppContent:(NSDictionary *)appDic{
    appInforDic = appDic;
    BOOL isdict = [appDic isKindOfClass:[NSDictionary class]];
    if([self.detailType isEqualToString:@"FreeFlow"]){
        detailTableViewController.mianLiuPlist = self.mianliuPList;
    }

    [self checkPraiseButtonState];
    [detailTableViewController prepareAppContent: isdict?[appDic objectForKey:@"appdigitalid"]:appDic pos:[NSString stringWithFormat:@"%d",1]];
    AppTestTableViewController *testDetail  = [detailTableViewController getTestTableViewController];

    testDetail.testDetailDelegate = self;
    [self hideDetailTableView];
    [_backView setStatus:Loading];
    //锁定分享等按钮
    [self lockFunctionButton:YES];
}

//检查推荐按钮状态
- (void)checkPraiseButtonState{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:APP_RECOMMEND]];
    
//    if ([array containsObject:[appInforDic objectForKey:@"appid"]]){
//        [navBar.praiseButton setSelected:YES];
//    }else{
//        [navBar.praiseButton setSelected:NO];
//    }
}

- (void)getImageFailFromUrl:(NSString *)urlStr userData:(id)userdata{
//    NSLog(@"下载图片失败");
}

#pragma mark-
//加载过程中禁止点击分享/推荐等按钮
- (void)lockFunctionButton:(BOOL)lock{
    navBar.praiseButton.enabled = !lock;
    navBar.shareButton.enabled = !lock;
}

- (void)setDetailToZeroPoint{
    detailTableViewController.tableView.contentOffset = CGPointZero;
}

- (void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadFailedViewHasBeenTap
{// 点击搜索失败页面 重新搜索
    [_backView setStatus:Loading];
    [self beginPrepareAppContent:appInforDic];
}


- (void)praise{
    [detailTableViewController promoteApp];
}

- (void)share{
    [KyShared shared].title = [[FileUtil instance] urlDecode:[appInforDic objectForKey:@"appname"]];
    [KyShared shared].description = [[FileUtil instance] urlDecode:[appInforDic objectForKey:@"appintro"]];
    [KyShared shared].image = self.icon;
    [KyShared shared].webpageUrl = [appInforDic objectForKey:@"appshareurl"];
    [KyShared shared].weiboText = [NSString stringWithFormat:@"分享一款很不错的app--%@  ",[[FileUtil instance] urlDecode:[appInforDic objectForKey:@"appname"]]];
    [KyShared shared].objectID = [appInforDic objectForKey:@"appid"];
    [KyShared shared].showType = show_app_detail;
    [[KyShared shared] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 隐藏显示detailTableView
- (void)showDetailTableView{
    detailTableViewController.tableView.hidden = NO;
    
    [_backView setStatus:Hidden];
    //解锁分享的按钮
    [self lockFunctionButton:NO];
}

- (void)hideDetailTableView{
    detailTableViewController.tableView.hidden = YES;
    [_backView setStatus:Failed];
}

- (void)showOrHideRotation:(NSNotification *)noti{
    if ([noti.object isEqualToString:@"hide"]) {
        [_backView setStatus:Hidden];
        detailTableViewController.tableView.hidden = NO;
    }else if ([noti.object isEqualToString:@"error"]){
        detailTableViewController.tableView.hidden = YES;
        [_backView setStatus:Hidden];
    }else{
        [_backView setStatus:Loading];
        detailTableViewController.tableView.hidden = YES;
    }
}

#pragma mark - testDelegate
//显示评测和活动详情
- (void)showTestDetail:(NSDictionary *)dic withImage:(UIImage *)image{

    FindDetailViewController *findDetailViewController = [FindDetailViewController new];
    findDetailViewController.shareImage = image;
    findDetailViewController.source = @"appDetail";
    [findDetailViewController reloadActivityDetailVC:dic];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:findDetailViewController animated:YES];
}

#pragma mark - relevantDelegate
- (void)loadAnotherApp_relevent:(id)data{
    NSNotification *noti = [[NSNotification alloc]initWithName:@"relevant" object:data userInfo:nil];
    [self loadAnotherApp:noti];
}

- (void)loadAnotherApp_source_relevant:(id)data{
    NSNotification *noti = [[NSNotification alloc]initWithName:@"source" object:data userInfo:nil];
    [self changeSource:noti];
}

- (void)showOrHideRotation_relevant:(id)data{
    NSNotification *noti = [[NSNotification alloc]initWithName:@"annimation" object:data userInfo:nil];
    [self showOrHideRotation:noti];
}

- (void)clearData{
    //将详情页所有的图片置空,防止在切换app时看到上个app的图片
    [detailTableViewController.appDetailView setIntroImagesNil];
    [detailTableViewController.appDetailView setDetailContent:nil];
    //截图调整标志置否
    detailTableViewController.isPreviewSizeFixed = NO;
    //相关应用置空
    [detailTableViewController setRelevantAppsNil];
    
    [detailTableViewController.headView setIconImage:_StaticImage.icon_60x60];
    detailTableViewController.tableView.contentOffset = CGPointZero;
    [detailTableViewController recoverDetail];
    //恢复相关应用frame
    [detailTableViewController setRelevantSizeZero];
    
    [detailTableViewController showDetailsPage];
    appTestDetailViewController.view.hidden = YES;
}
@end
