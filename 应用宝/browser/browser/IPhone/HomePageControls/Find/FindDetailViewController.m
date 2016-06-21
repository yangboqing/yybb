//
//  FindDetailViewController.m
//  KY20Version
//
//  Created by liguiyang on 14-5-21.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "FindDetailViewController.h"
#import "CustomNavigationBar.h"
#import "AppTableViewController.h"
#import "SearchResult_DetailViewController.h"
#import "ArgumentViewController.h"

#import "SearchServerManage.h"
#import "MarketServerManage.h"
#import "KyShared.h"
#import "UIImageEx.h"
#import "CollectionViewBack.h"
#import "UIWebViewController.h"
#import "ASIDownloadCache.h"
#import "FindPicInfoViewController.h"
#import "FileUtil.h"



#define TAG_ACTIVITYWEBVIEW 1123
#define TAG_MAINSCROLLVIEW 1125
#define ACTIVITY_ID(activityID) [NSString stringWithFormat:@"findDetail_%@",activityID]

@interface FindDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,MarketServerDelegate,AppTableViewDelegate,ArgumentViewDelegate,UIWebViewDelegate,FindPicInfoViewDelegate>
{
    // UIWebView
    UIWebView *activityWeb;
    CGFloat activityHeight;
    
    ASIHTTPRequest *activityRequest;
    ASIHTTPRequest *argumentRequest;
    
    // App tableview
    UIImageView *separateLine;
    UIImageView *separatorImgView;
    AppTableViewController *appTableVC;
    SearchResult_DetailViewController *appDetailVC;
    
    NSMutableArray *reportArray;
    
    // argument page
    ArgumentViewController *argumentVC;
    CGFloat argumentHeight;
    
    // scrollView
    UIScrollView *mainScrollView;
    
    CollectionViewBack * _backView;
    CustomNavigationBar *navBar;
    NSString *uniqueIdentifier;
    CGFloat  offset_appTableView;
    CGFloat  height_tableTop; // appTableView上面横线及“相关下载”图片总高度
    
    NSString *nextUrlStr;
    NSInteger index;
    
    FindPicInfoViewController *findPicVC;
    
    BOOL hasRemoveFlag; // 解决滑动返回不释放本类的问题
    
}

@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) NSArray *appArr;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *share_word;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation FindDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //
        reportArray = [NSMutableArray array];
        [[MarketServerManage getManager] addListener:self];
        
        // mainView
        [self initMainScreenView];
        
    }
    return self;
}

#pragma mark - initialization

-(void)initMainScreenView
{
    [self initActivityWebView];
    [self initDownloadTableVC];
    [self initArgumentView];
    [self initScrollView];
    
    [mainScrollView addSubview:activityWeb];
    [mainScrollView addSubview:separateLine];
    [mainScrollView addSubview:separatorImgView];
    [mainScrollView addSubview:appTableVC.tableView];
    [mainScrollView addSubview:argumentVC.view];
    [self.view addSubview:mainScrollView];
    
    // set frame
    [self setCustomFrame];
    
    
    _backView = [CollectionViewBack new];
    __weak FindDetailViewController* mySelf = self;
    [_backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(refreshDetailView) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:_backView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _backView.frame = self.view.bounds;
}

-(void)initActivityWebView
{
    activityWeb = [[UIWebView alloc] init];
    activityWeb.scrollView.scrollEnabled = NO;
    activityWeb.delegate = self;
    activityWeb.tag = TAG_ACTIVITYWEBVIEW;
    activityHeight = 100;
    [activityWeb.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"content"];
}

-(void)initDownloadTableVC
{
    separateLine = [[UIImageView alloc] init];
    separateLine.backgroundColor =  [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1];
    separatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"relatedApp.png"]];
//    SET_IMAGE(separatorImgView.image, @"relatedApp.png");
    
    appTableVC = [[AppTableViewController alloc] init];
    appTableVC.delegate = self;
    
    appDetailVC = [[SearchResult_DetailViewController alloc] init];
    appDetailVC.detailType = @"find";
}

