//
//  DesktopViewDataManage.h
//  browser
//
//  Created by 王毅 on 14-8-20.
//
//

//　┏┓　　　┏┓
//┏┛┻━━━┛┻┓
//┃　　　　　　　┃
//┃　　　━　　　┃
//┃　┳┛　┗┳　┃
//┃　　　　　　　┃
//┃　　　┻　　　┃
//┃　　　　　　　┃
//┗━┓　　　┏━┛
//　　┃　　　┃   神兽保佑
//　　┃　　　┃   代码无BUG！
//　　┃　　　┗━━━┓
//　　┃　　　　　　　┣┓
//　　┃　　　　　　　┏┛
//　　┗┓┓┏━┳┓┏┛
//　　　┃┫┫　┃┫┫
//　　　┗┻┛　┗┻┛



#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FileUtil.h"
#import "TMCache.h"
#import "CJSONDeserializer.h"
#import "DESUtils.h"

@protocol DesktopviewManageDelegate <NSObject>
@optional
//请求主数据失败
- (void) requestMainDataFail;

//请求数据成功
-(void)requestRecommendSucess:(NSDictionary*)saveDic requestStr:(NSString*)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData;
//请求数据失败
-(void)requestRecommendFail:(NSString*)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData;

//分类列表成功与否，取决于主数据
//请求分类列表成功
- (void)requestCategorySucess:(NSArray*)saveArray userData:(id)userData;
//请求分类列表失败
- (void)requestCategoryFail:(id)userData;



@end

@interface DesktopViewDataManage : NSObject
+(DesktopViewDataManage *) getManager;
@property (nonatomic ,weak) id<DesktopviewManageDelegate>delegate;
//全部数据 24小时一更新
//启动时候请求一次
- (void)requestMainData;
//小编推荐数据 4小时一更新
//初次请求requestStr传nil即可
//拿到的数据里，有link和data两个字段，data为数据
//link里有两个字段next和prev，next用于上拉刷新和详情页右滚
//prev仅用于详情页左滚
//data中数据：small小图地址 big大图地址 down下载次数 down_stat设置时get方式上报此地址
- (void)requestRecommend:(NSString*)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData;
//得到一个数组
//name分类名字 cover分类图地址 url点击分类后跳转后内容的请求地址
- (void)requestCategory:(id)userData;

- (void)reportSetWallpaper:(NSString*)reportAddress;

@end
