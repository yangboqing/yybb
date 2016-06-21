//
//  WallPaperListViewController.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperListViewController.h"
#import "WallPaperCell.h"
#import "WallpaperInfoViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "CollectionViewBack.h"
#import "CustomNavigationBar.h"
#import "AlertLabel.h"
#import "SDImageCache.h"


#define HWSCALE 1.775

static NSString *headerViewIden = @"HeaderViewIdentifier";
static NSString *footViewIden = @"FooterViewIdentifier";

@interface WallPaperListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate,DesktopviewManageDelegate,wallpaperInfoCollectDelegate>
{
    CGFloat topHeigt;// 分类二级页面兼容
    CGFloat cellWidth;
    CGFloat cellHeight;
    BOOL classifyFlag;
    
    // 上拉刷新
    BOOL hasMoreData; // 控制显示行数
    BOOL upwardPullCouldRequest; // 控制上拉是否能发送请求
    NSString *nextUrlStr;
    NSString *firstUrlStr;
    NSString *lastReqUrlStr;
    
    BOOL scrollEndFlag;
    BOOL upwardPullRequestFailed;
    
    // 下拉刷新
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL isLoading;
    
    WallPaperCellStyle loadingCellStyle;
    UIImage *defaultImage;
    
    CollectionViewBack *backView;
    AlertLabel *alertLabel; // 下拉刷新失败
    
    DesktopViewDataManage *desktopDataManage;
  }

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation WallPaperListViewController

