//
//  MarketServerManage.m
//  browser
//
//  Created by 王毅 on 14-5-23.
//
//

#import "MarketServerManage.h"
#import "NSDictionary+noNIL.h"
#import "ReportManage.h"



#define NOT_DIC_ERROR(name) NSLog(@"%@返回json数据无法解析成NSDictionary",name);

@interface MarketServerManage (){
    
}
//回调对象集合
@property (nonatomic, retain) NSMutableArray * listeners;



//获取加密后的字符串
- (NSString *)getDESString:(NSString *)string;

//解析json为数组
-(NSArray *)analysisJSONToArray:(NSString *)jsonStr;
//解析json为字典
-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr;
@end


@implementation MarketServerManage

@synthesize listeners = _listeners;



+(MarketServerManage *) getManager {
    
    @synchronized(@"lock") {
        static id obj = nil;
        if (obj == nil) {
            obj = [[MarketServerManage alloc] init];
        }
        return obj;
    }
    
}


- (id) init {
    
    if ( self=[super init] ) {
        self.listeners = [NSMutableArray array];
    }
    
    return self;
}


- (void) addListener:(id<MarketServerDelegate>) listener {
    
    @try {
        
        if( NSNotFound != [self.listeners indexOfObject:listener] ) {
            return ;
        }
        
        [self.listeners addObject:listener];
    }
    @catch (NSException *exception) {
        //        NSLog(@"%@", [exception description]);
    }
    @finally {
    }
    
}
- (void) removeListener:(id<MarketServerDelegate>) listener {
    
    @try {
        [self.listeners removeObject:listener];
    }
    @catch (NSException *exception) {
        //        NSLog(@"%@", [exception description]);
    }
    @finally {
    }
    
}

#pragma mark -
#pragma mark 首页-优秀游戏 优秀应用

- (void)getHomePageGoodgameAndGoodapp:(id)userData{
    
    NSString *bodyStr = @"r=index/goodapp";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHomepageGoodgameAndGoodapp:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestHomepageGoodgameAndGoodapp:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestHomepageGoodgameAndGoodapp:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestSucess:userData:)] ) {
                        [obj homepageGoodgameAndGoodappRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestHomepageGoodgameAndGoodapp:(id)userData{
    
    NSString*bodyStr = @"r=index/goodapp";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestFail:)] ) {
                        NOT_DIC_ERROR(@"首页-优秀游戏优秀应用")
                        [obj homepageGoodgameAndGoodappRequestFail:userData];
                    }
                }];
            });
            
            //错误汇报
            [self reportError:bodyStr response:responseString];
            
        }else{
            
            //数据错误
            if(! IS_NSDICTIONARY([map objectForKey:@"data"]) ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestFail:)] ) {
                            [obj homepageGoodgameAndGoodappRequestFail:userData];
                            
                        }
                    }];
                });
                
                return ;
            }
            
            if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestSucess:userData:)] ) {
                            [obj homepageGoodgameAndGoodappRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestFail:)] ) {
                            [obj homepageGoodgameAndGoodappRequestFail:userData];
                            
                        }
                    }];
                });
            }
        }
        
        
    }];
    
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(homepageGoodgameAndGoodappRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"首页-优秀游戏优秀应用请求失败---%@",error);
                    [obj homepageGoodgameAndGoodappRequestFail:userData];
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 轮播图
- (void)getLoopPlayData:(NSString*)loopPlayType userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/lunbo&type=%@",loopPlayType];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestLoopPlay:loopPlayType userData:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if ( !IS_NSDICTIONARY(data) ) {
            [self requestLoopPlay:loopPlayType userData:userData];
            return;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestLoopPlay:loopPlayType userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(loopPlayRequestSucess:loopPlayType:userData:)] ) {
                        [obj loopPlayRequestSucess:saveDic loopPlayType:loopPlayType userData:userData];
                    }
                }];
            });
        }
    }
    
}

- (void)requestLoopPlay:(NSString*)loopPlayType userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/lunbo&type=%@",loopPlayType];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(loopPlayRequestFail:userData:)] ) {
                        NSString *printStr = [NSString stringWithFormat:@"轮播图 %@",loopPlayType];
                        NOT_DIC_ERROR(printStr)
                        [obj loopPlayRequestFail:loopPlayType userData:userData];
                        
                    }
                }];
            });
            
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            
            if (![map getNSArrayObjectForKey:@"data"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(loopPlayRequestFail:userData:)] ) {
                            NSString *printStr = [NSString stringWithFormat:@"轮播图 %@",loopPlayType];
                            NOT_DIC_ERROR(printStr)
                            [obj loopPlayRequestFail:loopPlayType userData:userData];
                            
                        }
                    }];
                });
                
            } else {
                __block BOOL isSucess = NO;
                [[map getNSArrayObjectForKey:@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                    if ([obj objectForKey:@"lunbo_type"] && [[obj objectForKey:@"lunbo_type"] isKindOfClass:[NSNumber class]]) {
                        if (![obj getNSStringObjectForKey:@"pic_url"] || ![obj getNSStringObjectForKey:@"lunbo_intro"]) {
                            
                            isSucess = YES;
                            stop = YES;
                        }
                        NSString*lunbotype = [[obj objectForKey:@"lunbo_type"] stringValue];
                        if ([lunbotype isEqualToString:@"1"]) {
                            if (![obj getNSStringObjectForKey:@"appid"]) {
                                isSucess = YES;
                                stop = YES;
                            }
                        }else if ([lunbotype isEqualToString:@"4"]){
                            if (![obj getNSStringObjectForKey:@"huodong_id"]) {
                                isSucess = YES;
                                stop = YES;
                            }
                        }else if ([lunbotype isEqualToString:@"3"] || [lunbotype isEqualToString:@"5"] || [lunbotype isEqualToString:@"6"]){
                            if (![obj getNSStringObjectForKey:@"lunbo_url"]) {
                                isSucess = YES;
                                stop = YES;
                            }
                        }else if ([lunbotype isEqualToString:@"7"]){
                            if (![obj getNSStringObjectForKey:@"zt_id"]) {
                                isSucess = YES;
                                stop = YES;
                            }
                        }

                    } else {
                        isSucess = YES;
                        stop = YES;
                    }

                }];

                if (isSucess == YES) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if( [obj respondsToSelector:@selector(loopPlayRequestFail:userData:)] ) {
                                NSString *printStr = [NSString stringWithFormat:@"轮播图 %@",loopPlayType];
                                NOT_DIC_ERROR(printStr)
                                [obj loopPlayRequestFail:loopPlayType userData:userData];
                                
                            }
                        }];
                    });
                    //错误汇报
                    [self reportError:bodyStr response:[[requestSelf error] localizedDescription]];
                } else {
                    
                    if (IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                         NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                        
                        if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                            
                            NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                            
                            [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                            
                            [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];

                        }else{

                            NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                            
                            [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                            
                            [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                            
                            
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.listeners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                if( [obj respondsToSelector:@selector(loopPlayRequestSucess:loopPlayType:userData:)] ) {
                                    
                                    [obj loopPlayRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] loopPlayType:loopPlayType userData:userData];
                                    
                                    
                                    
                                }
                            }];
                        });
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                if( [obj respondsToSelector:@selector(loopPlayRequestFail:userData:)] ) {
                                    
                                    [obj loopPlayRequestFail:loopPlayType userData:userData];

                                }
                                
                            }];
                            
                        });
                    }
                    
                }

            }
        }
    }];

    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(loopPlayRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"轮播图%@请求失败---%@",loopPlayType,error);
                    [obj loopPlayRequestFail:loopPlayType userData:userData];
                    
                }
            }];
        });
        
        //错误汇报
        [self reportError:bodyStr response:[[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 首页专题
- (void)gethomePageSpecial:(id)userData{
    NSString *bodyStr = @"r=index/zt";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHomepageSpecial:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestHomepageSpecial:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestHomepageSpecial:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homepageSpecialRequestSucess:userData:)] ) {
                        [obj homepageSpecialRequestSucess:saveDic userData:userData];
                    }
                }];
            });
        }
    }
}

