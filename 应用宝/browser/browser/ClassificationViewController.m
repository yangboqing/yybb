//
//  ClassificationViewController.m
//  MyHelper
//
//  Created by 李环宇 on 15-1-7.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "ClassificationViewController.h"
#import "PublicCollectionCell.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingCollectionCell.h"
#import "SearchViewController_my.h"
#import "SearchResult_DetailViewController.h"
#import "AppStatusManage.h"

@interface ClassificationViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,MyServerRequestManagerDelegate>{
    UICollectionView *myCollectionView;
    EGORefreshTableHeaderView * _refreshHeader;
    
    BOOL isLoading;
    BOOL result;
    BOOL hasNextData;
    BOOL HeaderBool;//失败加载页判断
    BOOL couldPullRefreshFlag; // 是否请求中
    int loadingCellHigh;

    NSInteger pageNumber;
    CollectionCellRequestStyle lastCellStyle;
    CollectionViewBack * _backView;
    int _appid;
    LoadingCollectionCell *_cell_loading;
    SearchType _type;
    SearchResult_DetailViewController *detailVC;//app详情页面
}

@end
static NSString *CellIdentifier_class = @"classPublicCollectionCell";
static NSString *cellLoadingIden_class = @"LoadingCollectionCell_class";
@implementation ClassificationViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        [[MyServerRequestManager getManager]addListener:self];
        HeaderBool=YES;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    result=YES;
    loadingCellHigh=0;

    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor orangeColor];
    addNavigationLeftBarButton(leftBarItem_backType, self, @selector(back));
//    addNavigationRightBarButton(rightBarItem_searchType, self, @selector(search));
//    self.title = @"分类详情";
    
    _dataArr=[[NSMutableArray alloc] init];
    [self initCollectionView];
    [self setCollectionViewFrame];

    _backView = [CollectionViewBack new];
    __weak typeof(self) mySelf = self;
    [_backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(refreshRequest) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:_backView];
    _backView.status = Loading;
//    [self refreshRequest];
    
    detailVC = [[SearchResult_DetailViewController alloc]init];
    detailVC.isPushByClassification = YES;

    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    }
- (void)search{
//    NSLog(@"lala");
    SearchViewController_my *searchView = [[SearchViewController_my alloc] initWithSearchType:_type];
    [self.navigationController pushViewController:searchView animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_SEARCHVIEW object:self];

}
//网络请求
- (void)requestData:(NSString*)categoryid apptype:(NSString *)type{
//    NSLog(@"requestData");
    _appid=[categoryid intValue];
    if ([type isEqualToString:@"tagType_app"]) {
        _type=searchType_app;
    }else{
        _type=searchType_game;
    }
    
    pageNumber=1;
    result=YES;
  [self initRequest];
//    NSLog(@"-----shouci");

}
//刷新请求
-(void)refreshRequest{
    pageNumber=1;
    couldPullRefreshFlag=NO;

    [self initRequest];
//    NSLog(@"----shuaxin");
}
-(void)initRequest{
//    NSLog(@"--0-0-0-0---%d,%d",_appid,pageNumber);
    if(result){
    [[MyServerRequestManager getManager] requestCategoryList:_appid pageCount:pageNumber isUseCache:YES userData:@"ClassificationViewController"];
        _cell_loading.hidden=NO;

    }
}
#pragma mark - MyServerRequestManagerDelegate
- (void)categoryListRequestSuccess:(NSDictionary *)dataDic categoryId:(NSInteger)categoryId pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData{
    if (![userData isEqualToString:@"ClassificationViewController"]) return;
    if (pageNumber==1) {
        [_dataArr removeAllObjects];

    }
    if ([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]) {
//        NSLog(@"y");
        result=YES;
        
    }else{
//        NSLog(@"n");
        result=NO;
        _cell_loading.hidden=YES;
        loadingCellHigh=44;
        [self setCollectionViewFrame];

    }

    
    NSArray*ary=[dataDic objectForKey:@"data"];
    if (ary.count<1&&pageNumber==1) {
        _backView.status = Failed;//无数据失败
        result=YES;

    }
//    NSLog(@"chenggong---%d,%d",ary.count,pageCount);

        _backView.status = Hidden;
    
    if (![[MyVerifyDataValid instance] verifySearchResultListData:dataDic]){
            _backView.status=Failed;
        result=YES;

        return;
    } // 数据有效性检测
    if ( ary.count>=1) {
        hasNextData=YES;
        [_dataArr addObjectsFromArray:ary];
    }else{
//        NSLog(@"就这些");
        // 上拉cell隐藏
    }
    
    // 下次请求页数+1
    pageNumber++;
    [myCollectionView reloadData];
    
    
}
- (void)categoryListRequestFailed:(NSInteger)categoryId pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData{
    if (![userData isEqualToString:@"ClassificationViewController"]) return;
//    NSLog(@"分类shibai");

    hasNextData=NO;
    if (HeaderBool&&pageNumber==1) {
        _backView.status = Failed;

    }
}