-(void)initArgumentView
{
    argumentVC = [[ArgumentViewController alloc] init];
    argumentVC.delegate = self;
    argumentHeight = 100;
}

-(void)initScrollView
{
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.delegate = self;
    mainScrollView.tag = TAG_MAINSCROLLVIEW;
}

#pragma mark - RequestMethods

-(void)reloadActivityDetailVC:(NSDictionary *)dic
{
    self.detailDic = dic;
    NSString *appId = [_detailDic objectForKey:@"appid"];
    NSString *acId  = [_detailDic objectForKey:@"huodong_id"];
    if (acId == nil) { // 区分lunbo id
        acId = [_detailDic objectForKey:@"id"];
    }
    if ([_detailDic objectForKey:@"content"]) {
        self.content = [_detailDic objectForKey:@"content"];
    }
    
    if (appId && ![appId isEqualToString:@""]) {
        [self requestActivityDetailWidhId:[acId intValue] appId:[_detailDic objectForKey:@"appid"]];
    }
    else
    {
        [self requestActivityDetailWidhId:[acId intValue] appId:@""];
    }
}

-(void)requestActivityDetailWidhId:(NSInteger)activityId appId:(NSString *)appId
{
    // 请求
    uniqueIdentifier = [NSString stringWithFormat:@"%d_%@",activityId,appId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MarketServerManage getManager] getDiscoverActivityDetail:activityId appid:appId userData:uniqueIdentifier];
    });
    
    _backView.status = Loading;
}

-(void)loadWebView:(NSURL *)url withType:(WebViewType)type
{
    
    if (type == activity_Type) {
        activityRequest = [ASIHTTPRequest requestWithURL:url];
        [activityRequest setTimeOutSeconds:60.0f];
        [activityRequest setDelegate:self];
        activityRequest.tag = type;
        [activityRequest setDidFailSelector:@selector(webViewRequestFailed:)];
        [activityRequest setDidFinishSelector:@selector(webViewRequestSuccess:)];
        // 缓存策略
        [activityRequest setDownloadCache:[ASIDownloadCache sharedCache]];
        [activityRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [activityRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:activityRequest]];
        [activityRequest startAsynchronous];
    }
    else if(type == argument_Type)
    {
        argumentRequest = [ASIHTTPRequest requestWithURL:url];
        [argumentRequest setTimeOutSeconds:60.0f];
        [argumentRequest setDelegate:self];
        argumentRequest.tag = type;
        [argumentRequest setDidFailSelector:@selector(webViewRequestFailed:)];
        [argumentRequest setDidFinishSelector:@selector(webViewRequestSuccess:)];
        // 缓存策略
        [argumentRequest setDownloadCache:[ASIDownloadCache sharedCache]];
        [argumentRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [argumentRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:argumentRequest]];
        [argumentRequest startAsynchronous];
    }
    
    
    
}

-(void)sendRecommendActive:(NSString *)activityId
{
//    [[SearchServerManage getObject] requestRecommendActivity:activityId];
    
    [[ReportManage instance] reportClickZan:CLICK_ZAN_FIND typeid:activityId];
    
}

#pragma mark - UIButton Action
-(void)praiseButtonAction:(id)sender
{
    UIButton *praiseBtn = (UIButton *)sender;
    if (!praiseBtn.selected) {
        // 状态、提示
        praiseBtn.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:PROMOTE_INFO_SHOW object:PROMOTE_SUCCESS];
        // 保存
        NSString *acId = ACTIVITY_ID([_detailDic objectForKey:@"id"]);
        [[SearchManager getObject] setAppRecommendKid:acId];
        [self sendRecommendActive:[_detailDic objectForKey:@"id"]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PROMOTE_INFO_SHOW object:ALREADY_PROMOTED];
    }
}

