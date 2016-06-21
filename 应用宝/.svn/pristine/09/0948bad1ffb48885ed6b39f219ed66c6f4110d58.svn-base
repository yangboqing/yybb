//
//  BppDistriPlistManager.h
//  browser
//
//  Created by 刘 亮亮 on 13-1-11.
//
//

#import <Foundation/Foundation.h>



//应用状态有变化
#define DOWNLOAD_ITEM_STATUS_CHANGE_NOTIFICATION @"DOWNLOAD_ITEM_STATUS_CHANGE_NOTIFICATION"

#define DISTRI_APP_PRICE              @"distriAppprice"         //App 价格

#define DISTRI_PLIST_URL                @"distriPlistUrl"           //发布plist URL
#define DISTRI_APP_ID                   @"appid"              //App ID
#define DISTRI_APP_NAME                 @"distriAppName"            //App 名字
#define DISTRI_APP_VERSION              @"distriAppVersion"         //App 版本
#define DISTRI_APP_IMAGE_URL            @"distriAppImageURL"        //App Icon URL
#define DISTRI_APP_DOWNLOAD_PROGRESS    @"distriAppDownloadProgress"//App 下载进度
#define DISTRI_APP_IPA_LOCAL_PATH       @"distriLocalIPAPath"       //本地IPA路径

#define DISTRI_IPA_TOTAL_LENGTH         @"distriIPATotalLength"     //下载完成的ipa长度
#define DISTRI_PLIST_CACHE_LOCAL_PATH   @"DistriPlistCacheLocalPath" //缓存的plist地址
#define DISTRI_APP_DOWNLOAD_STATUS      @"distriAppDownloadStatus"   //app下载状态
#define DISTRI_APP_FROM                 @"distriAppFrom"              //App 来源

#define DISTRI_FREE_FLOW                @"distriFreeFlow"             //是否免流



//#废弃的字段，兼容老版本
#define DISTRI_APP_ICON_IMAGE_PATH    @"distriAppIconImagePath"     //App 图标路径
#define DISTRI_HTTP_PLIST_URL         @"distriLocalPlistURL"        //HTTP的plist地址



//下载状态列表
#define DOWNLOAD_STATUS_WAIT    0   //等待
#define DOWNLOAD_STATUS_RUN     1   //运行
#define DOWNLOAD_STATUS_STOP    2   //停止
#define DOWNLOAD_STATUS_SUCCESS 3   //正确
#define DOWNLOAD_STATUS_ERROR   4   //错误
#define DOWNLOAD_STATUS_MD5_CHECK   5 //MD5检测
#define DOWNLOAD_STATUS_UNKOWN  6   //未知



//添加或开始下载(用于3G流量提醒)
#define DISTRI_PLIST_MANAGER_NOTIFICATION_ADD_OR_START_DOWNLOAD @"DISTRI_PLIST_MANAGER_NOTIFICATION_ADD_OR_START_DOWNLOAD"


@protocol BppDistriPlistManagerDelegate <NSObject>

@optional

//添加了一个下载条目
- (void) onDidPlistMgrAddDownloadItem:(NSString*)distriPlist;

//图片下载完毕
- (void) onDidPlistMgrDownloadIconComplete:(NSString*)distriPlist icon:(UIImage*)image;
//图片下载失败
- (void) onDidPlistMgrDownloadIconError:(NSString*)distriPlist;


//IPA下载进度
- (void) onDidPlistMgrDownloadIPAProgress:(NSString*)distriPlist attr:(NSDictionary*)dicAttr;
//IPA下载完毕
- (void) onDidPlistMgrDownloadIPAComplete:(NSString*)distriPlist index:(NSUInteger)index;

//IPA下载状态改变
- (void) onDidPlistMgrStatusChange:(NSString*)distriPlist dicAttr:(NSDictionary *)attr;

//通知上层界面，当新添加进一个应用的时候，删掉与其不同版本的app
- (void) onDidPlistMgrInAlreayDownloadDeleteSameAppid:(NSString *)appid DiffenertVersion:(NSString *)version;

- (void) onDidPlistMgrDownloadAUIPAError:(NSString *)appid;

//通知界面下载失败原因
- (void)downloadFailCause:(NSString*)distriPlist failCause:(NSString *)failCause;

@end




