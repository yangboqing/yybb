//
//  AppStoreDownload.h
//  testLoginAppStore
//
//  Created by liull on 13-10-15.
//  Copyright (c) 2013年 kydesktop. All rights reserved.
//

#import <Foundation/Foundation.h>


/**实现AU和CU
 
 通过页面plist文件中指定的下载类型，分为
 (1)默认
    下载plist中指定的ipa,直接安装
 
 (2)AU
    通过PC端写入账号信息从appstore下载。如果下载失败，通过getBuyAppInfo返回信息中ipa和sinf文件地址来下载。
 
    优化实现:
    1.从getBuyAppInfo返回信息中ipa和sinf文件地址来下载
    2.登陆appstore并获取购买信息
    3.如果成功，则中断1过程，从appstore断点续传。否则一直持续1过程
 
 (3)CU
    直接从 另外接口 返回信息中ipa和sinf文件地址来下载。
 
 */


typedef enum _downloadType {
 DOWNLOAD_DEFAULT = 0,
 DOWNLOAD_CU = 1,
 DOWNLOAD_AU = 2,
 DOWNLOAD_EU = 3
}downloadType;

#define DOWNLOAD_AU_SUCCESS   0
#define GET_BUYINFO_ERROR 1

@interface AppStoreDownload : NSObject
@property (nonatomic , retain) NSString *md5Str;
@property(nonatomic, assign)BOOL isLogin;
@property(nonatomic, assign)BOOL isBuy;
@property(nonatomic, assign)BOOL isClean;
@property(nonatomic, assign)BOOL isgetInfo;


@property(nonatomic, retain) NSString *currentAppid;

/**
 通过AU的方式下载
 */
-(NSUInteger)downloadIPAByAU:(NSString*)appid downloadType:(NSString *)type download:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader;





/**组装ipa
 
 ipa下载完毕后，需要进一步处理，增加sinf文件。
 
 @param ipaPath ipa的路径
 @param appid ipa的appid
 @param type 下载类型
 */
-(BOOL)packageIPA:(NSString*)ipaPath appid:(NSString*)appid type:(downloadType)dtype;


@end