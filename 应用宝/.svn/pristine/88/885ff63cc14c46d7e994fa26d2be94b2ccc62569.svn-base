//
//  SearchViewController.m
//  browser
//
//  Created by 王毅 on 13-10-23.
//
//

#import "SearchViewController.h"
#import "FileUtil.h"
#import "PopViewController.h"
#import "CollectionViewBack.h"
#import "CategoryListViewController.h"
//监听键盘的宏定义

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
@interface SearchViewController ()<SearchZoomViewDelegate>
{
    CollectionViewBack * _backView;

    //    NSMutableArray *searchKeyBuff;
    NSString *currentSearchKey;

    UIBarButtonItem *backItem;
    BOOL *forbidPhoneShakeFlag;
//    UINavigationController *detailNav;//详情导航
    CategoryListViewController *searchList;
    UIImageView *emptySearchResult;
    BOOL iskey; // 控制 历史记录、联想词view的frame的变化（ 键盘显示/消失）
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
        self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        
        //热词页面
        searchHotWordHomeViewController = [[SearchHotWordHomeViewController alloc] initWithHotWords:nil];
        searchHotWordHomeViewController.delegate = self;
        searchHotWordHomeViewController.view.hidden = NO;
        [self.view addSubview:searchHotWordHomeViewController.view];
        
        
        //加载中
        __weak typeof(self) mySelf = self;
        _backView = [CollectionViewBack new];
        [self.view addSubview:_backView];
        [_backView setStatus:Hidden];
        [_backView setClickActionWithBlock:^{
            [mySelf performSelector:@selector(searchListFailedViewHasBeenTap) withObject:nil afterDelay:delayTime];
        }];
        
         //新市场接口
        [[MarketServerManage getManager] addListener:self];
        
        //搜索记录列表
        searchHistoryRecordTableViewController = [[SearchHistoryRecordTableViewController alloc] initWithStyle:UITableViewStylePlain];
        if ([searchHistoryRecordTableViewController.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [searchHistoryRecordTableViewController.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        searchHistoryRecordTableViewController.delegate = self;
        searchHistoryRecordTableViewController.view.hidden = YES;
        [self.view addSubview:searchHistoryRecordTableViewController.view];
        
        //搜索联想列表
        searchAssociationTableViewController = [[SearchAssociationTableViewController alloc] initWithShowData:nil];
        if ([searchAssociationTableViewController.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [searchAssociationTableViewController.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        searchAssociationTableViewController.delegate = self;
        searchAssociationTableViewController.view.hidden = YES;
        [self.view addSubview:searchAssociationTableViewController.view];
        
        //搜索框 (最后添加--最上层)
        searchZoomView = [[SearchZoomView alloc] init];
        searchZoomView.delegate = self;
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor clearColor];
//        [backButton setImage:LOADIMAGE(@"nav_back", @"png") forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
            [backButton setImage:image forState:UIControlStateNormal];
        }];
        [backButton addTarget:self action:@selector(showHotWords:) forControlEvents:UIControlEventTouchUpInside];
        backButton.hidden = YES;
        
        //搜索结果列表
        searchList = [[CategoryListViewController alloc]init];
        searchList.target =  @"search";
        
        //搜索结果为空图
        emptySearchResult  = [[UIImageView alloc]init];
        SET_IMAGE(emptySearchResult.image, @"emptySearchResult.png");
        emptySearchResult.hidden = YES;
        [self.view addSubview:emptySearchResult];
        
        
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.titleView = searchZoomView;
        [self.navigationController.navigationBar addSubview:backButton];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 支持shake
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHotWords:)
                                                 name:SHOW_HOT_WORDS
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forbidPhoneShake:)
                                                 name:@"ForbidPhoneShakeAction"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignFirstResponder)
                                                 name:@"ResignSearchFirstResponder"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeFirstResponder)
                                                 name:@"SearchBecomeFirstResponder"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callMotionEndedAction)
                                                 name:CALL_MOTION_ENDED_ACTION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActiveNotice)
                                                 name:SHOW_ACTIVE_NOTICE
                                               object:nil];
    
    [self addKeyBoardNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //新春版
    if(IOS7){
        [self.navigationController.navigationBar setBarTintColor:WHITE_BACKGROUND_COLOR];
    }
    
    [self.navigationController.navigationBar addSubview:backButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:NO]];
