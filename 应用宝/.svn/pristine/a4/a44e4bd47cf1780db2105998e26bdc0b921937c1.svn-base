//
//  MyServerRequestManager.h
//  MyHelper
//
//  Created by liguiyang on 14-12-23.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    tagType_app = 10,
    tagType_game,
    tagType_discoveryEvaluation, // 评测
    tagType_discoveryActivity, // 活动
    tagType_discoveryInformaton, // 资讯
    tagType_discoveryApplepie, // 苹果派
}TagType;

typedef enum {
    rankingType_week,
    rankingType_month,
    rankingType_All
}RankingType;

typedef enum{
    lunBo_chosenType, // 精选
    lunBo_appType, // 应用
    lunBo_gameType, // 游戏
    lunBo_discoverType, // 发现
}lunBoType;

@protocol MyServerRequestManagerDelegate <NSObject>

@optional
// 精彩推荐
- (void)wonderfulRecommendRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)wonderfulRecommendRequestFailed:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 优秀应用/游戏
- (void)excellentAppGameRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)excellentAppGameRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 最新应用/游戏
- (void)latestAppGameRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)latestAppGameRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 应用/游戏排行榜
- (void)rankingAppGameRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType rankingType:(RankingType)rankingType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)rankingAppGameRequestFailed:(TagType)tagType rankingType:(RankingType)rankingType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 应用/游戏分类
- (void)categoryAppGameRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)categoryAppGameRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 分类列表
- (void)categoryListRequestSuccess:(NSDictionary *)dataDic categoryId:(NSInteger)categoryId pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)categoryListRequestFailed:(NSInteger)categoryId pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 发现
- (void)discoveryRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)discoveryRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 付费金榜应用/游戏列表
- (void)paidListRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)paidListRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 免费畅玩应用/游戏列表
- (void)freeListRequestSuccess:(NSDictionary *)dataDic TagType:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)freeListRequestFailed:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 专题列表
- (void)specialListRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)specialListRequestFailed:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 专题详情
- (void)specialDetailRequestSuccess:(NSDictionary *)dataDic specialId:(NSString *)specialId isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)specialDetailRequestFailed:(NSString *)specialId isUseCache:(BOOL)isUseCache userData:(id)userData;
// 搜索联想
- (void)searchAssociativeWordRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)searchAssociativeWordRequestFailed:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData;
// 搜索列表
- (void)searchListRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)searchListRequestFailed:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData;
// 搜索热词
- (void)hotWordsRequestSuccess:(NSArray *)hotArray isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)hotWordsRequestFailed:(BOOL)isUseCache userData:(id)userData;
// 轮播图
- (void)carouselDiagramsRequestSuccess:(NSDictionary *)dataDic type:(lunBoType)type isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)carouselDiagramsRequestFailed:(lunBoType)type isUseCache:(BOOL)isUseCache userData:(id)userData;
// 首页混合数据
- (void)indexMixedDataRequestSuccess:(NSDictionary *)dataDic isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)indexMixedDataRequestFailed:(BOOL)isUseCache userData:(id)userData;
// 限时免费
- (void)limitFreeRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)limitFreeRequestFailed:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 装机必备
- (void)installedNecessaryRequestSuccess:(NSDictionary *)dataDic pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)installedNecessaryRequestFailed:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData;
// 获取自身id
- (void)selfDigitalIdRequestSuccess:(NSDictionary *)dataDic isUseCache:(BOOL)isUseCache userData:(id)userData;
- (void)selfDigitalIdRequestFailed:(BOOL)isUseCache userData:(id)userData;

// 开关

- (void)requestAllSwitchSuccess:(NSDictionary *)switches;
- (void)requestAllSwitchFailed;

////是否显示真实页面
//- (void)realViewSwitchRequestSuccess:(BOOL)flag;
//- (void)realViewSwitchRequestFailed;
////是否允许EU方式下载
//- (void)requestEUSwichCSuccess:(BOOL)flag;
//- (void)requestEUSwichFailed;
////是否直接跳Store
//- (void)requestDirectlyGoAppStoreSwitchSuccess:(BOOL)flag;
//- (void)requestDirectlyGoAppStoreSwitchFailed;


//应用详情
//应用详情信息请求成功
- (void)appInformationRequestSucess:(NSDictionary*)dataDic appid:(NSString*)appid userData:(id)userData;
//应用详情信息请求失败
- (void)appInformationRequestFail:(NSString*)appid userData:(id)userData;
@end

@interface MyServerRequestManager : NSObject


+ (MyServerRequestManager *)getManager;
// 添加、移除监听
- (void)addListener:(id<MyServerRequestManagerDelegate>)listener;
- (void)removeListener:(id<MyServerRequestManagerDelegate>)listener;

// 请求数据接口
- (void)requestWonderfulRecommendList:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 精彩推荐
- (void)requestExcellentAppGameList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 优秀应用/游戏
- (void)requestLatestAppGameList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 最新应用/游戏
- (void)requestRankingAppGameList:(TagType)tagType rankingType:(RankingType)rankingType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 应用/游戏排行榜
- (void)requestCategoryAppGameList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 应用/游戏分类
- (void)requestCategoryList:(NSInteger)categoryId pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 分类列表
- (void)requestDiscoveryList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 发现

- (void)requestPaidList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 付费金榜应用/游戏列表
- (void)requestFreeList:(TagType)tagType pageCount:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 免费畅玩应用/游戏列表
- (void)requestLimitFreeList:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 限时免费
- (void)requestInstalledNecessaryList:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 装机必备
- (void)requestSpecialList:(NSInteger)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData; // 专题列表
- (void)requestSpecialDetail:(NSString *)specialId isUseCache:(BOOL)isUseCache userData:(id)userData; // 专题详情

- (void)requestSearchAssociativeWordList:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData; // 搜索联想词
- (void)requestSearchList:(NSInteger)pageCount keyWord:(NSString *)keyWord isUseCache:(BOOL)isUseCache userData:(id)userData; // 搜索列表
- (void)requestSearchHotWords:(BOOL)firstFlag isUseCache:(BOOL)isUseCache userData:(id)userData; // 摇一摇热词
- (void)requestCarouselDiagrams:(lunBoType)type isUseCache:(BOOL)isUseCache userData:(id)userData; // 轮播图
- (void)requestIndexMixedData:(BOOL)isUseCache userData:(id)userData; // 首页混合数据
//- (void)requestDownloadTip; // 下载提示（暂时无用）

- (void)getSelfDigitalId:(BOOL)isUseCache userData:(id)userData;


//开关

- (void)requestAllSwitch;//请求所有开关
//- (void)getRealViewSwitchInformation;//是否显示真实界面,默认否
//- (void)requestEUSwitch;//是否允许EU下载,默认开
//- (void)requestDirectlyGoAppStoreSwitch;//是否直接跳store,默认否
//应用详情
- (void)requestAppInformation:(NSString*)appid userData:(id)userData;
@end