- (void)initCollectionView{
    
    //列表
    MyCollectionViewFlowLayout *flowLayout = [MyCollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    myCollectionView.backgroundColor = hllColor(242, 242, 242, 1);
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    myCollectionView.alwaysBounceVertical = YES;

    myCollectionView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [myCollectionView registerClass:[PublicCollectionCell class] forCellWithReuseIdentifier:CellIdentifier_class];
    [myCollectionView registerClass:[LoadingCollectionCell class] forCellWithReuseIdentifier:cellLoadingIden_class];
    [self.view addSubview:myCollectionView];
    
    
    _refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    _refreshHeader.egoDelegate = self;
    _refreshHeader.backgroundColor=[UIColor whiteColor];
    _refreshHeader.inset = myCollectionView.contentInset;
    [myCollectionView addSubview:_refreshHeader];
    
    
}
-(void)setCollectionViewFrame{
    myCollectionView.frame=CGRectMake(0, 64, MainScreen_Width, MainScreen_Height - 20+loadingCellHigh);
    _refreshHeader.frame = CGRectMake(0, -myCollectionView.frame.size.height-myCollectionView.contentInset.top, myCollectionView.frame.size.width, myCollectionView.frame.size.height);
    _backView.frame = self.view.bounds;
    

}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    //    CGFloat topHeight = (IOS7)?64:0;
    
}


#pragma mark - UICollectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArr.count>0) {
        return _dataArr.count+1;

    }
    return _dataArr.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

//    
    if (indexPath.row==_dataArr.count&&_dataArr.count>0) {
        
        _cell_loading = [collectionView dequeueReusableCellWithReuseIdentifier:cellLoadingIden_class forIndexPath:indexPath];
        _cell_loading.identifier = nil;
        
//        NSLog(@"classaa");
        if (self->hasNextData){
            lastCellStyle=CollectionCellRequestStyleLoading;

        }else{
            lastCellStyle=CollectionCellRequestStyleFailed;

        }
        
        [_cell_loading setStyle:lastCellStyle];
        _cell_loading.hidden=YES;

        [self initRequest];
//        NSLog(@"-----shangla");

        return _cell_loading;
        
    }
    
    PublicCollectionCell*cell=(PublicCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier_class forIndexPath:indexPath];
    cell.tag=203;

    if (_dataArr!=nil&&_dataArr.count>0) {
        NSString*str=[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
        cell.orderLabel.text=str;
        
        [cell setBottomLineLong:YES];
        //设置数据
        
        NSDictionary *showCellDic = [_dataArr objectAtIndex:indexPath.row];
        //设置属性
        cell.downLoadSource = HOME_PAGE_RECOMMEND_MY(indexPath.section, indexPath.row);
        [cell setCellData:showCellDic];
        [cell initDownloadButtonState];

    }

    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;

}

#pragma mark - UICollectionViewLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row<=_dataArr.count-1) {
        CGSize size = CGSizeMake(collectionView.frame.size.width,168/2*MULTIPLE);
        return size;
        
    }
    CGSize size = CGSizeMake(collectionView.frame.size.width,100/2*MULTIPLE);
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"ssss点击");
    if (indexPath.row!=_dataArr.count) {

    PublicCollectionCell *cell = (PublicCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *source =[NSString stringWithFormat:@"%d",_appid];
        
    if (SHOW_REAL_VIEW_FLAG&&!DIRECTLY_GO_APPSTORE) {
        [self pushToAppDetailViewWithAppInfor:_dataArr[indexPath.row] andSoure:CATEGORY_APP(source, (long)indexPath.row)];
    }else{
        [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:cell.appdigitalid];
    }
    
        

    
    
    //汇报点击
    [[ReportManage instance] reportAppDetailClick:CATEGORY_APP(source, (long)indexPath.row) contentDic:_dataArr[indexPath.row]];
    }
}


#pragma mark - UIScrollViewDelegate
BOOL _deceler_classification;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    
    CGFloat refreshHeight = self.view.frame.size.height+49; // 底部导航条的高度
    if (couldPullRefreshFlag&&scrollView.contentSize.height-scrollView.contentOffset.y < refreshHeight){
//        NSLog(@"lalala");
        [self initRequest];
        
        couldPullRefreshFlag=NO;
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _deceler_classification = YES;
    [_cell_loading setStyle:CollectionCellRequestStyleLoading];

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    if (!decelerate && !_deceler_classification) [self exposure]; _deceler_classification = NO;
    couldPullRefreshFlag=YES;
    if (!hasNextData&&!decelerate && !_deceler_classification) {
        [_cell_loading setStyle:CollectionCellRequestStyleFailed];
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_deceler_classification) {
        _deceler_classification = YES;
        [self exposure];
        if (!hasNextData) {
            [_cell_loading setStyle:CollectionCellRequestStyleFailed];
            
        }
    }
    


}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(myCollectionView.contentInset.top+65) && !self->isLoading) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - 下拉刷新

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    isLoading = YES;
        [self refreshRequest];
    HeaderBool=NO;
    [self performSelector:@selector(downRefreshRquest) withObject:nil afterDelay:delayTime];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return isLoading;
}

- (void)downRefreshRquest{
    self -> isLoading = NO;
    [_refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:myCollectionView];
}

#pragma mark - 推详情
- (void)pushToAppDetailViewWithAppInfor:(NSDictionary *)inforDic andSoure:(NSString *)source{
    [detailVC setAppSoure:source];
    [detailVC beginPrepareAppContent:inforDic];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 曝光
- (void)exposure
{
    NSArray *cellArray = [myCollectionView visibleCells];
    
    NSMutableArray *appIds = [NSMutableArray array];
    NSMutableArray *digitalIds = [NSMutableArray array];
    
    for (UICollectionViewCell *obj in cellArray) {
        if (obj.tag == 203) {
            PublicCollectionCell *cell = (PublicCollectionCell*)obj;
            [appIds addObject:cell.appID];
            [digitalIds addObject:cell.appdigitalid];
        }
    }
    long sourceIndex = -1;
    NSString *source =[NSString stringWithFormat:@"%d",_appid];
    [[ReportManage instance] reportAppBaoGuang:CATEGORY_APP(source, sourceIndex) appids:appIds digitalIds:digitalIds];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;

}
- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[MyServerRequestManager getManager]removeListener:self];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
