//
//  MyUpdateSelfManager.h
//  MyHelper
//
//  Created by liguiyang on 14-12-27.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPDATE_APPSTORE @"appStore"
#define UPDATE_OTATYPE @"ota"
#define KEY_FORCEUPDATE @"forcedupgrade"

@protocol MyUpdateSelfManagerDelegate <NSObject>

- (void)hasNewVersion:(NSDictionary *)dic userData:(NSString *)userData;
- (void)hasNoVersionUpdate:(NSString *)reason userData:(NSString *)userData;

@end

@interface MyUpdateSelfManager : NSObject<UIAlertViewDelegate>

@property (nonatomic, weak) id <MyUpdateSelfManagerDelegate>delegate;

+ (MyUpdateSelfManager *)instance;
- (void)detectVersionOfMyHelper:(NSString *)userData;

@end
