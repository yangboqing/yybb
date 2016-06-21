//
//  encryAppID.h
//  browser
//
//  Created by liull on 15-2-11.
//
//

//#ifndef __browser__encryAppID__
//#define __browser__encryAppID__

#include <stdio.h>


@interface DecryAppID : NSObject

//解密Appid
+(NSString*)DecryAppID:(NSString*)appid;

//是否为加密后的appid验证
+(BOOL)enAppIDCheck:(NSString*)enAppid;

//是否为解密后的appid验证
+(BOOL)deAppIDCheck:(NSString*)enAppid;

//取得解密后的Appid 索引部分
+(NSInteger)getAppIDPart_Index:(NSString*)decAppID;

//取得解密后的Appid 伪AppID部分
+(NSString*)getAppIDPart_AppID:(NSString*)decAppID;

+(NSString*)getBundlePesudoAppID;

+(NSString*)getPseudoAppID:(NSString*)enAppID;

@end



//#endif /* defined(__browser__encryAppID__) */
