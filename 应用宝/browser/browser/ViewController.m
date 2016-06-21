//
//  ViewController.m
//  MyHelper
//
//  Created by liguiyang on 14-11-29.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "IphoneAppDelegate.h"
#import "TopicDetailsViewController.h"
#import "MaskAlertView.h"
#import "MyNavigationController.h"
#import "SearchViewController_my.h"
#import "FindDetailViewController_my.h"
#import "HomeViewController.h"

#import "MyUpdateSelfManager.h"
#import "CollectionCells.h"
#import "SearchResult_DetailViewController.h"


typedef enum{
    HIDE = 700,
    LOADING,
    FAILD
}ShowDetailsType;
#define DetailsLoading @"正在载入..."
#define DetailsFaild   @"无法连接到AppStore 点击刷新"

@interface ViewController ()<MaskAlertViewDelegate,MyUpdateSelfManagerDelegate,SKStoreProductViewControllerDelegate,HomeViewControllerDelegate>
{
    MyNavigationController *homeNav;
    HomeViewController *homeViewController;
    
    // maskAlertView
    MaskAlertView *maskAlertView;
    
    //详情菊花
    UIView *goDetailsLoadingView;
    UIImageView *bannerView;
    UIImageView *bannerLine;
    UIButton *calcelBtn;
    UILabel *loadInfoLabel;
    UILabel *faildInfoLabel;
    UIActivityIndicatorView *_activityIndicator;
    UIImageView *XXImageView;
    BOOL touchGoDetailsHidden;
    NSNotification *storeNo;
    UITapGestureRecognizer *tapFaild;
    //
    ShowDetailsType loadType;
    BOOL showAppDetails;
    //
    UIStatusBarStyle sBarStyle;
    UIImageView *launchImgView;
    SearchResult_DetailViewController *detailVC;//app详情页面
    
    UIView * statusBarView;
}

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(openAppWithIdentifier:)
        name:OPEN_APPSTORE object:nil];
    //消息推送
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(receiveNotificationPush:)
        name:RECEIVE_NOTIFICATION_PUSH object:nil];
    
    // 更新检测
    if (SHOW_REAL_VIEW_FLAG) {
        [self checkSelfVersion:nil];
    }
    
    // mainView
    homeViewController = [[HomeViewController alloc] init];
    homeViewController.delegate = self;
    homeNav = [[MyNavigationController alloc] initWithRootViewController:homeViewController];
    homeNav.tag = tagNav_home;
    [self.view addSubview:homeNav.view];
    [Context defaults].homeNav = homeNav;
    
    // MaskView
    maskAlertView = [[MaskAlertView alloc] init];
    maskAlertView.delegate = self;
    [self.view addSubview:maskAlertView];
    maskAlertView.hidden = YES;
    
    // NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchViewController:) name:SHOW_SEARCHVIEW object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSelfVersion:) name:UPDATE_VERSION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFindDetailViewController:) name:SHOW_FIND object:nil];
    
    //详情菊花
    goDetailsLoadingView = [UIView new];
    goDetailsLoadingView.userInteractionEnabled = YES;
    goDetailsLoadingView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self.view addSubview:goDetailsLoadingView];
    
    bannerView = [UIImageView new];
    bannerView.backgroundColor = hllColor(246, 246, 246, 1);
    [goDetailsLoadingView addSubview:bannerView];
    
    bannerLine = [UIImageView new];
    bannerLine.backgroundColor = hllColor(168, 167, 168, 1);
    [goDetailsLoadingView addSubview:bannerLine];
    
    calcelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calcelBtn.backgroundColor = [UIColor clearColor];
    [calcelBtn setTitleColor:hllColor(10, 123, 252, 1) forState:UIControlStateNormal];
    [calcelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [calcelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [calcelBtn addTarget:self action:@selector(hideTheLoadView) forControlEvents:UIControlEventTouchUpInside];
    [goDetailsLoadingView addSubview:calcelBtn];
    
    loadInfoLabel = [UILabel new];
    loadInfoLabel.text = DetailsLoading;
    loadInfoLabel.backgroundColor = [UIColor clearColor];
    loadInfoLabel.textAlignment = NSTextAlignmentLeft;
    loadInfoLabel.font = [UIFont systemFontOfSize:14.0f];
    loadInfoLabel.textColor = hllColor(100, 100, 100, 1);
    [goDetailsLoadingView addSubview:loadInfoLabel];
    
    faildInfoLabel = [UILabel new];
    faildInfoLabel.text = DetailsFaild;
    faildInfoLabel.backgroundColor = loadInfoLabel.backgroundColor;
    faildInfoLabel.textAlignment = NSTextAlignmentCenter;
    faildInfoLabel.font = loadInfoLabel.font;
    faildInfoLabel.textColor = loadInfoLabel.textColor;
    [goDetailsLoadingView addSubview:faildInfoLabel];
    
    _activityIndicator = [UIActivityIndicatorView new];
    _activityIndicator.backgroundColor = [UIColor clearColor];
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_activityIndicator startAnimating];
    [goDetailsLoadingView addSubview:_activityIndicator];
    
    XXImageView = [UIImageView new];
    XXImageView.backgroundColor = [UIColor clearColor];
    XXImageView.image = [UIImage imageNamed:@"storeLoading"];
    [goDetailsLoadingView addSubview:XXImageView];
    
    tapFaild = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshStoreView)];
    [goDetailsLoadingView addGestureRecognizer:tapFaild];
    
    // stautusBarStyle
    sBarStyle = UIStatusBarStyleLightContent;
    
    //
    
    NSString *imgName = [self getLanuchImgName];
    launchImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    launchImgView.userInteractionEnabled = YES;
    [self.view addSubview:launchImgView];
    
    detailVC = [[SearchResult_DetailViewController alloc]init];
    
}
- (void)refreshStoreView
{
    [self openAppWithIdentifier:storeNo];
}

