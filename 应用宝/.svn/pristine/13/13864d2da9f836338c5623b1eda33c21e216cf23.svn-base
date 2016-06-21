//
//  BppStoreBrowserAppDelegate.h
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
#import "UpdateAppManager.h"


#define   browserAppDelegate ((BppStoreBrowserAppDelegate *)[UIApplication sharedApplication].delegate) 


@interface BppStoreBrowserAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate, WeiboSDKDelegate,PCServerDelegate,SaveUtilDelegate>{
    PCServer * server;
    PhotosAlbumManager *photosAlbumManager;
@public
    UIWindow * yindao;
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger shareID;



-(void)addDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo;

-(void)add3GFreeFlowDistriPlistURL:(NSString*)distriPlistURL   appInfo:(NSDictionary*)appInfo;

- (void)downloadIPAByPlistURL:(NSString*)distriPlist;

@end
