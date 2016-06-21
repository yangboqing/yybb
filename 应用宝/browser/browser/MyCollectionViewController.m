//
//  MyCollectionViewController.m
//  MyHelper
//
//  Created by mingzhi on 15/1/5.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "PublicCollectionCell.h"
#import "EGORefreshTableHeaderView.h"
#import "SearchResult_DetailViewController.h"
#import "AppStatusManage.h"

@interface MyCollectionViewController () <UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate>{
    NSMutableArray *_dataArray;
    SearchResult_DetailViewController *detailVC;//app详情页面

}
@end

@implementation MyCollectionViewController

- (void)dealloc
{
    _dataArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavColor;    
    
    //列表
    MyCollectionViewFlowLayout *flowLayout = [MyCollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    _myCollectionView.backgroundColor = hllColor(242, 242, 242, 1);
    _myCollectionView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [_myCollectionView registerClass:[PublicCollectionCell class] forCellWithReuseIdentifier:RECOMMENDAPPS];
    [_myCollectionView registerClass:[LoadingCollectionCell class] forCellWithReuseIdentifier:MORECELL];
    
    //下拉刷新
    _refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    _refreshHeader.backgroundColor = [UIColor whiteColor];
    _refreshHeader.egoDelegate = self;
    //_refreshHeader.inset = _myCollectionView.contentInset;
    [_myCollectionView addSubview:_refreshHeader];
    
    [self.view addSubview:_myCollectionView];
    
    detailVC = [[SearchResult_DetailViewController alloc]init];

    
}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    _myCollectionView.frame = rect;
    _refreshHeader.frame = CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 设置数据
- (void)setcollectionViewRequestBlock:(CollectionViewRequestBlock)block
{
    collectionViewRequestBlock = block;
}
- (void)requestData:(NSNumber *)num
{
    BOOL hasdata = [num boolValue];
    if (!isRequesting) {
        [self freshLoadingCell:CollectionCellRequestStyleLoading];
        if (collectionViewRequestBlock) {
            collectionViewRequestBlock(hasdata);
        }
        isRequesting = YES;
    }
    
}

- (NSInteger)getCount
{
    return self._dataArray.count;
}

- (NSMutableArray *)_dataArray
{
    if (_dataArray) return _dataArray;
    
    _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    isRequesting = NO;
    if (!dataArray) {
        [self._dataArray removeAllObjects];
        [_myCollectionView reloadData];
        return;
    }
//    NSUInteger index = self._dataArray.count;
    [self._dataArray addObjectsFromArray:dataArray];
    
//    if (self._dataArray.count != index && index){
//        NSMutableArray * array  = [NSMutableArray array];
//        for (NSUInteger i=index; i<self._dataArray.count; i++) {
//            [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        [_myCollectionView insertItemsAtIndexPaths:array];
//        [CATransaction commit];
//    }else{
//        
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        [_myCollectionView reloadData];
//        [CATransaction commit];
//    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_myCollectionView reloadData];
    [CATransaction commit];
}

#pragma mark - UICollectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self->hasNextPage?self._dataArray.count+1:self._dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self._dataArray.count){
        LoadingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MORECELL forIndexPath:indexPath];
        
        
        if (self->_isFailed){
            cell.style = CollectionCellRequestStyleFailed;
        }else{
            cell.style = CollectionCellRequestStyleLoading;
        }
        
