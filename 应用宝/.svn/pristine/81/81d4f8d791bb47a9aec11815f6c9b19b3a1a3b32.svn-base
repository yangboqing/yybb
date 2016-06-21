//
//  MarketAppViewController.m
//  browser
//
//  Created by liguiyang on 14-9-24.
//
//

#import "MarketAppGameViewController_my.h"
#import "NewAppGameViewController.h"
#import "TopAppGameViewController.h"
#import "GoodAppGameViewController.h"
#import "SimilarNavigationView.h"
#import "ClassificationBackView.h"
#import "SearchViewController_my.h"
#import "MyNavigationController.h"

@interface MarketAppGameViewController_my ()<UIScrollViewDelegate,GoodAppGameViewDelegate>
{
    
    MarketType marketType;
    SimilarNavigationView *myNaView;
    MyNavigationController *categoryNav;

    UIScrollView *gbScrollView;
    NewAppGameViewController*newViewController;
    TopAppGameViewController*topViewController;
    GoodAppGameViewController*goodViewController;
    SearchType*searchType;
    BOOL firstNew;
    BOOL firstTop;
    BOOL firstGood;
}

@end

#define APPTITLE @"应用"
#define GAMETITLE @"游戏"
#define FUNCBTNTITLE @[@"优秀",@"最新",@"排行"]
#define LEFTRIGHTBTNIMAGE @[@"nav_categoryIcon",@"nav_search"]

@implementation MarketAppGameViewController_my

-(id)initWithMarketType:(MarketType)mType
{
    self = [super init];
    if (self) {
        marketType = mType;
        if (mType==marketType_App) {
            
        }
        else
        {
        }
    }
    
    return self;
}


#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate){
        scrollView.scrollEnabled = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = YES;

    if (scrollView.contentOffset.x/scrollView.bounds.size.width >0 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 1){
        if (firstNew) {
            [newViewController initTopRequest];
            firstNew=NO;
        }
            [myNaView btnImage:new_tag];
//            NSLog(@"a－aa");
        
    } else if (scrollView.contentOffset.x/scrollView.bounds.size.width >1 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 2){
        if (firstTop) {
            [topViewController initTopRequest];
            firstTop=NO;
        }
        [myNaView btnImage:top_tag];
        
    }else{
        [myNaView btnImage:good_tag];
//        NSLog(@"bb");
    }
}

//首次请求数据展示
-(void)requestAll{

    [goodViewController initGoodRequest];
}

#pragma mark - Utility

// 获取轮播图实例
//    NSString *sourceType = (marketType==marketType_App)?@"app":@"game";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    firstNew=YES;
    firstTop=YES;
    firstGood=YES;
    // UI
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (marketType==marketType_Game) {
        
    }
    //----------------------------------
    // scrollView
    gbScrollView = [[UIScrollView alloc] init];
    gbScrollView.scrollEnabled = YES;
    gbScrollView.pagingEnabled = YES;
    gbScrollView.bounces = NO;
    gbScrollView.directionalLockEnabled = YES;
    gbScrollView.showsVerticalScrollIndicator = NO;
    gbScrollView.showsHorizontalScrollIndicator = NO;
    gbScrollView.backgroundColor = [UIColor blackColor];
    gbScrollView.delegate = self;
    
    //
    newViewController = [[NewAppGameViewController alloc] init];
    newViewController.parentVC = self;
    topViewController=[[TopAppGameViewController alloc] init];
    topViewController.parentVC = self;
    goodViewController=[[GoodAppGameViewController alloc] init];
    topViewController.parentVC = self;
    goodViewController.delegate=self;
    if (marketType==marketType_App) {
        [newViewController appJudge:mark_app];
        [topViewController appJudge:top_app];
        [goodViewController appJudge:good_app];

    }
    else
    {
        [newViewController appJudge:mark_game];
        [topViewController appJudge:top_game];
        [goodViewController appJudge:good_game];

    }
    [gbScrollView addSubview:goodViewController.view];
    [gbScrollView addSubview:newViewController.view];
    [gbScrollView addSubview:topViewController.view];
    [self.view addSubview:gbScrollView];
    
    [self.myNaView setTitle:(marketType==marketType_App?APPTITLE:GAMETITLE) AndBtnTitleNameArray:FUNCBTNTITLE];
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
                if (firstNew) {
                    [newViewController initTopRequest];
                    firstNew=NO;
                }
                
            }
                break;
                
            case funcThirdBtn_tag:
            {
//                NSLog(@"功能三键");
         gbScrollView.contentOffset=CGPointMake(gbScrollView.bounds.size.width*2, 0);
                if (firstTop) {
                    [topViewController initTopRequest];
                    firstTop=NO;
                }
            }
                break;
                
            case leftBtn_tag:
                NSLog(@"导航左键");
//                [self ClassificationButton];
                [[Context defaults].homeNav popViewControllerAnimated:YES];
                break;
                
            case rightBtn_tag:
                //[self pushSearchClass];
                [self ClassificationButton];

//                NSLog(@"导航右键");
                break;
                
            default:
                break;
        }
    }];

    [self.view addSubview:self.myNaView];

}
-(void)pushSearchClass{

    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_SEARCHVIEW object:self];

}
- (SimilarNavigationView *)myNaView{
    if (myNaView) return myNaView;
    
    myNaView = [SimilarNavigationView new];
    [myNaView initAppGameBtn];
    return myNaView;
}
//分类跳转
- (void)ClassificationButton{

            if (marketType == marketType_App) {
                [self.delegate presentClassifyViewController:@"app"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_FENLEI object:@"app"];

            }
            else
            {
                [self.delegate presentClassifyViewController:@"game"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_FENLEI object:@"game"];

            }
//底部菜单

}


- (void)buttonClick:(UIButton *)btn{
    
//    NSLog(@"===dianji");
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (marketType == marketType_App) {
        self.title = @"应用";
    }
    else
    {
        self.navigationItem.title = @"游戏";
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

-(void)viewWillLayoutSubviews
{
        CGRect rect = self.view.bounds;
    myNaView.frame = CGRectMake(0, 0, rect.size.width, 210/2+2);
    goodViewController.view.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height - 20);
    newViewController.view.frame = CGRectMake(MainScreen_Width, 0, MainScreen_Width, MainScreen_Height - 20);
    topViewController.view.frame = CGRectMake(MainScreen_Width*2, 0, MainScreen_Width, MainScreen_Height - 20);

    gbScrollView.frame = CGRectMake(0, 44, MainScreen_Width, MainScreen_Height - 20);
    gbScrollView.contentSize = CGSizeMake(MainScreen_Width*3, MainScreen_Height - 20);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}


-(void)GoodNavControllerPushViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self hideNavBottomBar:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(void)hideNavBottomBar:(BOOL)flag
{
    self.navigationController.navigationBar.hidden = flag;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:(flag?@"yes":nil)];
}
@end
