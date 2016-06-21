//
//  SearchServerManage.m
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import "SearchServerManage.h"
#import "CJSONDeserializer.h"
#import "DESUtils.h"
#import "NSDictionary+noNIL.h"
#import "ReportManage.h"



#define NOT_DIC_ERROR NSLog(@"返回json数据无法解析成NSDictionary");

@interface SearchServerManage(){
    
}

@end


@implementation SearchServerManage
@synthesize delegate = _delegate;
+(SearchServerManage *)getObject{
    @synchronized(@"SearchServerManage") {
        static SearchServerManage *getObject = nil;
        if(getObject == nil){
            getObject = [[SearchServerManage alloc]init];
        }
        return getObject;
    }
}

- (id) init {
    
    if ( self=[super init] ) {
        
    }
    
    return self;
}


#pragma mark -
#pragma mark 搜索热词

- (void)requestHotWord:(BOOL)isInit{
    NSString *urlStr = nil;
    NSString * bodyStr = nil;
    
    if (isInit == YES) {
        //28
        bodyStr = @"r=search/hotwords";
    }else{
        //29
        bodyStr = @"r=search/rockhotword";
    }
    
    urlStr = [self getSearchRequestAddress:bodyStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        
        NSString *responseString = [requestSelf responseString];
        //        NSLog(@"hotWord responseString: %@",responseString);
        NSArray * array = [self analysisJSONToArray:responseString];
        
        if (array && array.count >8) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getSearchHotWord:)]) {
                [self.delegate getSearchHotWord:array];
            }
            
//            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setValue:array forKey:HOT_WORD_NSUSERDEFAULTS];
//            [userDefaults synchronize];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchHotWordRequestFail)]) {
//                NSLog(@"返回数据不足9个");
                [self.delegate searchHotWordRequestFail];
                
                [self reportError:bodyStr response:responseString];
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchHotWordRequestFail)]) {
            NSError *error = [requestSelf error];
//            NSLog(@"请求失败---%@",error);
            [self.delegate searchHotWordRequestFail];
            
            [self reportError:bodyStr response: [[requestSelf error] localizedDescription] ];
        }
        
    }];
    
    
}


#pragma mark -
#pragma mark 结果列表

- (void)requestSearchLIst:(NSString *)searchContent requestPageNumber:(NSUInteger)pageNumber userData:(id)userData{

    NSString *bodyStr = [NSString stringWithFormat:@"r=search/apps&keyword=%@&page=%d",[[FileUtil instance] urlEncode:searchContent ],pageNumber];

    NSString * urlStr = [self getSearchRequestAddress:bodyStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    
//    NSLog(@"开始请求搜索结果%d",pageNumber);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        //        NSLog(@"responseString: %@",responseString);
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        if (!map) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchListRequestFailWord:userData:)]) {
                NOT_DIC_ERROR
                [self.delegate searchListRequestFailWord:searchContent userData:userData];
            }
            
            [self reportError:bodyStr response:responseString];
            
        }else{
            
            //对数据进行检测
            if( !IS_NSDICTIONARY([map objectForKey:@"flag"]) ){          //data不是数组
                [self.delegate searchListRequestFailWord:searchContent userData:userData];
                return ;
            }
            
            NSDictionary *flag = @{};
            if ([map objectForKey:@"flag"]) {
                flag = [map objectForKey:@"flag"];
            }
            BOOL isFlag = NO;
            if ([[flag objectForKey:@"dataend"] isEqualToString:@"y"]) {
                isFlag = YES;
            } 
            NSArray *dataArray = @[];
            if ([map objectForKey:@"data"]) {
                dataArray = [map objectForKey:@"data"];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getSearchListPageData:isNextData:searchContent:userData:)]) {
//                NSLog(@"加载请求成功");
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[ReportManage instance] reportKeyWord:searchContent];
                });

                [self.delegate getSearchListPageData:dataArray isNextData:isFlag searchContent:searchContent userData:userData];
            }
            
        }
        
    }];
    
    [request setFailedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchListRequestFailWord:userData:)]) {
            NSError *error = [requestSelf error];
//            NSLog(@"请求失败---%@",error);
            [self.delegate searchListRequestFailWord:searchContent userData:userData];
            
            [self reportError:bodyStr response:[error localizedDescription] ];
        }
        
    }];
    
    
}

#pragma mark -
#pragma mark 推荐按钮

- (void)requestRecommendApp:(NSString *)appid{
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/addreputation&appid=%@",appid];
    NSString * urlStr = [self getSearchRequestAddress:bodyStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        
        NSDictionary * dic = [self analysisJSONToDictionary:responseString];
        
        if (!dic) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(recommendUpdateServerFail:)]) {
                NOT_DIC_ERROR
                [self.delegate recommendUpdateServerFail:appid];
            }
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(recommendSucessUpdateServer:)]) {
                [[SearchManager getObject] setRecommendIsClick:appid];
                [self.delegate recommendSucessUpdateServer:appid];
            }
        }
        
        
    }];
    
    [request setFailedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(recommendUpdateServerFail:)]) {
            NSError *error = [requestSelf error];
//            NSLog(@"请求失败---%@",error);
            [self.delegate recommendUpdateServerFail:appid];
            
            [self reportError:bodyStr response:[error localizedDescription] ];
        }
    }];
    
}