- (void)requestHomepageSpecial:(id)userData{
    
    NSString*bodyStr = @"r=index/zt";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homepageSpecialRequestFail:)] ) {
                        NOT_DIC_ERROR(@"首页专题")
                        [obj homepageSpecialRequestFail:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response:responseString];
            
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageSpecialRequestFail:)] ) {
                            [obj homepageSpecialRequestFail:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageSpecialRequestSucess:userData:)] ) {
                            [obj homepageSpecialRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homepageSpecialRequestFail:)] ) {
                            [obj homepageSpecialRequestFail:userData];
                            
                        }
                    }];
                });
                
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(homepageSpecialRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"首页专题请求失败---%@",error);
                    [obj homepageSpecialRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
        
    }];
    
}


#pragma mark -
#pragma mark 专题详情
- (void)getSpecialInfo:(int)specialID userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/ztdetail&id=%d",specialID];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestSpecialInfo:specialID userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestSpecialInfo:specialID userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestSpecialInfo:specialID userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialInfoRequestSucess:specialID:userData:)] ) {
                        [obj specialInfoRequestSucess:saveDic specialID:specialID userData:userData];
                    }
                }];
            });
        }
    }
    
}

- (void)requestSpecialInfo:(int)ID userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/ztdetail&id=%d",ID];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialInfoRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"专题详情")
                        [obj specialInfoRequestFail:ID userData:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialInfoRequestSucess:specialID:userData:)] ) {
                            [obj specialInfoRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] specialID:ID userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialInfoRequestFail:userData:)] ) {
                            [obj specialInfoRequestFail:ID userData:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(specialInfoRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"专题详情请求失败---%@",error);
                    [obj specialInfoRequestFail:ID userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}


#pragma mark -
#pragma mark 首页精彩推荐
- (void)getHomePageSplendidRecommend:(int)pageCount userData:(id)userData{
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/recommand&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHomePageSplendidRecommend:pageCount userData:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestHomePageSplendidRecommend:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            [self requestHomePageSplendidRecommend:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestSucess:pageCount:userData:)] ) {
                        [obj homePageSplendidRecommendRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
        }
    }
    
}

- (void)requestHomePageSplendidRecommend:(int)pageCount userData:(id)userData{
    
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/recommand&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"首页精彩推荐")
                        [obj homePageSplendidRecommendRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestFail:userData:)] ) {
                            [obj homePageSplendidRecommendRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestSucess:pageCount:userData:)] ) {
                            [obj homePageSplendidRecommendRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestFail:userData:)] ) {
                            [obj homePageSplendidRecommendRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(homePageSplendidRecommendRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"首页精彩推荐请求失败---%@",error);
                    [obj homePageSplendidRecommendRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 应用详情信息
- (void)getAppInformation:(NSString*)appid userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/appdetail&appid=%@",appid];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestAppInformation:appid userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"data"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestAppInformation:appid userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"cachetime"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestAppInformation:appid userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appInformationRequestSucess:appid:userData:)] ) {
                        [obj appInformationRequestSucess:saveDic appid:appid userData:userData];
                    }
                }];
            });
        }
    }
    
}

- (void)requestAppInformation:(NSString *)appid userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/appdetail&appid=%@",appid];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appInformationRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"应用详情信息")
                        [obj appInformationRequestFail:appid userData:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            
            if ( IS_NSDICTIONARY([map objectForKey:@"data"])  ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[saveDic objectForKey:@"md5"] isEqualToString:[map objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appInformationRequestSucess:appid:userData:)] ) {
                            [obj appInformationRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] appid:appid userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appInformationRequestFail:userData:)] ) {
                            [obj appInformationRequestFail:appid userData:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(appInformationRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"应用详情信息请求失败---%@",error);
                    [obj appInformationRequestFail:appid userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 栏目-游戏栏目-最新
- (void)getNewGameColumn:(id)userData{
    
    
    NSString *bodyStr = @"r=game/newest";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestNewGameColumn:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestNewGameColumn:userData];
            return;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestNewGameColumn:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(newGameColumnRequestSucess:userData:)] ) {
                        [obj newGameColumnRequestSucess:saveDic userData:userData];
                    }
                }];
            });
        }
    }
    
}