//        if (self->_isFailed){
//            [cell.upRefresh stopGif];
//        }else{
//            if (self->_isHaseData) {
//                [cell.upRefresh startGif];
//            }else
//            {
//                [cell.upRefresh hasNotData];
//            }
//        }
//        [self requestData:[NSNumber numberWithBool:YES]];
        
        return cell;
    }
    
    PublicCollectionCell *cell = (PublicCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RECOMMENDAPPS forIndexPath:indexPath];
    [cell setBottomLineLong:NO];
    
    //设置数据
    NSDictionary *showCellDic = [self._dataArray objectAtIndex:indexPath.row];
    //设置属性
    cell.downLoadSource = HOME_PAGE_RECOMMEND_MY(indexPath.section, indexPath.row);
    [cell setCellData:showCellDic];
    [cell initDownloadButtonState];
    
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = indexPath.row == self._dataArray.count?CGSizeMake(collectionView.frame.size.width, 44):CGSizeMake(collectionView.frame.size.width, 168/2*MULTIPLE);
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[LoadingCollectionCell class]]) {
        return;
    }
    //cell
    PublicCollectionCell *cell = (PublicCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //上报点击
    
    [[ReportManage instance] reportAppDetailClick:[self getcolorm:indexPath.row] contentDic:cell.cellDataDic];
    if (SHOW_REAL_VIEW_FLAG&&!DIRECTLY_GO_APPSTORE) {
        [self pushToAppDetailViewWithAppInfor:cell.cellDataDic andSoure:@"my_collection"];
    }else{
        [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:cell.appdigitalid];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (NSString *)getcolorm:(NSInteger)index
{
    NSString *colorm;
    if (!colorm) colorm = [NSString string];
    switch (_collectionlistType) {
        case limiteCharge_App:
            colorm = LIMITFREE_APP((long)index);
            break;
            
        case free_App:
            colorm = _collectionrequestType==tagType_app?FREE_APP((long)index):FREE_GAME((long)index);
            break;
            
        case charge_App:
            colorm = _collectionrequestType==tagType_app?PAID_APP((long)index):PAID_GAME((long)index);
            break;
            
        default:
            break;
    }
    return colorm;
}

#pragma mark - scrollViewDelegate
BOOL _deceler_myCollection;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //下拉刷新
    [_refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    
    if (isRequesting || isLoading || !hasNextPage) return;
    
    if (!scrollView.contentSize.height) return;
    
    //上拉刷新
    //NSLog(@"%f  \n%f",scrollView.contentOffset.y+MainScreen_Height,scrollView.contentSize.height-BOTTOM_HEIGHT);
    if (scrollView.contentOffset.y+MainScreen_Height - 20 >= scrollView.contentSize.height-BOTTOM_HEIGHT){
        
        [self performSelector:@selector(requestData:) withObject:[NSNumber numberWithBool:YES] afterDelay:0];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    if (!decelerate && !_deceler_myCollection) [self baoguang]; _deceler_myCollection = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    self -> isLoading = YES;
    [self requestData:[NSNumber numberWithBool:NO]];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return self -> isLoading;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //NSLog(@"-=-=^^%f   %f",scrollView.contentOffset.y,_collectionView.contentInset.top+60);
    if (scrollView.contentOffset.y<-(scrollView.contentInset.top+60+5)  && !self->isLoading ) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

//还原
- (void)endloading{
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}
- (void)refresh
{
//    NSLog(@"下拉还原");
    self -> isLoading = NO;
    isRequesting = NO;
    [_refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:_myCollectionView];
}
- (void)freshLoadingCell:(CollectionCellRequestStyle)state
{
    if (state==CollectionCellRequestStyleFailed) {
        isRequesting = NO;
    }
    [_myCollectionView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LoadingCollectionCell class]]){
            *stop = YES;
            LoadingCollectionCell * cell = obj;
            cell.style = state;
        }
    }];
}

#pragma mark - 曝光
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _deceler_myCollection = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.view.hidden) return;
    [self baoguang];
}
- (void)baoguang{
    
    NSMutableArray *appidArray;
    NSMutableArray *appdigidArray;
    if (!appidArray) appidArray = [NSMutableArray array];
    if (!appdigidArray) appdigidArray = [NSMutableArray array];
    
    for (id cell in self.myCollectionView.visibleCells) {
        if ([cell isKindOfClass:[PublicCollectionCell class]]) {
            PublicCollectionCell *tmpCell = cell;
            [appidArray addObject:tmpCell.appID];
            [appdigidArray addObject:tmpCell.appdigitalid];
        }
    }
    
    [[ReportManage instance] reportAppBaoGuang:[self getcolorm:-1] appids:appidArray digitalIds:appdigidArray];
}

#pragma mark - 推详情
- (void)pushToAppDetailViewWithAppInfor:(NSDictionary *)inforDic andSoure:(NSString *)source{
    [detailVC setAppSoure:source];
    [detailVC beginPrepareAppContent:inforDic];
    [self.parentVC.navigationController pushViewController:detailVC animated:YES];
}
@end
