//
//  SettingPlistConfig.h
//  browser
//
//  Created by 王 毅 on 13-4-9.
//
//

#import <Foundation/Foundation.h>

//key
//下载到设备中再安装
#define DOWNLOAD_TO_LOCAL                       @"downloadToLocal"


//下载完成提示安装
#define QUICK_INSTALL                                     @"quickInstall"
//后台下载
#define AUDIO_HOLD_STRENGTH                     @"audioholdstrength"
//同时下载任务数
#define DOWNLOADCOUNT                               @"downloadCount"

//是否在安装成功后自动删除安装包
#define DELETE_PACK_AFTER_INSTALLING           @"deletePackAfterInstalling"

//下载模式
#define DOWN_ONLY_ON_WIFI                                      @"download_only_on_wifi"
//服务器保存的最新版本号
#define CAN_UPDATA_VERSION                           @"serverSaveClientVersion"

//value
//开关-开启
#define SWITCH_YES          @"yes"
//开关-关闭
#define SWITCH_NO           @"no"



@interface SettingPlistConfig : NSObject

+ (SettingPlistConfig *)getObject;

//检查iphone的系统设置plist是否存在
- (BOOL)checkIphonePlistFile;

//修改plist里字典的值
- (BOOL)changePlistObject:(NSString *)objectName key:(NSString *)keyName;

//取得plist里字典的相应的key的值(除了同时下载数)
- (BOOL)getPlistObject:(NSString *)keyName;

//取得下载最大数和下载权限高中低
- (int)getPlistObject_holdStrength_downCount:(NSString *)keyName;


@end