- (void)requestNewGameColumn:(id)userData{
    
    NSString*bodyStr = @"r=game/newest";
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(newGameColumnRequestFail:)] ) {
                        NOT_DIC_ERROR(@"栏目-游戏栏目-最新")
                        [obj newGameColumnRequestFail:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newGameColumnRequestFail:)] ) {
                            [obj newGameColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newGameColumnRequestSucess:userData:)] ) {
                            [obj newGameColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newGameColumnRequestFail:)] ) {
                            [obj newGameColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(newGameColumnRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-游戏栏目-最新请求失败---%@",error);
                    [obj newGameColumnRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 栏目-游戏栏目-最热
- (void)getHotGameColumn:(id)userData{
    
    NSString *bodyStr = @"r=game/hots";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHotGameColumn:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestHotGameColumn:userData];
            return;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestHotGameColumn:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(hotGameColumnRequestSucess:userData:)] ) {
                        [obj hotGameColumnRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestHotGameColumn:(id)userData{
    
    NSString*bodyStr = @"r=game/hots";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        
        responseString = [self clearNullInString:responseString];
        
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                        NOT_DIC_ERROR(@"栏目-游戏栏目-最热")
                        [obj hotGameColumnRequestFail:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                            [obj hotGameColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY( [map objectForKey:@"flag"] ) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotGameColumnRequestSucess:userData:)] ) {
                            [obj hotGameColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                            [obj hotGameColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-游戏栏目-最热请求失败---%@",error);
                    [obj hotGameColumnRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}



#pragma mark -
#pragma mark 获取游戏栏目-封测网游
- (void)getFengCeBetaGameColumn:(id)userData {
    
    
    NSString *bodyStr = @"r=index/fengce";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    if (!saveDic) {
        [self requestFengCeBetaGameColumn:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY( data ) ){
            [self requestFengCeBetaGameColumn:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestFengCeBetaGameColumn:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(FengCeBetaGameColumnRequestSucess:userData:)] ) {
                        [obj FengCeBetaGameColumnRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestFengCeBetaGameColumn:(id)userData {
    
    NSString*bodyStr = @"r=index/fengce";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        
        responseString = [self clearNullInString:responseString];
        
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                        NOT_DIC_ERROR(@"栏目-游戏栏目-封测游戏")
                        [obj FengCeBetaGameColumnRequestFail:userData];
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotGameColumnRequestFail:)] ) {
                            [obj FengCeBetaGameColumnRequestFail:userData];
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(FengCeBetaGameColumnRequestSucess:userData:)] ) {
                            [obj FengCeBetaGameColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(FengCeBetaGameColumnRequestFail:)] ) {
                            [obj FengCeBetaGameColumnRequestFail:userData];
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(FengCeBetaGameColumnRequestFail:)] ) {
                    NSLog(@"栏目-游戏栏目-封测游戏请求失败---%@",[requestSelf error]);
                    [obj FengCeBetaGameColumnRequestFail:userData];
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}




#pragma mark -
#pragma mark 栏目-游戏栏目-排行榜

- (void)getGameRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=game/ranking&order=%@&page=%d",rankingList,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestGameRankingListColumn:rankingList pageCount:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestGameRankingListColumn:rankingList pageCount:pageCount userData:userData];
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestGameRankingListColumn:rankingList pageCount:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameRankingListColumnRequestSucess:rankingList:pageCount:userData:)] ) {
                        [obj gameRankingListColumnRequestSucess:saveDic rankingList:rankingList pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
}

- (void)requestGameRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=game/ranking&order=%@&page=%d",rankingList,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameRankingListColumnRequestFail:pageCount:userData:)] ) {
                        NOT_DIC_ERROR(@"栏目-游戏栏目-排行榜")
                        [obj gameRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameRankingListColumnRequestFail:pageCount:userData:)] ) {
                            [obj gameRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameRankingListColumnRequestSucess:rankingList:pageCount:userData:)] ) {
                            [obj gameRankingListColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ]rankingList:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameRankingListColumnRequestFail:pageCount:userData:)] ) {
                            [obj gameRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(gameRankingListColumnRequestFail:pageCount:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-游戏栏目-排行榜请求失败---%@",error);
                    [obj gameRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}



#pragma mark -
#pragma mark 栏目-应用栏目-最新
- (void)getNewAppColumn:(id)userData{
    
    NSString *bodyStr = @"r=app/newest";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestNewAppColumn:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestNewAppColumn:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestNewAppColumn:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(newAppColumnRequestSucess:userData:)] ) {
                        [obj newAppColumnRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestNewAppColumn:(id)userData{
    
    NSString*bodyStr = @"r=app/newest";
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(newAppColumnRequestFail:)] ) {
                        NOT_DIC_ERROR(@"栏目-应用栏目-最新")
                        [obj newAppColumnRequestFail:userData];
                        
                    }
                }];
            });
            
            [self reportError:bodyStr response: responseString];
            
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newAppColumnRequestFail:)] ) {
                            [obj newAppColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newAppColumnRequestSucess:userData:)] ) {
                            [obj newAppColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(newAppColumnRequestFail:)] ) {
                            [obj newAppColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(newAppColumnRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-应用栏目-最新请求失败---%@",error);
                    [obj newAppColumnRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 栏目-应用栏目-最热
- (void)getHotAppColumn:(id)userData{
    
    
    NSString *bodyStr = @"r=app/hots";
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //    NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHotAppColumn:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestHotAppColumn:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestHotAppColumn:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(hotAppColumnRequestSucess:userData:)] ) {
                        [obj hotAppColumnRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestHotAppColumn:(id)userData{
    
    NSString*bodyStr = @"r=app/hots";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest * requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        
        responseString = [self clearNullInString:responseString];
        
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(hotAppColumnRequestFail:)] ) {
                        NOT_DIC_ERROR(@"栏目-应用栏目-最热")
                        [obj hotAppColumnRequestFail:userData];
                        
                    }
                }];
            });
            
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotAppColumnRequestFail:)] ) {
                            [obj hotAppColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotAppColumnRequestSucess:userData:)] ) {
                            [obj hotAppColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(hotAppColumnRequestFail:)] ) {
                            [obj hotAppColumnRequestFail:userData];
                            
                        }
                    }];
                });
            }
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(hotAppColumnRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-应用栏目-最热请求失败---%@",error);
                    [obj hotAppColumnRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 栏目-应用栏目-排行榜

- (void)getAppRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=app/ranking&order=%@&page=%d",rankingList,pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestAppRankingListColumn:rankingList pageCount:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestAppRankingListColumn:rankingList pageCount:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestAppRankingListColumn:rankingList pageCount:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appRankingListColumnRequestSucess:rankingList:pageCount:userData:)] ) {
                        [obj appRankingListColumnRequestSucess:saveDic rankingList:rankingList pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
}

- (void)requestAppRankingListColumn:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=app/ranking&order=%@&page=%d",rankingList,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appRankingListColumnRequestFail:pageCount:userData:)] ) {
                        NOT_DIC_ERROR(@"栏目-应用栏目-排行榜")
                        [obj appRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                        
                    }
                }];
            });
            
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appRankingListColumnRequestFail:pageCount:userData:)] ) {
                            [obj appRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appRankingListColumnRequestSucess:rankingList:pageCount:userData:)] ) {
                            [obj appRankingListColumnRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ]rankingList:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appRankingListColumnRequestFail:pageCount:userData:)] ) {
                            [obj appRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(appRankingListColumnRequestFail:pageCount:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-应用栏目-排行榜请求失败---%@",error);
                    [obj appRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 分类列表
- (void)getClassifyList:(NSString *)listMode userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/category&type=%@",listMode];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestClassifyList:listMode userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestClassifyList:listMode userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestClassifyList:listMode userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(classifyListRequestSucess:listMode:userData:)] ) {
                        [obj classifyListRequestSucess:saveDic listMode:listMode userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

-(void)requestClassifyList:(NSString*)listMode userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/category&type=%@",listMode];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(classifyListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"分类列表")
                        [obj classifyListRequestFail:listMode userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyListRequestFail:userData:)] ) {
                            [obj classifyListRequestFail:listMode userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyListRequestSucess:listMode:userData:)] ) {
                            [obj classifyListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] listMode:listMode userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyListRequestFail:userData:)] ) {
                            [obj classifyListRequestFail:listMode userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(classifyListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"分类列表请求失败---%@",error);
                    [obj classifyListRequestFail:listMode userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 分类应用
- (void)getClassifyApp:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/cateapp&id=%@&page=%d",classifyID,pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestClassifyApp:classifyID pageCount:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestClassifyApp:classifyID pageCount:pageCount userData:userData];
            return ;
        }
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestClassifyApp:classifyID pageCount:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(classifyAppRequestSucess:classifyID:pageCount:userData:)] ) {
                        [obj classifyAppRequestSucess:saveDic classifyID:classifyID pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
}

- (void)requestClassifyApp:(NSString*)classifyID pageCount:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/cateapp&id=%@&page=%d",classifyID,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(classifyAppRequestFail:pageCount:userData:)] ) {
                        NOT_DIC_ERROR(@"分类应用")
                        [obj classifyAppRequestFail:classifyID pageCount:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyAppRequestFail:pageCount:userData:)] ) {
                            [obj classifyAppRequestFail:classifyID pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyAppRequestSucess:classifyID:pageCount:userData:)] ) {
                            
                            [obj classifyAppRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] classifyID:classifyID pageCount:pageCount userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(classifyAppRequestFail:pageCount:userData:)] ) {
                            [obj classifyAppRequestFail:classifyID pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(classifyAppRequestFail:pageCount:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"分类应用请求失败---%@",error);
                    [obj classifyAppRequestFail:classifyID pageCount:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 专题列表
- (void)getSpecialList:(int)pageCount userData:(id)userData{
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/zt&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestSpecialList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestSpecialList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestSpecialList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialListRequestSucess:pageCount:userData:)] ) {
                        [obj specialListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

-(void)requestSpecialList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/zt&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"专题列表")
                        [obj specialListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialListRequestFail:userData:)] ) {
                            [obj specialListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialListRequestSucess:pageCount:userData:)] ) {
                            [obj specialListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialListRequestFail:userData:)] ) {
                            [obj specialListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(specialListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"专题列表请求失败---%@",error);
                    [obj specialListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 专题应用
- (void)getSpecialApp:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/ztapp&id=%@&page=%d",specialID,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestSpecialApp:specialID pageCount:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self requestSpecialApp:specialID pageCount:pageCount userData:userData];
            return ;
        }
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestSpecialApp:specialID pageCount:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialAppRequestSucess:specialID:pageCount:userData:)] ) {
                        [obj specialAppRequestSucess:saveDic specialID:specialID pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestSpecialApp:(NSString*)specialID pageCount:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/ztapp&id=%@&page=%d",specialID,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(specialAppRequestFail:pageCount:userData:)] ) {
                        NOT_DIC_ERROR(@"专题应用")
                        [obj specialAppRequestFail:specialID pageCount:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialAppRequestFail:pageCount:userData:)] ) {
                            [obj specialAppRequestFail:specialID pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialAppRequestSucess:specialID:pageCount:userData:)] ) {
                            
                            [obj specialAppRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] specialID:specialID pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(specialAppRequestFail:pageCount:userData:)] ) {
                            [obj specialAppRequestFail:specialID pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(specialAppRequestFail:pageCount:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"专题应用请求失败---%@",error);
                    [obj specialAppRequestFail:specialID pageCount:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 栏目-相关应用列表

- (void)getDeveloperCompangProductList:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData{
    
    NSString*devCodeName = [[FileUtil instance] urlEncode:developerName];
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/developerapp&developer=%@&page=%d",devCodeName,pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestDeveloperCompangProductList:developerName pageCount:pageCount appid:appid userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if(!IS_NSDICTIONARY(data)){
            [self requestDeveloperCompangProductList:developerName pageCount:pageCount appid:appid userData:userData];
            return ;
        }
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestDeveloperCompangProductList:developerName pageCount:pageCount appid:appid userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(developerCompangProductListRequestSucess:developerName:pageCount:appid:userData:)] ) {
                        [obj developerCompangProductListRequestSucess:saveDic developerName:devCodeName pageCount:pageCount appid:appid userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
}

- (void)requestDeveloperCompangProductList:(NSString*)developerName pageCount:(int)pageCount appid:(NSString*)appid userData:(id)userData{
    NSString*devCodeName = [[FileUtil instance] urlEncode:developerName];
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/developerapp&developer=%@&page=%d&appid=%@",devCodeName,pageCount,appid];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(developerCompangProductListRequestFail:pageCount:appid:userData:)] ) {
                        NOT_DIC_ERROR(@"相关应用列表")
                        [obj developerCompangProductListRequestFail:developerName pageCount:pageCount appid:appid userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(developerCompangProductListRequestFail:pageCount:appid:userData:)] ) {
                            [obj developerCompangProductListRequestFail:developerName pageCount:pageCount appid:appid userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(developerCompangProductListRequestSucess:developerName:pageCount:appid:userData:)] ) {
                            
                            [obj developerCompangProductListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] developerName:developerName pageCount:pageCount appid:appid userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(developerCompangProductListRequestFail:pageCount:appid:userData:)] ) {
                            [obj developerCompangProductListRequestFail:developerName pageCount:pageCount appid:appid userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(developerCompangProductListRequestFail:pageCount:appid:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"相关应用列表请求失败---%@",error);
                    [obj developerCompangProductListRequestFail:developerName pageCount:pageCount appid:appid userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 栏目-优秀游戏应用列表
- (void)getGoodGameAppList:(NSString*)type pageCount:(int)pageCount userData:(id)userData{
    
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/goodgameapp&type=%@&page=%d",type,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    NSDictionary * saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self  requestGoodGameAppList:type pageCount:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self  requestGoodGameAppList:type pageCount:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self  requestGoodGameAppList:type pageCount:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(goodGameAppListRequestSucess:type:pageCount:userData:)] ) {
                        [obj goodGameAppListRequestSucess:saveDic type:type pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestGoodGameAppList:(NSString*)type pageCount:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/goodgameapp&type=%@&page=%d",type,pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(goodGameAppListRequestFail:pageCount:userData:)] ) {
                        NOT_DIC_ERROR(@"优秀游戏应用列表")
                        [obj goodGameAppListRequestFail:type pageCount:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(goodGameAppListRequestFail:pageCount:userData:)] ) {
                            [obj goodGameAppListRequestFail:type pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(goodGameAppListRequestSucess:type:pageCount:userData:)] ) {
                            
                            [obj goodGameAppListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] type:type pageCount:pageCount userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(goodGameAppListRequestFail:pageCount:userData:)] ) {
                            [obj goodGameAppListRequestFail:type pageCount:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(goodGameAppListRequestFail:pageCount:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"优秀游戏应用列表请求失败---%@",error);
                    [obj goodGameAppListRequestFail:type pageCount:pageCount userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 栏目-发现
- (void)getDiscoverList:(int)pageCount type:(NSString*)type userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/discovery&type=%@&page=%d",type,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self  requestDiscoverList:pageCount type:type userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ){
            [self  requestDiscoverList:pageCount type:type userData:userData];
            return;
        }
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self  requestDiscoverList:pageCount type:type userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverListRequestSucess:pageCount:type:userData:)] ) {
                        [obj discoverListRequestSucess:saveDic pageCount:pageCount type:type userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestDiscoverList:(int)pageCount type:(NSString*)type userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/discovery&type=%@&page=%d",type,pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverListRequestFail:type:userData:)] ) {
                        NOT_DIC_ERROR(@"发现列表")
                        [obj discoverListRequestFail:pageCount type:type userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverListRequestFail:type:userData:)] ) {
                            [obj discoverListRequestFail:pageCount type:type userData:userData];
                            
                        }
                    }];
                });
            }else if ( IS_NSDICTIONARY([map objectForKey:@"flag"]) ) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverListRequestSucess:pageCount:type:userData:)] ) {
                            [obj discoverListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount type:type userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverListRequestFail:type:userData:)] ) {
                            [obj discoverListRequestFail:pageCount type:type userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(discoverListRequestFail:type:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"发现列表请求失败---%@",error);
                    [obj discoverListRequestFail:pageCount type:type userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 栏目-发现-评测详情
- (void)getDiscoverTestEvaluationDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/pingcedetail&id=%d&appid=%@",testEvaluationID,appid];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self  requestDiscoverTestEvaluationDetail:testEvaluationID appid:appid userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if(!IS_NSDICTIONARY(data)){
            [self  requestDiscoverTestEvaluationDetail:testEvaluationID appid:appid userData:userData];
            return;
        }
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self  requestDiscoverTestEvaluationDetail:testEvaluationID appid:appid userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverTestEvaluationDetailRequestSucess:testEvaluationID:appid:userData:)] ) {
                        [obj discoverTestEvaluationDetailRequestSucess:saveDic testEvaluationID:testEvaluationID appid:appid userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestDiscoverTestEvaluationDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/pingcedetail&id=%d&appid=%@",testEvaluationID,appid];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverTestEvaluationDetailRequestFail:appid:userData:)] ) {
                        NOT_DIC_ERROR(@"栏目-发现-评测详情")
                        [obj discoverTestEvaluationDetailRequestFail:testEvaluationID appid:appid userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverTestEvaluationDetailRequestSucess:testEvaluationID:appid:userData:)] ) {
                            
                            [obj discoverTestEvaluationDetailRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] testEvaluationID:testEvaluationID appid:appid userData:userData];
                        }
                    }];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverTestEvaluationDetailRequestFail:appid:userData:)] ) {
                            [obj discoverTestEvaluationDetailRequestFail:testEvaluationID appid:appid userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(discoverTestEvaluationDetailRequestFail:appid:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-发现-评测详情请求失败---%@",error);
                    [obj discoverTestEvaluationDetailRequestFail:testEvaluationID appid:appid userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 栏目-发现-活动详情
- (void)getDiscoverActivityDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=index/huodongdetail&id=%d&appid=%@",testEvaluationID,appid];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self  requestDiscoverActivityDetail:testEvaluationID appid:appid userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self  requestDiscoverActivityDetail:testEvaluationID appid:appid userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self  requestDiscoverActivityDetail:testEvaluationID appid:appid userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverActivityDetailRequestSucess:testEvaluationID:appid:userData:)] ) {
                        [obj discoverActivityDetailRequestSucess:saveDic testEvaluationID:testEvaluationID appid:appid userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestDiscoverActivityDetail:(int)testEvaluationID appid:(NSString*)appid userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/huodongdetail&id=%d&appid=%@",testEvaluationID,appid];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(discoverActivityDetailRequestFail:appid:userData:)] ) {
                        NOT_DIC_ERROR(@"栏目-发现-活动详情")
                        [obj discoverActivityDetailRequestFail:testEvaluationID appid:appid userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
            
        }else{
            if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverActivityDetailRequestSucess:testEvaluationID:appid:userData:)] ) {
                            
                            [obj discoverActivityDetailRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] testEvaluationID:testEvaluationID appid:appid userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(discoverActivityDetailRequestFail:appid:userData:)] ) {
                            [obj discoverActivityDetailRequestFail:testEvaluationID appid:appid userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(discoverActivityDetailRequestFail:appid:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"栏目-发现-活动详情请求失败---%@",error);
                    [obj discoverActivityDetailRequestFail:testEvaluationID appid:appid userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 栏目-联通免流列表
- (void)getChinaUnicomFreeFlowList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/liantong3g&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self  requestChinaUnicomFreeFlowList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self  requestChinaUnicomFreeFlowList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self  requestChinaUnicomFreeFlowList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(ChinaUnicomFreeFlowListRequestSucess:pageCount:userData:)] ) {
                        [obj ChinaUnicomFreeFlowListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestChinaUnicomFreeFlowList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/liantong3g&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(ChinaUnicomFreeFlowListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"联通3G免流列表")
                        [obj ChinaUnicomFreeFlowListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(ChinaUnicomFreeFlowListRequestSucess:pageCount:userData:)] ) {
                            
                            [obj ChinaUnicomFreeFlowListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(ChinaUnicomFreeFlowListRequestFail:userData:)] ) {
                            [obj ChinaUnicomFreeFlowListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(ChinaUnicomFreeFlowListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"联通3G免流列表请求失败---%@",error);
                    [obj ChinaUnicomFreeFlowListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}


#pragma mark -
#pragma mark 栏目-首页-活动
- (void)getHomePageActivity:(id)userData{
    
    NSString *bodyStr = @"r=index/huodong";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestHomePageActivity:userData];
    }else{
        
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestHomePageActivity:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestHomePageActivity:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homePageActivityRequestSucess:userData:)] ) {
                        [obj homePageActivityRequestSucess:saveDic userData:userData];
                    }
                }];
            });
            
        }
    }
    
}

