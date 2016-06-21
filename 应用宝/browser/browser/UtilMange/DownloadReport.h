//
//  DownloadReport.h
//  browser
//
//  Created by 王毅 on 13-12-25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "DESUtils.h"

//行为类型,下载行为填download 安装行为为install
#define REPORT_TYPE                         @"report"
//结果: success, fail, pause, click(OTA安装方式)
#define REPORT_RESULT                       @"result"
//来源
#define REPORT_DLFROM                       @"dlfrom"
//下载AppID
#define REPORT_APPID                        @"appid"
//下载应用的版本号
#define REPORT_APPVERSION                   @"appver"

//开始接收时间
#define REPORT_BTICK                        @"btick"
//结束接收时间
#define REPORT_ETICK                        @"etick"
//总的接收时间长度
#define REPORT_TOTAL_TICK                  @"ttick"

//开始时文件长度
#define REPORT_B                            @"b"
//结束时文件长度
#define REPORT_E                            @"e"

//下载文件的URL
#define REPORT_URL                          @"url"

#define REPORT_AULOGIN                      @"aulogin"
#define REPORT_AUBUY                            @"aubuy"
#define REPORT_AUCLEAN                      @"auclean"
//IPA下载类型企签，AU，EU
#define REPORT_IPA_DOWNLOAD_TYPE            @"downloadtype"
//IPA的URL
#define REPORT_IPA_DOWNLOAD_URL            @"ipaurl"


//下载应用错误原因
#define REPORT_ERROR_TYPE           @"errortype"
//下载失败后服务器返回码
#define REPORT_ERROR_SERVER_RESPONSE_CODE  @"responsecode"
//下载失败后，文件用于比对的MD5
#define REPORT_MD5                  @"filemd5"
//下载失败后，错误的MD5
#define REPROT_IPA_ERROR_MD5    @"errormd5"

//是否有跳转
#define REPROT_HAS_URL_JMP         @"hasjmp"
//跳转后地址
#define REPROT_URL_JMP_ADDRESS     @"jmpurl"
//服务器的IP地址
#define REPROT_URL_CDN_IP_ADDRESS  @"peerip"





@interface DownloadReport : NSObject


+ (DownloadReport *)getObject;

- (BOOL)checkPlistFile;

//保存数组
- (void) writePListToFile:(NSArray *)updatalist;

//获取文件夹的最外层数组
- (NSMutableArray *)getReportFileArray;

//通过appid删除
-(void)deleteItemInfoByAppID:(NSString *)appid;

//获取相应的字典， 通过AppID
- (NSMutableDictionary *)getReportFileDicByAppID:(NSString *)appid;
//获取相应的字典， 通过distriPlist
- (NSMutableDictionary *)getReportFileDicByDistriPlist:(NSString *)distriPlist;

//索引
- (NSUInteger) IndexOfDownloadedAppid:(NSString*)appid;

//更新内容，没有则添加
-(void)updateReportFile:(NSDictionary*)dicFileInfo;

//删除
-(BOOL)deleteDownloadedAppID:(NSString*)appid;


//获取当前时间戳
- (NSString *)getUnixTime;

//获取文件路径
- (NSString *)getReportFilePath;

- (void)downloadReportByAppId:(NSString *)appID;

- (void)downloadReportByDistriPlist:(NSString *)distriPlist;
//用Openurl方式的下载
- (void)localdownloadReportByAppId:(NSString *)appID appVersion:(NSString *)version dlfrom:(NSString *)dlfr appUrl:(NSString *)appUrl;
@end