-(void)shareButtonAction:(id)sender
{
    NSString *acId = [_detailDic objectForKey:@"id"];
    NSString *title = [_detailDic objectForKey:@"title"];
    if (acId == nil) {
        acId = [_detailDic objectForKey:@"huodong_id"];
        title = [_detailDic objectForKey:@"lunbo_intro"];
    }
    
    [KyShared shared].title = [[FileUtil instance] urlDecode:title];
    [KyShared shared].description = [[FileUtil instance] urlDecode:_share_word];
    [KyShared shared].image = _shareImage;
    [KyShared shared].webpageUrl = _contentUrl;
    [KyShared shared].weiboText = [NSString stringWithFormat:@"%@",[[FileUtil instance] urlDecode:title]];
    [KyShared shared].objectID = acId;
    [KyShared shared].showType = show_find_detail;
    [[KyShared shared] show];
}

#pragma mark - Utility


-(void)showLoadingView
{
    _backView.status = Loading;
}

-(void)showFailedView
{
    _backView.status = Failed;
}


-(void)hideAllView
{
    _backView.status = Hidden;
}

-(void)hideAppTableViewUtility:(BOOL)flag
{
    separatorImgView.hidden = flag;
    [self setCustomFrame];
}

-(void)setCustomFrame
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat topHeight = IOS7?64:0;
    
    // webView
    activityWeb.frame = CGRectMake(0, topHeight, rect.size.width, activityHeight);
    
    // download Tableview
    separateLine.frame = CGRectMake(10, activityWeb.frame.origin.y+activityWeb.frame.size.height+15, MainScreen_Width-20, 0.5);
    separatorImgView.frame = CGRectMake(separateLine.frame.origin.x, separateLine.frame.origin.y+13, 159, 16);
    appTableVC.tableView.frame = CGRectMake(0, separatorImgView.frame.origin.y+separatorImgView.frame.size.height+3+offset_appTableView, rect.size.width, 80*_appArr.count);
    
    // argument page
    argumentVC.view.frame = CGRectMake(0, appTableVC.tableView.frame.origin.y+appTableVC.tableView.frame.size.height, rect.size.width,argumentHeight);
    CGRect webFrame = argumentVC.view.frame;
    webFrame.origin.y = 0;
    argumentVC.webView.frame = webFrame;
    
    // mainScrollView
    mainScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    mainScrollView.contentSize = CGSizeMake(rect.size.width, 44+activityWeb.frame.size.height+height_tableTop+appTableVC.tableView.frame.size.height+argumentVC.view.frame.size.height+60);
    
}

-(void)resetPraiseButtonState
{
    NSString *acId = ACTIVITY_ID([_detailDic objectForKey:@"id"]);
    
    if ([[SearchManager getObject] getRecommendState:acId]) {
        navBar.praiseButton.selected = YES;
    }
    else
    {
        navBar.praiseButton.selected = NO;
    }
}

-(void)refreshDetailView
{
    // 请求数据
    NSString *appId = [_detailDic objectForKey:@"appid"];
    NSString *acId  = [_detailDic objectForKey:@"huodong_id"];
    if (acId == nil) { // 区分lunbo id
        acId = [_detailDic objectForKey:@"id"];
    }
    
    if (appId && ![appId isEqualToString:@""]) {
        [self requestActivityDetailWidhId:[acId intValue] appId:[_detailDic objectForKey:@"appid"]];
    }
    else
    {
        [self requestActivityDetailWidhId:[acId intValue] appId:@""];
    }
}

