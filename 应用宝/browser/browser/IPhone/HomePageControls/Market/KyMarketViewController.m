//
//  KyMarketViewController.m
//  browser
//
//  Created by 王毅 on 14-5-19.
//
//

#import "KyMarketViewController.h"
#import "KyMarketNavgationController.h"

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif



@interface KyMarketViewController () <UIScrollViewDelegate>{
    NSArray * itemArray;
    UIScrollView * _scrollView;
    BlackCoverBackgroundView *blackCover;
}

@end

@implementation KyMarketViewController

- (void)dealloc{
    
    _scrollView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    _scrollView = [[UIScrollView alloc] init];
    
    _scrollView.delegate = self;
    
    _scrollView.directionalLockEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.bounces = NO;
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    [self.view addSubview:_scrollView];
    
    
    //精选
    _choiceViewController = [[ChoiceViewController alloc] init];
    _choiceViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    _choiceViewController.navgationController = _marketNavgationController;
    [_scrollView addSubview:_choiceViewController.view];
    
    //应用
    _appViewController = [[MarketAppGameViewController alloc] initWithMarketType:marketType_App];
    _appViewController.navigationController = _marketNavgationController;
    [_scrollView addSubview:_appViewController.view];
    
    //游戏
    _gameViewController = [[MarketAppGameViewController alloc] initWithMarketType:marketType_Game];
    _gameViewController.navigationController = _marketNavgationController;
    [_scrollView addSubview:_gameViewController.view];
    
    // 壁纸
    _wallPaperViewController = [[WallPaperViewController alloc] init];
    _wallPaperViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    _wallPaperViewController.navigationController = _marketNavgationController;
    [_scrollView addSubview:_wallPaperViewController.view];
    
    
    //点击分类时的遮黑视图
    blackCover  = [[BlackCoverBackgroundView alloc]init];
    [self.view addSubview:blackCover];

    
    //分类
//    _sortViewController = [[SortViewController alloc] init];
//    
//    [_scrollView addSubview:_sortViewController.view];
    
    
    itemArray = [NSArray arrayWithObjects:_choiceViewController.view, _appViewController.view, _gameViewController.view,_wallPaperViewController.view, nil];
    
    
    
    //顶部bar
    __weak typeof(self) mySelf = self;
    
    NSArray * __weak __itemArray = itemArray;
    
    UIScrollView * __weak __scroll = _scrollView;
    
    KyMarketNavgationController * __weak __marketNav = self.marketNav;
    _topbar = [[Market_top_bar alloc] initWithFrame:_marketNavgationController.navigationBar.bounds];
    
    //新春版
//    if(IOS7){
//        [self.navigationController.navigationBar setBarTintColor:NEWYEAR_RED];
//    }
    
    
    [_topbar setMarket_top_barClickWithBlock:^(NSInteger index) {
        
        if (index < __itemArray.count) {
            [__scroll setContentOffset:CGPointMake(__scroll.bounds.size.width*index, 0) animated:NO];
            [mySelf scrollViewDidEndDecelerating:__scroll];
        }else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"showCategory" object:nil];
            [__marketNav showCategory:nil];
        }

    }];

    [_marketNavgationController.navigationBar addSubview:_topbar];
    
    //市场-分类全屏遮黑界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBlackCover:) name:@"showBlackCover" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fadeBlackCover:) name:@"fadeBlackCover" object:nil];


}
- (void)showBlackCover:(NSNotification *)noti{
    if (noti.object) {
        [blackCover showWithoutAnimation];
    }else{
        [blackCover show];
    }
}

- (void)fadeBlackCover:(NSNotification *)noti{
    if ([noti.object isEqualToString:@"withAnimation"]) {
        [blackCover fade];
    }else{
        [blackCover fade_withoutAnimation];
    }
}
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setBlackCoverEnabled:(BOOL)enabled{
    blackCover.userInteractionEnabled = enabled;
}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    _scrollView.frame = self.view.bounds;
    blackCover.frame = _scrollView.frame;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*itemArray.count, self.view.bounds.size.height);
    
    for (int i=0; i<itemArray.count; i++) {
        
        UIView * view = (UIView *)[itemArray objectAtIndex:i];
        
        view.frame = CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.bounds.size.width, (IOS7 ? _scrollView.bounds.size.height : _scrollView.bounds.size.height-_marketNavgationController.navigationBar.bounds.size.height));
    }
}

#pragma mark -  ScrollView delegate

int _curMarkLunboIndex = 0; // 0: 精选，1：应用，2：游戏 3：发现精选 -1：无
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //scrollView.scrollEnabled = YES;
    _topbar.userInteractionEnabled = YES;
    if (scrollView.contentOffset.x/scrollView.bounds.size.width >0 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 1){
        _curMarkLunboIndex = 1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [_appViewController requestAll];
        });
    }else if (scrollView.contentOffset.x/scrollView.bounds.size.width >1 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 2){
        _curMarkLunboIndex = 2;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [_gameViewController requestAll];
        });
    }
    else if (scrollView.contentOffset.x/scrollView.bounds.size.width >2 && scrollView.contentOffset.x/scrollView.bounds.size.width <= 3)
    { // 壁纸
        _curMarkLunboIndex = -1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [_wallPaperViewController requestDefaultData];
        });
    }
    else
    {
        _curMarkLunboIndex = 0; // 精选
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _topbar.userInteractionEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_topbar setMarket_top_barDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate){
        //scrollView.scrollEnabled = NO;
    }else{
        _topbar.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
