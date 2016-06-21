//
//  GetDevIPAddress.h
//  browser
//
//  Created by 王 毅 on 13-7-22.
//
//

#import <Foundation/Foundation.h>

@interface GetDevIPAddress : NSObject
+(GetDevIPAddress *) getObject;
- (void)reportInstallAPPID: (NSString *)appId appName:(NSString *)appName appVersion:(NSString *)appVer;
- (void)reportUpdataAppID:(NSString *)appId AppName:(NSString *)appName AppVersion:(NSString *)appVersion;
//删除上报统计数据
- (BOOL)deleteInstallReportData:(NSString *)appid;


//openurl方式安装
- (void)localReportInstallAPPID: (NSString *)appId appName:(NSString *)appName appVersion:(NSString *)appVer dlfrom:(NSString *)dlfr downloadUrl:(NSString *)downloadUrl;
@end
