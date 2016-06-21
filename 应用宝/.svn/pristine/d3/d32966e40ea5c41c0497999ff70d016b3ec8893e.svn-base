//
//  ChargeFreeViewController.m
//  MyHelper
//
//  Created by mingzhi on 14/12/31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "ChargeFreeViewController.h"
#import "SimilarNavigationView.h"
#import "MyCollectionViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface ChargeFreeViewController () <MyServerRequestManagerDelegate>
{
    //UI
    SimilarNavigationView *myNaView;
    MyCollectionViewController *myCollectionView_app;
    MyCollectionViewController *myCollectionView_game;
    CollectionViewBack *backView;
    //数据
    CGFloat myNaviHeight;
    int appPage;
    int gamePage;
}
@end

#define MYNAVIHEIGHTER 210/2
#define MYNAVILOWER 64.0
#define LIMITETITLE @"限免金榜"
#define FREETITLE @"免费畅玩"
#define CHARGETITLE @"畅销金榜"
#define FUNCBTNTITLE @[@"应用",@"游戏"]
#define MZLEFTRIGHTBTNIMAGE @[@"nav_back"] //@[@"nav_back",@"nav_search"]

@implementation ChargeFreeViewController

+ (id)defaults{
    
    static ChargeFreeViewController * _chargeFreeViewController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _chargeFreeViewController = [ChargeFreeViewController new];
    });
    
    return _chargeFreeViewController;
}