- (void)hideTheLoadView
{
    touchGoDetailsHidden = YES;
    [self showDetailsState:HIDE];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showDetailsState:) object:[NSNumber numberWithInt:HIDE]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(storeLoadingTimeout) object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    homeViewController.view.frame = self.view.bounds;
    homeNav.view.frame = self.view.bounds;
    launchImgView.frame = self.view.bounds;
    
    //详情页菊花
    goDetailsLoadingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    bannerView.frame = CGRectMake(0, 0, MainScreen_Width, 64.0);
    bannerLine.frame = CGRectMake(0, bannerView.frame.origin.x+bannerView.frame.size.height, MainScreen_Width, 0.5);
    calcelBtn.frame = CGRectMake(0, 20+3, 50, 40);
    _activityIndicator.frame = CGRectMake((MainScreen_Width-130)/2+5, (goDetailsLoadingView.frame.size.height-24)/2, 30, 30);
    CGFloat lStartx = _activityIndicator.frame.origin.x+_activityIndicator.frame.size.width;
    loadInfoLabel.frame = CGRectMake(lStartx, _activityIndicator.frame.origin.y, 70, 30);
    faildInfoLabel.frame = CGRectMake(0, _activityIndicator.frame.origin.y, MainScreen_Width, 30);
    
    XXImageView.frame = CGRectMake(0, 0, XXImageView.image.size.width/2*MULTIPLE, XXImageView.image.size.height/2*MULTIPLE);
    XXImageView.center = CGPointMake(goDetailsLoadingView.center.x, _activityIndicator.center.y-_activityIndicator.frame.size.height/2-XXImageView.image.size.height/4*MULTIPLE-8);
}

- (void)showDetailsState:(ShowDetailsType)type
{
    loadType = type;
    switch (type) {
        case HIDE:
        {
            [goDetailsLoadingView removeGestureRecognizer:tapFaild];
            [self setStoreLoadingViewhidde:YES];
            [_activityIndicator stopAnimating];
        }
            break;
            
        case LOADING:
        {
            [goDetailsLoadingView removeGestureRecognizer:tapFaild];
            [self setStoreLoadingViewhidde:NO];
            [_activityIndicator startAnimating];
            loadInfoLabel.hidden = NO;
            faildInfoLabel.hidden = YES;
        }
            break;
            
        case FAILD:
        {
            [goDetailsLoadingView addGestureRecognizer:tapFaild];
            [self setStoreLoadingViewhidde:NO];
            [_activityIndicator stopAnimating];
            loadInfoLabel.hidden = YES;
            faildInfoLabel.hidden = NO;
        }
            break;
            
        default:
        {
            [goDetailsLoadingView removeGestureRecognizer:tapFaild];
            [self setStoreLoadingViewhidde:YES];
            [_activityIndicator stopAnimating];
        }
            break;
    }
}

