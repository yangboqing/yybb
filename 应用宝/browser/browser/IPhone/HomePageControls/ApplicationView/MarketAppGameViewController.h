//
//  MarketAppViewController.h
//  browser
//
//  Created by liguiyang on 14-9-24.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    marketType_App = 300,
    marketType_Game
}MarketType;

@interface MarketAppGameViewController : UIViewController

@property (nonatomic, strong) UINavigationController *navigationController;

-(id)initWithMarketType:(MarketType)mType;
-(void)requestAll; //仅执行一次

@end