//    [self.navigationController setNavigationBarHidden:YES];
    [_backView setStatus:Hidden];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self becomeFirstResponder]; // 注释掉：解决每次打开程序时在首页支持摇一摇手势的bug
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers count] >1) {
        backButton.hidden = YES;
    }
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    titleLabel = nil;
    searchZoomView = nil;
    searchHotWordHomeViewController = nil;
    searchHistoryRecordTableViewController = nil;
    searchAssociationTableViewController = nil;
    _backView = nil;
    [[MarketServerManage getManager]removeListener:self];
    
}
#pragma mark - Utility

// self变为第一响应者 支持 shake
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)forbidPhoneShake:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"YES"]) {
        forbidPhoneShakeFlag = YES;
    }
    else
    {
        forbidPhoneShakeFlag = NO;
    }
    
}

-(void)changeHistoryAndAssociateWordViewByKeyboardHeight:(CGFloat)height
{
    CGRect associateRect = searchAssociationTableViewController.view.frame;
    CGRect historyRect = searchHistoryRecordTableViewController.view.frame;
    
    if (IOS7) {
        associateRect.size.height = self.view.bounds.size.height-height-searchZoomView.frame.size.height-20;
        historyRect.size.height = self.view.bounds.size.height-height-searchZoomView.frame.size.height-20;
    }
    else
    {
        associateRect.size.height = self.view.bounds.size.height-height;
        historyRect.size.height = self.view.bounds.size.height-height;
    }
    
    
    searchAssociationTableViewController.view.frame = associateRect;
    searchHistoryRecordTableViewController.view.frame = historyRect;
}

#pragma mark - 显示或隐藏searchZoomView
- (void)hideSearchZoomView:(NSNotification *)noti{
    searchZoomView.hidden = [noti.object boolValue];
}
#pragma mark - 返回显示隐藏
- (void)frashBackBtnFrame:(BOOL)sender
{
    CGFloat TMPFL = 0;//IOS7 ? 20 : 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        backButton.hidden = sender;
        if (sender) {
            backButton.frame = CGRectMake(16-37, 5 + TMPFL, 34, 34);
        }else
        {
            backButton.frame = CGRectMake(16, 5 + TMPFL, 34, 34);
        }
        
    } completion:^(BOOL isFinish){
        
    }];
}

- (void)requestTheHotWord
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //第一次请求热词
        [searchHotWordHomeViewController initilizationRequestHotWord];
    });
}

#pragma mark - 显示热词（首页）
- (void)showHotWords:(id)sender
{
    searchZoomView.searchBar.placeholder = PLACEHOLDER;
    
    if (sender) {
        [self frashBackBtnFrame:YES];//当点击返回按钮时
        [searchZoomView isSearchFrame:NO andIsResulePage:NO];
        [SearchServerManage getObject].delegate = nil;
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        [searchZoomView isSearchFrame:NO andIsResulePage:YES];
    }
    [self becomeFirstResponder];
    //[searchHotWordHomeViewController showHomeView];
    searchHotWordHomeViewController.view.hidden = NO;
    [self.view bringSubviewToFront:searchHotWordHomeViewController.view];
    searchHistoryRecordTableViewController.view.hidden = YES;
    searchAssociationTableViewController.view.hidden = YES;
    emptySearchResult.hidden = YES;
    [_backView setStatus:Hidden];
    
    //点击返回按钮置空搜索列表
    [searchList.detailListTableViewController showSearchResult:nil isNextData:NO searchContent:nil];
    [searchList.detailListTableViewController.tableView reloadData];

}
#pragma mark - 显示搜索结果
- (void)showSearchingResult:(id)sender
{
    [self frashBackBtnFrame:NO];
    [searchZoomView isSearchFrame:NO  andIsResulePage:YES];
    
    searchHotWordHomeViewController.view.hidden = YES;
    searchHistoryRecordTableViewController.view.hidden = YES;
    searchAssociationTableViewController.view.hidden = YES;

    [self.view bringSubviewToFront:searchZoomView];
    [_backView setStatus:Hidden];
}