- (void)requestHomePageActivity:(id)userData{
    
    NSString*bodyStr = @"r=index/huodong";
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(homePageActivityRequestFail:)] ) {
                        NOT_DIC_ERROR(@"首页-活动")
                        [obj homePageActivityRequestFail:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageActivityRequestFail:)] ) {
                            [obj homePageActivityRequestFail:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageActivityRequestSucess:userData:)] ) {
                            [obj homePageActivityRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(homePageActivityRequestFail:)] ) {
                            [obj homePageActivityRequestFail:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(homePageActivityRequestFail:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"首页-活动请求失败---%@",error);
                    [obj homePageActivityRequestFail:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 游戏栏目-最新全部列表
- (void)getGameColumnNewAllList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=game/newestall&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestGameColumnNewAllList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestGameColumnNewAllList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestGameColumnNewAllList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestSucess:pageCount:userData:)] ) {
                        [obj gameColumnNewAllListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestGameColumnNewAllList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=game/newestall&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"游戏栏目最新全部列表")
                        [obj gameColumnNewAllListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestFail:userData:)] ) {
                            [obj gameColumnNewAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestSucess:pageCount:userData:)] ) {
                            [obj gameColumnNewAllListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestFail:userData:)] ) {
                            [obj gameColumnNewAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(gameColumnNewAllListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"游戏栏目最新全部列表请求失败---%@",error);
                    [obj gameColumnNewAllListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 游戏栏目-热门全部列表
- (void)getGameColumnHotAllList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=game/hotsall&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestGameColumnHotAllList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestGameColumnHotAllList:pageCount userData:userData];
            return ;
        }
        
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestGameColumnHotAllList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestSucess:pageCount:userData:)] ) {
                        [obj gameColumnHotAllListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestGameColumnHotAllList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=game/hotsall&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"游戏栏目热门全部列表")
                        [obj gameColumnHotAllListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestFail:userData:)] ) {
                            [obj gameColumnHotAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestSucess:pageCount:userData:)] ) {
                            [obj gameColumnHotAllListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestFail:userData:)] ) {
                            [obj gameColumnHotAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(gameColumnHotAllListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"游戏栏目热门全部列表请求失败---%@",error);
                    [obj gameColumnHotAllListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 游戏栏目-封测网游全部列表
// -获取游戏栏目-封测网游全部列表
- (void)getGameColumnFengCeBetaGameAllList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=list/fengce&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestGameColumnFengCeBetaGameAllList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestGameColumnFengCeBetaGameAllList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestGameColumnFengCeBetaGameAllList:pageCount userData:userData];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestSucess:pageCount:userData:)] ) {
                        [obj gameColumnFengCeBetaGameAllListRequestSucess:saveDic
                                                                pageCount:pageCount
                                                                 userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
}

- (void)requestGameColumnFengCeBetaGameAllList:(int)pageCount userData:(id)userData{
    
    NSString*bodyStr = [NSString stringWithFormat:@"r=list/fengce&page=%d",pageCount];
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"游戏栏目热门全部列表")
                        [obj gameColumnFengCeBetaGameAllListRequestFail:pageCount userData:userData];
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestFail:userData:)] ) {
                            
                            [obj gameColumnFengCeBetaGameAllListRequestFail:pageCount userData:userData];
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestSucess:pageCount:userData:)] ) {
                            [obj gameColumnFengCeBetaGameAllListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestFail:userData:)] ) {
                            [obj gameColumnFengCeBetaGameAllListRequestFail:pageCount userData:userData];
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(gameColumnFengCeBetaGameAllListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"游戏栏目封测游戏全部列表请求失败---%@",error);
                    [obj gameColumnFengCeBetaGameAllListRequestFail:pageCount userData:userData];
                }
            }];
        });
        
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
    
}

