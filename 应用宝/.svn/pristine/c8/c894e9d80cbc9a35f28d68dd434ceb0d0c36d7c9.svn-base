//
//  NewAppGameViewController.h
//  MyHelper
//
//  Created by 李环宇 on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketAppGameViewController_my.h"
typedef enum{
    mark_app = 101,
    mark_game,
}AppGameType;

@interface NewAppGameViewController : UIViewController{
    NSMutableArray*_appDataArr;
    NSMutableArray*_gameDataArr;
    NSString*classState;
}
@property (nonatomic,retain)MarketAppGameViewController_my *parentVC;
-(void)initTopRequest;
-(void)appJudge:(AppGameType)state;
@end