- (void)requestRecommendActivity:(NSString*)actID {
    NSString *urlStr = [NSString stringWithFormat:@"r=index/addhdreputation&appid=%@",actID];
    urlStr = [self getSearchRequestAddress:urlStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        NSDictionary * dic = [self analysisJSONToDictionary:responseString];
//        NSLog(@"活动点赞reponse:%@", dic);
        
    }];
    
    [request setFailedBlock:^{
//        if (self.delegate && [self.delegate respondsToSelector:@selector(recommendUpdateServerFail:)]) {
//            NSError *error = [requestSelf error];
//            NSLog(@"请求失败---%@",error);
//            [self.delegate recommendUpdateServerFail:appid];
//        }
    }];
    
}


#pragma mark -
#pragma mark 搜索联想
- (void)requestRealtimeSearchData:(NSString *)keyWord{
    NSString *bodyStr = [NSString stringWithFormat:@"%@%@",@"r=search/associateword&keyword=",[[FileUtil instance] urlEncode:keyWord]];
    
    NSString *urlStr = [self getSearchRequestAddress:bodyStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchRealtimeServerFailKeyword:)]) {
                NOT_DIC_ERROR
                [self.delegate searchRealtimeServerFailKeyword:keyWord];
            }
            
            [self reportError:bodyStr response:responseString];
            
        }else{
            

            if( !IS_NSSTRING([map objectForKey:@"flag"]) ||
               !IS_NSDICTIONARY([map objectForKey:@"data"])
               ){
                [self.delegate searchRealtimeServerFailKeyword:keyWord];
                return ;
            }
            
            BOOL isSucces = NO;
            if ([map objectForKey:@"flag"]) {
                if ([[map objectForKey:@"flag"] isKindOfClass:[NSString class]]) {
                    isSucces = [[map objectForKey:@"flag"] isEqualToString:@"y"]?YES:NO;
                }else
                {
                    return ;
                }
            }
            
            NSDictionary *dic = @{};
            if ([map objectForKey:@"data"]) {
                dic = [map objectForKey:@"data"];
            }
            
            NSString *keyStr = nil;
            if ([dic objectForKey:@"keyword"]) {
                keyStr = [dic objectForKey:@"keyword"];
            }
            NSArray *resultArray = @[];
            if ([dic objectForKey:@"items"]) {
                resultArray = [dic objectForKey:@"items"]?[dic objectForKey:@"items"]:nil;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchRealtimeKeyword:succes:realtimeData:)]) {
                [self.delegate searchRealtimeKeyword:keyStr succes:isSucces realtimeData:resultArray];
            }
        }
    }];
    
    [request setFailedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchRealtimeServerFailKeyword:)]) {
            NSError *error = [requestSelf error];
//            NSLog(@"请求失败---%@",error);
            [self.delegate searchRealtimeServerFailKeyword:keyWord];
            
            [self reportError:bodyStr response:[error localizedDescription]];

        }
    }];
    
}

- (NSString *)getDESstring:(NSString *)string{
    return [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:string key:@"i2.0908o"]];
}

- (NSString *)getCurrentSystemDate{
    return [[FileUtil instance] getSystemTime];
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

- (NSString *)getSearchRequestAddress:(NSString *)bodyStr{
    
    //UDID
    NSString *udid = [[FileUtil instance] getDeviceFileUdid];
    //DEVMAC
    NSString *devmac = [[FileUtil instance] macaddress];
    //IDFA
    NSString *idfa = [[FileUtil instance] getDeviceIDFA];
    //设备类型
    NSString *devicetype = [[UIDevice currentDevice] localizedModel];
    NSString *deviceinfotype = [[FileUtil instance] platform];
    //设备版本
    NSString *osVer = [[UIDevice currentDevice] systemVersion];
    //应用版本
    NSString *kyVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString * deviceInfo = [NSString stringWithFormat:@"&udid=%@&devmac=%@&idfa=%@&devicetype=%@&osVer=%@&kyVer=%@&deviceinfotype=%@", udid, devmac, idfa, devicetype, osVer,kyVer,deviceinfotype];

    
    bodyStr = [bodyStr stringByAppendingString:deviceInfo];
    
    if( [[FileUtil instance] checkAuIsCanLogin] ) {
        return [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS,[self getDESstring:bodyStr]];
    }
    
    return [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS_QIQIAN,[self getDESstring:bodyStr]];

}


-(void)reportError:(NSString*)requestStr response:(NSString*)responseStr {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectNoNIL:requestStr forKey:@"request"];
    [dic setObjectNoNIL:responseStr forKey:@"response"];
    

    [[ReportManage instance] reportPHPRequestError:dic];
    
}

- (void)dealloc{    
    self.delegate = nil;
}

@end