#pragma mark -
#pragma mark 应用栏目-最新全部列表
- (void)getAppColumnNewAllList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=app/newestall&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestAppColumnNewAllList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestAppColumnNewAllList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestAppColumnNewAllList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appColumnNewAllListRequestSucess:pageCount:userData:)] ) {
                        [obj appColumnNewAllListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestAppColumnNewAllList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=app/newestall&page=%d",pageCount];
    
    
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appColumnNewAllListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"应用栏目最新全部列表")
                        [obj appColumnNewAllListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnNewAllListRequestFail:userData:)] ) {
                            [obj appColumnNewAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnNewAllListRequestSucess:pageCount:userData:)] ) {
                            [obj appColumnNewAllListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnNewAllListRequestFail:userData:)] ) {
                            [obj appColumnNewAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(appColumnNewAllListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"应用栏目最新全部列表请求失败---%@",error);
                    [obj appColumnNewAllListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 应用栏目-热门全部列表
- (void)getAppColumnHotAllList:(int)pageCount userData:(id)userData{
    
    NSString *bodyStr = [NSString stringWithFormat:@"r=app/hotsall&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    
    //NSDictionary *saveDic = @{};
    
    NSDictionary *saveDic = (NSDictionary *)[[TMCache sharedCache] objectForKey:cacheStr];
    
    if (!saveDic) {
        [self requestAppColumnHotAllList:pageCount userData:userData];
    }else{
        NSDictionary *data = [saveDic objectForKey:@"flag"];
        if( !IS_NSDICTIONARY(data) ) {
            [self requestAppColumnHotAllList:pageCount userData:userData];
            return ;
        }
        
        CGFloat pastdueTime = [[data objectForKey:@"expire"] floatValue];
        if ([[FileUtil instance] timeIntervalFromNow:[saveDic objectForKey:@"ModifyTime"]] > pastdueTime) {
            
            [self requestAppColumnHotAllList:pageCount userData:userData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appColumnHotAllListRequestSucess:pageCount:userData:)] ) {
                        [obj appColumnHotAllListRequestSucess:saveDic pageCount:pageCount userData:userData];
                    }
                }];
            });
            
        }
        
    }
    
    
}

