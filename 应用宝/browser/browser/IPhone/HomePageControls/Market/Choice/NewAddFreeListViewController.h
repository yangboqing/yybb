
//  新增功能区免费页面

#import <UIKit/UIKit.h>
#import "MarketListViewController.h"
#import "MarketServerManage.h"

typedef enum{
    FreeType_App = 500,
    FreeType_Game
}FreeType;

@interface NewAddFreeListViewController : UIViewController<MarketServerDelegate,MarketListViewDelegate>


@end
