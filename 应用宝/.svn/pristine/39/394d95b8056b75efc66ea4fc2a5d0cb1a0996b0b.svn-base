//
//  DesktopViewDataManage.m
//  browser
//
//  Created by 王毅 on 14-8-20.
//
//

#import "DesktopViewDataManage.h"
#import "NSDictionary+noNIL.h"
#import "ReportManage.h"

@interface DesktopViewDataManage ()

@property (nonatomic,retain) NSMutableDictionary *mainDataDic;

@end

@implementation DesktopViewDataManage

@synthesize mainDataDic = _mainDataDic;

+(DesktopViewDataManage *) getManager {
    
    @synchronized(@"lock") {
        static id obj = nil;
        if (obj == nil) {
            obj = [[DesktopViewDataManage alloc] init];
        }
        return obj;
    }
    
}

#define MODIFYTIME @"ModifyTime"

- (id) init {
    
    if ( self=[super init] ) {

        self.mainDataDic = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}

- (NSMutableDictionary *)getMainData{
    return self.mainDataDic;
}

- (void)requestMainData{
    int width = (int)[[UIScreen mainScreen] bounds].size.width;
    int height = (int)[[UIScreen mainScreen] bounds].size.height;

    NSString *deviceModel = [[FileUtil instance] platform];
    
    if ([deviceModel isEqualToString:@"iPhone6"]) {
        width = 750;
        height = 1334;
    }else if ([deviceModel isEqualToString:@"iPhone6 Plus"]){
        width = 1080;
        height = 1920;
    }else{
        width += width;
        height += height;
    }

    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"http://open.lovebizhi.com/kuaiyong_app.php?width=%d&height=%d",width,height];
    
    
    NSMutableDictionary *mainDataMap = [[TMCache sharedCache] objectForKey:requestStr];
    
    if (mainDataMap) {
        
        if ([mainDataMap objectForKey:MODIFYTIME]) {
            NSInteger cacheDate = [[mainDataMap objectForKey:MODIFYTIME] integerValue];
            if (nowDate - cacheDate <= 86400) {
                self.mainDataDic = mainDataMap;
                
                return;
            }
        }
        

    }
    
    NSURL *url = [NSURL URLWithString:requestStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (IS_NSDICTIONARY(map) && [map allKeys].count > 2) {
            
            self.mainDataDic = [map mutableCopy];
            [self.mainDataDic setObject:[NSNumber numberWithInteger:nowDate] forKey:MODIFYTIME];
            
            [[TMCache sharedCache] setObject:self.mainDataDic forKey:requestStr];
        }
        
    }];
    
    [request setFailedBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@"壁纸主数据请求失败---%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestMainDataFail)]) {
                [self.delegate requestMainDataFail];
            }
        });
    }];

}

- (void)requestRecommend:(NSString*)requestStr isUseCache:(BOOL)isUseCache userData:(id)userData{

    if (requestStr == nil) {
        requestStr = [self.mainDataDic objectForKey:@"recommend"];
    }
    
    
    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    //检测本地缓存是否可用
    
    while (isUseCache) {
        
        NSMutableDictionary *cacheData = [[TMCache sharedCache] objectForKey:requestStr];
        if(![cacheData isKindOfClass:[NSMutableDictionary class]]){
            break;
        }
        NSInteger modTime = [[cacheData objectForKey:MODIFYTIME] integerValue];
        if (nowDate - modTime <= 14400) {
            //返回本地数据, 回调成功消息
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRecommendSucess:requestStr:isUseCache:userData:)]) {
                    [self.delegate requestRecommendSucess:cacheData requestStr:requestStr isUseCache:isUseCache userData:userData];
                }
            });
            return;
        }
        
        break;
    }
    
    
    NSURL *url = [NSURL URLWithString:requestStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        NSMutableDictionary * map = [NSMutableDictionary dictionaryWithDictionary:[self analysisJSONToDictionary:responseString]];
        
        if ([map isKindOfClass:[NSMutableDictionary class]]) {
            
            [map setObject:[NSNumber numberWithInteger:[[FileUtil instance] currentTimeStamp]] forKey:MODIFYTIME];
            
            [[TMCache sharedCache] setObject:map forKey:requestStr];
            
            //sucess
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRecommendSucess:requestStr:isUseCache:userData:)]) {
                    [self.delegate requestRecommendSucess:map requestStr:requestStr isUseCache:isUseCache userData:userData];
                }
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 推荐请求失败---%@",error);
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRecommendFail:isUseCache:userData:)]) {
                    [self.delegate requestRecommendFail:requestStr isUseCache:isUseCache userData:userData];
                }
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@" 推荐请求失败---%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestRecommendFail:isUseCache:userData:)]) {
                [self.delegate requestRecommendFail:requestStr isUseCache:isUseCache userData:userData];
            }
        });
    }];

}

- (void)requestCategory:(id)userData{
    
    if (self.mainDataDic && [self.mainDataDic isKindOfClass:[NSMutableDictionary class]] && [self.mainDataDic allKeys].count > 1) {
        NSArray *categoryArray = [self.mainDataDic objectForKey:@"category"];
        //sucessDelegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestCategorySucess:userData:)]) {
                [self.delegate requestCategorySucess:categoryArray userData:userData];
            }
        });
        
    }else{
        [self requestMainData];
        
        //failDelegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestCategoryFail:)]) {
                [self.delegate requestCategoryFail:userData];
            }
        });
        
    }
    
}

- (void)reportSetWallpaper:(NSString*)reportAddress{

    NSURL * _url = [NSURL URLWithString:reportAddress];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 5;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];

}


-(NSArray *)analysisJSONToArray:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSARRAY(root))
        return nil;
    
    return root;
}

-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSDICTIONARY(root))
        return nil;
    
    return root;
}

@end
