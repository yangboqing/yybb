
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "NewAddFreeListViewController.h"
#import "RotatingLoadView.h"
#import "SearchResult_DetailViewController.h"
#import "CollectionViewBack.h"

#define CLICK_APP_BUTTON 111
#define CLICK_GAME_BUTTON 222


@interface FreeListTopView : UIView
{
@public
    NSUInteger _selectButtonTag;
    UIImageView *bgImageView;
    UIImageView *spaceBtnLine1;
    UIImageView *spaceBtnLine2;
}
@property (nonatomic , retain) UIView *line;
@property (nonatomic , retain) UIButton *backButton;
@property (nonatomic , retain) UIButton *gameBtn;
@property (nonatomic , retain) UIButton *appBtn;
@property (nonatomic , retain) UIButton *totalBtn;

- (void)myAnimation:(NSInteger)before;
- (void)myAnimation:(float)dur anIndex:(NSUInteger)index;
- (void)setBtnEnable:(BOOL)enable;

- (void)setList_top_barDidScroll:(UIScrollView *)_scrollView;
@end

#define SELECTED hllColor(222, 53, 46, 1)
#define NO_SELECTED hllColor(81, 81, 81, 1)
//新春版
//#define NO_SELECTED hllColor(244, 188, 184, 1)
//
//#define SELECTED hllColor(255, 255, 255, 1)
#define MINFONT 15.0
#define MAXFONT 19.0

@implementation FreeListTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        bgImageView = [[UIImageView alloc]init];
        if (!IOS7) {
            bgImageView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        }
        
        self.gameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gameBtn.backgroundColor = [UIColor clearColor];
        self.gameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.gameBtn setTitleColor:NO_SELECTED forState:UIControlStateNormal];
        [self.gameBtn setTitle:[NSString stringWithFormat:@"游戏"] forState:UIControlStateNormal];
        
        spaceBtnLine1 = [[UIImageView alloc] init];
        spaceBtnLine1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        //新春版
        spaceBtnLine1.image = [UIImage imageNamed:@"cut_41.png"];
        
        self.appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.appBtn.backgroundColor = [UIColor clearColor];
        self.appBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.appBtn setTitleColor:NO_SELECTED forState:UIControlStateNormal];
        [self.appBtn setTitle:[NSString stringWithFormat:@"应用"] forState:UIControlStateNormal];
        
        
        self.gameBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        self.appBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        
        bgImageView.userInteractionEnabled = YES;
        
        [self addSubview:bgImageView];
        //[bgImageView addSubview:self.backButton];
        [bgImageView addSubview:self.gameBtn];
        [bgImageView addSubview:spaceBtnLine1];
        [bgImageView addSubview:self.appBtn];

        
        _selectButtonTag = 1;
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat oriX = 5;
    CGFloat oriY = 0;
    CGFloat width = (self.frame.size.width-10-2)/2;
    CGFloat height = 44;
    bgImageView.frame = self.bounds;
    
    self.gameBtn.frame = CGRectMake(oriX + width + 1 , oriY, width, height);
    spaceBtnLine1.frame = CGRectMake(oriX + width , 11, 1, 22);
    self.appBtn.frame = CGRectMake(oriX, oriY, width, height);
}


