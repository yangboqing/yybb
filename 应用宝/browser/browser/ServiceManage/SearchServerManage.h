//
//  SearchServerManage.h
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "SearchManager.h"
#import "FileUtil.h"
#import "TMCache.h"

@protocol SearchServerManageDelegate <NSObject>

@optional
/*
 关于返回值内容的描述
 
 数据数组内内容Key描述：
 kid:内部编号
 appid:应用标识
 appname:应用名称
 appintro:应用简介
 appdowncount:应用下载总量
 appprice:应用价格
 appiconurl:图标地址
 appsize:应用包大小
 appversion:应用显示的版本
 appminosver:应用最低适用的系统版本
 device:支持设备类型
 filemd5:md5校验码
 category:应用类别
 appupdatetime:应用更新时间
 plist:下载地址
 datapage:本数据从服务端搜索的关键词
 apppreview:预览图,列表页有一个，详细页有多个
 appreputation:推荐数
 apptag:类别--1是应用2是游戏
 appversion_2:应用版本
 apptotaldowncount:总下载数
 appinserttime:入库时间
 appdeveloper:开发者
 stat_down_data:数据的base64表示
 stat_download_bool:系统是否低于最低适用版本
 xgFlag--是否有评测和活动
 xxFlag--是否有相关应用
 */

/*
 参数1为返回数据数组，参数2为当前页数 参数3为搜索的关键词
 */
- (void)getSearchListPageData:(NSArray *)dataArray isNextData:(BOOL)nextData searchContent:(NSString *)searchContent userData:(id)userData;

/*
 搜索热词返回的时一个含有9个字符串元素的数组
 请求失败的条件为：1服务端返回数组为假；2返回的数据数组的元素个数不足9个
 */
- (void)getSearchHotWord:(NSArray *)hotArray;

//推荐按钮是否成功上传到服务器
- (void)recommendSucessUpdateServer:(NSString *)kid;

//搜索联想返回数据--如果succes为NO，则表示无搜索结果，data为nil,无需get此参数
- (void)searchRealtimeKeyword:(NSString *)keyword succes:(BOOL)succes realtimeData:(NSArray *)data;

//搜索详情
- (void)searchInfoDataDic:(NSDictionary *)dataDic keyWord:(NSString *)appid userData:(id)userData;
- (void)searchInfoRequestSuccesButNotData:(NSString *)appid userData:(id)userData;
///////////////////////////////////////////////////////

//通知失败的回调
//结果列表失败-返回搜索关键词
- (void)searchListRequestFailWord:(NSString *)keyWord userData:(id)userData;
//热词失败
- (void)searchHotWordRequestFail;
//推荐按钮计次没有成功同步到服务端--返回kid
- (void)recommendUpdateServerFail:(NSString *)kid;
//联想服务器响应失败--返回关键词
- (void)searchRealtimeServerFailKeyword:(NSString *)keyword;
//搜索详情失败返回appid
- (void)searchInfoRequestFail:(NSString *)appid userData:(id)userData;
@end

@interface SearchServerManage : NSObject<ASIHTTPRequestDelegate>{
    
}

+(SearchServerManage *)getObject;
@property (nonatomic , weak) id<SearchServerManageDelegate>delegate;

//28&29-请求热词数据
- (void)requestHotWord:(BOOL)isInit;
//31-请求搜索结果列表
- (void)requestSearchLIst:(NSString *)searchContent requestPageNumber:(NSUInteger)pageNumber userData:(id)userData;
//33-推荐按钮上传是否成功--这个需要提交内部编号kid
//在应用-36
- (void)requestRecommendApp:(NSString *)appid;
//在活动上点击赞, actID 活动ID
- (void)requestRecommendActivity:(NSString*)actID;

//30-搜索联想
- (void)requestRealtimeSearchData:(NSString *)keyWord;

//加密
- (NSString *)getDESstring:(NSString *)string;

//- (void)requestAppidInfo:(NSString *)appid;
@end
