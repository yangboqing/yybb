//
//  MarketServerManage.h
//  browser
//
//  Created by 王毅 on 14-5-23.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FileUtil.h"
#import "TMCache.h"
#import "CJSONDeserializer.h"
#import "DESUtils.h"

//轮播图
#define LOOPPALY_JINGXUAN           @"jingxuan"   //轮播图-精选
#define LOOPPALY_GAME                  @"game"           //轮播图-游戏
#define LOOPPALY_APP                      @"app"               //轮播图-应用
#define LOOPPALY_DISCOVERY         @"discovery"   //轮播图-发现

/*

 关于轮播图：
 返回数据中的lunbo_type (int) 的返回值解释
 1:普通 ----应用详情
 2:免流轮播图(type=jingxuan时会用到)  --- 免流轮播专区列表
 3:公告 --- 公告页网址
 4:活动---活动页(活动ID对应详情)
 5:外链(网址，快用移动端打开)
 6:外链:(调用safari打开)
 */



/*
 栏目--发现--详情
 
 content_url_open_type
 活动外链打开方式
 1:用快用本身打开
 2:用safari打开
 */


//栏目-游戏栏目-排行榜
#define WEEK_RANKING_LIST @"week"       //周下载
#define MONTH_RANKING_LIST @"month" //月下载
#define TOTAL_RANKING_LIST @"total"  //总下载

//分类列表
#define CLASSIFY_GAME @"game"  //分类列表 游戏
#define CLASSIFY_APP     @"app"     //分类列表 应用


//发现
#define DISCOVER_ALL_LIST @"all" //混合列表
#define DISCOVER_ACTIVITY_LIST @"huodong"  //发现-活动
#define DISCOVER_TESTEVALUATION_LIST @"pingce" //发现-评测
#define DISCOVER_INFORMATION_LIST @"information" // 发现-资讯
#define DISCOVER_APPPIE_LIST      @"applepie" // 发现-苹果派


@protocol MarketServerDelegate <NSObject>

@optional

//成功

//优秀游戏优秀应用请求成功
- (void)homepageGoodgameAndGoodappRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//轮播图请求成功
- (void)loopPlayRequestSucess:(NSDictionary*)dataDic loopPlayType:(NSString*)type userData:(id)userData;
//首页专题请求成功
- (void)homepageSpecialRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//专题详情请求成功
- (void)specialInfoRequestSucess:(NSDictionary*)dataDic specialID:(int)specialID userData:(id)userData;
//首页精彩推荐请求成功
- (void)homePageSplendidRecommendRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//应用详情信息请求成功
- (void)appInformationRequestSucess:(NSDictionary*)dataDic appid:(NSString*)appid userData:(id)userData;
//最新游戏栏目请求成功
- (void)newGameColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//最热游戏栏目请求成功
- (void)hotGameColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//封测游戏栏目请求成功
- (void)FengCeBetaGameColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;

//游戏栏目排行榜请求成功
- (void)gameRankingListColumnRequestSucess:(NSDictionary*)dataDic rankingList:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//最新应用栏目请求成功
- (void)newAppColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//最热应用栏目请求成功
- (void)hotAppColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//应用栏目排行榜请求成功
- (void)appRankingListColumnRequestSucess:(NSDictionary*)dataDic rankingList:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//分类列表请求成功
- (void)classifyListRequestSucess:(NSDictionary*)dataDic listMode:(NSString*)listMode userData:(id)userData;
//分类应用请求成功
- (void)classifyAppRequestSucess:(NSDictionary*)dataDic classifyID:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData;
//专题列表请求成功
- (void)specialListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//专题应用请求成功
- (void)specialAppRequestSucess:(NSDictionary*)dataDic specialID:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData;
//栏目-相关应用列表请求成功
- (void)developerCompangProductListRequestSucess:(NSDictionary*)dataDic developerName:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData;
//栏目-优秀游戏应用列表请求成功
- (void)goodGameAppListRequestSucess:(NSDictionary*)dataDic type:(NSString *)type pageCount:(int)pageCount userData:(id)userData;
//栏目-发现请求成功
- (void)discoverListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount type:(NSString*)type userData:(id)userData;
//栏目-发现-评测详情请求成功
- (void)discoverTestEvaluationDetailRequestSucess:(NSDictionary*)dataDic testEvaluationID:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//栏目-发现-活动详情请求成功
- (void)discoverActivityDetailRequestSucess:(NSDictionary*)dataDic testEvaluationID:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//栏目-联通免流列表请求成功
- (void)ChinaUnicomFreeFlowListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//栏目-首页-活动请求成功
/*
 返回数据中data包含huodong_type，
 huodong_type包含common:一般活动(页面，应用列表，评论)
 specify:指定活动(页面)
 */
