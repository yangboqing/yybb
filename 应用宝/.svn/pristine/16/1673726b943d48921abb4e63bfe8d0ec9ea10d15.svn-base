//
//  SearchResult_DetailTableViewController.h
//  browser
//
//  Created by caohechun on 14-4-2.
//
//

#import <UIKit/UIKit.h>
#import "AppDetailView.h"
#import "AppInforView.h"
#import "AppInforFootView.h"
#import "MarketServerManage.h"
#import "AppTestTableViewController.h"
#import "SearchResult_DetailViewController.h"
#import "AppRelevantTableViewController.h"
#import "MyServerRequestManager.h"

//单个app的详情表视图
@class SearchResult_DetailViewController;
@interface SearchResult_DetailTableViewController : UITableViewController<UIWebViewDelegate,UIScrollViewDelegate,SearchServerManageDelegate,SearchManagerDelegate,MyServerRequestManagerDelegate>
@property (nonatomic,retain)UIButton *detailsButton;//点击打开详情页签
@property (nonatomic,retain)UIButton *discussButton;//点击打开评论页签
@property (nonatomic,retain)UIButton *relevantAppsButton;//点击打开相关评论页签
@property (nonatomic,retain)UIButton *testButton;//点击打开评测活动页签
@property (nonatomic,retain) AppInforView *headView;
@property (nonatomic,retain) AppDetailView *appDetailView;
@property (nonatomic,retain) NSMutableArray *appCache;
@property (nonatomic,retain)SearchResult_DetailViewController *parentVC;
@property (nonatomic,retain) NSString *detailSource;//来源
@property (nonatomic,assign)BOOL isPreviewSizeFixed;
@property (nonatomic,retain) NSString *mianLiuPlist;//免流plist


//搜索结果列表选中应用后,请求应用详情
- (void)prepareAppContent:(NSString *)appID pos:(NSString *)pos;
//显示详情页签
- (void)showDetailsPage;
//初始化详情页;
- (void)initDetailPage;
//点返回按钮时详情页置空

- (void)unloadData;
//收起更多
- (void)recoverDetail;
//相关应用置空
- (void)setRelevantAppsNil;
//相关应用frame置0
- (void)setRelevantSizeZero;
//点赞
- (void)promoteApp;

//获取到活动
- (AppTestTableViewController *)getTestTableViewController;
////获取到相关应用
//- (AppRelevantTableViewController *)getRelevantTableViewController;
@end
