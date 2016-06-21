//
//  TopAppGameViewController.h
//  MyHelper
//
//  Created by 李环宇 on 14-12-31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketAppGameViewController_my.h"

typedef enum{
    top_app = 111,
    top_game,
}TopType;
@interface TopAppGameViewController : UIViewController{
NSMutableArray *_dataArr;
    BOOL _App;
    NSString*classState;

}
@property (nonatomic,retain)MarketAppGameViewController_my *parentVC;
-(void)initTopRequest;
-(void)appJudge:(TopType)state;

@end