- (void)homePageActivityRequestSucess:(NSDictionary*)dataDic userData:(id)userData;


//游戏栏目-最新全部列表请求成功
- (void)gameColumnNewAllListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//游戏栏目-热门全部列表请求成功
- (void)gameColumnHotAllListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//游戏栏目-封测游戏列表请求成功
- (void)gameColumnFengCeBetaGameAllListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;

//应用栏目-最新全部列表请求成功
- (void)appColumnNewAllListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
//应用栏目-热门全部列表请求成功
- (void)appColumnHotAllListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;

//发现-咨询-苹果派 请求成功
- (void)FoundRequestSucess:(NSDictionary*)dataDic type:(NSString*)type pageCount:(int)pageCount userData:(id)userData isUseCache:(BOOL)isUseCache;

//启动提醒请求成功
- (void)EnableRemindRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
//装机必备请求成功
- (void)requestInstallednecessarySucess:(NSDictionary*)dataDic userData:(id)userData;
//免费应用请求成功
- (void)requestFreeAppOrGameSucess:(NSDictionary*)dataDic page:(int)page type:(NSString*)type userData:(id)userData;
//礼包请求成功
- (void)requestPackageWebUrlSucess:(id)userData webUrl:(NSString*)webUrl;



//失败

//优秀游戏优秀应用请求失败
- (void)homepageGoodgameAndGoodappRequestFail:(id)userData;
//轮播图请求失败
- (void)loopPlayRequestFail:(NSString*)type userData:(id)userData;
//首页专题请求失败
- (void)homepageSpecialRequestFail:(id)userData;
//专题详情请求失败
- (void)specialInfoRequestFail:(int)specialID userData:(id)userData;
//首页精彩推荐请求失败
- (void)homePageSplendidRecommendRequestFail:(int)pageCount userData:(id)userData;
//应用详情信息请求失败
- (void)appInformationRequestFail:(NSString*)appid userData:(id)userData;
//最新游戏栏目请求失败
- (void)newGameColumnRequestFail:(id)userData;
//最热游戏栏目请求失败
- (void)hotGameColumnRequestFail:(id)userData;

//封测游戏栏目请求失败
- (void)FengCeBetaGameColumnRequestFail:(id)userData;

//游戏栏目排行榜请求失败
- (void)gameRankingListColumnRequestFail:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//最新应用栏目请求失败
- (void)newAppColumnRequestFail:(id)userData;
//最热应用栏目请求失败
- (void)hotAppColumnRequestFail:(id)userData;
//应用栏目排行榜请求失败
- (void)appRankingListColumnRequestFail:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//分类列表请求是白
- (void)classifyListRequestFail:(NSString*)listMode userData:(id)userData;
//分类应用请求成功
- (void)classifyAppRequestFail:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData;
//专题列表请求失败
- (void)specialListRequestFail:(int)pageCount userData:(id)userData;
//专题应用请求失败
- (void)specialAppRequestFail:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData;
//栏目-相关应用列表请求失败
- (void)developerCompangProductListRequestFail:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData;
//栏目-优秀游戏应用请求失败
- (void)goodGameAppListRequestFail:(NSString *)type pageCount:(int)pageCount userData:(id)userData;
//栏目-发现请求失败
- (void)discoverListRequestFail:(int)pageCount type:(NSString*)type userData:(id)userData;
//栏目-发现-评测详情请求失败
- (void)discoverTestEvaluationDetailRequestFail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//栏目-发现-活动详情请求失败
- (void)discoverActivityDetailRequestFail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//栏目-联通免流列表请求失败
- (void)ChinaUnicomFreeFlowListRequestFail:(int)pageCount userData:(id)userData;
//栏目-首页-活动请求失败
- (void)homePageActivityRequestFail:(id)userData;