-(void)stopLoadingAndClearCache
{
    // ASIHttpRequest
    [activityRequest clearDelegatesAndCancel];
    [argumentRequest clearDelegatesAndCancel];
    
    // 内容WebView
    [activityWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    //[activityWeb loadHTMLString:@"" baseURL:nil];
    [activityWeb stopLoading];
    [activityWeb setDelegate:nil];
    [activityWeb removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSHTTPCookie *cookie;
    for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    //评论WebView
    [argumentVC stopLoadingAndClearCache];
    [argumentVC.view removeFromSuperview];
}

-(void)backFindVC
{
    [self.navigationController popViewControllerAnimated:YES];
    [self removeObserverAndListener]; // 移除监听释放本类
}

-(void)removeObserverAndListener
{ // 移除observer 和 listener 为了系统调用dealloc
    if (!hasRemoveFlag) {
        hasRemoveFlag = YES;
        [[MarketServerManage getManager] removeListener:self];
        [activityWeb.scrollView removeObserver:self forKeyPath:@"contentSize" context:@"content"];
    }
}

-(void)resetWebViewFrame
{
    activityHeight = 100;
    argumentHeight = 100;
    [self setCustomFrame];
}

-(void)webViewRequestFailed:(ASIHTTPRequest *)theRequest
{
    if (theRequest.tag == activity_Type) {
        _backView.status = Failed;
    }
}

-(void)webViewRequestSuccess:(ASIHTTPRequest *)theRequest
{
    NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:NSUTF8StringEncoding error:nil];
    
    if (theRequest.tag == activity_Type) {
        [activityWeb loadHTMLString:response baseURL:[theRequest url]];
        
        // 加载成功去掉数据
        [self performSelector:@selector(hideAllView) withObject:nil afterDelay:1.0f];
        
        //导航按钮状态
        [navBar praiseAndShareButtonSelectEnable:YES];
        
        // 该活动已被查看
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SearchManager getObject] storeActivityId:[_detailDic objectForKey:@"id"]];
        });
    }
    else if (theRequest.tag == argument_Type)
    {
        [argumentVC loadArgumentString:response baseUrl:[theRequest url]];
    }
    
    
}

#pragma mark - 曝光度

-(void)reportBaoGuangAboutAppsByOffset:(CGFloat)offset
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat topHeight = (IOS7)?64:44;
    CGFloat visibleHeight = screenHeight-topHeight-BOTTOM_HEIGHT;
    CGFloat appOriY = appTableVC.tableView.frame.origin.y;
    
    if (appOriY < visibleHeight+topHeight) {
        [self setVisibleAppsReportArray]; // 设置reportArray
        [[ReportManage instance] ReportAppBaoGuang:APP_DETAIL(PRIVILEGE_ACTIVITY(-1)) appids:reportArray];
    }
    else if (offset>(appOriY-visibleHeight-topHeight))
    {
        [self setVisibleAppsReportArray];
        [[ReportManage instance] ReportAppBaoGuang:APP_DETAIL(PRIVILEGE_ACTIVITY(-1)) appids:reportArray];
    }
}

-(void)setVisibleAppsReportArray
{
    [reportArray removeAllObjects];
    
    for (NSDictionary *dic in _appArr) {
        [reportArray addObject:[dic objectForKey:@"appid"]];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [(__bridge NSString *)context isEqualToString:@"content"] && [keyPath isEqualToString:@"contentSize"]) {
        activityHeight = activityWeb.scrollView.contentSize.height;
        [self setCustomFrame];
    }
}

#pragma mark - UIScrollViewDelegate

static bool _deceler = false;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _deceler = true;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && _deceler==false && _appArr.count!=0) {
        [self reportBaoGuangAboutAppsByOffset:scrollView.contentOffset.y];
    }
    
    _deceler = false;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_appArr.count != 0) {
        [self reportBaoGuangAboutAppsByOffset:scrollView.contentOffset.y];
    }
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)hideNavBottomBar:(BOOL)flag
{
    self.navigationController.navigationBar.hidden = flag;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:flag]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* currentUrl = request.URL.absoluteString;
    
    if ([currentUrl hasPrefix:@"callios:getappstate"]) {
        
        NSArray *array = [currentUrl componentsSeparatedByString:@":"];
        if ([array isKindOfClass:[NSArray class]] && array.count > 2) {
            
            
            NSInteger imageIndex = [array[2] integerValue];
            
            index = 0;
            self.itemArray = [[FileUtil instance] AnalyticalImage:self.content];
            
            if (self.itemArray.count > 0) {
                
                
                
                if (imageIndex >= self.itemArray.count) {
                    imageIndex = self.itemArray.count -1;
                }
                
                findPicVC.currentIndex = imageIndex;
                
                [findPicVC setCollectItems:self.itemArray index:imageIndex];
                [self.navigationController pushViewController:findPicVC animated:NO];
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                [self hideNavBottomBar:YES];
            }
        }
        
    }
    
    BOOL refreshFlag = YES;
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        UIWebViewController *webVC = [[UIWebViewController alloc] init];
        [webVC navigation:request.URL.absoluteString];
        [self.navigationController pushViewController:webVC animated:YES];
        //
        refreshFlag = NO;
    }
    
    return refreshFlag;
}

