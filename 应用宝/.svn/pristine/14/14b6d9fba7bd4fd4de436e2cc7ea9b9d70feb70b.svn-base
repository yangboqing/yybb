//
//  BppDownloadToLocal.h
//  browser
//
//  Created by 王毅 on 13-11-6.
//
//

#import <Foundation/Foundation.h>

@interface BppDownloadToLocal : NSObject


@property (nonatomic, retain)  NSString * plistURL;           //plist文件URL
+ (BppDownloadToLocal *)getObject;

//收集plist地址用于解析发安装日志
- (BOOL)downLoadPlistFile:(NSString *)plistUrl;

//对于不是快用库的plist进行获取
- (NSString *)getIpaPlist:(NSString *)appId;
@end