//游戏栏目-最新全部列表请求失败
- (void)gameColumnNewAllListRequestFail:(int)pageCount userData:(id)userData;
//游戏栏目-热门全部列表请求失败
- (void)gameColumnHotAllListRequestFail:(int)pageCount userData:(id)userData;
//游戏栏目-封测游戏列表请求失败
- (void)gameColumnFengCeBetaGameAllListRequestFail:(int)pageCount userData:(id)userData;

//应用栏目-最新全部列表请求失败
- (void)appColumnNewAllListRequestFail:(int)pageCount userData:(id)userData;
//应用栏目-热门全部列表请求失败
- (void)appColumnHotAllListRequestFail:(int)pageCount userData:(id)userData;


//发现-咨询-苹果派 请求失败
- (void)FoundRequestFail:(NSString*)type pageCount:(int)pageCount userData:(id)userData isUseCache:(BOOL)isUseCache;

//启动提醒请求失败
- (void)EnableRemindRequestFail:(id)userData;
//装机必备请求失败
- (void)requestInstallednecessaryFail:(id)userData;
//免费应用请求失败
- (void)requestFreeAppOrGameFail:(int)page type:(NSString*)type userData:(id)userData;
//礼包请求失败
- (void)requestPackageWebUrlFail:(id)userData;
@end

@interface MarketServerManage : NSObject


+(MarketServerManage *) getManager;
//添加和移除监听
- (void) addListener:(id<MarketServerDelegate>) listener;
- (void) removeListener:(id<MarketServerDelegate>) listener;

/*
 所有pageCount，首页为 (int) 1
 */




//1-获取首页-优秀游戏优秀应用
- (void)getHomePageGoodgameAndGoodapp:(id)userData;
- (void)requestHomepageGoodgameAndGoodapp:(id)userData;
//2-获取轮播图数据
- (void)getLoopPlayData:(NSString*)loopPlayType userData:(id)userData;
- (void)requestLoopPlay:(NSString*)loopPlayType userData:(id)userData;
//3-获取首页-专题
- (void)gethomePageSpecial:(id)userData;
- (void)requestHomepageSpecial:(id)userData;
//4-获取专题详情
- (void)getSpecialInfo:(int)specialID userData:(id)userData;
- (void)requestSpecialInfo:(int)ID userData:(id)userData;
//5-获取首页精彩推荐
- (void)getHomePageSplendidRecommend:(int)pageCount userData:(id)userData;
- (void)requestHomePageSplendidRecommend:(int)pageCount userData:(id)userData;
//6-获取应用详情信息
- (void)getAppInformation:(NSString*)appid userData:(id)userData;
- (void)requestAppInformation:(NSString*)appid userData:(id)userData;
//7-获取栏目-游戏栏目-最新
- (void)getNewGameColumn:(id)userData;
- (void)requestNewGameColumn:(id)userData;
//8-获取游戏栏目-最新全部列表
- (void)getGameColumnNewAllList:(int)pageCount userData:(id)userData;
- (void)requestGameColumnNewAllList:(int)pageCount userData:(id)userData;
//9-获取栏目-游戏栏目-最热
- (void)getHotGameColumn:(id)userData;
- (void)requestHotGameColumn:(id)userData;
//10-获取游戏栏目-热门全部列表
- (void)getGameColumnHotAllList:(int)pageCount userData:(id)userData;
- (void)requestGameColumnHotAllList:(int)pageCount userData:(id)userData;
// 34-获取游戏栏目-封测网游
- (void)getFengCeBetaGameColumn:(id)userData;
- (void)requestFengCeBetaGameColumn:(id)userData;
// 35-获取游戏栏目-封测网游全部列表
- (void)getGameColumnFengCeBetaGameAllList:(int)pageCount userData:(id)userData;
- (void)requestGameColumnFengCeBetaGameAllList:(int)pageCount userData:(id)userData;