- (void)requestAppColumnHotAllList:(int)pageCount userData:(id)userData{
    NSString*bodyStr = [NSString stringWithFormat:@"r=app/hotsall&page=%d",pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(appColumnHotAllListRequestFail:userData:)] ) {
                        NOT_DIC_ERROR(@"应用栏目热门全部列表")
                        [obj appColumnHotAllListRequestFail:pageCount userData:userData];
                        
                    }
                }];
            });
            //错误汇报
            [self reportError:bodyStr response:responseString];
        }else{
            if (![[map objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnHotAllListRequestFail:userData:)] ) {
                            [obj appColumnHotAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
            }else if (IS_NSDICTIONARY([map objectForKey:@"flag"])) {
                NSDictionary *saveDic = [[TMCache sharedCache] objectForKey:cacheStr];
                if (saveDic && [[[saveDic objectForKey:@"flag"] objectForKey:@"md5"] isEqualToString:[[map objectForKey:@"flag"] objectForKey:@"md5"]]) {
                    NSMutableDictionary *_saveDic = [NSMutableDictionary dictionaryWithDictionary:saveDic];
                    [_saveDic setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_saveDic forKey:cacheStr];
                    
                }else{
                    
                    NSMutableDictionary *_map = [NSMutableDictionary dictionaryWithDictionary:map];
                    [_map setObject:[self getCurrentSystemDate] forKey:@"ModifyTime"];
                    [[TMCache sharedCache] setObject:(NSDictionary*)_map forKey:cacheStr];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnHotAllListRequestSucess:pageCount:userData:)] ) {
                            [obj appColumnHotAllListRequestSucess:(NSDictionary *)[[TMCache sharedCache] objectForKey: cacheStr ] pageCount:pageCount userData:userData];
                        }
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(appColumnHotAllListRequestFail:userData:)] ) {
                            [obj appColumnHotAllListRequestFail:pageCount userData:userData];
                            
                        }
                    }];
                });
                
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(appColumnHotAllListRequestFail:userData:)] ) {
                    NSError *error = [requestSelf error];
                    NSLog(@"应用栏目热门全部列表请求失败---%@",error);
                    [obj appColumnHotAllListRequestFail:pageCount userData:userData];
                    
                }
            }];
        });
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];
}

#pragma mark -
#pragma mark 获取定时本地推送
- (void)getTimingLocalNotifications{
    NSString*bodyStr = @"r=index/pushmsg";
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        responseString = [self clearNullInString:responseString];
        NSDictionary * map = [self analysisJSONToDictionary:responseString];
        
        if (!map) return ;
        NSArray *dataArray = [map objectForKey:@"data"];
        if (!dataArray || ![dataArray isKindOfClass:[NSArray class]] ||dataArray.count < 1) return;
        
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary*)obj;
            NSString*keyName = [self zipLocalNotifiDocmentKey:[dic objectForKey:@"id"] fireDate:[dic objectForKey:@"show_date"]];
            
            if ([self searchLocalNotifiFromDocment:keyName] == NO) {
                NSInteger sendTimer = (NSInteger)[[FileUtil instance] NotifTimeIntervalFromNow:[dic objectForKey:@"show_date"]];
                
                [self sendLoaclNotifi:sendTimer info:dic];
                [self loaclNotifiSaveDocment:dic key:keyName];
            }
         
            
        }];
        
        NSInteger nextTime = [[[dataArray objectAtIndex:0] objectForKey:@"next_time"] integerValue];
        [self requestLocalNotificationInfoAgain:nextTime];

    }];
    
    [request setFailedBlock:^{
        [self reportError:bodyStr response: [[requestSelf error] localizedDescription]];
    }];

}

