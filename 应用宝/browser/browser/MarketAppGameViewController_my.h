//
//  MarketAppViewController.h
//  browser
//
//  Created by liguiyang on 14-9-24.
//
//

#import <UIKit/UIKit.h>
#import "ClassificationBackView.h"
typedef enum{
    marketType_App = 300,
    marketType_Game
}MarketType;


@protocol MarketAppGameDelegate <NSObject>

- (void)presentClassifyViewController:(NSString*)classifyName;

@end

@interface MarketAppGameViewController_my : UIViewController

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic , retain) ClassificationBackView*backview;
@property (nonatomic , weak) id<MarketAppGameDelegate>delegate;

-(id)initWithMarketType:(MarketType)mType;
-(void)requestAll; //仅执行一次

@end