#pragma mark - 显示搜索联想
- (void)showAssociate:(id)sender
{
    if (!searchHotWordHomeViewController.view.hidden) {
        [self frashBackBtnFrame:YES];
        [searchZoomView isSearchFrame:YES  andIsResulePage:NO];
    }else
    {
        [self frashBackBtnFrame:NO];
        [searchZoomView isSearchFrame:YES  andIsResulePage:YES];
    }
    
    searchAssociationTableViewController.view.hidden = NO;
    [self.view bringSubviewToFront:searchAssociationTableViewController.view];
    searchHistoryRecordTableViewController.view.hidden = YES;
    [_backView setStatus:Hidden];
    
    // 搜索框内搜索词变化 更新联想词
    [self requestAssociateTermWithKey:(NSString *)sender];
    
}
#pragma mark - 显示搜索记录
- (void)showSearchHistory:(id)sender
{
    if (!searchHotWordHomeViewController.view.hidden) {
        [self frashBackBtnFrame:YES];
        [searchZoomView isSearchFrame:YES  andIsResulePage:NO];
    }else
    {
        [self frashBackBtnFrame:NO];
        [searchZoomView isSearchFrame:YES  andIsResulePage:YES];
    }
    [searchHistoryRecordTableViewController rushList];
    searchHistoryRecordTableViewController.view.hidden = NO;
    [self.view bringSubviewToFront:searchHistoryRecordTableViewController.view];
    searchAssociationTableViewController.view.hidden = YES;
    
    [_backView setStatus:Hidden];
    
}

#pragma mark - 开始搜索
- (void)beginSearching:(id)sender
{
    [self frashBackBtnFrame:NO];//显示返回按钮
    [searchZoomView isSearchFrame:YES  andIsResulePage:YES];
    
    [searchZoomView.searchBar resignFirstResponder]; // 取消键盘响应
    
    // 摇一摇相关
    [self callMotionEndedAction]; // 防止摇一摇没有走系统的cancel及end方法，就搜索，导致菊花一直转 
    [self resignFirstResponder]; // 取消震动
    
    NSString *key = (NSString *)sender;
    searchZoomView.searchBar.text = key;
    [self requestSearchResultListWithKey:key]; // 请求结果列表
}

#pragma mark - 取消搜索，回到原始页面
- (void)cancleSearching:(id)sender
{
    if (!searchHotWordHomeViewController.view.hidden) {
        [self frashBackBtnFrame:YES];
        [searchZoomView isSearchFrame:NO  andIsResulePage:NO];
        // 摇一摇相关
        [self callMotionEndedAction]; // 防止摇一摇没有走系统的cancel及end方法，就搜索，导致菊花一直转
        [self resignFirstResponder]; // 取消震动
        [self showHotWords:@"111"];
    }else
    {
        [self frashBackBtnFrame:NO];
        [searchZoomView isSearchFrame:NO  andIsResulePage:YES];
        
        [self showSearchingResult:nil];
    }
    
    currentSearchKey = nil;
}
#pragma mark - 搜索结果失败页面
-(void)showSearchListFailedView
{
    [self frashBackBtnFrame:NO];
    [searchZoomView isSearchFrame:NO  andIsResulePage:YES];
    [_backView setStatus:Failed];
    [self.view bringSubviewToFront:_backView];
}
-(void)showSearchEmptyView
{
//    [self frashBackBtnFrame:NO];
//    [searchZoomView isSearchFrame:NO  andIsResulePage:YES];
//    [_backView setStatus:Hidden];
    [self showSearchingResult:nil];
    emptySearchResult.hidden = NO;

}
#pragma mark - shake
//开始晃动手机
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (!forbidPhoneShakeFlag && !searchHotWordHomeViewController.view.hidden && !searchHotWordHomeViewController.isHotWordHomeViewHidden) {
        searchHotWordHomeViewController.isShaking = YES; // 是否在摇一摇震动中
        [searchHotWordHomeViewController performSelector:@selector(sharkPhone) withObject:nil afterDelay:0.2f];
        [searchHotWordHomeViewController reloadHotWordRequest];
    }
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self callMotionEndedAction];
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self callMotionEndedAction];
}
-(void)callMotionEndedAction
{
    searchHotWordHomeViewController.isShaking = NO;
    if (searchHotWordHomeViewController.isHotWordDataReturn && !searchHotWordHomeViewController.isShakedForReturn) {
        [searchHotWordHomeViewController performSelector:@selector(sharkPhone) withObject:nil afterDelay:0.3f];
        [searchHotWordHomeViewController performSelector:@selector(showHomeView) withObject:nil afterDelay:0.5f];
        searchHotWordHomeViewController.isShakedForReturn = YES;
    }
}

#pragma mark - Request
// 搜索联想词数据请求
-(void)requestAssociateTermWithKey:(NSString *)key
{
    [SearchServerManage getObject].delegate = self;
    [[SearchServerManage getObject] requestRealtimeSearchData:key];
}

