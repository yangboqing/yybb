//
//  SearchViewController.m
//  browser
//
//  Created by 王毅 on 13-10-23.
//
//

#import "SearchViewController_my.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CollectionViewBack.h"
#import "SearchToolBar.h" // 搜索条
#import "HotWordViewController.h" // 热词页面
#import "SearchKeyWordViewController.h" // 搜索联想、记录列表
#import "SearchListViewController.h"
#import "MyServerRequestManager.h" // 请求类
#import "MyNavigationController.h"
#import "SearchManager.h"

typedef enum {
    displayType_hotWords = 10, // 热词
    displayType_recordKeyWords, // 搜索记录
    displayType_assoKeyWords, // 联想词
    displayType_Null // 全部隐藏
}DisplayType;

@interface SearchViewController_my ()<SearchToolBarDelegate,MyServerRequestManagerDelegate,SearchKeyWordViewDelegate>
{
    CollectionViewBack * _backView;
    SearchToolBar *searchToolBar; // 搜索条
    HotWordViewController *hotWordVC; // 热词页面
    SearchKeyWordViewController *assoKeyWordVC; // 联想词列表
    SearchKeyWordViewController *recordKeyWordVC; // 搜索记录列表
    
    //
    NSString *searchID;
    SearchType searchType;
    CGRect oriRect; // 联想词、历史记录原frame
    CGFloat topHeight;
    
    // 热词
    BOOL isFirstFlag; // 是否第一次请求热词
    BOOL couldShakeFlag;
}

@end

@implementation SearchViewController_my

- (instancetype)initWithSearchType:(SearchType)type
{
    self = [super init];
    if (self) {
        searchType = type;
        searchID = [NSString stringWithFormat:@"searchID_%d",type];
    }
    
    return self;
}

#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    topHeight = 64;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES]; // 支持shake
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    __weak id mySelf = self; // 避免循环引用
    
    // 热词UI
    hotWordVC = [[HotWordViewController alloc] init];
    [self.view addSubview:hotWordVC.view];
    [hotWordVC setHotWordClickBlock:^(NSString *hotWord) {
        [mySelf setSearchToolBarText:hotWord];
        [mySelf searchKeyWord:hotWord];
    }];
    
    //加载中
    _backView = [CollectionViewBack new];
    [self.view addSubview:_backView];
    [_backView setStatus:Loading];
    [_backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(reloadRequest) withObject:nil afterDelay:delayTime];
    }];
    
    // 联想词、搜索记录UI
    assoKeyWordVC = [[SearchKeyWordViewController alloc] initWithSearchListType:keyWordList_associateKeyWordType];
    assoKeyWordVC.delegate = self;
    assoKeyWordVC.view.hidden = YES;
    [self.view addSubview:assoKeyWordVC.view];
    
    recordKeyWordVC = [[SearchKeyWordViewController alloc] initWithSearchListType:keyWordList_recondType];
    recordKeyWordVC.delegate = self;
    recordKeyWordVC.view.hidden = YES;
    [self.view addSubview:recordKeyWordVC.view];
    
    // 搜索条
    searchToolBar = [[SearchToolBar alloc] init];
    searchToolBar.delegate = self;
    [self.navigationController.navigationBar addSubview:searchToolBar];
