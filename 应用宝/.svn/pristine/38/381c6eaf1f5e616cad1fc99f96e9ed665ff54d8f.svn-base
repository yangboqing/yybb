//
//  AListViewController.m
//  browser
//
//  Created by mingzhi on 14-5-14.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AListViewController.h"
#import "ListMangerTopView.h"
#import "RotatingLoadView.h"
#import "SearchResult_DetailViewController.h"
#import "CollectionViewBack.h"

@interface AListViewController ()<UIScrollViewDelegate>
{
    ListMangerTopView *listTopView;
    MarketListViewController *weekListVC;
    MarketListViewController *monthListVC;
    MarketListViewController *totalListVC;
    SearchResult_DetailViewController *detailVC;
    
    RankingListType rankingListType;
    UIScrollView * _scrollView;
    NSInteger beforeIndex;
    BOOL clickBtn;
}

@end

@implementation AListViewController

-(void)dealloc{
    weekListVC.delegate = nil;
    monthListVC.delegate = nil;
    totalListVC.delegate = nil;
    weekListVC = nil;
    monthListVC = nil;
    totalListVC = nil;
    
    listTopView = nil;
    detailVC = nil;
    _scrollView.delegate = nil;
    _scrollView = nil;
}

-(id)initWithRankingListType:(RankingListType)listType
{
    self = [super init];
    
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        if (IOS7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //top三按钮
        listTopView = [[ListMangerTopView alloc] init];
        listTopView.weekBtn.tag = CLICK_WEEK_BUTTON;
        listTopView.monthBtn.tag = CLICK_MONTH_BUTTON;
        listTopView.totalBtn.tag = CLICK_TOTAL_BUTTON;
        [listTopView.weekBtn addTarget:self action:@selector(changeViewshow:) forControlEvents:UIControlEventTouchUpInside];
        [listTopView.monthBtn addTarget:self action:@selector(changeViewshow:) forControlEvents:UIControlEventTouchUpInside];
        [listTopView.totalBtn addTarget:self action:@selector(changeViewshow:) forControlEvents:UIControlEventTouchUpInside];
        [listTopView myAnimation:1.0f anIndex:0];
        self.navigationItem.titleView = listTopView;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.directionalLockEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
        
        //周排行列表
        rankingListType = listType;
        if (listType == rankingListType_App) {
            weekListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_AppWeekRankingType];
            weekListVC.delegate = self;
            monthListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_AppMonthRankingType];
            monthListVC.delegate = self;
            totalListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_AppTotalRankingType];
            totalListVC.delegate = self;
        }
        else
        {
            weekListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_GameWeekRankingType];
            weekListVC.delegate = self;
            monthListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_GameMonthRankingType];
            monthListVC.delegate = self;
            totalListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_GameTotalRankingType];
            totalListVC.delegate = self;
        }
        
        [_scrollView addSubview:weekListVC.view];
        [_scrollView addSubview:monthListVC.view];
        [_scrollView addSubview:totalListVC.view];
        
        [self setViewFrame];
        
        [self changeViewshow:listTopView.weekBtn];
        
        //搜索详情
        detailVC = [[SearchResult_DetailViewController alloc]init];
        [detailVC setDetailToZeroPoint];
    }
    
    return self;
}

#pragma mark - 切换显示视图
- (void)changeViewshow:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    int tag = tmpBtn.tag;
    
    clickBtn = YES;
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*(tag/111-1), 0) animated:NO];
    beforeIndex = tag;
    
    // 曝光数据
    [self requestDataWithTag:tag];
}

#pragma mark - 返回
- (void)popMyView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestDataWithTag:(NSInteger)tag
{
    switch (tag) {
        case CLICK_WEEK_BUTTON:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [weekListVC initRequest];
            });
        }
            break;
        case CLICK_MONTH_BUTTON:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [monthListVC initRequest];
            });
        }
            break;
        case CLICK_TOTAL_BUTTON:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [totalListVC initRequest];
            });
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置frame
- (void)setViewFrame
{
    //边缘空出位置用于实现边缘右滑返回
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _scrollView.frame = CGRectMake(0, 0, MainScreen_Width, screenHeight);
    _scrollView.contentSize = CGSizeMake(MainScreen_Width*3, screenHeight);
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    listTopView.frame = CGRectMake(0, 0, MainScreen_Width, 44);
    
    weekListVC.view.frame = CGRectMake(0, 0, MainScreen_Width, _scrollView.frame.size.height);
    monthListVC.view.frame = CGRectMake(MainScreen_Width*1, 0, MainScreen_Width, weekListVC.view.frame.size.height);
    totalListVC.view.frame = CGRectMake(MainScreen_Width*2, 0, MainScreen_Width, weekListVC.view.frame.size.height);
    
}

#pragma mark - MarketListViewDelegate

-(void)aCellHasBeenSelected:(NSDictionary *)infoDic
{
    NSString *source = [infoDic objectForKey:@"source"];
    NSDictionary *dataDic = [infoDic objectForKey:@"data"];
    [detailVC setAppSoure:APP_DETAIL(source)];
    detailVC.view.hidden = NO;
    [detailVC hideDetailTableView];
    detailVC.BG.hidden = NO;
    [detailVC beginPrepareAppContent:dataDic];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    // 汇报点击
    [[ReportManage instance] ReportAppDetailClick:APP_DETAIL(source) appid:[dataDic objectForKey:@"appid"]];
}

#pragma mark -  ScrollView delegate
// view已经停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [listTopView setBtnEnable:YES];
    
    int tmpIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
    listTopView->_selectButtonTag = tmpIndex;
    
    // 曝光数据、请求
    [self requestDataWithTag:tmpIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    listTopView->_selectButtonTag = scrollView.contentOffset.x/scrollView.bounds.size.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
#define SIZE (_scrollView.bounds.size.width/2)
    
    listTopView->_selectButtonTag = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    if (clickBtn) {
        [listTopView myAnimation:beforeIndex];
        clickBtn = NO;
    }else
    {
        [listTopView setList_top_barDidScroll:scrollView];
    }
    
}

// 已经结束拖拽，手指刚离开view的那一刻
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [listTopView setBtnEnable:NO];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    addNavgationBarBackButton(self, popMyView:)
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count==1) {
        [weekListVC removeListener];
        weekListVC.delegate = nil;
//        weekListVC = nil;
        [monthListVC removeListener];
        monthListVC.delegate = nil;
//        monthListVC = nil;
        [totalListVC removeListener];
        totalListVC.delegate = nil;
//        totalListVC = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