#pragma mark - ArgumentViewDelegate

-(void)argumentViewChangeHeight:(CGFloat)height
{
    CGFloat maxHeight = MainScreeFrame.size.height-64-BOTTOM_HEIGHT+10;
    if (height > maxHeight) {
        argumentHeight = maxHeight;
    }
    
    [self setCustomFrame];
}

#pragma mark - 数据验证

-(BOOL)checkAppArray:(NSArray *)appArray
{
    BOOL arrayFlag = NO;
    if (IS_NSARRAY(appArray)) {
        if (appArray.count == 0) {
            arrayFlag = YES;
        }
        else if (appArray.count > 0)
        {
            for (id obj in appArray) {
                if (IS_NSDICTIONARY(obj)) {// 是个字典
                    if ([obj getNSStringObjectForKey:@"appdowncount"] &&
                        [obj getNSStringObjectForKey:@"appiconurl"] &&
                        [obj getNSStringObjectForKey:@"appid"] &&
                        [obj getNSStringObjectForKey:@"appintro"] &&
                        [obj getNSStringObjectForKey:@"appname"] &&
                        [obj getNSStringObjectForKey:@"appreputation"] &&
                        [obj getNSStringObjectForKey:@"appsize"] &&
                        [obj getNSStringObjectForKey:@"appupdatetime"] &&
                        [obj getNSStringObjectForKey:@"appversion"] &&
                        [obj getNSStringObjectForKey:@"category"] &&
                        [obj getNSStringObjectForKey:@"ipadetailinfor"] &&
                        [obj getNSStringObjectForKey:@"plist"] &&
                        [obj getNSStringObjectForKey:@"share_url"]) {
                        arrayFlag = YES;
                    }
                }
                else
                {
                    arrayFlag = NO;
                    break;
                }
            }
        }
    }
    
    return arrayFlag;
}

-(BOOL)checkData:(NSDictionary *)dataDic
{
    BOOL typeFlag = NO;
    NSDictionary *tmpDic = [dataDic getNSDictionaryObjectForKey:@"data"];
    
    if (tmpDic) {
        
        if ([tmpDic getNSStringObjectForKey:@"content"] &&
            [tmpDic getNSStringObjectForKey:@"comment"] &&
            [tmpDic getNSStringObjectForKey:@"content_url_open_type"] &&
            [tmpDic getNSStringObjectForKey:@"share_word"] &&
            [self checkAppArray:[tmpDic objectForKey:@"app"]]) {
                typeFlag = YES;
            }
    }
    
    return typeFlag;
}