// 搜索结果列表 请求
-(void)requestSearchResultListWithKey:(NSString *)key
{
    [_backView setStatus:Loading];
    [self.view bringSubviewToFront:_backView];
    
    currentSearchKey = key;
    [SearchServerManage getObject].delegate = self;
    [[SearchServerManage getObject] requestSearchLIst:key requestPageNumber:1 userData:nil];
    
    // 存储搜索记录
    [[SearchManager getObject] saveSearchHistoryRecord:key];
}

#pragma mark -  点击搜索失败页面 重新搜索
-(void)searchListFailedViewHasBeenTap
{
    [self requestSearchResultListWithKey:searchZoomView.searchBar.text];
}
#pragma mark - SearchHotWordHomeViewDelegate
-(void)hotWordHasBeenSelected:(NSString *)hotWord
{
    [self beginSearching:hotWord];
}
#pragma mark - SearchAssociationTableViewDelegate
-(void)aSearchAssociationTermHasBeenSelected:(NSString *)searchTerm
{
    [self beginSearching:searchTerm];
}
#pragma mark - SearchHistoryRecordDelegate
-(void)getHistoryRecordString:(NSString *)string
{
    searchHistoryRecordTableViewController.view.hidden = YES;
    [self beginSearching:string];
}

#pragma mark - searchServerManagerDelegate

-(BOOL)checkData:(NSArray*)data {
    
    if(!IS_NSARRAY(data))
        return NO;
    
    for (NSDictionary * dicItem in data){
        
        if( !IS_NSDICTIONARY(dicItem) )
            return NO;
        
        if([dicItem getNSStringObjectForKey:@"appdowncount"] &&
           [dicItem getNSStringObjectForKey:@"appiconurl"] &&
           [dicItem getNSStringObjectForKey:@"appid"] &&
           [dicItem getNSStringObjectForKey:@"appintro"] &&
           [dicItem getNSStringObjectForKey:@"appname"] &&
           [dicItem getNSStringObjectForKey:@"appreputation"] &&
           [dicItem getNSStringObjectForKey:@"appsize"] &&
           [dicItem getNSStringObjectForKey:@"appupdatetime"] &&
           [dicItem getNSStringObjectForKey:@"appversion"] &&
           [dicItem getNSStringObjectForKey:@"category"] &&
           [dicItem getNSStringObjectForKey:@"ipadetailinfor"] &&
           [dicItem getNSStringObjectForKey:@"plist"] &&
           [dicItem getNSStringObjectForKey:@"share_url"]
           ){
            //数据正常..
        }else{
            return NO;
        }
    }
    
    return YES;
    
}

- (void)getSearchListPageData:(NSArray *)dataArray isNextData:(BOOL)nextData searchContent:(NSString *)searchContent userData:(id)userData
{
    if (currentSearchKey!=searchContent) {
         return;
    }
    
    //恢复刷新cell状态
    if( ![self checkData:dataArray] ){
        //数据有问题
         return ;
    }
        //显示搜索的结果页
    if ([dataArray count]) {
        //搜索无结果,不切换界面
        [searchList.detailListTableViewController setRefreshCellText:nil andActivityHiden:YES searchLock:NO];
        // 显示搜索的结果页
        [searchList.detailListTableViewController showSearchResult:dataArray isNextData:nextData searchContent:searchContent];
        searchList.detailListTableViewController.target  = @"search";
        [searchList showCategoryListTableView];
        searchList.searchContent = searchContent;
        if ([self.navigationController visibleViewController] == self) {
            [self.navigationController pushViewController:searchList animated:YES];
        }
   }else{
       [searchList.detailListTableViewController setRefreshCellText:FRASHLOAD_ING andActivityHiden:NO searchLock:NO];
       //显示搜索无结果
       [self showSearchEmptyView];
//       [searchZoomView isSearchFrame:YES  andIsResulePage:YES];
       [self.navigationController.navigationBar addSubview:backButton];
    }
    
}