- (void)myAnimation:(float)dur anIndex:(NSUInteger)index{
    
    static UIButton * _select = nil;
    static UIButton * _next = nil;
    
    float _dur;
    _select = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    _next = (UIButton *)[self viewWithTag:(index + 1) * 111];
    
    
    _dur = fabsf(dur) ? fabsf(dur)*(MAXFONT/MINFONT-1)+1 : 1;
    
    if (dur < 0) {
        
        if (_selectButtonTag > index) {
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
            [_select setTitleColor:NO_SELECTED forState:UIControlStateNormal];
        }else if (_selectButtonTag == index){
            UIButton * button = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111 + 111];
            [button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
        }else{
            [_select setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
        }

        
        if (_selectButtonTag > index) {
            _next.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
        }else{
            _select.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
        }
        
    }else{
        
        if (_selectButtonTag > index) {
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
            [_select setTitleColor:NO_SELECTED forState:UIControlStateNormal];
        }else if (_selectButtonTag == index){
            if (_selectButtonTag==0) {
                _selectButtonTag = 1;
            }
            UIButton * button = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111 - 111];
            [button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
        }else{
            [_select setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            [_next setTitleColor:SELECTED forState:UIControlStateNormal];
        }
        
        _next.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
    }
}

- (void)myAnimation:(NSInteger)before{
    UIButton * beforeBtn = (UIButton *)[self viewWithTag:before];
    UIButton * selectBtn = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    
    [beforeBtn setTitleColor:NO_SELECTED forState:UIControlStateNormal];
    [selectBtn setTitleColor:SELECTED forState:UIControlStateNormal];
    
    beforeBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    float _dur = 1.2*(MAXFONT/MINFONT-1)+1;
    
    beforeBtn.titleLabel.layer.transform = CATransform3DMakeScale(1, 1, 1);
    selectBtn.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    
    [CATransaction commit];
    
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    selectBtn.titleLabel.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
}

- (void)setBtnEnable:(BOOL)enable
{
    self.gameBtn.enabled = enable;
    self.appBtn.enabled = enable;
}

- (void)setList_top_barDidScroll:(UIScrollView *)_scrollView
{
    static UIButton * _select = nil;
    static UIButton * _next = nil;
    
    _selectButtonTag = _scrollView.contentOffset.x/(_scrollView.bounds.size.width);
    
    NSInteger idx = (NSInteger)_scrollView.contentOffset.x % (NSInteger)_scrollView.bounds.size.width;
    
    if (idx == 0) return;
    
    NSInteger next = _selectButtonTag;
    
    if (_scrollView.contentOffset.x >= _selectButtonTag*_scrollView.bounds.size.width) {
        next ++;
    }else{
        next --;
    }
    
    float dur = idx/_scrollView.bounds.size.width;
    float _dur = fabsf(dur) ? fabsf(dur)*(MAXFONT/MINFONT-1)+1 : 1;
    float __dur = fabsf(dur) ? fabsf(1-dur)*(MAXFONT/MINFONT-1)+1 : 1;
    
    
    _select = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    _next = (UIButton *)[self viewWithTag:(next + 1) * 111];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    //_next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    //_select.titleLabel.layer.transform = CATransform3DMakeScale(__dur, __dur, __dur);
    
    _next.titleLabel.font = [UIFont systemFontOfSize:MINFONT*_dur];
    _select.titleLabel.font = [UIFont systemFontOfSize:MINFONT*__dur];
    
    [CATransaction commit];
    
    [_next setTitleColor:hllColor(222*dur, 53, 46, 1.0) forState:UIControlStateNormal];
    [_select setTitleColor:hllColor(222*(1.0-dur), 53, 46, 1.0) forState:UIControlStateNormal];
    //新春版
//    [_next setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*dur) forState:UIControlStateNormal];
//    [_select setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*(1 - dur)) forState:UIControlStateNormal];
}


@end


@interface NewAddFreeListViewController ()<UIScrollViewDelegate>
{
    FreeListTopView *listTopView;
    MarketListViewController *appListVC;
    MarketListViewController *gameListVC;

    SearchResult_DetailViewController *detailVC;
    
    FreeType freeType;
    UIScrollView * _scrollView;
    NSInteger beforeIndex;
    BOOL clickBtn;
}

@end





@implementation NewAddFreeListViewController

-(void)dealloc{
    appListVC.delegate = nil;
    gameListVC.delegate = nil;
    appListVC= nil;
    gameListVC = nil;
    
    listTopView = nil;
    detailVC = nil;
    _scrollView.delegate = nil;
    _scrollView = nil;
}

-(id)init{
    self = [super init];
   
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        if (IOS7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //游戏和应用两个按钮
        listTopView = [[FreeListTopView alloc] init];
        
        listTopView.gameBtn.tag = CLICK_GAME_BUTTON;
        listTopView.appBtn.tag = CLICK_APP_BUTTON;
        [listTopView.gameBtn addTarget:self action:@selector(changeViewshow:) forControlEvents:UIControlEventTouchUpInside];
        [listTopView.appBtn addTarget:self action:@selector(changeViewshow:) forControlEvents:UIControlEventTouchUpInside];
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
        
        appListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_NewAddFreeApp];
        //是否加入价格cell
        appListVC.isFreeCell = YES;
        appListVC.delegate = self;
        gameListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_NewAddFreeGame];
        gameListVC.isFreeCell = YES;
        gameListVC.delegate = self;


        [_scrollView addSubview:appListVC.view];
        [_scrollView addSubview:gameListVC.view];
        
        [self setViewFrame];
        
        [self changeViewshow:listTopView.appBtn];
        
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

}

#pragma mark - 返回
- (void)popMyView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)requestDataWithTag:(NSInteger)tag
{
    switch (tag) {
        case CLICK_APP_BUTTON:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [appListVC initRequest];
            });
        }
            break;
        case CLICK_GAME_BUTTON:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [gameListVC initRequest];
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
    _scrollView.contentSize = CGSizeMake(MainScreen_Width*2, screenHeight);
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    listTopView.frame = CGRectMake(0, 0, MainScreen_Width, 44);
    
    gameListVC.view.frame = CGRectMake(MainScreen_Width*1, 0, MainScreen_Width, _scrollView.frame.size.height);
    appListVC.view.frame = CGRectMake(0, 0, MainScreen_Width, gameListVC.view.frame.size.height);

    
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
        [appListVC removeListener];
        appListVC.delegate = nil;
        [gameListVC removeListener];
        gameListVC.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
