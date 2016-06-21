//
//  GoodAppGameViewController.h
//  MyHelper
//
//  Created by 李环宇 on 15-1-20.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketAppGameViewController_my.h"
#import "MyCollectionViewFlowLayout.h"
#import "PublicCollectionCell.h"
#import "TopFirstAppGameCell.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingCollectionCell.h"
#import "UIWebViewController.h"
#import "TopicDetailsViewController.h"//专题详情
#import "FindDetailViewController.h" // 发现详情页
// 轮播图
#import "CarouselView.h"
#import "AppStatusManage.h"
#import "SearchResult_DetailViewController.h"
typedef enum{
    good_app = 411,
    good_game,
}GoodType;

@protocol GoodAppGameViewDelegate <NSObject>

-(void)GoodNavControllerPushViewController:(UIViewController *)viewController;

@end

@interface GoodAppGameViewController : UIViewController{
    NSMutableArray *_dataArr;
    BOOL _App;
    NSString*classState;
    
}
@property (nonatomic, weak) id <GoodAppGameViewDelegate>delegate;

-(void)initGoodRequest;
-(void)appJudge:(GoodType)state;


@end