#pragma mark - marketSearchManageDelegate
//栏目-发现-活动详情请求成功
- (void)discoverActivityDetailRequestSucess:(NSDictionary*)dataDic testEvaluationID:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData
{
    if ([userData isEqualToString:uniqueIdentifier]) {
        
        if ([self checkData:dataDic]) {
            self.appArr = [[dataDic objectForKey:@"data"] objectForKey:@"app"];
            self.share_word = [[dataDic objectForKey:@"data"]objectForKey:@"share_word"];
            self.contentUrl = [[dataDic objectForKey:@"data"] objectForKey:@"content"];
            NSString *argumentUrl = [[dataDic objectForKey:@"data"] objectForKey:@"comment"];
            
            BOOL flag = NO;
            if (_appArr.count==0 || _appArr==nil) { // 数据为空隐藏TableView上的提示图片、分割线、argumentView.frame.origin.y变小
                offset_appTableView = -48.0f;
                height_tableTop = 0;
                flag = YES;
            }
            else
            {
                offset_appTableView = 0.0f;
                height_tableTop = 48;
                flag = NO;
            }
            [self hideAppTableViewUtility:flag];
            
            // 网页请求
            if (_contentUrl) { // 内容页
                [self loadWebView:[NSURL URLWithString:_contentUrl] withType:activity_Type];
            }
            if (argumentUrl) { // 评论页
                [self loadWebView:[NSURL URLWithString:argumentUrl] withType:argument_Type];
            }
            
            // 相关应用页
            if (IS_NSARRAY([[dataDic objectForKey:@"data"] objectForKey:@"app"])) {
                [appTableVC reloadAppTableView:_appArr withFromSource:APP_DETAIL(_fromSource)];
            }
        }
        else
        {
            _backView.status = Failed;
        }
        
    }
}

//栏目-发现-活动详情请求失败
- (void)discoverActivityDetailRequestFail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
{
    //导航按钮状态
    [navBar praiseAndShareButtonSelectEnable:NO];
    //动画处理
    [self showFailedView];
}

-(void)discoverTestEvaluationDetailRequestSucess:(NSDictionary *)dataDic testEvaluationID:(int)testEvaluationID appid:(NSString *)appid userData:(id)userData
{
}

#pragma mark - AppTableViewDelegate
-(void)appTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [appDetailVC setAppSoure:APP_DETAIL(_fromSource)];
    appDetailVC.view.hidden = NO;
    [appDetailVC hideDetailTableView];
    appDetailVC.BG.hidden = NO;
    [appDetailVC beginPrepareAppContent:_appArr[indexPath.row]];
    [self.navigationController pushViewController:appDetailVC animated:YES];
    // 汇报点击
    [[ReportManage instance] ReportAppDetailClick:APP_DETAIL(_fromSource) appid:[_appArr[indexPath.row] objectForKey:@"appid"]];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // navigationBar
    addNavgationBarBackButton(self, backFindVC);
//    navBar = [[CustomNavigationBar alloc] init];
//    [navBar.praiseButton addTarget:self action:@selector(praiseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navBar.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = navBar;
    
    findPicVC = [[FindPicInfoViewController alloc] init];
    findPicVC.delegate = self;
    
    // 设置网页默认高度
    [self resetWebViewFrame];
    
    hasRemoveFlag = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //
    [self resetPraiseButtonState];
    if (IOS7) {
        //开启iOS7的滑动返回效果
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObserverAndListener]; // 移除监听释放本类（解决反动返回不释放本类的问题）
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     // 本页面网页停止加载并置空
    [activityWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [activityWeb stopLoading];
    
    [argumentVC.webView loadHTMLString:@"" baseURL:nil];
    [argumentVC.webView stopLoading];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // UI
    [self resetWebViewFrame];
    _backView.status = Failed;
//    NSLog(@"详情界面 内存警告 停止加载并置空");
}

-(void)dealloc
{
    //
    navBar = nil;
    // 文章
    [self stopLoadingAndClearCache];
    
    activityRequest = nil;
    argumentRequest = nil;
    
    activityWeb.delegate = nil;
    activityWeb = nil;
    // 评论
    argumentVC = nil;
    
    // 应用页及详情
    separateLine = nil;
    separatorImgView = nil;
    appTableVC = nil;
    appDetailVC = nil;

    mainScrollView = nil;
    _backView = nil;
    // 数据源
    self.appArr = nil;
    self.detailDic = nil;
    self.fromSource = nil;
    reportArray = nil;
}

- (void)clickFindWebYulanBackButton{
    [self.navigationController popViewControllerAnimated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(IOS7){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self hideNavBottomBar:NO];
}

@end
