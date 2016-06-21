//
//  IPhoneBrowserViewController.h
//  browser
//
//  Created by 呼啦呼啦圈 on 12-9-28.
//
//

#import <UIKit/UIKit.h>
#import "ResourceHomePageViewController.h"
#import "FlashQuitRepairView.h"
//#import "IOSTransProxy.h"
#import "BackgroundDownloadAlertView.h"
#import "PromptBoxView.h"
#import "PromptBoxView_newVersion.h"
#import "dowloadCompetAlertView.h"
#import "PopViewController.h"
#import "RealtimeShowAdvertisement.h"
#import "AfterLaunchPopView.h"
#import "BlackCoverBackgroundView.h"
#import "AuthorizationGuideViewController.h"
#import "LoginCancellationView.h"
#import "MumView.h"
#import "LoginServerManage.h"
#import "GuideView.h"
#import "RequestAppidResultView.h"
#import "AppidAlert.h"

@interface ResourceIPhoneBrowserViewController : UIViewController<RHomePageMainVCDelegate,downAlertViewDelegate,UIAlertViewDelegate,lessonDelegate,requestRealtimeShowDelegate,AuthorizationDelegate,MumDelegate,AppidResultDeletate>{

    //快用市场
    ResourceHomePageViewController *_homePageViewController;
    //闪退修复页面
    FlashQuitRepairView *flashQuitRepairView;
    //开启背景音乐时的提示框
    BackgroundDownloadAlertView *backgroundDownloadAlertView;
    //无自更新时的提示框
    PromptBoxView * boxView;
    //有自更新时的提示框
    PromptBoxView_newVersion * boxView_newVersion;
    //下载完成时的弹框
    dowloadCompetAlertView *_dowloadCompetAlertView;
    //市场-分类全屏遮黑框
     BlackCoverBackgroundView *blackCover ;
    
    //注销账号
    LoginCancellationView *loginCancellationView;
    
    MumView *mumView;
    GuideView *guideView;
    RequestAppidResultView *appidResultView;

    @public
    AfterLaunchPopView *tmpPopView;
}
@end