- (id)initWithLeftType:(LeftBarButtonType)type
{
    self = [super init];
    if (self) {
        if (type == wallPaper_back) {
            addNavigationLeftBarButton(leftBarItem_backType, self, @selector(back));
        }
        else if (type ==wallPaper_presentClassfyView )
        {
            addNavigationLeftBarButton(leftBarITem_pop, self, @selector(pop));
            addNavigationRightBarButton(rightBarItem_categoryIconType, self, @selector(presentClassfyWallPaper));
        }
        NSMutableArray *items = [NSMutableArray array];
        self.itemArray = items;
        _type = type;
    }
    return self;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWallPaperList:(NSString *)urlStr dataManage:(DesktopViewDataManage *)dataManage AndTitle:(NSString *)title
{
        if (dataManage) {
            //分类->list
            classifyFlag = YES;
            topHeigt = (IOS7)?64:0;
            firstUrlStr = urlStr;
            desktopDataManage = dataManage;
            self.title = title;
        }
        else
        {// 首页list
            classifyFlag = NO;
            topHeigt = (IOS7)?68:0;
            firstUrlStr = nil;
            //
            desktopDataManage = [[DesktopViewDataManage alloc] init];
            desktopDataManage.delegate = self;
            [desktopDataManage requestMainData];
        }
    
}

#pragma mark - Utility

-(void)setDisplayValuesByData:(NSArray *)data withUserData:(NSString *)userData
{
    if ([userData isEqualToString:@"pulldownRefreshRequest"]) {
        // 下拉刷新数据请求成功、清理数据
        [self.itemArray removeAllObjects];
    }
    [self.itemArray addObjectsFromArray:data];
    [self.collectionView reloadData];
}

-(void)scrollToIndex:(NSInteger)index byData:(NSMutableArray *)items nextPageUrl:(NSString *)pageUrl lastReqUrl:(NSString *)lastUrl
{
    self.itemArray = [items mutableCopy];
    lastReqUrlStr = lastUrl;
    nextUrlStr = pageUrl;
    if (pageUrl == nil) {
        hasMoreData = NO;
    }
    
    // 刷新CollectionView
    [self.collectionView reloadData];
    
    // 滚动到指定的位置
    if (index >= _itemArray.count || index < 6) {
        return ;
    }
    index = index-3; // 滚动到中间位置
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

-(void)hideDownPullAnimation
{
    isLoading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
}

-(void)hideToolBar:(BOOL)hideFlag
{
    self.navigationController.navigationBar.hidden = hideFlag;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:(hideFlag?@"yes":nil)]; // 底端bottomBar
}

-(void)showWallPaperCellStyle:(WallPaperCellStyle)style
{
    loadingCellStyle = style;
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

-(void)showBackViewStatus:(Request_status)status
{
    switch (status) {
        case Loading:
        {
            backView.status = Loading;
        }
            break;
        case Failed:
        {
            backView.status = Failed;
        }
            break;
        case Hidden:
        {
            backView.status = Hidden;
        }
            break;
            
        default:
            break;
    }
}

-(void)showDownRefreshFailedLabel
{
    CGFloat originY = (IOS7)?64:44;
    if (classifyFlag) {
        originY = (IOS7)?64:0;
    }
    
    [alertLabel startAnimationFromOriginY:originY];
}

-(void)showWallPaperInfoAtIndex:(NSInteger)index nextPageUrl:(NSString*)nextPageUrl form:(NSString *)source
{
    WallpaperInfoViewController *wallPaperInfoVC = [[WallpaperInfoViewController alloc] init];
    wallPaperInfoVC.delegate = self;
    [wallPaperInfoVC setCollectItems:[_itemArray mutableCopy] currentItme:index prevAddress:nil nextAddress:nextPageUrl from:source];
    [self.navigationController pushViewController:wallPaperInfoVC animated:NO];
    
    // 隐藏UINavigationBar、BottomToolBar
    [self hideToolBar:YES];
    
    // 汇报日志
    [[ReportManage instance] reportWallPaperClick:source ImageUrl:[_itemArray[index] objectForKey:@"big"]];
}

-(void)popWallPaperListViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkWallPaperDataValidity:(NSDictionary *)data
{
    BOOL valid = YES;
    
    NSDictionary *urlDic = [data getNSDictionaryObjectForKey:@"link"];
    if (urlDic) {
        NSArray *keys = urlDic.allKeys;
        if (!keys ||
            ![keys containsObject:@"next"] ||
            ![keys containsObject:@"prev"]) {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    
    //
    NSArray *picArr = [data getNSArrayObjectForKey:@"data"];
    if (picArr) {
        for (NSDictionary *picDic in picArr) {
            if (IS_NSDICTIONARY(picDic) &&
                [picDic getNSStringObjectForKey:@"big"] &&
                [picDic getNSStringObjectForKey:@"small"] &&
                [picDic getNSStringObjectForKey:@"down_stat"]) {
                continue;
            }
            else
            {
                valid = NO;
                break;
            }
        }
    }
    else
    {
        valid = NO;
    }
    
    return valid;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (hasMoreData) {
        return 2;
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (section==0)?_itemArray.count:1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        WallPaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIden forIndexPath:indexPath];
        [cell setStyle:WallPaperCellStyleDefault];
        
        NSDictionary *infoDic = _itemArray[indexPath.row];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"small"]] placeholderImage:defaultImage];
        
        return cell;
    }
    
    //
    WallPaperCell *loadingCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellLoadingIden forIndexPath:indexPath];
    [loadingCell setStyle:loadingCellStyle];
    return loadingCell;
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden forIndexPath:indexPath];
        return headerView;
    }
    
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewIden forIndexPath:indexPath];
    return footerView;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *smallUrlStr = [_itemArray[indexPath.row] objectForKey:@"small"];
        if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallUrlStr]) {
            [self showWallPaperInfoAtIndex:indexPath.row nextPageUrl:nextUrlStr form:(classifyFlag?self.navigationItem.title:@"推荐")];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    if (section == 0) {
        size = CGSizeMake(_collectionView.frame.size.width, topHeigt);
    }
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;

    if (hasMoreData && section == 1) {
        size =  CGSizeMake(_collectionView.frame.size.width-12, 20+4.0);
    }
    else if (!hasMoreData && section==0)
    {
    size =  CGSizeMake(_collectionView.frame.size.width-12, 4.0);
    }
    
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(cellWidth, cellHeight);
    if (indexPath.section == 1) {
        size = CGSizeMake(_collectionView.frame.size.width-12, 15);
    }
    
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(4, 6, 0, 6);
    
    if (section == 1) {
        edgeInset = UIEdgeInsetsMake(0, 6, 0, 6);
    }
    return edgeInset;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

#pragma mark - wallpaperInfoCollectDelegate

-(void)notifitionInterfaceReloadArray:(NSMutableArray *)array current:(NSUInteger)index nextUrlAdress:(NSString *)next lastRequest:(NSString *)str
{
    BOOL latestFlag = YES;
    for (UIViewController *viewController in _navigationController.viewControllers) {
        if ([viewController isMemberOfClass:[WallPaperListViewController class]]) {
            [self scrollToIndex:index byData:array nextPageUrl:next lastReqUrl:str];
            latestFlag = NO;
            break;
        }
    }
    
    if (latestFlag) {
        [self scrollToIndex:index byData:array nextPageUrl:next lastReqUrl:str];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    if(IOS7){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self hideToolBar:NO];
}

#pragma mark - UIScollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    // hasMoreData:是否有下一页数据；upwardPullCouldRequest:collectionView滚动到底部再展示失败；lastReqUrl
    CGFloat offset = scrollView.contentSize.height-scrollView.contentOffset.y;
    if (hasMoreData && upwardPullCouldRequest &&offset < MainScreeFrame.size.height+40+((_type == wallPaper_back)?49:0)) {
        upwardPullCouldRequest = NO;
        upwardPullRequestFailed = NO;
        scrollEndFlag = NO;
        [self requestNextPageData];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.y<-(_collectionView.contentInset.top+65)) {
        *targetContentOffset = scrollView.contentOffset;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!decelerate) {
        scrollEndFlag = YES;
        if (upwardPullRequestFailed) {
            upwardPullRequestFailed = NO;
            
            upwardPullCouldRequest = YES;
            [self showWallPaperCellStyle:WallPaperCellStyleRequestFailed];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollEndFlag = YES;
    if (upwardPullRequestFailed) {
        upwardPullRequestFailed = NO;
        
        upwardPullCouldRequest = YES;
        [self showWallPaperCellStyle:WallPaperCellStyleRequestFailed];
    }
}

#pragma mark - EGORefreshTableHeaderViewDelegate

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self performSelector:@selector(requestIndexPageData) withObject:nil afterDelay:delayTime];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isLoading;
}

#pragma mark - DesktopViewDataManageDelegate

-(void)requestRecommendSucess:(NSDictionary *)saveDic requestStr:(NSString *)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if ([self checkWallPaperDataValidity:saveDic]) {
        
        if (classifyFlag && [userData isEqualToString:@"FirstRequest"] && ![firstUrlStr isEqualToString:requestStr]) {
            return ;
        }
        
        // 是否有下一页数据
        nextUrlStr = [[saveDic objectForKey:@"link"] objectForKey:@"next"];
        if (nextUrlStr.length > 0) {
            hasMoreData = YES;
            upwardPullCouldRequest = YES;
        }
        else
        {
            hasMoreData = NO;
            upwardPullCouldRequest = NO;
        }
        
        // UI
        if (![requestStr isEqualToString:lastReqUrlStr]) {
            [self setDisplayValuesByData:[saveDic objectForKey:@"data"] withUserData:userData];
            lastReqUrlStr = requestStr; // 防止重复数据
        }
        
        [self showBackViewStatus:Hidden];
    }
    else
    {
        // 首页首次请求失败
        if (nextUrlStr == nil) {
            hasMoreData = YES;
            [desktopDataManage requestMainData];
        }
        
        if ([userData isEqualToString:@"FirstRequest"]) {
            hasMoreData = YES;
            [self showBackViewStatus:Failed];
            return ;
        }
        
        // 上拉刷新失败
        upwardPullRequestFailed = YES;
        if (scrollEndFlag) {
            scrollEndFlag = NO;
            
            upwardPullCouldRequest = YES;
            [self showWallPaperCellStyle:WallPaperCellStyleRequestFailed];
        }
    }
    
}

