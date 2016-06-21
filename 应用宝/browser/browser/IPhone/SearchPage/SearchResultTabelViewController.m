//
//  SearchRuseltTabelViewController.m
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "SearchResultTabelViewController.h"
#import "SearchResultCell.h"
#import "SettingPlistConfig.h"
#import "SearchResult_DetailTableViewController.h"
#import "SearchResult_DetailViewController.h"
#import "SearchViewController.h"
#import "SearchManager.h"
#import "BppDistriPlistManager.h"
#import "SetDownloadButtonState.h"
#import "Reachability.h"
#import "FileUtil.h"
#import "UIImageEx.h"
#import "MarketServerManage.h"
#import "KyMarketNavgationController.h"
#import "FindDetailViewController.h"
#import "AppStatusManage.h"
#import "CategoryListViewController.h"
#import "CollectionViewBack.h"
#import "SearchServerManage.h"
#import "MarketServerManage.h"
#define FULLSCREEN_MAX_CELLCOUNT ((MainScreen_Height - 20 - 44 -49)/88 + 1)
@interface SearchResultTabelViewController () <BppDistriPlistManagerDelegate>
{
    NSMutableArray *resultArray;//搜索结果
    BOOL searchLock;//发送搜索请求,在请求回调之前不允许请求
    BOOL hasNextPage;//是否还有下页
    NSString *searchContent_;//当前搜索内容
    int requestTimesCount;//请求搜索的次数
    SearchManager *searchManager;
    SearchResult_DetailViewController *detailVC;//之创建一个详情页面,复用
    RefreshView *freshLoadView;
    UITableViewCell *refreshCell;
    NSString * isNetAvilibale;
    UIButton *activeNoticeButton;
    
    BOOL isCategoryDetail;//用于判断是否是从分类进入的导航
    UILabel *customTextLabel;
    NSMutableArray *exposure;//曝光应用数组
    BOOL isRefreshing;
    EGORefreshTableHeaderView *refreshHeader;
}

enum{
    IMAGE_TYPE_ICON = 0,
    IMAGE_TYPE_PREVIEW
};
@end

@implementation SearchResultTabelViewController

- (void)dealloc{
    [[MarketServerManage getManager] removeListener:self];
    
    [[BppDistriPlistManager getManager] removeListener:self];
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //设置图片下载代理
    searchManager = [[SearchManager alloc]init];
    searchManager.delegate = self;
    
    //新市场代理
    [[MarketServerManage getManager] addListener:self];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加cell显示模式的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BrowserModelChanged) name:@"BrowserModelSwitchIsChange" object:nil];
    
    detailVC = [[SearchResult_DetailViewController alloc]init];
    
    [[BppDistriPlistManager getManager] addListener:self];
    
    
    searchLock = NO;
    hasNextPage = NO;
    requestTimesCount = 1;
    resultArray  = [[NSMutableArray alloc]init];
    
    exposure = [[NSMutableArray alloc]init];
    
    //下拉刷新
    refreshHeader  =[[ EGORefreshTableHeaderView alloc]init];
