//
//  KyMarketViewController.h
//  browser
//
//  Created by 王毅 on 14-5-19.
//
//

#import <UIKit/UIKit.h>
#import "ChoiceViewController.h"
#import "MarketAppGameViewController.h"
#import "WallPaperViewController.h"
#import "CategoryViewController.h"
#import "Market_top_bar.h"
#import "BlackCoverBackgroundView.h"
@class KyMarketNavgationController;
@interface KyMarketViewController : UIViewController{
    ChoiceViewController * _choiceViewController;
    MarketAppGameViewController * _appViewController;
    MarketAppGameViewController * _gameViewController;
    WallPaperViewController *_wallPaperViewController;
    CategoryViewController *categoryViewController;
    
    @public
    UINavigationController * _marketNavgationController;
}
@property (nonatomic,strong)    Market_top_bar  * topbar;
@property (nonatomic,retain)KyMarketNavgationController *marketNav;
//设置遮黑是否可点击
- (void)setBlackCoverEnabled:(BOOL)enabled;
@end
