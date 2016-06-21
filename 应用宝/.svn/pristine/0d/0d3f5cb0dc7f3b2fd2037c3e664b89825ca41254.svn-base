//
//  IphoneAppDelegate.h
//  browser
//
//  Created by 毅 王 on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PCServer.h"
#import "SearchServerManage.h"
#import "PhotosAlbumManager.h"
#import "BppDistriPlistManager.h"
#import "SelfSettingViewController.h"
#import "EnableView.h"

#define   browserAppDelegate ((IphoneAppDelegate *)[UIApplication sharedApplication].delegate) 


@interface IphoneAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate, WeiboSDKDelegate,PCServerDelegate,SaveUtilDelegate, BppDistriPlistManagerControlDelegate>{
    PCServer * server;
    PhotosAlbumManager *photosAlbumManager;
//@public
//    UIWindow * yindao;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger shareID;

@property (assign, nonatomic) NSInteger sslPort;
@property (assign, nonatomic) NSInteger webserverPort;

@property (nonatomic , strong) NSMutableArray * installingAppIDs;

@property (assign, nonatomic) BOOL isBackGround;
@property (nonatomic , strong) EnableView *yindaoWindow;


@property (nonatomic,assign) BOOL isSafeURL;//是否安全包

@property (strong, nonatomic) NSNotification *note;

-(BOOL)isAppNeedsSystemVersionValid:(NSString *)minSysVer;// 要下载的应用程序是否可以运行在本机系统

-(void)addDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo;

-(void)add3GFreeFlowDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo;

- (void)downloadIPAByPlistURL:(NSString*)distriPlist;

//安装闪退修复
-(void)installFix;
//创建引导图
- (void)creatCustomWindow;
@end