#pragma mark -
#pragma mark 壁纸分享
- (void)sendBizhiShareToKuaiyong:(NSString*)bigPicUrl{
    
    NSString*bodyStr = [NSString stringWithFormat:@"r=index/sharewallpaper&pic=%@",bigPicUrl];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        

    }];
    
    [request setFailedBlock:^{

    }];
}


#pragma mark -
#pragma mark 启动提醒

#define MODIFYTIME @"ModifyTime"
#define ENABLE_REMIND @"enable_remind"

- (void)requestEnableRemind:(id)userData{
    
    NSString*bodyStr = @"r=remind/getRemind";
    NSString *urlStr = [self getRequestString:bodyStr];

    //检测本地缓存是否可用

    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        NSMutableDictionary * map = [NSMutableDictionary dictionaryWithDictionary:[self analysisJSONToDictionary:responseString]];
        NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
        
        
        if (![[map objectNoNILForKey:@"data"] isKindOfClass:[NSDictionary class]] ||![map objectNoNILForKey:@"data"] || ![[map objectNoNILForKey:@"data"] objectNoNILForKey:@"begin_time"] || ![[map objectNoNILForKey:@"data"] objectNoNILForKey:@"end_time"] || ![[map objectNoNILForKey:@"data"] objectNoNILForKey:@"detailUrl"] || ![[map objectNoNILForKey:@"data"] objectNoNILForKey:@"show_times"]) {
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 启动提醒失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(EnableRemindRequestFail:)] ) {
                        [obj EnableRemindRequestFail:userData];
                        
                    }
                }];
            });
            return ;
        }
        
        NSInteger startTime = [[[map objectNoNILForKey:@"data"] objectNoNILForKey:@"begin_time"] integerValue];
        NSInteger endTime = [[[map objectNoNILForKey:@"data"] objectNoNILForKey:@"end_time"] integerValue];
        NSString *webUrl = [[map objectNoNILForKey:@"data"] objectNoNILForKey:@"detailUrl"];
        
        
        if ([map isKindOfClass:[NSMutableDictionary class]] && nowDate >= startTime && nowDate <= endTime && webUrl.length >2) {
            
            NSInteger showTime = [[[map objectNoNILForKey:@"data"] objectNoNILForKey:@"show_times"] integerValue];
            NSString *saveKey = [NSString stringWithFormat:@"%@%d",ENABLE_REMIND,showTime];
            
            if (showTime <1) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if( [obj respondsToSelector:@selector(EnableRemindRequestSucess:userData:)] ) {
                            [obj EnableRemindRequestSucess:(NSDictionary*)[map objectForKey:@"data"] userData:userData];
                            
                        }
                    }];
                });
            }else{
                
                if (![[NSUserDefaults standardUserDefaults] objectForKey:saveKey]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:showTime] forKey:saveKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if( [obj respondsToSelector:@selector(EnableRemindRequestSucess:userData:)] ) {
                                [obj EnableRemindRequestSucess:(NSDictionary*)[map objectForKey:@"data"] userData:userData];
                                
                            }
                        }];
                    });
                    
                }else{
                    //fail
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if( [obj respondsToSelector:@selector(EnableRemindRequestFail:)] ) {
                                [obj EnableRemindRequestFail:userData];
                                
                            }
                        }];
                    });
                }

                
            }
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 启动提醒失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(EnableRemindRequestFail:)] ) {
                        [obj EnableRemindRequestFail:userData];
                        
                    }
                }];
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@" 启动提醒请求失败---%@",error);
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            }];
        });
    }];
    
}




#pragma mark -
#pragma mark 发现-资讯,苹果派





- (void)requestFound:(NSString*)type page:(int)pageCount isUseCache:(BOOL)isUseCache userData:(id)userData{

    NSString*bodyStr = [NSString stringWithFormat:@"r=list/discovery&type=%@&page=%d",type,pageCount];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSString *requestStr = urlStr;
    
    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    //检测本地缓存是否可用
    
    while (isUseCache) {
        
        NSMutableDictionary *cacheData = [[TMCache sharedCache] objectForKey:cacheStr];
        if(![cacheData isKindOfClass:[NSMutableDictionary class]]){
            break;
        }
        NSInteger modTime = [[cacheData objectNoNILForKey:MODIFYTIME] integerValue];
        NSInteger _modTime = [[[cacheData objectNoNILForKey:@"flag"] objectNoNILForKey:@"expire"] integerValue];
        if (nowDate - modTime <= _modTime) {
            //返回本地数据, 回调成功消息
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(FoundRequestSucess:type:pageCount:userData:isUseCache:)] ) {
                        [obj FoundRequestSucess:(NSDictionary *)cacheData type:type pageCount:pageCount userData:userData isUseCache:isUseCache];
                    }
                }];

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
        //        NSLog(@"map map == %@", map);
        
        if ([map isKindOfClass:[NSMutableDictionary class]] && [[map objectNoNILForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            [map setObject:[NSNumber numberWithInteger:[[FileUtil instance] currentTimeStamp]] forKey:MODIFYTIME];
            
            [[TMCache sharedCache] setObject:map forKey:cacheStr];
            
            //sucess
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(FoundRequestSucess:type:pageCount:userData:isUseCache:)] ) {
                        [obj FoundRequestSucess:map type:type pageCount:pageCount userData:userData isUseCache:isUseCache];
                    }
                }];
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 推荐请求失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(FoundRequestFail:pageCount:userData:isUseCache:)] ) {
                        [obj FoundRequestFail:type pageCount:pageCount userData:userData isUseCache:isUseCache];
                    }
                }];
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@" 推荐请求失败---%@",error);
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(FoundRequestFail:pageCount:userData:isUseCache:)] ) {
                    [obj FoundRequestFail:type pageCount:pageCount userData:userData isUseCache:isUseCache];
                }
            }];
        });
    }];
    
}

