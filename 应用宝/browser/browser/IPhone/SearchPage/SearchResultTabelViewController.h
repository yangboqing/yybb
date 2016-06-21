//
//  SearchRuseltTabelViewController.h
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//搜索完成时显示结果的控制器的表视图

#import <UIKit/UIKit.h>
#import "SearchServerManage.h"
#import "SearchManager.h"
#import "MarketServerManage.h"
#import "EGORefreshTableHeaderView.h"
@class SearchResult_DetailViewController;
@class CategoryListViewController;

//点击搜索结果某一个app cell时,切换视图到其详情页
@protocol PresentViewDelegate<NSObject>
- (void)presentDetailView:(SearchResult_DetailViewController *)detailViewController;
@end


@interface SearchResultTabelViewController : UITableViewController<SearchManagerDelegate,MarketServerDelegate,EGORefreshTableHeaderDelegate>
@property (nonatomic,weak)id<SearchServerManageDelegate>searchServerManageDelegate;
@property (nonatomic,weak)id<PresentViewDelegate>presentViewDelegate;
@property (nonatomic,weak)id<MarketServerDelegate>marketServerDelegate;
@property (nonatomic,strong) CategoryListViewController *parentCategoryListViewController;
@property (nonatomic,retain)NSString *target;//用于区分列表用于搜索还是市场


- (void)showSearchResult:(NSArray *)result isNextData:(BOOL)nextData searchContent:(NSString *)searchContent;
- (BOOL) hasExistData;
- (NSString *)getLastSearchContent;
- (void)setRefreshCellText:(NSString *)content andActivityHiden:(BOOL)isHiden searchLock:(BOOL)isLocked;
//- (void)clearImgCache;//清空图片缓存
- (void)setInforNil;//清空信息
- (void)refreshDataComplete;//恢复下拉刷新状态

@end