//    CGFloat startY = IOS7 ? 64 : 20;
    if ([self.target isEqualToString:@"search"]&&![[FileUtil instance] checkAuIsCanLogin]){
        self.tableView.contentInset = UIEdgeInsetsMake(47.5, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    
    
    refreshHeader.inset = self.tableView.contentInset;
    refreshHeader.frame = CGRectMake(0, -self.tableView.bounds.size.height-self.tableView.contentInset.top, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    refreshHeader.egoDelegate = self;
    [self.view addSubview:refreshHeader];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)setInforNil{
    for (id cell in [self.tableView visibleCells]) {
        if ( [cell isKindOfClass:[SearchResultCell class]]) {
            SearchResultCell *cell_ = (SearchResultCell *)cell;
            [cell_ setInforNil];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - cell显示模式通知方法
- (void)BrowserModelChanged{
    //这样会导致tableView刷新后,会有系统的sperateLine显示紊乱的问题
    //    [self.searchResultTVC.tableView reloadData];
    
    //重新初始化tableViewController
    [self.tableView reloadData];
}

- (NSString *)getLastSearchContent{
    return searchContent_;
}
- (void) showSearchResult:(NSArray *)result isNextData:(BOOL)nextData searchContent:(NSString *)searchContent{
    if (isRefreshing) {
        [resultArray removeAllObjects];
        requestTimesCount = 1;
    }
    
    if ([result count] == 0) {
        return;
    }
    //如本次搜索内容不同于上次,重置
    if (![searchContent_ isEqualToString:searchContent]) {
        
        [resultArray removeAllObjects];
        requestTimesCount = 1;
    }
    
    for (NSDictionary *dic in result) {
        //当搜索内容相同,且搜索结果与之前相同时,进行过滤,不加入结果数组;
        if ([resultArray containsObject:dic]) {
            if (hasNextPage == YES) {
                float cellHeight;

                cellHeight  = 80;
            }
            break;
        }
        [resultArray addObject:dic];
    }
    searchLock = NO;
    searchContent_ = searchContent;
    hasNextPage = nextData;
    requestTimesCount ++;
    
    //结果列表归零位,要避免和下拉刷新的归零位同时进行
    if (!isRefreshing&&([resultArray count] == [result count])&&[resultArray count] != 0) {
        self.tableView.contentOffset = CGPointZero;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    //下拉刷新完成
    [self refreshDataComplete];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //控制刷新cell的显示
    if (!hasNextPage||[resultArray count] ==0||[resultArray count]<FULLSCREEN_MAX_CELLCOUNT) {
        return [resultArray count];
    }else{
        return [resultArray count]  +1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"searchResult";
    if((indexPath.row >= [resultArray count])&&([resultArray count]>=FULLSCREEN_MAX_CELLCOUNT)) {
        refreshCell = [tableView dequeueReusableCellWithIdentifier:@"last_cell"];
        if (!refreshCell) {
            refreshCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"last_cell"];
            freshLoadView = [[RefreshView alloc] init];
            freshLoadView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, refreshCell.frame.size.height);
            
            refreshCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [refreshCell addSubview:freshLoadView];
        }
        [freshLoadView startGif];
        return refreshCell;
    }
    
    
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.searchResultTableViewController = self;
        cell.searchManager = searchManager;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.identifier = CellIdentifier;

    NSDictionary *appInfor = resultArray[indexPath.row];
    //初始化cell显示内容
    [cell initCellwithInfor:appInfor];
    //cell 内实现下载按钮状态改变
    [cell initDownloadButtonState];
    
    if ([self.target isEqualToString:@"market"]) {
        cell.source = CATEGORY_APP(searchContent_, indexPath.row);
    }else if([self.target isEqualToString:@"search"]){
        cell.source = SEARCH_APP(indexPath.row);
    }
    
    //图片显示

    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:_StaticImage.icon_60x60];
    
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [resultArray count]) {
        return 40;
    }else{
        return 88;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != [resultArray count]) {
        
        SearchResultCell *cell = (SearchResultCell *)[tableView cellForRowAtIndexPath:indexPath];
        //是从分类还是搜索中的detail
        detailVC.detailType = self.target;
        NSString *exposureSource = nil;
        if ([self.target isEqualToString:@"market"]) {
            exposureSource = self.parentCategoryListViewController.categoryName;
        }else{
//            NSDictionary *dic = resultArray[indexPath.row];
//            NSMutableDictionary* dicTmp   = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [dicTmp setObject:cell.source forKey:@"dlfrom"];
            exposureSource = self.target;
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"showSearchDetail" object:dicTmp];
        }
        
        
        [detailVC setAppSoure:cell.source];
        [detailVC beginPrepareAppContent:resultArray[indexPath.row]];
        exposureSource = self.parentCategoryListViewController.categoryName;
        [self.parentCategoryListViewController.navigationController pushViewController:detailVC animated:YES];
        
        [[ReportManage instance] ReportAppDetailClick:exposureSource appid:cell.appID];
    }
}


//下载并显示app相关图片,icon,proview
- ( void )showAppImageWithIndex:(int)index type:(int)imageType{
    
    NSDictionary *appDic = resultArray[index];
    [ searchManager downloadImageURL:[NSURL URLWithString:[appDic objectForKey:imageType?@"apppreview": @"appiconurl"]]  userData:nil];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    if (!searchLock &&hasNextPage){
        SearchResultCell *cell = [self.tableView.visibleCells lastObject];
        if ([resultArray count] != 0&&([self.tableView indexPathForCell:cell].row == [resultArray count])) {
            [self setRefreshCellText:FRASHLOAD_ING andActivityHiden:NO searchLock:YES];
            if (![self.target isEqualToString:@"market"]) {
                [[SearchServerManage getObject]requestSearchLIst:searchContent_ requestPageNumber:requestTimesCount userData:searchContent_];
            }else{
                [self performSelector:@selector(delayRequestCategoryList) withObject:nil afterDelay:0.3];
            }
        }
    }
}
- (void)delayRequestCategoryList{
    [[MarketServerManage getManager] getClassifyApp:searchContent_ pageCount:requestTimesCount userData:searchContent_];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [exposure removeAllObjects];
    for (id cell in [self.tableView visibleCells]) {
        if ([self.tableView indexPathForCell:cell].row <= 50) {
            if ([cell isKindOfClass:[SearchResultCell class]]) {
                SearchResultCell * searchResultCell  = (SearchResultCell * )cell;
                [exposure addObject:searchResultCell.appID];
            }
        }
    }
    
    NSString *source = nil;
    if ([self.target isEqualToString:@"market"]   ){
        source = self.parentCategoryListViewController.categoryName;
    }else{
        source = self.target;
    }
    [[ReportManage instance] ReportAppBaoGuang:source appids:exposure];

    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(self.tableView.contentInset.top+65)) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

#pragma mark EGO delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    isRefreshing = YES;
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.3];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return isRefreshing;
}

