//
//  KY_UpdataSDK.h
//  browser
//
//  Created by 王毅 on 14-3-5.
//
//

#import <Foundation/Foundation.h>
@protocol UpdataDelegate <NSObject>

- (void) checkResult:(BOOL)result forceupdate:(BOOL)force;

- (void) updateInfo:(NSArray *)infoArray updateVersion:(NSString *)version;

- (void) happenError:(NSError *)error;

@end
@interface KY_UpdataSDK : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic, weak) id<UpdataDelegate>updataDelegate;

- (void) checkVersionOfAppId:(NSString *)appId nowVersion:(NSString *)version;

- (void) setTimeOut:(int)flag;

- (void) installNewVersion;

@end