//流程控制代理
@protocol BppDistriPlistManagerControlDelegate <NSObject>

@required

//回调外部,获得当前最大同时下载数
-(NSInteger)maxDowndingCount;

//解决IOS8 OTA安装没反应的问题
-(BOOL)IsChangeAppid;

//当前SSL Port
-(NSInteger)currentSSLPort;

//当前HTTP Port
-(NSInteger)currentWebServerPort;

//该appid 是否在安装中
-(BOOL)IsAppInstalling:(NSString*)appid;

@end




@interface BppDistriPlistManager : NSObject

//已下载
@property (atomic, strong) NSMutableArray * distriAlReadyDownloadedPlists;

//流程控制代理
@property (atomic, weak) id<BppDistriPlistManagerControlDelegate>  controlDelegate;



+(BppDistriPlistManager *) getManager;


//是否需要请求(用于优化批量添加的情况)
-(void)setNeedRequest:(BOOL)needRequest;


typedef enum _DOWNLOAD_STATUS{
    STATUS_SUCCESS,                        //添加成功
    STATUS_ALREADY_IN_DOWNLOADING_LIST,    //已经在下载中列表中
    STATUS_ALREADY_IN_DOWNLOADED_LIST,     //已经下载完成了
    STATUS_NONE,                           //没有下载
}DOWNLOAD_STATUS;

//添加企业发布用的URL，开始分析地址，下载IPA相关
//说明: appInfoDic 包含下面key值
//DISTRI_APP_ID
//DISTRI_APP_VERSION
//DISTRI_APP_NAME
//DISTRI_APP_IMAGE_URL
//
- (DOWNLOAD_STATUS) addPlistURL: (NSString*)distriPlistURL appInfoDic:(NSDictionary*)dicAppInfo;

//取得下载状态(下载中，已下载)
- (DOWNLOAD_STATUS) getPlistURLStatus: (NSString*)distriPlistURL;
//取得下载状态（适用于更新，使用appID）
- (DOWNLOAD_STATUS) getAppIdStatus: (NSString*)appID;

//开始下载
- (BOOL) startPlistURL: (NSString*)distriPlistURL;
//全部开始
- (BOOL) startAllPlistURL;

//停止下载
- (BOOL) stopPlistURL: (NSString*)distriPlistURL;
//停止所有下载
- (BOOL) stopAllPlistURL;
//从wait状态->下载中状态
- (void) waitToRun;


//下载个数
-(NSInteger)countOfDownloadingItem;
-(NSDictionary*)ItemInfoInDownloadingByIndex:(NSInteger)index;
//已下载个数
-(NSInteger)countOfDownloadedItem;
-(NSMutableDictionary*)ItemInfoInDownloadedByIndex:(NSInteger)index;


//通过属性值, 获取Item信息
- (NSDictionary*) ItemInfoByAttriName:(NSString*)attriName  value:(id)value;
- (NSMutableDictionary*) ItemInfoInDownloadedByAttriName:(NSString*)attriName  value:(id)value;
- (NSMutableDictionary*) ItemInfoInDownloadingByAttriName:(NSString*)attriName  value:(id)value;

//通过属性值，在下载中查找
-(NSInteger) indexItemInDownloadingByAttriValue:(NSString*)attriName  value:(id)value;
//通过属性值，在已下载中查找
-(NSInteger) indexItemInDownloadedByAttriValue:(NSString*)attriName  value:(id)value;


//删除下载
- (int) removePlistURL: (NSString*)distriPlistURL;
- (int) removeDownloadedPlistURL: (NSString*)distriPlistURL;
//删除所有下载
- (BOOL) removeAllDownloadedPlistURL;
- (BOOL) removeAllDownloadingPlistURL;


//安装指定的应用
- (BOOL) installPlistURL:(NSString*)distriPlistURL;

//取得对应的Image
- (UIImage *) imageForPlistURL:(NSString*)distriPlistURL;

//添加和移除监听
- (void) addListener:(id<BppDistriPlistManagerDelegate>) listener;
- (void) removeListener:(id<BppDistriPlistManagerDelegate>) listener;

//如果是3g是否可以继续下载ipa
- (void) isCan3gDownload:(BOOL)isCan;


-(NSInteger)getIPASize:(NSString*)distriPlistURL;

@end