//11-获取栏目-游戏栏目-排行榜
//参数：WEEK_RANKING_LIST    MONTH_RANKING_LIST     TOTAL_RANKING_LIST
- (void)getGameRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
- (void)requestGameRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//12-获取栏目-应用栏目-最新
- (void)getNewAppColumn:(id)userData;
- (void)requestNewAppColumn:(id)userData;
//13-获取应用栏目-最新全部列表
- (void)getAppColumnNewAllList:(int)pageCount userData:(id)userData;
- (void)requestAppColumnNewAllList:(int)pageCount userData:(id)userData;
//14-获取栏目-应用栏目-最热
- (void)getHotAppColumn:(id)userData;
- (void)requestHotAppColumn:(id)userData;
//15获取应用栏目-热门全部列表
- (void)getAppColumnHotAllList:(int)pageCount userData:(id)userData;
- (void)requestAppColumnHotAllList:(int)pageCount userData:(id)userData;
//16-获取栏目-应用栏目-排行榜
//参数：WEEK_RANKING_LIST    MONTH_RANKING_LIST     TOTAL_RANKING_LIST
- (void)getAppRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
- (void)requestAppRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
//17-获取分类列表
//参数：CLASSIFY_GAME    或者  CLASSIFY_APP
- (void)getClassifyList:(NSString *)listMode userData:(id)userData;
-(void)requestClassifyList:(NSString*)listMode userData:(id)userData;
//18-获取分类应用
- (void)getClassifyApp:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData;
- (void)requestClassifyApp:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData;
//19-获取专题列表
- (void)getSpecialList:(int)pageCount userData:(id)userData;
-(void)requestSpecialList:(int)pageCount userData:(id)userData;
//20-获取专题应用
- (void)getSpecialApp:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData;
- (void)requestSpecialApp:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData;
//21-获取相关应用列表
- (void)getDeveloperCompangProductList:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData;
- (void)requestDeveloperCompangProductList:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData;
//22-获取栏目-优秀游戏应用列表
//参数：CLASSIFY_GAME    或者  CLASSIFY_APP
- (void)getGoodGameAppList:(NSString*)type pageCount:(int)pageCount userData:(id)userData;
- (void)requestGoodGameAppList:(NSString*)type pageCount:(int)pageCount userData:(id)userData;
//23-获取栏目-发现
//type参数:DISCOVER_ALL_LIST   DISCOVER_ACTIVITY_LIST   DISCOVER_TESTEVALUATION_LIST
- (void)getDiscoverList:(int)pageCount type:(NSString*)type userData:(id)userData;
- (void)requestDiscoverList:(int)pageCount type:(NSString*)type userData:(id)userData;
//24-获取栏目-发现-评测详情
- (void)getDiscoverTestEvaluationDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
- (void)requestDiscoverTestEvaluationDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//25-获取栏目-发现-活动详情
- (void)getDiscoverActivityDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
- (void)requestDiscoverActivityDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData;
//26-获取栏目-联通免流列表
/*
        key为@"plist"在data里，data为数组-----字典@"plist"里的几个key为@"chinaunicom"联通  @"chinamobile"移动  @"chinatelecom"电信  @"kuaiyong"wifi情况下为快用
        如果获取到某一运营商的value为@"" 则使用快用的
 */
- (void)getChinaUnicomFreeFlowList:(int)pageCount userData:(id)userData;
- (void)requestChinaUnicomFreeFlowList:(int)pageCount userData:(id)userData;
//27获取栏目-首页-活动
- (void)getHomePageActivity:(id)userData;
- (void)requestHomePageActivity:(id)userData;


//38
//获取定时的本地推送
- (void)getTimingLocalNotifications;

//40
- (void)sendBizhiShareToKuaiyong:(NSString*)bigPicUrl;

- (void)deleteLocalNotifiFromDocment:(NSString*)key;
- (NSString*)zipLocalNotifiDocmentKey:(NSString*)ID fireDate:(NSString*)fireDate;


/*
咨询传 @"information"
 苹果派传 @"applepie"
 */
- (void)requestFound:(NSString*)type page:(int)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;

//启动提醒
- (void)requestEnableRemind:(id)userData;

//装机必备专题
- (void)requestInstallednecessary:(BOOL)isUseCache userData:(id)userData;
//免费应用
//type:app/应用,game/游戏
- (void)requestFreeAppOrGame:(int)page type:(NSString*)type userData:(id)userData isUseCache:(BOOL)isUseCache;
//礼包
- (void)requestPackageWebUrl:(id)userData;
@end