- (void)searchInfoRequestSuccesButNotData:(NSString *)appid userData:(id)userData{
    
}
- (void)searchListRequestFailWord:(NSString *)keyWord userData:(id)userData
{
    if (!IS_NSSTRING(keyWord)) {
        return;
    }
//    [searchKeyBuff removeObject:keyWord];
    NSLog(@"UI-searchListRequestFailWord: %@",keyWord);
    if ([searchList.detailListTableViewController hasExistData]) {
        
        if (![[searchList.detailListTableViewController getLastSearchContent] isEqualToString:keyWord]) {
//            [self showHotWords:nil];
            [self showSearchListFailedView];
            [searchList.detailListTableViewController setRefreshCellText:FRASHLOAD_ING andActivityHiden:NO searchLock:YES];
        }else{
            [searchList.detailListTableViewController setRefreshCellText:FRASHLOAD_FAILD andActivityHiden:YES searchLock:YES];
//            [self showSearchingResult:nil];
        }
        [self performSelector:@selector(setSearchListLock) withObject:nil afterDelay:0.5];

    }else{
        [self showSearchListFailedView];
        [searchList.detailListTableViewController setRefreshCellText:FRASHLOAD_ING andActivityHiden:NO searchLock:NO];
    }
    //恢复搜索列表下拉刷新状态
    [searchList.detailListTableViewController refreshDataComplete];
}
- (void)setSearchListLock{
    [searchList.detailListTableViewController setRefreshCellText:FRASHLOAD_FAILD andActivityHiden:YES searchLock:NO];
}
// 搜索联想
-(void)searchRealtimeKeyword:(NSString *)keyword succes:(BOOL)succes realtimeData:(NSArray *)data
{
    if ([keyword isEqualToString:searchZoomView.searchBar.text]) {
        // 刷新联想列表
        [searchAssociationTableViewController reloadSearchTableViewWithData:data];
    }
}
-(void)searchRealtimeServerFailKeyword:(NSString *)keyword
{// 联想词搜索不到，不进行任何操作
    NSLog(@"searchRealtimeServerFailKeyword:%@",keyword);
}

#pragma mark - 显示收起激活教程
- (void)showActiveNotice{
    [[NSNotificationCenter defaultCenter]postNotificationName:OPENLESSON object:nil];
}
#pragma mark -
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    CGFloat TMPFL = IOS7 ? 20 : 0;
    
    //titleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    searchZoomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 88/2);
    backButton.frame = CGRectMake(16, (44-34)/2, 34, 34);
    if (IOS7) {
            searchHotWordHomeViewController.view.frame = CGRectMake(0, searchZoomView.frame.origin.y + searchZoomView.frame.size.height + TMPFL, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
    }else{
            searchHotWordHomeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
    }

    if (!iskey) {
        if (IOS7) {
            searchHistoryRecordTableViewController.view.frame = CGRectMake(0, searchZoomView.frame.origin.y + searchZoomView.frame.size.height+ TMPFL, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
            
            searchAssociationTableViewController.view.frame = CGRectMake(0, searchZoomView.frame.origin.y + searchZoomView.frame.size.height+ TMPFL, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
        }else{
            searchHistoryRecordTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
            
            searchAssociationTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
        }
        
        rect1 = searchAssociationTableViewController.view.frame;
        rect2 = searchHistoryRecordTableViewController.view.frame;
    }

    if (IOS7) {
//        _backView.frame = CGRectMake(0, searchZoomView.frame.origin.y + searchZoomView.frame.size.height+2.5, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
        _backView.frame = CGRectMake(0, 44 + 20 + 2.5, self.view.frame.size.width, self.view.frame.size.height-49 - (44 + 20));
    }else{
        _backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49 - (searchZoomView.frame.origin.y + searchZoomView.frame.size.height));
    }
    emptySearchResult.frame = CGRectMake(0, 0, 153, 116);
    emptySearchResult.center = self.view.center;
}
//监听键盘隐藏和显示事件
- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//注销监听事件
- (void)removeKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

static CGRect rect1, rect2;
-(void)keyboardWillHide:(NSNotification *)notification{

    searchAssociationTableViewController.view.frame = rect1;
    searchHistoryRecordTableViewController.view.frame = rect2;
    iskey = NO;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    searchAssociationTableViewController.view.frame = rect1;
    searchHistoryRecordTableViewController.view.frame = rect2;
}

//计算当前键盘的高度
-(void)keyboardDidShow:(NSNotification *)notification{
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = _keyboardRect.size.height;
    
    // 键盘类型变化（键盘高度变化）
    NSDictionary *dic = [notification userInfo];
    CGRect beginRect = [[dic objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGFloat offset = _keyboardRect.size.height - beginRect.size.height;
    
    if (offset != 0) { // 键盘类型变化时改变frame
        [self changeHistoryAndAssociateWordViewByKeyboardHeight:height];
    }
    
    if(iskey){
        return ;
    }
    iskey = YES;
    
    [self changeHistoryAndAssociateWordViewByKeyboardHeight:height];
    
    //隐藏搜索结果为空图
    emptySearchResult.hidden = YES;
}
     
@end
