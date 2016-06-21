//
//  AppUpdateNewVersion.h
//  browser
//
//  Created by liull on 14-8-29.
//
//

#import <Foundation/Foundation.h>


@protocol AppUpdateNewVersionProtocol <NSObject>

//请求最新版本信息成功
-(void)AppUpdateNewVersionSuccess:(NSDictionary*)data userinfo:(id)userinfo;
//请求失败
-(void)AppUpdateNewVersionFail:(NSDictionary*)data userinfo:(id)userinfo;

@end

@interface AppUpdateNewVersion : NSObject

+(id)shareInstance;

//更新新的版本
-(void)udpateNewVersion:(id<AppUpdateNewVersionProtocol>)delegate  userinfo:(id)userinfo;

//获取3Klite版ipa文件下载地址
- (void)requestKKKDownloadAdress;
@end
