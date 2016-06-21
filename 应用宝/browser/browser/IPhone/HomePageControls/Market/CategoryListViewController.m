//
//  CategoryListViewController.m
//  browser
//
//  Created by caohechun on 14-6-20.
//
//

#import "CategoryListViewController.h"
#import "MarketServerManage.h"
#import "KyMarketNavgationController.h"
#import "FindDetailViewController.h"
#import "SearchResult_DetailViewController.h"
#import "CustomNavigationBar.h"
#import "CollectionViewBack.h"
#import "FileUtil.h"


#define ACTIVE_NOTICE_BUTTON_HEIGHT 47.5

@interface CategoryListViewController ()
{
     BOOL isCategoryDetail;//用于判断是否是从分类进入的导航
    UILabel *titleLabel;//顶部自定义导航栏
    UIButton *backButton;//自定义返回按钮
    UIView *searchListFailedView;
    UIImageView *failedImgView;//加载失败view
    UILabel *failedLabel;//加载失败文字
    int failedTimes;//加载失败次数
    CustomNavigationBar *navTitleBar;
    CollectionViewBack * _backView;//加载中
    UIButton *activeNoticeButton;

}
@end

@implementation CategoryListViewController

- (void)dealloc{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //加载中
        __weak typeof(self) mySelf = self;
        _backView = [CollectionViewBack new];
        [self.view addSubview:_backView];
        [_backView setClickActionWithBlock:^{
            [mySelf performSelector:@selector(categoryListFailedViewHasBeenTap) withObject:nil afterDelay:delayTime];
        }];
        
        self.detailListTableViewController  =[[ SearchResultTabelViewController alloc]initWithStyle:UITableViewStylePlain];
        self.detailListTableViewController.parentCategoryListViewController = self;
        self.detailListTableViewController.view.hidden = YES;
        [self.view addSubview:self.detailListTableViewController.view];
        
        //右滑返回手势
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBackVC)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.view addGestureRecognizer:swipe];
        
        //2.5加入未激活提示区域
        activeNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [activeNoticeButton setTitle:@"找不到应用?如何搜索出你要的应用? (点我)" forState:UIControlStateNormal];
        [activeNoticeButton setTitleColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1] forState:UIControlStateNormal];
        //        activeNoticeButton.titleLabel.textColor = TOP_RED_COLOR;
        activeNoticeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [activeNoticeButton addTarget:self action:@selector(showActiveNotice) forControlEvents:UIControlEventTouchUpInside];
        activeNoticeButton.frame = CGRectMake(0, (IOS7?64:44), MainScreen_Width, ACTIVE_NOTICE_BUTTON_HEIGHT);
        activeNoticeButton.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bottomLineImageView = [[UIImageView alloc]init];
        bottomLineImageView.backgroundColor = SEPERATE_LINE_COLOR;
        bottomLineImageView.frame = CGRectMake(0, activeNoticeButton.frame.size.height - 1, activeNoticeButton.frame.size.width, 1);
        [activeNoticeButton addSubview:bottomLineImageView];
        


        
    }
    return self;
}
- (void)viewWillLayoutSubviews{

    //2.5版本加入激活提示区域
    if (IOS7) {
        //未授权时显示的headView
        if ([self.target isEqualToString:@"search"]&&![[FileUtil instance] checkAuIsCanLogin]){
            self.detailListTableViewController.view.frame = CGRectMake(0,64 + ACTIVE_NOTICE_BUTTON_HEIGHT, MainScreen_Width, MainScreen_Height - 64 - 49 - ACTIVE_NOTICE_BUTTON_HEIGHT);
            
        }else{
            self.detailListTableViewController.view.frame = CGRectMake(0,64, MainScreen_Width, MainScreen_Height - 64 - 49);
        }
       
    }else{
        if ([self.target isEqualToString:@"search"]&&![[FileUtil instance] checkAuIsCanLogin]){
            
            self.detailListTableViewController.view.frame = CGRectMake(0, 44 + ACTIVE_NOTICE_BUTTON_HEIGHT, MainScreen_Width, MainScreen_Height - 64 - 49 - ACTIVE_NOTICE_BUTTON_HEIGHT);
        }else{
            self.detailListTableViewController.view.frame = CGRectMake(0,44, MainScreen_Width, MainScreen_Height - 64 - 49);
        }

    }
    
    if ([self.target isEqualToString:@"search"]&&![[FileUtil instance] checkAuIsCanLogin]){
        [self.view addSubview:activeNoticeButton];
        [self.view bringSubviewToFront:activeNoticeButton];
    }
    _backView.frame = self.view.bounds;
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.title = @"";
    // NavigationBar
    navTitleBar = [[CustomNavigationBar alloc] init];
    if ([self.target isEqualToString:@"search"]) {
        [navTitleBar showNavigationTitleView:self.searchContent];
    }else{
        [navTitleBar showNavigationTitleView:self.categoryName];
    }
    self.navigationItem.titleView = navTitleBar;
    addNavgationBarBackButton(self,goBackVC);
//    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:YES]];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if ([self.target isEqualToString:@"search"]&&![self.navigationController.topViewController isKindOfClass:[SearchResult_DetailViewController class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HOT_WORDS object:nil];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fadeBlackCover" object:@"withAnimation"];
}

- (void)setNavTitle:(NSString *)titile{
    [navTitleBar showNavigationTitleView:titile];
    if ([self.target isEqualToString:@"market"]) {
        self.categoryName = titile;
    }
}
- (void)goBackVC{
//    NSLog(@"goBackVC---------%@",self.target);
//    [self.detailListTableViewController clearImgCache];
    [self.detailListTableViewController setInforNil];
    [self setNavTitle:nil];
    [titleLabel removeFromSuperview];
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.target isEqualToString:@"market"]) {
//        [self performSelector:@selector(delayShowCategory) withObject:nil afterDelay:0.01];
    }else if ([self.target isEqualToString:@"search"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HOT_WORDS object:nil];
    }
}
- (void)delayShowCategory{
    if ([self.marketNavDelegate respondsToSelector:@selector(showCategory:)]) {
        [self.marketNavDelegate showCategory:@"noAnimation"];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showSearchListFailedView
{
    [_backView setStatus:Failed];
    self.detailListTableViewController.view.hidden = YES;
}

-(void)categoryListFailedViewHasBeenTap
{// 点击搜索失败页面 重新搜索
    [_backView setStatus:Loading];
     [[MarketServerManage getManager] getClassifyApp:self.categoryName pageCount:1 userData:self.categoryName];
}

- (void)showCategoryLoadingView{
    [_backView setStatus:Loading];
    self.detailListTableViewController.view.hidden = YES;
}

- (void)showCategoryListTableView{
    [_backView setStatus:Hidden];
    self.detailListTableViewController.view.hidden  = NO;
}
#pragma mark - 未激活提示按钮
- (void)showActiveNotice{
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_ACTIVE_NOTICE object:nil];
}
@end
