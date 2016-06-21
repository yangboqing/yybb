//
//  KyMarketNavgationController.m
//  browser
//
//  Created by niu_o0 on 14-5-22.
//
//

#import "KyMarketNavgationController.h"
#import "CategoryViewController.h"
#import "MarketServerManage.h"
#import "CategoryListViewController.h"

@interface KyMarketNavgationController (){
    CategoryListViewController *categoryList;//game或app下的分类列表
    UIButton *gameButton ;
    UIButton *appButton;
    UIView *topView;//导航栏game+app
    NSNotification *lastNoti;

}

@end

@implementation KyMarketNavgationController

- (void)dealloc{
    [[MarketServerManage getManager]removeListener:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.

    [[MarketServerManage getManager]addListener:self];
    
    _marketViewController = [[KyMarketViewController alloc] init];
    _marketViewController.marketNav = self;
    
    _marketViewController->_marketNavgationController = self.navigationController;
    
    _marketViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.view addSubview:_marketViewController.view];
    
    //显示市场 - 分类视图
    categoryViewController = [[CategoryViewController alloc]init];
    categoryViewController.view.frame  = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    categoryViewController.view.hidden = YES;
    [self.view addSubview:categoryViewController.view];
    
    
    
    //显示分类
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(showCategory:)
//                                                name:@"showCategory"
//                                              object:nil];
    //隐藏分类
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(hideCategory)
                                                name:HIDE_CATEGORY
                                              object:nil];
    //显示分类的顶部title
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(recoverCategoryTitle)
                                                name:@"recoverCategoryTitle"
                                              object:nil];
    //除后退按钮外所有navigationBar上的组件都隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allHide)
                                                 name:@"navigationBarItemAllHide"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showCustomNav)
                                                name:@"showCustomNav"
                                              object:nil];
    //显示loading界面
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showCategoryLoadingView)
                                                name:@"showCategoryLoadingView"
                                              object:nil];
    //显示分类下的所有app
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showCategoryList_:)
                                                name:SHOW_CATEGORY_LIST
                                              object:nil];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideCategoryViewController) name:@"hideCategoryViewController" object:nil];
    //分类标题
    gameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gameButton setTitle:@"游戏分类" forState:UIControlStateNormal];
    [gameButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
    gameButton.backgroundColor = TOP_RED_COLOR;
    //新春
//        gameButton.backgroundColor = [UIColor whiteColor];
    gameButton.tag = GAMEBUTTON_TAG;
    gameButton.layer.borderColor = TOP_RED_COLOR.CGColor;
//    gameButton.layer.borderColor = [UIColor whiteColor].CGColor;
    gameButton.layer.borderWidth = 0.5;
    [gameButton addTarget:self action:@selector(showGameCategory) forControlEvents:UIControlEventTouchUpInside];
    
    appButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [appButton setTitle:@"应用分类" forState:UIControlStateNormal];
    [appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appButton.backgroundColor = TOP_RED_COLOR;
//新春版
//    appButton.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];

    appButton.tag = APPBUTTON_TAG;
    appButton.layer.borderColor = TOP_RED_COLOR.CGColor;
//    appButton.layer.borderColor = [UIColor whiteColor].CGColor;

    appButton.layer.borderWidth = 0.5;
    [appButton addTarget:self action:@selector(showAppCategory) forControlEvents:UIControlEventTouchUpInside];
    

    
    topView = [[UIView alloc]init];
    [topView addSubview:gameButton];
    [topView addSubview:appButton];
    topView.userInteractionEnabled = YES;
    topView.alpha = 0;
    
    [self setButtonSelected:gameButton.tag];
    [self.navigationController.navigationBar addSubview:topView];
    
    categoryList = [[CategoryListViewController alloc]init];
    categoryList.target = @"market";
    categoryList.marketNavDelegate = self;
    
    
}
- (void)hideCategoryViewController{
    categoryViewController.view.hidden = YES;
    /**
     2.0发版后新增,解决点市场按钮后,再点分类无下拉动画以及列表无加载动画的问题
     */
    categoryViewController.view.frame = CGRectMake(0, - self.view.frame.size.height - 84, self.view.frame.size.width, self.view.frame.size.height);
    [categoryList showCategoryLoadingView];
    categoryList.categoryName = @"";

}
- (void) setButtonSelected:(int)buttonTag{
    //新春版
//    if (buttonTag == GAMEBUTTON_TAG) {
//        gameButton.backgroundColor = [UIColor whiteColor];
//        [gameButton setTitleColor:NEWYEAR_RED forState:UIControlStateNormal];
//        appButton.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];
//        [appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [categoryViewController showAppOrGameCategory:CLASSIFY_GAME];
//    }else{
//        appButton.backgroundColor = [UIColor whiteColor];
//        [appButton setTitleColor:NEWYEAR_RED forState:UIControlStateNormal];
//        gameButton.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];
//        [gameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [categoryViewController showAppOrGameCategory:CLASSIFY_APP];
//    }
    
    if (buttonTag == GAMEBUTTON_TAG) {
        gameButton.backgroundColor = TOP_RED_COLOR;
        [gameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        appButton.backgroundColor = CONTENT_BACKGROUND_COLOR;
        [appButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
        [categoryViewController showAppOrGameCategory:CLASSIFY_GAME];
    }else{
        appButton.backgroundColor = TOP_RED_COLOR;
        [appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        gameButton.backgroundColor = CONTENT_BACKGROUND_COLOR;
        [gameButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
        [categoryViewController showAppOrGameCategory:CLASSIFY_APP];
    }
    topView.tag = buttonTag;

}

//显示某个小分类下所有应用的列表
//- (void)showCategoryList:(NSNotification *)noti{
//    lastNoti = noti;
//    int pageCount  = [[noti.object  objectForKey:@"pageCount"]intValue];
//    BOOL isNextData = [[[[noti.object objectForKey:@"dataDic" ] objectForKey:@"flag"] objectForKey:@"dataend"] boolValue];
//    NSDictionary *dataDic = [noti.object valueForKey:@"dataDic"];
////    NSString *contentString = [[dataDic objectForKey:@"data"][0] objectForKey:@"category"];
//    NSString *contentString = [noti.object objectForKey:@"classifyID"];
//
//    if (pageCount ==1) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"fadeBlackCover" object:nil];
//        if (!IOS7) {
//            self.navigationController.navigationBarHidden = YES;
//        }
//        [self.navigationController pushViewController:categoryList animated:YES];
//        categoryList.detailListTableViewController.target = @"market";
//        //    _marketViewController.topbar.hidden = YES;
//        topView.hidden = YES;
//    }
//    [categoryList.detailListTableViewController showSearchResult:[dataDic objectForKey:@"data"] isNextData:isNextData  searchContent:contentString];
//}
//显示某个小分类下所有应用的列表
- (void)showCategoryList_:(NSNotification *)noti{
    categoryList.detailListTableViewController.target = @"market";
    topView.hidden = YES;
    [categoryList showCategoryLoadingView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fadeBlackCover" object:@"withoutAnimation"];
    [self.navigationController pushViewController:categoryList animated:NO];
}

//显示分类视图
- (void)showCategory:(id)obj{
    //显示分类界面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showBlackCover" object:obj];
    [self showCategoryTitle:obj];
    categoryViewController.view.hidden = NO;
    if (!obj) {
        if (topView.tag == GAMEBUTTON_TAG) {
            [categoryViewController requestCategoryData:@"game"];
        }
    }
    [categoryViewController showAppOrGameCategory:topView.tag==GAMEBUTTON_TAG?CLASSIFY_GAME: CLASSIFY_APP];
    [self setButtonSelected:topView.tag];

}
- (void)recoverCategoryTitle{
    topView.hidden = NO;
}
- (void)showCustomNav{
    _marketViewController.topbar.hidden = YES;
    topView.hidden = YES;
}

//收起分类视图
- (void)hideCategory{
    _marketViewController.topbar.hidden = NO;
    [self hideCategoryTitle];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fadeBlackCover" object:@"withAnimation"];
    [UIView animateWithDuration:HIDE_TIME animations:^{
        [categoryViewController lockUserInterActive:YES];
//        categoryViewController.view.userInteractionEnabled = NO;
        categoryViewController.view.frame = CGRectMake(0, - self.view.frame.size.height - 84, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
//        categoryViewController.view.userInteractionEnabled = YES;
        [categoryViewController lockUserInterActive:NO];
        categoryViewController.view.hidden = YES;
    }];
}
//显示游戏和应用按钮
- (void)showCategoryTitle:(id)data{
    topView.hidden = NO;
    topView.alpha = 0;
    if ([data isEqualToString:@"noAnimation"]) {
            _marketViewController.topbar.alpha = 0.0;
            topView.alpha = 1.0;
            if (IOS7) {
                categoryViewController.view.frame = CGRectMake(0, 20 + 44, self.view.frame.size.width, self.view.frame.size.height - 20 - 40 - 49);
            }else{
                categoryViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 20 - 40 - 49);
            }

    }else{
        [UIView animateWithDuration:SHOW_TIME animations:^{
            //        categoryViewController.view.userInteractionEnabled = NO;
            [categoryViewController lockUserInterActive:YES];
            _marketViewController.topbar.alpha = 0.0;
            if (IOS7) {
                categoryViewController.view.frame = CGRectMake(0, 20 + 44, self.view.frame.size.width, self.view.frame.size.height - 20 - 40 - 49);
            }else{
                categoryViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 20 - 40 - 49);
            }
            
            topView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [categoryViewController lockUserInterActive:NO];
            
            //        categoryViewController.view.userInteractionEnabled = YES;
        }];

    }
}
//隐藏游戏和应用按钮
- (void)hideCategoryTitle{
    [UIView animateWithDuration:HIDE_TIME/2 animations:^{
        topView.alpha = 0;
    } completion:^(BOOL finished) {
        //
        [UIView animateWithDuration:HIDE_TIME/2 animations:^{
            _marketViewController.topbar.alpha = 1;
        } completion:^(BOOL finished) {
            //
        }];
    }];
}

- (void)allHide{
    _marketViewController.topbar.hidden = YES;
    topView.hidden = YES;
}
//显示游戏下分类
- (void)showGameCategory{
    [self setButtonSelected:gameButton.tag];
    [categoryViewController requestCategoryData:@"game"];

}
//显示应用下分类
- (void)showAppCategory{
    [self setButtonSelected:appButton.tag];
    [categoryViewController requestCategoryData:@"app"];
}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    CGFloat width_btn = (MainScreen_Width-10*2)*0.5;
    gameButton.frame = CGRectMake(10, 5, width_btn, 30);
    appButton.frame = CGRectMake(gameButton.frame.origin.x + gameButton.frame.size.width, gameButton.frame.origin.y, width_btn, 30);
    topView.frame = CGRectMake(0, 0, MainScreen_Width, 60);
    _marketViewController.view.frame = CGRectMake(0, MainScreen_Y, MainScreen_Width, MainScreen_Height - 20);

}
-  (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    //新春版
//    if(IOS7){
//        [self.navigationController.navigationBar setBarTintColor:NEWYEAR_RED];
//    }
    
    [super viewWillAppear:animated];


    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:NO]];
    
    if (categoryViewController.view.frame.origin.y > 0) {
        //处理分类列表边缘右滑带来的底部遮黑不显示的问题
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showBlackCover" object:nil];
    }
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    topView.hidden = YES;
    _marketViewController.topbar.hidden = NO;
    _marketViewController.topbar.alpha = 1.0;

    //处理分类列表边缘右滑带来的顶部类导航区显示问题(游戏分类和应用分类不显示问题)
    if (categoryViewController.view.frame.origin.y > 0) {
        [self showCategoryTitle:@"noAnimation"];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _marketViewController.topbar.alpha = 0.0;
    topView.alpha = 0.0f;
    _marketViewController.topbar.hidden = YES;
    topView.hidden = YES;

//    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        _marketViewController.topbar.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

#pragma mark - markedtSearchManagerDelegate

-(BOOL)checkData:(NSDictionary*)dataDic {
    NSArray *categories = [dataDic getNSArrayObjectForKey:@"data"];
    if(!categories)
        return NO;
    
    for (NSDictionary * dicItem in categories) {
        if(!IS_NSDICTIONARY(dicItem))
            return NO;
        
        if( [dicItem getNSStringObjectForKey:@"category_count"] &&
           [dicItem getNSStringObjectForKey:@"category_id"] &&
           [dicItem getNSStringObjectForKey:@"category_name"] ) {
            
            //数据正常
        }else{
            return NO;
        }
    }
    
    return YES;
}

//请求游戏或应用分类
- (void)classifyListRequestSucess:(NSDictionary *)dataDic listMode:(NSString *)listMode userData:(id)userData{
    if (!IS_NSDICTIONARY(dataDic)) {
        return;
    }
    if (!IS_NSARRAY([dataDic objectForKey:@"data"])) {
        return;
    }
    
    if( ![self checkData:dataDic] ){
        return;
    }
    
    NSArray *data = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
    [categoryViewController loadingDataSuccess];
    [categoryViewController setCategory:userData withData:data];
    [categoryViewController showAppOrGameCategory:userData];
    
}
- (void)classifyListRequestFail:(NSString *)listMode userData:(id)userData{
    [categoryViewController loadingDataFailed];
}

-(BOOL)checkAppsOrGamesData:(NSDictionary*)dataDic {
    NSArray *apps = [dataDic getNSArrayObjectForKey:@"data"];
    if(!apps)
        return NO;
    
    for (NSDictionary * dicItem in apps) {
        if(!IS_NSDICTIONARY(dicItem))
            return NO;
        
        if( [dicItem getNSStringObjectForKey:@"appdowncount"] &&
           [dicItem getNSStringObjectForKey:@"appiconurl"] &&
           [dicItem getNSStringObjectForKey:@"appid"] &&
           [dicItem getNSStringObjectForKey:@"appintro"] &&
           [dicItem getNSStringObjectForKey:@"appname"] &&
           [dicItem getNSStringObjectForKey:@"appupdatetime"] &&
           [dicItem getNSStringObjectForKey:@"appversion"] &&
           [dicItem getNSStringObjectForKey:@"category"] &&
           [dicItem getNSStringObjectForKey:@"ipadetailinfor"] &&
           [dicItem getNSStringObjectForKey:@"plist"] &&
           [dicItem getNSStringObjectForKey:@"share_url"]) {
            
            //数据正常
        }else{
            return NO;
        }
    }
    
    return YES;

}

//分类应用请求成功
- (void)classifyAppRequestSucess:(NSDictionary*)dataDic classifyID:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData{
    
    //检查数据是否为字典格式
    if (!IS_NSDICTIONARY(dataDic)) {
        return;
    }
    //检查data是否为数组格式
    if (!IS_NSARRAY([dataDic objectForKey:@"data"])) {
        return;
    }
    //检查必要数据是否为真
    if( ![self checkAppsOrGamesData:dataDic] ){
        return;
    }
    
    //加载完成时恢复遮黑可点击
    [_marketViewController setBlackCoverEnabled:YES];
//    NSLog(@"userData = %@",userData);
    if (![[categoryViewController getCurrentSearchKey] isEqualToString:userData]) {
        return;
    }
    if (!userData) {
        userData = @"";
    }
    if (pageCount ==1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"fadeBlackCover" object:nil];
//        if (!IOS7) {
//            self.navigationController.navigationBarHidden = YES;
//        }
        categoryList.detailListTableViewController.target = @"market";
        //    _marketViewController.topbar.hidden = YES;
        topView.hidden = YES;
    }
    BOOL isNextData  = [[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"]boolValue];
    NSString *contentString = userData;
    NSString *title ;
   
    if ([userData isEqualToString:@"1"]) {
        title = @"全部游戏";
    }else if([userData isEqualToString:@"2"]){
        title = @"全部应用";
    }else{
        if ([[dataDic objectForKey:@"data"][0] isKindOfClass:[NSDictionary class]]) {
            title= [[dataDic objectForKey:@"data"][0] objectForKey:@"category"];
        }else{
            title  = @"";
            categoryList.categoryName  = classifyID;
            [categoryList showSearchListFailedView];
            return;
        }
    }
    [categoryList setNavTitle:title];
    [categoryList.detailListTableViewController showSearchResult:[dataDic objectForKey:@"data"] isNextData:isNextData  searchContent:contentString];
    [categoryList showCategoryListTableView];

//    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_CATEGORY_LIST object:dic];
}
//失败
- (void)classifyAppRequestFail:(NSString *)classifyID pageCount:(int)pageCount userData:(id)userData{
    if ([categoryList.detailListTableViewController hasExistData]) {
        
        if (![[categoryList.detailListTableViewController getLastSearchContent] isEqualToString:classifyID]) {
            [categoryList.detailListTableViewController setRefreshCellText:@"努力加载中" andActivityHiden:NO searchLock:YES];
            categoryList.categoryName = classifyID;
            [categoryList showSearchListFailedView];
        }else{
            [categoryList.detailListTableViewController setRefreshCellText:@"网络有点堵塞，试试再次上拉" andActivityHiden:YES searchLock:YES];
            [categoryList showCategoryListTableView];
        }
        [self performSelector:@selector(setSearchListLock) withObject:nil afterDelay:0.5];
        
    }else{

        [categoryList.detailListTableViewController setRefreshCellText:@"努力加载中" andActivityHiden:NO searchLock:NO];
        [categoryList showSearchListFailedView];
    }
    //恢复列表下拉状态
    [categoryList.detailListTableViewController refreshDataComplete];
}

- (void)setSearchListLock{
    [categoryList.detailListTableViewController setRefreshCellText:@"网络有点堵塞，试试再次上拉" andActivityHiden:YES searchLock:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
