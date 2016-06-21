//
//  DESUtils.h
//  KY_PaySDK
//
//  Created by 呼啦呼啦圈 on 13-6-13.
//  Copyright (c) 2013年 吕冬剑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileUtil.h"

@interface DESUtils : NSObject

//+(DESUtils *)instance;

//解密
+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

//加密
+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

//MD5
+ (NSString *)getMD5:(NSString *)str;

//md5加密串
+ (NSString *)getMD5Str:(NSDictionary *)map;

//http转码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString *) macaddress;

+ (NSString *) getIDFA;
@end