- (void)refreshData{

    if ([self.target isEqualToString:@"search"]) {
        //搜索重新请求
        [[SearchServerManage getObject] requestSearchLIst:searchContent_ requestPageNumber:1 userData:searchContent_];
    }else if ([self.target isEqualToString:@"market"]){
        //重新请求分类
        [[MarketServerManage getManager] getClassifyApp:searchContent_ pageCount:1 userData:searchContent_];
    }
}

- (void)refreshDataComplete{
    isRefreshing = NO;
//    searchLock = NO;
    [refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

//    临时解决搜索结果过少,搜索结果列表不能归零位的问题
    if (self.tableView.contentOffset.y < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = refreshHeader.inset;
            self.tableView.contentOffset = CGPointZero;
        }];
    }else{
        self.tableView.contentInset = refreshHeader.inset;
    }
    
    
    [self.tableView reloadData];
}
#pragma mark - 更新下载按钮状态
- (void)updateDownloadButtonState{
    //通知在子线程内发出,更新界面要在主线程内
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
#pragma mark - 是否存在已请求的数据
- (BOOL)hasExistData{
    if ([resultArray count]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -设置刷新按钮状态

- (void)setRefreshCellText:(NSString *)content andActivityHiden:(BOOL)isHiden searchLock:(BOOL)isLocked{
    if (isHiden) {
        [freshLoadView stopGif];
    }else{
        [freshLoadView startGif];
    }
    searchLock = isLocked;
}
#pragma mark - 未激活提示按钮
- (void)showActiveNotice{
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_ACTIVE_NOTICE object:nil];
}


//通知界面下载失败原因
- (void)downloadFailCause:(NSString*)distriPlist failCause:(NSString *)failCause {
    [self.tableView reloadData];
}


@end
