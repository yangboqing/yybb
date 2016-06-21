

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "DownloadReport.h"

@interface ReportManage : NSObject<ASIHTTPRequestDelegate>{

}

+(ReportManage *)instance;

-(NSMutableDictionary* )baseInfo;
//启动日志
-(void)ReportLaunch;


//汇报php接口错误问题
//-(void)ReportPHPRequestError:(NSDictionary*)errorInfo;


//汇报曝光量
-(void)ReportAppBaoGuang:(NSString*)column appids:(NSArray*)apps;

//汇报点击量(查看应用详情,咨询详情时汇报)
-(void)ReportAppDetailClick:(NSString*)column appid:(NSString*)app;


//汇报点击下载按钮量(点击下载按钮时汇报)
-(void)ReportAppClickDownload:(NSString*)column appid:(NSString*)app;

//上报关键词日志
- (void)reportKeyWord:(NSString *)keyWord;

//上报登录成功信息
- (void)reportLoginInfo:(NSString*)appleID;

//上报点赞汇报
//type:文章或者应用
//aid: 文章或者应用的ID
#define CLICK_ZAN_FIND   @"find"
#define CLICK_ZAN_APP   @"app"
- (void)reportClickZan:(NSString *)type typeid:(NSString*)aid;
//上报手机点击分页
- (void)reportEnterPage:(int)page;


//上报开屏启动
- (void)reportKaipingLaunchedWithType:(NSString *)type andImgid:(NSString *)imgid;

//上报开屏点击
- (void)reportKaipingClickedWithType:(NSString *)type andContentid:(NSString *)imgid;

//上报远程推送点击
- (void)reportRemoteNotificationClickedWithType:(NSString *)type andContentid:(NSString *)contentid;


//MY添加
- (void)reportPHPRequestError:(NSDictionary*)errorInfo; //汇报php接口错误问题
- (void)reportAppBaoGuang:(NSString*)column appids:(NSArray*)apps digitalIds:(NSArray *)digitalIds; //汇报曝光量
- (void)reportAppDetailClick:(NSString*)column contentDic:(NSDictionary *)contentDic; //汇报点击量(应用/游戏)
- (void)reportOtherDetailClick:(NSString*)column appid:(NSString *)appid;//汇报点击量（发现、专题、轮播）
- (void)reportWallPaperClick:(NSString *)column ImageUrl:(NSString *)imgUrl; // 壁纸大图
- (void)reportDiscoveryDetailRecommend:(NSString *)column appid:(NSString *)appid; // 发现详情（赞）
- (void)reportSearchKeyWord:(NSString *)keyWord; // 汇报搜索词
@end