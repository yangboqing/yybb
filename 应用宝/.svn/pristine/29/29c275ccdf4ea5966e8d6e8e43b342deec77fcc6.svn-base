//
//  ResourceHomeViewController.h
//  MyAssistant
//
//  Created by liguiyang on 14-11-18.
//  Copyright (c) 2014年 myAssistant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallPaperListViewController.h" // 壁纸
#import "MyServerRequestManager.h"
#import "LoginCancellationView.h"
#import "MumView.h"
#import "GuideView.h"
#import "RequestAppidResultView.h"
#import "AfterLaunchPopView.h"
@interface ResourceHomeViewController : UIViewController<MumDelegate,AppidResultDeletate,MyServerRequestManagerDelegate,UIAlertViewDelegate>{
    //注销账号
    LoginCancellationView *loginCancellationView;
    
    MumView *mumView;
    GuideView *guideView;
    RequestAppidResultView *appidResultView;
    
@public
    AfterLaunchPopView *tmpPopView;
}


-(void)homeBottomToolBarItemClick:(HomeToolBarItemType)barItemType;
@end
