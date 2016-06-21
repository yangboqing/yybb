//
//  SearchManager.h
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//负责接受和发送搜索页面与服务器交互的单例

#import <Foundation/Foundation.h>
#import "FileUtil.h"
#import "DESUtils.h"
#import "TMCache.h"


#define CDN_APPDETAILINTRO @"APPDETAILINTRO"
#define CDN_APPPREVIEWURLS @"APPPREVIEWURLS"

#define APP_RECOMMEND @"appRecommendSearch"
#define ACTIVITY_CLICKED @"activityHasBeenClicked"

@protocol SearchManagerDelegate <NSObject>
@optional

- (void)getImageSucessFromImageUrl:(NSString *)urlStr image:(UIImage *)aimage userData:(id)userdata;
- (void)getImageFailFromUrl:(NSString *)urlStr userData:(id)userdata;

- (void)getDictionarySucessFromUrl:(NSString *)urlStr Dictionary:(NSDictionary *)Dictionary userData:(id)userdata;
- (void)getDictionaryFailFromUrl:(NSString *)urlStr userData:(id)userdata;

@end

@interface SearchManager : NSObject

@property (nonatomic , weak) id<SearchManagerDelegate>delegate;
@property (nonatomic , retain) NSString *searchRecordPlistPath;
@property (nonatomic , retain) NSString *recommendClickPlistPath;
@property (nonatomic , retain) NSMutableArray *searchRecordArray;
@property (nonatomic , retain) NSMutableDictionary *recommendClickDictionary;

+(SearchManager *)getObject;
//设置-添加搜索记录
- (void)saveSearchHistoryRecord:(NSString *)historyRecord;
//获取最新一条搜索记录
- (NSString *)getSearchHistoryLastoneRecord;
//获取任意一条搜索记录
- (NSString *)getSearchHistoryRecord:(NSUInteger)index;
//获取数组
- (NSMutableArray *)getSearchResultArray;
- (NSMutableArray *)getSearchHistoryArray; //获取数组

//删除一条搜索记录
- (BOOL)deleteSearchHistoryRecord:(NSUInteger)index;


//热词沙盒初始化
- (void)initHotWord;
////获取热词沙盒数据
//- (NSArray *)getHotWord;

//点击过推荐按钮进行保存
- (void)setRecommendIsClick:(NSString *)kid;
- (void)setAppRecommendKid:(NSString *)kid;
//获取推荐按钮状态是否可点
- (BOOL)getRecommendButtonState:(NSString *)kid;
- (BOOL)getRecommendState:(NSString *)kid;
//发现点击过的活动进行保存
- (void)storeActivityId:(NSString *)activityId;
//发现点击过的活动id获取
- (NSMutableArray *)getActivityIDs;
//下载图片
- (void)downloadImageURL:(NSURL *)url userData:(id)userdata;
//根据data解析成字典（字典里内容见实现方法里的注释）
- (NSDictionary *)getDetailAppDetailIntroStr:(NSData*)data;
//下载详情内的地址
- (void)downloadDictionaryFromUrlString:(NSString*)str  userData:(id)userdata;

// 获取文件中图片的url
- (NSArray *)getIpaDetailContent:(NSString *)urlStr;


@end
