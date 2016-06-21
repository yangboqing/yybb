//
//  CategoryViewController.h
//  browser
//
//  Created by caohechun on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "MarketServerManage.h"
#import "SearchServerManage.h"
#define SHOW_TIME 0.6
#define HIDE_TIME 0.4
@interface CategoryViewController : UIViewController<MarketServerDelegate>
- (void)requestCategoryData:(NSString *)gameOrApp;
- (void)setScrollViewLock:(BOOL)lock;//是否禁止游戏和应用scrollview的点击
- (NSString *)getCurrentSearchKey;
- (void)showAppOrGameCategory:(NSString *)gameOrApp;
- (void)setCategory:(NSString *)gameOrApp withData:(id)data;
- (void)lockUserInterActive:(BOOL)lock;

- (void)loadingData;
- (void)loadingDataSuccess;
- (void)loadingDataFailed;
@end
