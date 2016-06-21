//
//  HotWordHomeViewController.m
//  HotWordSearch
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "SearchHotWordHomeViewController.h"
#import "HotWordView.h"
#import "SearchServerManage.h"
#import "CollectionViewBack.h"

#define VIEW_WIDTH  self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height

@interface SearchHotWordHomeViewController ()<HotWordViewDelegate,SearchServerManageDelegate>
{

    // 搜索热词首页
    UIImageView *shakeImageView;
    HotWordView *hotWordView;
    UIView *homeView;
    SearchServerManage *searchManage;
    
    CollectionViewBack * _backView;
}
@end

@implementation SearchHotWordHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{// 防止初始化是使用 init
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchManage = [[SearchServerManage alloc] init];
        searchManage.delegate = self;
        
        // 搜索热词主UI
        homeView = [self createSearchHotWordsHomeView];
        homeView.hidden = YES;
        self.isHotWordHomeViewHidden = YES;
        
        // 设置UI Frame值
        [self setCustomFrame];
        
        [self.view addSubview:homeView];
        
        //加载中
        __weak typeof(self) mySelf = self;
        _backView = [CollectionViewBack new];
        [self.view addSubview:_backView];
        [_backView setStatus:Hidden];
        [_backView setClickActionWithBlock:^{
            [mySelf performSelector:@selector(failedImageViewAction:) withObject:nil afterDelay:delayTime];
        }];
    }
    return self;
}

-(id)initWithHotWords:(NSArray *)hotWords
{
    self = [super init];
    if (self) {
        // 展示首页
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHotWordUserInterfaceWithArray:) name:@"initHotWordView" object:nil];
        [self showHomeView];
    }
    return self;
}
#pragma mark - show UI methods
-(void)showHomeViewWithSearchWords:(NSArray *)wordArr
{
    [self showHomeView];
    [hotWordView setLabelTextWithWords:wordArr];
}
-(void)showHomeView
{
    self.isHotWordHomeViewHidden = NO;
    homeView.hidden = NO;
    
    [_backView setStatus:Hidden];
}
-(void)showLoadingView
{
    self.isHotWordHomeViewHidden = YES;
    homeView.hidden = YES;
    
    [_backView setStatus:Loading];
}

-(void)showFailedView
{
    self.isHotWordHomeViewHidden = YES;
    homeView.hidden = YES;
    
    [_backView setStatus:Failed];
}

-(void)setHotWordUserInterfaceWithArray:(NSNotification *)notify
{
    if (notify.object) {
        _backView.status = Hidden;
        [hotWordView setLabelTextWithWords:notify.object];
    }
    else
    {
        _backView.status = Failed;
        [self showFailedView];
    }
}
#pragma mark - Utility

-(void)initilizationRequestHotWord
{
    _backView.status = Loading;
    [[SearchManager getObject] initHotWord];
}

-(void)reloadHotWordRequest
{
    [searchManage requestHotWord:NO];
    self.isHotWordDataReturn = NO; // 热词数据是否返回
    self.isShakedForReturn = NO; // 热词返回后是否震动过
    [self showLoadingView];
}
-(void)failedImageViewAction:(id)sender
{
    self.isShaking = NO;
    [self reloadHotWordRequest];
}
-(void)setCustomFrame
{
    // home frame
    CGFloat topHeight = 19;
    homeView.frame = CGRectMake(0, topHeight, VIEW_WIDTH, VIEW_HEIGHT-topHeight-44);
    
    // home View
    hotWordView.frame = CGRectMake(0, 0, homeView.frame.size.width, 105);
    shakeImageView.frame = CGRectMake((VIEW_WIDTH-114)*0.5, 175, 114, 140.5);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect tmpFrame = self.view.bounds;
//    tmpFrame.origin.y += 2.5;
    tmpFrame.origin.y -= 7.5;
    _backView.frame = tmpFrame;
}

-(void)sharkPhone
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(BOOL)checkData:(NSArray *)data
{
    BOOL hotFlag = NO;
    if (IS_NSARRAY(data) && data.count>=9) {
        for (int i=0; i < 9 ;i++) {
            if (IS_NSSTRING(data[i])) {
                hotFlag = YES;
            }
            else
            {
                hotFlag = NO;
                break;
            }
        }
    }
    
    return hotFlag;
}
#pragma mark - Create UI methods
-(UIView *)createSearchHotWordsHomeView
{
    UIView *localHomeView = [[UIView alloc] init];
    // 显示搜索热词View
    hotWordView = [[HotWordView alloc] init];
    hotWordView.delegate = self;
    [localHomeView addSubview:hotWordView];
    
    // 震动图片
//    UIImage *img = [UIImage imageNamed:@"shake.png"];
    shakeImageView = [[UIImageView alloc] init];
    SET_IMAGE(shakeImageView.image, @"shake.png");
    [localHomeView addSubview:shakeImageView];
    
    return localHomeView;
}

#pragma mark - SearchServerManageDelegate
-(void)getSearchHotWord:(NSArray *)hotArray
{
    if ([self checkData:hotArray]) {
        [hotWordView setLabelTextWithWords:hotArray];
        self.isHotWordDataReturn = YES;
        
        if (!_isShaking && !_isShakedForReturn) {
            [self performSelector:@selector(sharkPhone) withObject:nil afterDelay:0.3f];
            [self performSelector:@selector(showHomeView) withObject:nil afterDelay:0.5f];
            self.isShakedForReturn = YES;
        }
    }
    else
    {
        [self showFailedView];
    }
}
-(void)searchHotWordRequestFail
{
    [self showFailedView];
}
#pragma mark - HotWordsHomePageViewDelegate
-(void)aHotWordHasBeenSelected:(NSString *)hotWord
{
    if ([self.delegate respondsToSelector:@selector(hotWordHasBeenSelected:)]) {
        [self.delegate hotWordHasBeenSelected:hotWord];
    }
}
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
