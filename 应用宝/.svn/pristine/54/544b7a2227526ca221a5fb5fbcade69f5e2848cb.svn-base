//
//  MyVerifyDataValid.h
//  MyHelper
//
//  Created by liguiyang on 14-12-29.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <Foundation/Foundation.h>

//轮播图:
#define LUNBO_LINK_DETAIL   @"link_detail"      //连接类型的具体类容
#define LUNBO_ID            @"id"               //ID
#define LUNBO_TITLE         @"title"            //标题
#define LUNBO_VIEW_TYPE     @"view_type"        //运营还是广告数据
#define LUNBO_LINK          @"link"             //连接类型
#define LUNBO_VERSION_END   @"version_end"      //版本结束
#define LUNBO_INTRODUCE     @"introduce"        //简介
//#define LUNBO_TYPE          @"type"             //栏目类型
#define LUNBO_VERSION_BEGIN @"version_begin"    //版本开始
#define LUNBO_PIC_URL       @"pic_url"          //图片地址

//应用信息字段:
#define APPDIGITALID    @"appdigitalid"     //数字ID
#define APPID           @"appid"            //APPID
#define APPSIZE_MY         @"appdisplaysize"   //大小
#define APPNAME         @"appname"          //名称
#define APPVERSION      @"appversion"       //版本
#define APPDISPLAYVER   @"displayversion"   //显示版本号
#define APPUPDATETIME   @"appupdatetime"    //更新时间
#define PLIST           @"plist"            //下载地址
#define APPICONURL      @"appiconurl"       //icon下载地址
#define APPREPUTATION   @"appreputation"    //好评量
#define CATEGORY        @"category"         //分类
#define APPDOWNCOUNT    @"appdowncount"     //总下载量
#define APPINTRO        @"appintro"         //简介
#define IPADETAILINFOR  @"ipadetailinfor"   //detail文件下载地址
#define APPMINOSVER     @"appminosver"      //最小支持版本
#define APPOMSERTTIME   @"appinserttime"    //入库时间
#define APPPRICE        @"appprice"         //价格
#define INSTALLTYPE     @"installtype"      //安装方式 appstore/苹果store安装，local/my助手安装
#define BANNER          @"banner"//专题
#define CREAT_DATE      @"create_time"
#define TOPIC_ID        @"id"
#define INTRODUCE       @"introduce"
#define TITLE           @"title"
#define APPCOUNT         @"app_total"//专题
// 自更新
#define SELFUPDATETYPE  @"selfupdatetype"   //自更新方式 ota/ota升级,appstore/苹果商店升级
#define FORCEDUPGRADE   @"forcedupgrade"    //是否强制升级 y/强制升级,n/非强制升级
#define UPGRADEINFO     @"upgradeinfo"      //升级提示信息

//精选数据字段
#define LIMITEDFREEAPPS @"limitedFreeApps" //限免
#define CHARGEAPPS      @"chargeApps" //收费
#define FREEAPPS        @"freeApps" //免费
#define RECOMMENDAPPS   @"recommendApps"  //列表推荐应用
#define SPECIALS        @"specials"  //专题
#define LISTVIEWCELLS   @"listViewCells"//排行
#define MORECELL        @"MoreIdectifierString"//上拉刷新

//专题信息字段:
#define SPECIAL_ID   @"id"
#define DEVICE      @"device"
#define PLATFORM    @"platform"
#define TITLE       @"title"
#define BANNER      @"banner"
#define CREAT_TIME  @"create_time"
#define INTRODUCE   @"introduce"

// 发现


@interface MyVerifyDataValid : NSObject

+ (instancetype)instance;

- (BOOL)verifySelfUpdateInfoData:(NSDictionary *)dataDic; // 更新数据检测

- (BOOL)verifySearchAssociateWordsData:(NSDictionary *)dataDic; // 搜索联想词
- (BOOL)verifySearchHotWordsData:(NSArray *)dataArray; // 搜索热词
- (BOOL)verifySearchResultListData:(NSDictionary *)dataDic; // 搜索结果列表
- (BOOL)verifySearchNoResultData:(NSDictionary *)dataDic; // 搜索结果数据为空
- (BOOL)verifyFindAppsData:(NSDictionary*)dataDic;

- (BOOL)checkLunboData:(NSDictionary *)lunboData; //轮播
- (BOOL)checkChoiceData:(NSDictionary *)totaldata;//精选
- (BOOL)checkSpecialDetails:(NSDictionary *)dataDic; //专题详情

- (BOOL)verifyInstallEssentialData:(NSDictionary *)dataDic; // 装机必备
- (BOOL)verifyTopicData:(NSDictionary *)dataDic; // 专题
@end