-(void)requestRecommendFail:(NSString *)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData
{
    // 首页首次请求失败
    if (nextUrlStr == nil) {
        hasMoreData = YES;
        [desktopDataManage requestMainData];
    }
    
    if ([userData isEqualToString:@"FirstRequest"]) {
        hasMoreData = YES;
        [self showBackViewStatus:Failed];
        return ;
    }
    
    // 上拉刷新失败
    upwardPullRequestFailed = YES;
    if (scrollEndFlag) {
        scrollEndFlag = NO;
        
        upwardPullCouldRequest = YES;
        [self showWallPaperCellStyle:WallPaperCellStyleRequestFailed];
    }
    
    // 提示下拉刷新失败
    if ([userData isEqualToString:@"pulldownRefreshRequest"]) {
//        [self showDownRefreshFailedLabel];
    }
}

#pragma mark - Request Methods

-(void)initRequest
{
    [self showBackViewStatus:Loading];
    
    nextUrlStr = nil;
    lastReqUrlStr = @"initTap";
    desktopDataManage.delegate = self;
    [desktopDataManage requestRecommend:firstUrlStr isUseCache:YES userData:@"FirstRequest"];
}

-(void)requestIndexPageData
{
    nextUrlStr = nil;
    lastReqUrlStr = @"pullDownUrl";
    desktopDataManage.delegate = self;
    [desktopDataManage requestRecommend:firstUrlStr isUseCache:NO userData:@"pulldownRefreshRequest"];
    
    [self hideDownPullAnimation];
}