#pragma mark -
#pragma mark 装机必备专题
- (void)requestInstallednecessary:(BOOL)isUseCache userData:(id)userData{
    NSString*bodyStr = @"r=special/necessarySpecialApp";
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSString *requestStr = urlStr;
    
    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    //检测本地缓存是否可用
    
    while (isUseCache) {
        
        NSMutableDictionary *cacheData = [[TMCache sharedCache] objectForKey:cacheStr];
        if(![cacheData isKindOfClass:[NSMutableDictionary class]]){
            break;
        }
        NSInteger modTime = [[cacheData objectNoNILForKey:MODIFYTIME] integerValue];
        NSInteger _modTime = [[[cacheData objectNoNILForKey:@"flag"] objectNoNILForKey:@"expire"] integerValue];
        if (nowDate - modTime <= _modTime) {
            //返回本地数据, 回调成功消息
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestInstallednecessarySucess:userData:)] ) {
                        [obj requestInstallednecessarySucess:(NSDictionary *)cacheData userData:userData];
                    }
                }];
                
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
        
        if ([map isKindOfClass:[NSMutableDictionary class]] && [[map objectNoNILForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            [map setObject:[NSNumber numberWithInteger:[[FileUtil instance] currentTimeStamp]] forKey:MODIFYTIME];
            
            [[TMCache sharedCache] setObject:map forKey:cacheStr];
            
            //sucess
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestInstallednecessarySucess:userData:)] ) {
                        [obj requestInstallednecessarySucess:map userData:userData];
                    }
                }];
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 装机必备请求失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestInstallednecessaryFail:)] ) {
                        [obj requestInstallednecessaryFail:userData];
                    }
                }];
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@" 装机必备请求失败---%@",error);
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(requestInstallednecessaryFail:)] ) {
                    [obj requestInstallednecessaryFail:userData];
                }
            }];
        });
    }];
}

#pragma mark -
#pragma mark 免费下载
- (void)requestFreeAppOrGame:(int)page type:(NSString*)type userData:(id)userData isUseCache:(BOOL)isUseCache{
    
    NSString*bodyStr = [NSString stringWithFormat:@"r=freeApp/list&page=%d&tag=%@",page,type];
    NSString *cacheStr = [self getCacheString:bodyStr];
    NSString *urlStr = [self getRequestString:bodyStr];
    
    NSString *requestStr = urlStr;
    
    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    //检测本地缓存是否可用
    
    while (isUseCache) {
        
        NSMutableDictionary *cacheData = [[TMCache sharedCache] objectForKey:cacheStr];
        if(![cacheData isKindOfClass:[NSMutableDictionary class]]){
            break;
        }
        NSInteger modTime = [[cacheData objectNoNILForKey:MODIFYTIME] integerValue];
        NSInteger _modTime = [[[cacheData objectNoNILForKey:@"flag"] objectNoNILForKey:@"expire"] integerValue];
        if (nowDate - modTime <= _modTime) {
            //返回本地数据, 回调成功消息
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestFreeAppOrGameSucess:page:type:userData:)] ) {
                        [obj requestFreeAppOrGameSucess:(NSDictionary *)cacheData page:page type:type userData:userData];
                    }
                }];
                
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
        
        if ([map isKindOfClass:[NSMutableDictionary class]] && [[map objectNoNILForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            [map setObject:[NSNumber numberWithInteger:[[FileUtil instance] currentTimeStamp]] forKey:MODIFYTIME];
            
            [[TMCache sharedCache] setObject:map forKey:cacheStr];
            
            //sucess
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestFreeAppOrGameSucess:page:type:userData:)] ) {
                        [obj requestFreeAppOrGameSucess:(NSDictionary*)map page:page type:type userData:userData];
                    }
                }];
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@" 免费应用游戏请求失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestFreeAppOrGameFail:type:userData:)] ) {
                        [obj requestFreeAppOrGameFail:page type:type userData:userData];
                    }
                }];
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@"  免费应用游戏请求失败---%@",error);
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(requestFreeAppOrGameFail:type:userData:)] ) {
                    [obj requestFreeAppOrGameFail:page type:type userData:userData];
                }
            }];
        });
    }];

}

#pragma mark -
#pragma mark 礼包
- (void)requestPackageWebUrl:(id)userData{
    NSString*bodyStr = @"r=package/packageUrl";

    NSString *urlStr = [self getRequestString:bodyStr];

    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        NSMutableDictionary * map = [NSMutableDictionary dictionaryWithDictionary:[self analysisJSONToDictionary:responseString]];
        
        if ([map isKindOfClass:[NSMutableDictionary class]] && [[map objectNoNILForKey:@"data"] isKindOfClass:[NSString class]]) {

            //sucess
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestPackageWebUrlSucess:webUrl:)] ) {
                        [obj requestPackageWebUrlSucess:userData webUrl:[map objectNoNILForKey:@"data"]];
                    }
                }];
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                NSLog(@"礼包请求失败---%@",error);
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(requestPackageWebUrlFail:)] ) {
                        [obj requestPackageWebUrlFail:userData];
                    }
                }];
            });
            
        }
        
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            NSLog(@"礼包请求失败---%@",error);
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(requestPackageWebUrlFail:)] ) {
                    [obj requestPackageWebUrlFail:userData];
                }
            }];
        });
    }];
}

#pragma mark-
#pragma mark 私有方法
- (NSString*)zipLocalNotifiDocmentKey:(NSString*)ID fireDate:(NSString*)fireDate{
    return [NSString stringWithFormat:@"%@_%@",ID,fireDate];
}
- (void)loaclNotifiSaveDocment:(NSDictionary*)info key:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)searchLocalNotifiFromDocment:(NSString*)key{
    
    NSDictionary* obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (obj) return YES;
    return NO;
}
- (void)deleteLocalNotifiFromDocment:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)requestLocalNotificationInfoAgain:(NSTimeInterval)time{
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(requestLocalNotifi:) userInfo:nil repeats:NO];
}
- (void)requestLocalNotifi:(NSTimer*)time{
    [self getTimingLocalNotifications];
}

- (void)sendLoaclNotifi:(NSTimeInterval)time info:(NSDictionary*)info{
    
    if (IOS8) {
        //创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"接收";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        action.authenticationRequired = YES;
        action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2";
        action2.title=@"拒绝";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        
        //创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
        
        
        //注册推送
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:time];
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = [info objectForKey:@"title"];
    localNotification.userInfo = info;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (NSString *)getDESString:(NSString *)string{
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

- (NSString *)clearNullInString:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@"null" withString:@""];
}


-(NSString*)getRequestString:(NSString*)bodyStr {
    
    
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
    
    NSString * urlStr = nil;
    if ([[FileUtil instance] checkAuIsCanLogin] == YES) {
        urlStr = [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS,[self getDESString:bodyStr]];
    }else{
        urlStr = [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS_QIQIAN,[self getDESString:bodyStr]];
    }
    
    
    
    return urlStr;
}

-(NSString*)getCacheString:(NSString*)bodyStr {
    
    NSString * cacheStr = nil;
    if ([[FileUtil instance] checkAuIsCanLogin] == YES) {
        cacheStr = [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS,bodyStr];
    }else{
        cacheStr = [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS_QIQIAN,bodyStr];
    }
    
    return cacheStr;
}


-(void)reportError:(NSString*)requestStr response:(NSString*)responseStr {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectNoNIL:requestStr forKey:@"request"];
    [dic setObjectNoNIL:responseStr forKey:@"response"];
    
    [[ReportManage instance] reportPHPRequestError:dic];
    
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


@end
