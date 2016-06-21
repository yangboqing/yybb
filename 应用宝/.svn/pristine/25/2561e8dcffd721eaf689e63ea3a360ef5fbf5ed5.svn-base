//
//  CategoryListViewController.h
//  browser
//
//  Created by caohechun on 14-6-20.
//
//


//某一个小分类下的应用列表或搜索结果列表

#import <UIKit/UIKit.h>
#import "SearchResultTabelViewController.h"
#import "RotatingLoadView.h"
@class KyMarketNavgationController;
@protocol MarketNavDelegate<NSObject>
- (void)showCategory:(id)obj;
@end

@interface CategoryListViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic,strong)SearchResultTabelViewController *detailListTableViewController;
//设置列表的分类标题
@property (nonatomic,retain)NSString *target;//search,market
@property (nonatomic,retain)NSString *categoryName;
@property (nonatomic,retain)NSString *searchContent;
@property (nonatomic,weak)id<MarketNavDelegate>marketNavDelegate;
-(void)showSearchListFailedView;
- (void)showCategoryLoadingView;
- (void)showCategoryListTableView;
- (void)setNavTitle:(NSString *)titile;
@end
