//
//  FindViewController.m
//  browser
//
//  Created by liguiyang on 14-10-30.
//
//

#import "FindViewController_my.h"
#import "FindListViewController_my.h"
#import "SimilarNavigationView.h"
#import "MyServerRequestManager.h"

@interface FindViewController_my ()<FindListViewDelegate,UIScrollViewDelegate>
{
    FindListViewController_my *findChoiceListVC;
    FindListViewController_my *findEvaluateListVC;
    FindListViewController_my *findInformationListVC;
    UIScrollView *gbScrollView;
    SimilarNavigationView *myNaView;
    BOOL firsZixun;
    BOOL firstPingce;
    BOOL firstPingguo;
    BOOL firstHuodong;
}


@end

#define FINDTITLE @"应用资讯"

#define FUNCBTNTITLE @[@"资讯", @"评测", @"活动"]

@implementation FindViewController_my


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (decelerate){
        scrollView.scrollEnabled = NO;
    }else{
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = YES;
    if (scrollView.contentOffset.x/scrollView.bounds.size.width >0 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 1){
        [myNaView btnImage:new_tag];
        
        if (firstPingce) {
            firstPingce=NO;
            [findEvaluateListVC initilizationRequest];

        }

    }
    else if (scrollView.contentOffset.x/scrollView.bounds.size.width >1 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 2){
        [myNaView btnImage:top_tag];
        if (firstHuodong) {
            firstHuodong=NO;
            [findChoiceListVC initilizationRequest];
        }
    }
   else{
        [myNaView btnImage:good_tag];

    }
}

#pragma mark - FindListViewDelegate

-(void)findNavControllerPushViewController:(UIViewController *)viewController
{

}

#pragma mark - Request

-(void)initilizationChoiceRequest
{
    [findInformationListVC initilizationRequest];
}

#pragma mark - Utility

- (SimilarNavigationView *)myNaView{
    if (myNaView) return myNaView;
    
    myNaView = [SimilarNavigationView new];
    [myNaView initFindBtn];
    
    return myNaView;
}

- (void)removeAllListeners
{// 移除监听
    [findChoiceListVC removeListener];
    [findEvaluateListVC removeListener];
    [findInformationListVC removeListener];
    
    [myNaView setnavigationViewBtnclickBlock:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    firsZixun=YES;
    firstPingce=YES;
    firstHuodong=YES;
    
    

    
    gbScrollView = [[UIScrollView alloc] init];
    gbScrollView.pagingEnabled = YES;
    gbScrollView.scrollEnabled=YES;
    gbScrollView.bounces = NO;
    gbScrollView.directionalLockEnabled = YES;
    gbScrollView.showsVerticalScrollIndicator = NO;
    gbScrollView.showsHorizontalScrollIndicator = NO;
    gbScrollView.backgroundColor = [UIColor whiteColor];
    gbScrollView.delegate = self;
    
    // 精选、评测、资讯、苹果派
    findInformationListVC = [[FindListViewController_my alloc] initWithFindColumnType:findColumn_informationType];
    findInformationListVC.delegate = self;
   findEvaluateListVC= [[FindListViewController_my alloc] initWithFindColumnType:findColumn_evaluateType];
   findEvaluateListVC.delegate = self;
    findChoiceListVC= [[FindListViewController_my alloc] initWithFindColumnType:findColumn_activityType];
    findChoiceListVC.delegate = self;
  
 
    [gbScrollView addSubview:findInformationListVC.view];
    [gbScrollView addSubview:findEvaluateListVC.view];
    [gbScrollView addSubview: findChoiceListVC.view];
    [self.view addSubview:gbScrollView];
    
    [self.myNaView setTitle:(FINDTITLE) AndBtnTitleNameArray:FUNCBTNTITLE];
    [self.myNaView setnavigationViewBtnclickBlock:^(SimilarNavigationBtnType sender) {
        switch (sender) {
            case funcLeftBtn_tag:
            {
                //                NSLog(@"功能左键");
                gbScrollView.contentOffset=CGPointMake(0, 0);
                
            }
                break;
                
            case funcRightBtn_tag:
            {
                //                NSLog(@"功能右键");
                gbScrollView.contentOffset=CGPointMake(gbScrollView.bounds.size.width, 0);
                if (firstPingce) {
                    firstPingce=NO;
                    [findEvaluateListVC initilizationRequest];
                    
                }

                
            }
                break;
                
            case funcThirdBtn_tag:
            {
                //                NSLog(@"功能三键");
                gbScrollView.contentOffset=CGPointMake(gbScrollView.bounds.size.width*2, 0);
                if (firstHuodong) {
                    firstHuodong=NO;
                    [findChoiceListVC initilizationRequest];
                    
                }
                

            }
                break;
                
            case leftBtn_tag:
                //                NSLog(@"导航左键");
//                [self ClassificationButton];
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            case rightBtn_tag:
//                [self pushSearchClass];
                //                NSLog(@"导航右键");
                break;
                
            default:
                break;
        }
    }];
    
    [self.view addSubview:self.myNaView];
    [self initilizationChoiceRequest];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 发现导航栏 显示
//    findNavBar.hidden = NO;

    // 浏览过的显示灰色
    [findChoiceListVC viewDidAppear:animated];
    [findEvaluateListVC viewDidAppear:animated];
    [findInformationListVC viewDidAppear:animated];
    
    if (IOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    CGRect rect = self.view.bounds;
    myNaView.frame = CGRectMake(0, 0, rect.size.width, 210/2+2);

   findInformationListVC.view.frame = CGRectMake(0, 0, width, height);
  findEvaluateListVC.view.frame = CGRectMake(width, 0, width, height);
   findChoiceListVC.view.frame = CGRectMake(width*2, 0, width, height);
    
    gbScrollView.frame = self.view.frame;
    gbScrollView.contentSize = CGSizeMake(width*3, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeAllListeners];
    findChoiceListVC.delegate = nil;
    findChoiceListVC = nil;
    findEvaluateListVC.delegate = nil;
    findEvaluateListVC = nil;
    findInformationListVC.delegate = nil;
    findInformationListVC = nil;
    
    gbScrollView.delegate = nil;
    gbScrollView = nil;
    myNaView = nil;
}

@end
