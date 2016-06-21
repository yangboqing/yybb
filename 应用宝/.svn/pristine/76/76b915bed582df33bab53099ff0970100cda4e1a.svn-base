//
//  FindViewController.m
//  browser
//
//  Created by liguiyang on 14-10-30.
//
//

#import "FindViewController.h"
#import "Find_top_bar.h"
#import "FindListViewController.h"

@interface FindViewController ()<FindListViewDelegate,UIScrollViewDelegate>
{
    Find_top_bar *findNavBar;
    FindListViewController *findChoiceListVC;
    FindListViewController *findEvaluateListVC;
    FindListViewController *findInformationListVC;
    FindListViewController *findApplePieListVC;
    UIScrollView *gbScrollView;
}


@end

@implementation FindViewController


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [findNavBar setFind_top_barDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    findNavBar.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate){
        //scrollView.scrollEnabled = NO;
    }else{
        findNavBar.userInteractionEnabled = YES;
    }
}

int _curDiscoveryLunboIndex = 3; // 3: 发现精选，-1：无 // 0: 市场精选，1：应用，2：游戏，3：发现精选，-1：无
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //scrollView.scrollEnabled = YES;
    
    findNavBar.userInteractionEnabled = YES;
    if (scrollView.contentOffset.x/scrollView.bounds.size.width >0 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 1){
        _curDiscoveryLunboIndex= -1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{ // 评测
            [findEvaluateListVC initilizationRequest];
        });
    }else if (scrollView.contentOffset.x/scrollView.bounds.size.width >1 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 2){
        _curDiscoveryLunboIndex = -1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{ // 资讯
            [findInformationListVC initilizationRequest];
        });
    }
    else if (scrollView.contentOffset.x/scrollView.bounds.size.width >2 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 3)
    {
        _curDiscoveryLunboIndex = -1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{ // 苹果派
            [findApplePieListVC initilizationRequest];
        });
    }
    else
    {
        _curDiscoveryLunboIndex = 3; // 发现精选
    }
}

#pragma mark - FindListViewDelegate

-(void)findNavControllerPushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
    findNavBar.hidden = YES;
}

#pragma mark - Request

-(void)initilizationChoiceRequest
{
    [findChoiceListVC initilizationRequest];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // scrollView
    gbScrollView = [[UIScrollView alloc] init];
    gbScrollView.pagingEnabled = YES;
    gbScrollView.bounces = NO;
    gbScrollView.directionalLockEnabled = YES;
    gbScrollView.showsVerticalScrollIndicator = NO;
    gbScrollView.showsHorizontalScrollIndicator = NO;
    gbScrollView.backgroundColor = [UIColor blackColor];
    gbScrollView.delegate = self;
    
    // 精选、评测、资讯、苹果派
    findChoiceListVC = [[FindListViewController alloc] initWithFindColumnType:findColumn_choiceType];
    findChoiceListVC.delegate = self;
    findEvaluateListVC = [[FindListViewController alloc] initWithFindColumnType:findColumn_evaluateType];
    findEvaluateListVC.delegate = self;
    findInformationListVC = [[FindListViewController alloc] initWithFindColumnType:findColumn_informationType];
    findInformationListVC.delegate = self;
    findApplePieListVC = [[FindListViewController alloc] initWithFindColumnType:findColumn_applePieType];
    findApplePieListVC.delegate = self;
    
    [gbScrollView addSubview:findChoiceListVC.view];
    [gbScrollView addSubview:findEvaluateListVC.view];
    [gbScrollView addSubview:findInformationListVC.view];
    [gbScrollView addSubview:findApplePieListVC.view];
    [self.view addSubview:gbScrollView];
    
    // CustomNavigationBar
    __weak UIScrollView *__scrollView = gbScrollView;
    __weak id mySelf = self;
    findNavBar =  [[Find_top_bar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    
    //新春版
//    if(IOS7){
//        [self.navigationController.navigationBar setBarTintColor:NEWYEAR_RED];
//    }
    [findNavBar setFind_top_barClickWithBlock:^(NSInteger index) {
        if (index < 4) {
            [__scrollView setContentOffset:CGPointMake(__scrollView.bounds.size.width*index, 0) animated:NO];
            [mySelf scrollViewDidEndDecelerating:__scrollView];
        }
    }];
    [self.navigationController.navigationBar addSubview:findNavBar];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 发现导航栏 显示
    findNavBar.hidden = NO;
    
    // 浏览过的显示灰色
    [findChoiceListVC viewWillAppear:animated];
    [findEvaluateListVC viewWillAppear:animated];
    [findInformationListVC viewWillAppear:animated];
    [findApplePieListVC viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    findChoiceListVC.view.frame = CGRectMake(0, 0, width, height);
    findEvaluateListVC.view.frame = CGRectMake(width, 0, width, height);
    findInformationListVC.view.frame = CGRectMake(width*2, 0, width, height);
    findApplePieListVC.view.frame = CGRectMake(width*3, 0, width, height);
    
    gbScrollView.frame = self.view.frame;
    gbScrollView.contentSize = CGSizeMake(width*4, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
