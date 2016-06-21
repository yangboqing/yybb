//
//  FileUtil.h
//  browser
//
//  Created by 王 毅 on 12-11-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "DESUtils.h"
#include <sys/sysctl.h>

@interface FileUtil : NSObject{

}
+ (FileUtil *)instance;

//文件是否存在
-(BOOL)isExistFile:(NSString *)path;

//得到document目录路径
-(NSString *)getDocumentsPath;
-(NSString *)getLibraryPath;

//加密
- (NSString*)base64Str:(NSString*)plainText;
//解密
- (NSString*)unbase64Str:(NSString*)plainText;


//检测网络连接状态
-(NSString*) GetCurrntNet;

//获取设备本地MAC地址
- (NSString *) macaddress;

//返回UDID
- (NSString *)getDeviceFileUdid;
//获取IDFA
- (NSString *)getDeviceIDFA;
//url编码
- (NSString *)urlEncode:(NSString *)str;
- (NSString *)encodeToPercentEscapeString: (NSString *) input;
//url解码
- (NSString *)urlDecode:(NSString *)str;
//url编码
+ (NSString*)URLEncodedString:(NSString*)input;
//url解码
+ (NSString*)URLDecodedString:(NSString*)input;

//获取ip地址
- (NSString *)deviceIPAdress;
//是否越狱
- (BOOL)isJailbroken;


//获取系统时间
//时间格式 yyyy-MM-dd HH:mm:ss
- (NSString*)getSystemTime;
//时间格式 yyyy-MM-dd
- (NSString *)getSystemDate;

//获得保存时间和当前时间的时间差
//dateString: 字符串 格式是 yyyy-MM-dd HH:mm:ss
//用于缓存--当前时间减去过去时间
- (CGFloat)timeIntervalFromNow:(NSString *)dateString;
//用于本地推送通知---未来时间减去当前时间
- (CGFloat)NotifTimeIntervalFromNow:(NSString *)dateString;
//NSInteger timestamp = [[FileUtil instance] timeToTimeStamp:@"2014-11-11 11:11:11" format:@"yyyy-MM-dd HH:mm:ss"];
-(NSInteger)timeToTimeStamp:(NSString*)timestring format:(NSString*)format;

//把时间戳 转 日期
- (NSString*)timeStampToTime:(NSInteger)timestamp;
- (NSString*)timeStampToTime:(NSInteger)timestamp format:(NSString*)format;

//获取当前的时间戳
-(NSInteger)currentTimeStamp;

//判断两个版本号是否一致
- (BOOL)hasNewVersion:(NSString *)newVer oldVersion:(NSString *)oldVer;


//检测AU的账号密码是否存在---更准确的判断是否激活过
- (BOOL)checkAuIsCanLogin;
- (BOOL)isActivateGG;

//获取运营商
- (NSString *)checkChinaMobile;
- (NSString *)checkChinaMobileNetState;

//解析域名为IP
-(NSString *) resolveDNS:(const NSString *)hostName;

- (float)getFreeDiskspace;


//去掉后面参数后的发布plist url
//如：item...plist?dlfrom=, 把dlfrom去掉
-(NSString*)distriPlistURLNoArg:(NSString*)distriPlistURL;

//参数：发布的plist地址
//只取plist的下载URL, 如：http://xxxxx.plist
-(NSString*)plistURLNoArg:(NSString*)distriPlistURL;

//参数如:itms-services...plist?dlfrom=xxx 或者 https://xxx.plist??dlfrom=xxx
//argName为dlfrom
//直接获取参数的名字
-(NSString*)getPlistURLArg:(NSString*)plistURL argName:(NSString*)argName;

- (void)setupLocalNotifications:(NSString *)text time:(NSTimeInterval)time infoDic:(NSDictionary*)infoDic;

//判断设备型号
- (NSString *) platform;
// 设备型号名
- (NSString *)getDeviceName;
- (NSString *)deviceType;//iphone4,5,6,6plus,ipad,others


-(NSMutableArray *)AnalyticalImage:(NSString *)htmlString;
//json解析成字典
-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr;

//仅用于越狱设备
-(NSString*)deviceUDID;


#define PRODUCT_NAME  @"productname"
#define CHANNEL_ID  @"channelid"
-(NSString*)channelInfoForKey:(NSString*)key;



- (void)showAlertView:(NSString *)title message:(NSString *)message delegate:(id)delegate;


- (NSData *)replaceNoUtf8:(NSData *)data;


- (void)showDidiGotoSafari;

//unicode转utf8
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;



//取账号密码
- (NSDictionary*)getAccountPasswordInfo;
//存账号密码
- (void)saveAccountPasswordInfo:(NSString*)account pwd:(NSString*)pwd;
//取账号KEY信息
- (NSDictionary*)getLoginKey;
//存账号KEY信息
- (void)saveLoginKey:(NSDictionary*)dic account:(NSString *)account pwd:(NSString*)pwd;

-(NSString*) uuid;
- (void)saveFileToPC;
//是否已经绑定账号
- (BOOL)hasBindAppleID;
//是否使用免费账号
- (BOOL)isBingingFreeAppleID;

//获取应用的发布证书
-(NSString*)Certificate;


//My助手判断是否连接过PC端
- (BOOL)hasConnectedPC;
@end