//    addNavigationLeftBarButton(leftBarITem_pop, self, @selector(backButtonClick));
    
    // set frame
    [self setCustomFrame];
    
    // 请求
    isFirstFlag = YES;
    couldShakeFlag = YES;
    [[MyServerRequestManager getManager] addListener:self];
    [self requestHotWord:isFirstFlag];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self becomeFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    
    for (UIView *searchBar in self.navigationController.navigationBar.subviews) {
        if ([searchBar isKindOfClass:[SearchToolBar class]]) {
            searchBar.hidden = NO;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    _backView  = nil;
    searchToolBar = nil;
    hotWordVC = nil;
    
    assoKeyWordVC.delegate = nil;
    assoKeyWordVC = nil;
    recordKeyWordVC.delegate = nil;
    recordKeyWordVC = nil;
    searchID = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark Utility

- (BOOL)canBecomeFirstResponder
{ // self变为第一响应者 支持 shake
    return YES;
}

- (void)backButtonClick
{
    [[Context defaults].homeNav popViewControllerAnimated:YES];
    [[MyServerRequestManager getManager] removeListener:self]; // 移除监听
}

- (void)keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary *keyBoardDic = [notification userInfo];
    CGFloat keyBoardHeight = [[keyBoardDic objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect rect = oriRect;
    rect.size.height = rect.size.height - keyBoardHeight + 49;
    assoKeyWordVC.view.frame = rect;
    recordKeyWordVC.view.frame = rect;
}

- (void)keyBoardDidHide:(NSNotification *)notification
{
    assoKeyWordVC.view.frame = oriRect;
    recordKeyWordVC.view.frame = oriRect;
}

- (void)vibrating
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)displayView:(DisplayType)displayType
{
    switch (displayType) {
        case displayType_hotWords:{
            hotWordVC.view.hidden = NO;
            assoKeyWordVC.view.hidden = YES;
            recordKeyWordVC.view.hidden = YES;
            
            // 是否可以摇一摇
            couldShakeFlag = YES;
            [self becomeFirstResponder];
        }
            break;
        case displayType_recordKeyWords:{
            recordKeyWordVC.view.hidden = NO;
            assoKeyWordVC.view.hidden = YES;
            
            // 是否可以摇一摇
            couldShakeFlag = NO;
        }
            break;
        case displayType_assoKeyWords:{
            recordKeyWordVC.view.hidden = YES;
            assoKeyWordVC.view.hidden = NO;
            
            // 是否可以摇一摇
            couldShakeFlag = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)setCustomFrame
{
    CGRect fullFrame = self.view.bounds;
    CGRect frame = CGRectMake(0, topHeight, fullFrame.size.width, fullFrame.size.height-topHeight - 49);
    searchToolBar.frame = CGRectMake(0, 0, MainScreen_Width, 44);
    hotWordVC.view.frame = frame;
    assoKeyWordVC.view.frame = frame;
    recordKeyWordVC.view.frame = frame;
    _backView.frame = fullFrame;
    
    oriRect = frame;
}

- (void)setSearchToolBarText:(NSString *)content
{
    NSString *searchWord = (content.length>30)?[content substringToIndex:30]:content;
    [searchToolBar setSearchContent:searchWord];
}

- (void)setLoadingStatus:(Request_status)status
{ //
    if (status == Loading) {
        assoKeyWordVC.view.hidden = YES;
        recordKeyWordVC.view.hidden = YES;
    }
    _backView.status = status;
}

- (void)reloadRequest
{
    [self requestHotWord:isFirstFlag];
}

- (BOOL)hotWordViewIsShowing
{
    BOOL showingFlag = NO;
    if (recordKeyWordVC.view.hidden && assoKeyWordVC.view.hidden) {
        showingFlag = YES;
    }
    
    return showingFlag;
}

- (void)searchKeyWord:(NSString *)keyWord
{
    [[MyServerRequestManager getManager] downloadCountToAPPID:keyWord version:@"" isSearch:YES];
    SearchListViewController *searchListVC = [[SearchListViewController alloc] initWithSearchKeyWord:keyWord];
    [self.navigationController pushViewController:searchListVC animated:YES];
}

#pragma mark shake
//开始晃动手机
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (couldShakeFlag && [Context defaults].currentNavTag == tagNav_search) {
        couldShakeFlag = NO;
        [self vibrating]; // 震动
        [self performSelector:@selector(requestHotWord:) withObject:nil afterDelay:1.0f];
        [self setLoadingStatus:Loading];; // 加载动画
    }
}

#pragma mark Request Methods

- (void)requestHotWord:(BOOL)firstFlag
{ // 热词请求
    [[MyServerRequestManager getManager] requestSearchHotWords:firstFlag isUseCache:NO userData:searchID];
}

- (void)requestAssociateKeyWords:(NSString *)keyWords
{ // 联想词请求
    [[MyServerRequestManager getManager] requestSearchAssociativeWordList:1 keyWord:keyWords isUseCache:NO userData:searchID];
}

#pragma mark SearchToolBarDelegate

- (void)searchToolBarContentChange:(NSString *)content
{
    // 摇一摇禁用
    couldShakeFlag = NO;
    
    // 搜索请求逻辑
    if ([content isEqualToString:@""]) {
        // 获取历史记录数据
        NSArray *recordArr = [[SearchManager getObject] getSearchHistoryArray];
        [recordKeyWordVC setKeyWordDataSource:recordArr];
        // 展示历史记录UI
        [self displayView:displayType_recordKeyWords];
    }
    else
    {
        // 清理之前联想词数据
        [assoKeyWordVC setKeyWordDataSource:nil];
        // 请求联想词
        [self requestAssociateKeyWords:content];
        // 展示联想词UI
        [self displayView:displayType_assoKeyWords];
    }
}

- (void)searchToolBarSearch:(NSString *)keyWord
{
    // 摇一摇禁用
    couldShakeFlag = NO;
    
    // 搜索请求逻辑
    if (keyWord) {
        // 没有输入内容
        [self searchKeyWord:keyWord];
    }
}

- (void)searchToolBarCancelClick:(id)sender
{
    // 是否响应摇一摇手势
    
    couldShakeFlag = [self hotWordViewIsShowing];

    [self displayView:displayType_hotWords];
}

- (void)searchToolBarBackClick:(id)sender
{
//    couldShakeFlag = YES; // 可以摇动
//    [self displayView:displayType_hotWords];
}

#pragma mark SearchKeyWordViewDelegate

- (void)keyWordWasSelected:(NSString *)keyWord
{
    [self setSearchToolBarText:keyWord];
    [searchToolBar hideKeyboard]; // 取消键盘响应
    
    [self searchKeyWord:keyWord];
}

#pragma mark MyServerRequestManagerDelegate

- (void)hotWordsRequestSuccess:(NSArray *)hotArray isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if (![userData isEqualToString:searchID]) return;
    if ([[MyVerifyDataValid instance] verifySearchHotWordsData:hotArray]) {
        if (!couldShakeFlag) {
            isFirstFlag = NO;
            couldShakeFlag = YES;
            [self vibrating]; // 震动
        }
        [hotWordVC setHotWords:hotArray]; // 设置数据
        [self setLoadingStatus:Hidden]; // 取消加载动画
    }
    else
    {
        // 搜索热词—数据有误
    }
    
    
}
- (void)hotWordsRequestFailed:(BOOL)isUseCache userData:(id)userData
{
    if (![userData isEqualToString:searchID]) return;
    
    couldShakeFlag = NO;
    [self setLoadingStatus:Failed];
}

- (void)searchAssociativeWordRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if (![userData isEqualToString:searchID]) return;
    if ([[MyVerifyDataValid instance] verifySearchAssociateWordsData:dataDic])
    { // 数据有效
        if ([[searchToolBar getSearchContent] isEqualToString:keyWord]) {
            [assoKeyWordVC setKeyWordDataSource:[dataDic objectForKey:@"data"]];
        }
    }
    else
    {
        // 搜索联想—数据有误
    }
    
}
- (void)searchAssociativeWordRequestFailed:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if (![userData isEqualToString:searchID]) return;
//    NSLog(@"searchAssociativeWordRequestFailed");
}

@end