- (void)setStoreLoadingViewhidde:(BOOL)bl
{
    if (bl) {
        [UIView animateWithDuration:0.25 animations:^{
            goDetailsLoadingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        } completion:^(BOOL finished) {
        }];
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
            goDetailsLoadingView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Utility

- (void)updateSelf:(NSString *)userData
{
    [MyUpdateSelfManager instance].delegate = self;
    [[MyUpdateSelfManager instance] detectVersionOfMyHelper:userData];
}

- (NSString*)getLanuchImgName
{
    NSString *imgName = @"Default-568h.png"; // 4寸
    
    if (iPhone4 || iPhone4S) {
        imgName = @"Default.png"; // 3.5寸
    }
    else if(iPhone6)
    {
        imgName = @"Default-667h.png"; // 4.5寸
    }
    else if (iPhone6Plus)
    {
        imgName = @"Default-736.png"; // 4.7寸
    }
    
    return imgName;
}

- (void)checkSelfVersion:(NSNotification *)notification
{
    if (notification == nil) {
        [self updateSelf:nil];
    }
    else
    { // 点击设置（自更新）
        // 设置loading界面
        [maskAlertView setMaskAlertViewType:AlertViewloading updateInfo:nil];
        [self performSelector:@selector(updateSelf:) withObject:@"setting" afterDelay:delayTime];
    }
}

- (void)showSearchViewController:(NSNotification *)notify
{ // 搜索界面
    SearchViewController_my *searchVC = [[SearchViewController_my alloc] initWithSearchType:searchType_chosen];
    [homeNav prepairScreenShot:notify.object];
    [homeNav pushViewController:searchVC animated:YES];
}

- (void)showFindDetailViewController:(NSNotification*)notify
{
    NSArray *ary = notify.object;
    if (ary!=nil&&ary.count==2) {
        FindDetailViewController_my * findDetailViewController = [[FindDetailViewController_my alloc] init];
        findDetailViewController.fromSource = [ary objectAtIndex:1];
        findDetailViewController.shareImage = nil;
        NSDictionary*dic=[[NSDictionary alloc] init];
        NSDictionary*infoDic=[ary objectAtIndex:0];
        if (![infoDic objectForKey:@"content_url"]) {
            //            NSLog(@"没有文章 content_url");
            dic=[infoDic objectForKey:@"link_detail"];
            
        }else{
            dic=infoDic;
        }
        
        findDetailViewController.content = [dic objectForKey:@"content_url"];
        [findDetailViewController reloadActivityDetailVC:dic];
        [homeNav prepairScreenShot:self]; // 解决截屏黑块
        [homeNav pushViewController:findDetailViewController animated:YES];
    }else{
        //        NSLog(@"－－－－传值有误");
    }
}

#pragma mark - MaskAlertViewDelegate
- (void)maskAlertViewConfirmButtonClick:(NSDictionary *)updateDic
{ // 更新确认按钮
    NSString *digitalId  = [[updateDic objectForKey:@"appinfo"]objectForKey:@"appdigitalid"];
    NSString *installStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", digitalId];
    // 安装
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installStr]];
}

#pragma mark - MyUpdateSelfDelegate

- (void)hasNewVersion:(NSDictionary *)dic userData:(NSString *)userData
{
    [maskAlertView setMaskAlertViewType:AlertViewUpdate updateInfo:dic];
}

- (void)hasNoVersionUpdate:(NSString *)reason userData:(NSString *)userData
{
    if (userData) {
        // 设置点击更新触发事件
        maskAlertView.hidden = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:reason delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 跳转appstore
- (void)openAppWithIdentifier:(NSNotification *)note {

    statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        storeNo = note;
        
        NSString *appId = note.object;
        
        if (appId) {
            SKStoreProductViewController *storeProductVC = [SKStoreProductViewController new];
            storeProductVC.delegate = self;
            
            if (IOS7) {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
                [self presentViewController:storeProductVC animated:YES completion:^{
                    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
                    }];
                }];
                
            }else
            {
                NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    });
}

- (void)storeLoadingTimeout
{
    if (loadType == LOADING) {
        touchGoDetailsHidden = YES;
        [self showDetailsState:FAILD];
    }
}
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    statusBarView.backgroundColor = [UIColor clearColor];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HomeViewControllerDelegate
- (void)statusBarStyle:(UIStatusBarStyle)barStyle
{
    sBarStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)removeLanuchImageView
{
    [launchImgView removeFromSuperview];
    launchImgView = nil;
}

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return sBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end