-(void)requestNextPageData
{
    desktopDataManage.delegate = self;
    [desktopDataManage requestRecommend:nextUrlStr isUseCache:YES userData:nil];
    
    [self showWallPaperCellStyle:WallPaperCellStyleRequestLoading];
}

#pragma mark - Life Cycle

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)presentClassfyWallPaper
{
//    NSLog(@"push 分类");
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentToClassifyView)]) {
        [self.delegate presentToClassifyView];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    defaultImage = [UIImage imageNamed:@"defaultImg.png"];
    cellWidth = (MainScreen_Width-20)/3;
    cellHeight = cellWidth*HWSCALE;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[WallPaperCell class] forCellWithReuseIdentifier:cellReuseIden];
    [collectionView registerClass:[WallPaperCell class] forCellWithReuseIdentifier:cellLoadingIden];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewIden];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // EGORefreshTableHeaderView
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] init];
    refreshHeaderView.egoDelegate = self;
    [self.collectionView addSubview:refreshHeaderView];
    
    // loading view
    backView = [[CollectionViewBack alloc] init];
    backView.status = Loading;
    __weak typeof(self) mySelf = self;
    [backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(initRequest) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:backView];
    
    alertLabel = [[AlertLabel alloc] init];
    [self.view addSubview:alertLabel];
    
    // 请求数据
    if (classifyFlag) {
        [self initRequest];
    }
}

-(void)setDataArr:(NSArray *)arr
{
    _itemArray = [NSMutableArray arrayWithArray:arr];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!classifyFlag) {
        self.title = @"壁纸";
    }
}

-(void)viewWillLayoutSubviews
{
    CGRect frame = self.view.frame;
    self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height+0);
    refreshHeaderView.frame = CGRectMake(0, -_collectionView.frame.size.height+topHeigt, _collectionView.frame.size.width, _collectionView.frame.size.height);
    backView.frame = _collectionView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.itemArray = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.collectionView = nil;
}

@end
