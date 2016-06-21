//
//  KyMarketNavgationController.h
//  browser
//
//  Created by niu_o0 on 14-5-22.
//
//市场导航控制器

#import <UIKit/UIKit.h>
#import "KyMarketViewController.h"
#import "MarketServerManage.h"
#import "RotatingLoadView.h"
#import "CategoryViewController.h"
#import "CategoryListViewController.h"
@interface KyMarketNavgationController : UIViewController<MarketServerDelegate,MarketNavDelegate>
{
    @public
    CategoryViewController *categoryViewController;
    KyMarketViewController * _marketViewController;

}
 enum{
    GAMEBUTTON_TAG = 100,
     APPBUTTON_TAG
};

@property (nonatomic,retain)RotatingLoadView *rotatingLoadView;
@property (nonatomic,retain)UIView *BG;//加载数据时的背景view
- (void)showCategory:(id)obj;//显示分类视图
@end