- (void)dealloc
{
    [[MyServerRequestManager getManager] removeListener:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NavColor;
    
    
    //初始化
    _requestType = tagType_app;
    appPage = gamePage = 1;
    
    //导航View
    if (_listType == limiteCharge_App) {
        myNaviHeight = MYNAVILOWER;
        [self.myNaView setTitle:@"限免金榜" AndBtnTitleNameArray:nil];
    }else
    {
        myNaviHeight = MYNAVIHEIGHTER;
        [self.myNaView setTitle:(_listType==free_App?FREETITLE:CHARGETITLE) AndBtnTitleNameArray:FUNCBTNTITLE];
        [self.myNaView setBtnImage:MZLEFTRIGHTBTNIMAGE];
    }
    
    __weak ChargeFreeViewController* mySelf = self;
    [self.myNaView setnavigationViewBtnclickBlock:^(SimilarNavigationBtnType sender) {
        switch (sender) {
            case funcLeftBtn_tag:
            {
//                NSLog(@"功能左键");
                [self setAppViewshow:YES];
                if (![myCollectionView_app getCount]) [mySelf requestData:YES];
            }
                break;
                
            case funcRightBtn_tag:
            {
//                NSLog(@"功能右键");
                [self setAppViewshow:NO];
                if (![myCollectionView_game getCount]) [mySelf requestData:YES];
            }
                break;
                
            case leftBtn_tag:
            {
//                NSLog(@"导航左键");
                [mySelf.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            case rightBtn_tag:
            {
//                NSLog(@"导航右键");
//                SearchViewController *searchView = [[SearchViewController alloc] initWithSearchType:searchType_chosen];
//                [mySelf.navigationController pushViewController:searchView animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_SEARCHVIEW object:self];
            }
                break;
                
            default:
                break;
        }
    }];
    
    //列表刷新
    [self.myCollectionView_app setcollectionViewRequestBlock:^(BOOL hasdata) {
        if (!hasdata) appPage = 1;
        [mySelf requestData:hasdata];
    }];
    [self.myCollectionView_game setcollectionViewRequestBlock:^(BOOL hasdata) {
        if (!hasdata) gamePage = 1;
        [mySelf requestData:hasdata];
    }];
    
    //菊花
    backView = [CollectionViewBack new];
    backView.status = Loading;
    [backView setClickActionWithBlock:^{
        [mySelf requestData:NO];
    }];
    
    [self.view addSubview:self.myCollectionView_app.view];
    [self.view addSubview:self.myCollectionView_game.view];self.myCollectionView_game.view.hidden = YES;
    [self.view addSubview:backView];
    [self.view addSubview:self.myNaView];

}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    self.myNaView.frame = CGRectMake(0, 0, rect.size.width, myNaviHeight);
    self.myCollectionView_app.view.frame = self.myCollectionView_game.view.frame = rect;
    self.myCollectionView_app.myCollectionView.contentInset = self.myCollectionView_game.myCollectionView.contentInset = UIEdgeInsetsMake(myNaviHeight, 0, 0, 0);
    self.myCollectionView_app->_refreshHeader.inset = self.myCollectionView_game->_refreshHeader.inset = UIEdgeInsetsMake(myNaviHeight, 0, 0, 0);
    backView.frame = rect;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[MyServerRequestManager getManager] removeListener:self];
    if ([self.navigationController.viewControllers count] <= 1) {
        [self clearCache];
    }
}
#pragma mark - 视图
- (MyCollectionViewController *)myCollectionView_app{
    if (myCollectionView_app) return myCollectionView_app;
    
    myCollectionView_app = [MyCollectionViewController new];
    myCollectionView_app.parentVC = self;
    myCollectionView_app.collectionrequestType = tagType_app;
    return myCollectionView_app;
}
- (MyCollectionViewController *)myCollectionView_game{
    if (myCollectionView_game) return myCollectionView_game;
    
    myCollectionView_game = [MyCollectionViewController new];
    myCollectionView_game.parentVC = self;
    myCollectionView_game.collectionrequestType = tagType_game;
    return myCollectionView_game;
}
- (SimilarNavigationView *)myNaView{
    if (myNaView) return myNaView;
    
    myNaView = [SimilarNavigationView new];
    [myNaView setBtnImage:MZLEFTRIGHTBTNIMAGE];
    return myNaView;
}

- (void)setAppViewshow:(BOOL)bl
{
    _requestType = bl?tagType_app:tagType_game;
    self.myCollectionView_app.view.hidden = !bl;
    self.myCollectionView_game.view.hidden = bl;
    
    if (bl) {
        backView.status = [myCollectionView_app getCount] ? Hidden:Failed;
    }else
    {
        backView.status = [myCollectionView_game getCount] ? Hidden:Failed;
    }
}

#pragma mark - 清理缓存
- (void)clearCache{
    appPage = gamePage = 1;
    [self.myCollectionView_app setDataArray:nil];
    [self.myCollectionView_game setDataArray:nil];
}

#pragma mark - 请求数据
- (void)setListType:(MenuType)listType
{
    [self setAppViewshow:YES];
    
    //设置标题
    _listType = listType;
    self.myCollectionView_app.collectionlistType = self.myCollectionView_game.collectionlistType = listType;
    
    if (listType == limiteCharge_App) {
        if (myNaviHeight != MYNAVILOWER) {
            myNaviHeight = MYNAVILOWER;
            [self viewWillLayoutSubviews];
        }
        
        [self.myNaView setTitle:LIMITETITLE AndBtnTitleNameArray:nil];
    }else {
        if (myNaviHeight != MYNAVIHEIGHTER) {
            myNaviHeight = MYNAVIHEIGHTER;
            [self viewWillLayoutSubviews];
        }
        [self.myNaView setTitle:(_listType==free_App?FREETITLE:CHARGETITLE) AndBtnTitleNameArray:FUNCBTNTITLE];
    }
    
    //还原位置
    [self.myCollectionView_app.myCollectionView setContentOffset:CGPointMake(0, -myNaviHeight)];
    [self.myCollectionView_game.myCollectionView setContentOffset:CGPointMake(0, -myNaviHeight)];
    
    [self requestData:YES];
}

- (void)requestData:(BOOL)isUseCache
{
//    NSLog(@"限免/收/免费请求数据");
    
    if ((_requestType==tagType_app && [self.myCollectionView_app getCount]) || (_requestType==tagType_game && [self.myCollectionView_game getCount])) {
        //下拉\上拉不显示菊花
        backView.status = Hidden;
    }else
    {
        //backView.status = (_requestType==tagType_app?appPage:gamePage)==1?Loading:Hidden;
        backView.status = Loading;
    }
    
    [[MyServerRequestManager getManager] addListener:self];
    switch (_listType) {
        case limiteCharge_App:{
            [[MyServerRequestManager getManager] requestLimitFreeList:appPage isUseCache:isUseCache userData:self];
        }
            break;
        case free_App:{
            [[MyServerRequestManager getManager] requestFreeList:_requestType pageCount:(_requestType==tagType_app?appPage:gamePage) isUseCache:isUseCache userData:self];
        }
            break;
        case charge_App:{
            [[MyServerRequestManager getManager] requestPaidList:_requestType pageCount:(_requestType==tagType_app?appPage:gamePage) isUseCache:isUseCache userData:self];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 付费金榜应用/游戏列表
- (void)paidListRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataSuccess:dataDic TagType:tagType pageCount:pageCount isUseCache:isUseCache userData:userData];
}
- (void)paidListRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataFailed:tagType pageCount:pageCount isUseCache:isUseCache userData:userData];
}
#pragma mark - 免费畅玩应用/游戏列表
- (void)freeListRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataSuccess:dataDic TagType:tagType pageCount:pageCount isUseCache:isUseCache userData:userData];
}
- (void)freeListRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataFailed:tagType pageCount:pageCount isUseCache:isUseCache userData:userData];
}

