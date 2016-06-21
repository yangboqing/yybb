//
//  WallPaperViewController.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperViewController.h"
#import "WallPaperTopView.h"
#import "WallPaperListViewController.h"
#import "WallPaperClassifyViewController.h"
#import "WallpaperInfoViewController.h"


BOOL datu = NO;

@interface WallPaperViewController ()<WallPaperListViewDelegate,wallpaperInfoCollectDelegate>
{
    WallPaperTopView *wallPaperTopView;
    WallPaperListViewController *wallPaperListVC;
    WallPaperClassifyViewController *wallPaperClassifyVC;
}

@end

@implementation WallPaperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Utility

-(void)requestDefaultData
{
    [wallPaperListVC initRequest];
}

-(void)TopBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == TAG_LATESTBTN) {
        wallPaperListVC.view.hidden = NO;
        wallPaperClassifyVC.view.hidden = YES;
    }
    else
    {
        wallPaperListVC.view.hidden = YES;
        wallPaperClassifyVC.view.hidden = NO;
        [wallPaperClassifyVC reloadCollectionView];
        //
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [wallPaperClassifyVC initClassifyRequest];
        });
    }
}

-(void)hideNavBottomBar:(BOOL)flag
{
    self.navigationController.navigationBar.hidden = flag;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDETABBAR object:[NSNumber numberWithBool:flag]];
}

#pragma mark - WallPaperListViewDelegate

-(void)wallPaperListView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index Items:(NSMutableArray *)items NextPageUrl:(NSString *)nextPageUrl from:(NSString *)source
{
    WallpaperInfoViewController *wallPaperInfoVC = [[WallpaperInfoViewController alloc] init];
    wallPaperInfoVC.delegate = self;
    [wallPaperInfoVC setCollectItems:[items mutableCopy] currentItme:index prevAddress:nil nextAddress:nextPageUrl from:source];
    if (datu) [[NSNotificationCenter defaultCenter] postNotificationName:@"datu" object:nil];
    [self.navigationController pushViewController:wallPaperInfoVC animated:NO];
    datu = YES;
    
    [self hideNavBottomBar:YES];
}

#pragma mark - WallPaperClassifyViewDelegate

-(void)wallPaperClassifyView:(UICollectionView *)collectionView desktopViewDataManage:(DesktopViewDataManage *)dataManage didSelectItem:(NSDictionary *)itemDic
{
//    WallPaperListViewController *listVC = [[WallPaperListViewController alloc] initWallPaperList:[itemDic objectForKey:@"url"] dataManage:dataManage];
//    listVC.delegate = self;
//    listVC.navigationItem.title = [itemDic objectForKey:@"name"];
//    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - wallpaperInfoCollectDelegate

-(void)notifitionInterfaceReloadArray:(NSMutableArray *)array current:(NSUInteger)index nextUrlAdress:(NSString *)next lastRequest:(NSString *)str
{
    BOOL latestFlag = YES;
    for (UIViewController *viewController in _navigationController.viewControllers) {
        if ([viewController isMemberOfClass:[WallPaperListViewController class]]) {
            [((WallPaperListViewController *)viewController) scrollToIndex:index byData:array nextPageUrl:next lastReqUrl:str];
            latestFlag = NO;
            break;
        }
    }
    
    if (latestFlag) {
        [wallPaperListVC scrollToIndex:index byData:array nextPageUrl:next lastReqUrl:str];
    }
    [self.navigationController popViewControllerAnimated:NO];
    datu = NO;
    if(IOS7){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self hideNavBottomBar:NO];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // initilization
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
	
    // subViews
    wallPaperTopView = [[WallPaperTopView alloc] init];
    [wallPaperTopView.latestBtn addTarget:self action:@selector(TopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wallPaperTopView.classifyBtn addTarget:self action:@selector(TopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    wallPaperListVC = [[WallPaperListViewController alloc] initWallPaperList:nil dataManage:nil];
//    wallPaperListVC.delegate = self;
//    
//    wallPaperClassifyVC = [[WallPaperClassifyViewController alloc] init];
//    wallPaperClassifyVC.delegate = self;
//    wallPaperClassifyVC.view.hidden = YES;
//    
//    [self.view addSubview:wallPaperListVC.view];
//    [self.view addSubview:wallPaperClassifyVC.view];
//    [self.view addSubview:wallPaperTopView];
    // setFrame
    [self setLayoutSubViewFrame];
}

-(void)setLayoutSubViewFrame
{
    CGFloat topHeight = (IOS7)?44:0;
    CGFloat width = self.view.frame.size.width;
    wallPaperTopView.frame = CGRectMake(0, topHeight, width, 34);
    wallPaperListVC.view.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    wallPaperClassifyVC.view.frame = wallPaperListVC.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