#pragma mark - 限免APP
- (void)limitFreeRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataSuccess:dataDic TagType:tagType_app pageCount:pageCount isUseCache:isUseCache userData:userData];
}
- (void)limitFreeRequestFailed:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    [self dataFailed:tagType_app pageCount:pageCount isUseCache:isUseCache userData:userData];
}

#pragma mark - 数据成功失败处理
- (void)dataSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    //检测数据
    if (![[MyVerifyDataValid instance] verifySearchResultListData:dataDic]) {
//        NSLog(@"%i_%i数据有误",_listType,tagType);
        [self dataFailed:tagType pageCount:pageCount isUseCache:isUseCache userData:userData];
        return;
    }
    
    backView.status = Hidden;
    
    if (tagType == tagType_app) {
        //收费应用
        NSMutableArray *appArray = [dataDic objectForKey:@"data"];
        //下拉则先清除老数据
        self.myCollectionView_app->hasNextPage = [[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]?YES:NO;
        appPage+=([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]?1:0);
        
        if (self.myCollectionView_app->isLoading) {
            [self.myCollectionView_app setDataArray:nil];
            [self.myCollectionView_app endloading];
        }
        [self.myCollectionView_app setDataArray:appArray];
        
    }else if (tagType == tagType_game)
    {
        //收费游戏
        NSMutableArray *gameArray = [dataDic objectForKey:@"data"];
        //下拉则先清除老数据
        self.myCollectionView_game->hasNextPage = [[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]?YES:NO;
        gamePage+=([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]?1:0);
        
        if (self.myCollectionView_game->isLoading) {
            [self.myCollectionView_game setDataArray:nil];
            [self.myCollectionView_game endloading];
        }
        [self.myCollectionView_game setDataArray:gameArray];
        
    }
}

- (void)dataFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData
{
    if (tagType == tagType_app) {
        //免费应用
        if (self.myCollectionView_app->isLoading) {
            //下拉失败则保持老数据
            backView.status = Hidden;
            [self.myCollectionView_app endloading];
        }else{
            backView.status = pageCount==1?Failed:Hidden;
        }
        [self.myCollectionView_app freshLoadingCell:CollectionCellRequestStyleFailed];
    }else if (tagType == tagType_game)
    {
        //免费游戏
        if (self.myCollectionView_game->isLoading) {
            //下拉失败则保持老数据
            backView.status = Hidden;
            [self.myCollectionView_game endloading];
        }else{
            backView.status = pageCount==1?Failed:Hidden;
        }
        [self.myCollectionView_game freshLoadingCell:CollectionCellRequestStyleFailed];
    }
}


@end
