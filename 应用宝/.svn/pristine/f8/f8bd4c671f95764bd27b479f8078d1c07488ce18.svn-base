//
//  RealtimeShowAdvertisement.m
//  browser
//
//  Created by 王毅 on 14-4-10.
//
//

#import "RealtimeShowAdvertisement.h"


@implementation RealtimeShowAdvertisement
@synthesize delegate;

+(RealtimeShowAdvertisement *)getObject{
    @synchronized(@"RealtimeShowAdvertisement") {
        
        static RealtimeShowAdvertisement *getObject = nil;
        if(getObject == nil){
            getObject = [[RealtimeShowAdvertisement alloc]init];
        }
        return getObject;
    }
}

- (id) init {
    
    if ( self=[super init] ) {
        
        
    }
    
    return self;
}
- (void)requestRealtimeShowNew{
    NSString *platform = [[FileUtil instance] deviceType];
    
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",IPHONE_REQUEST_ADDRESS,[self getDESString:[NSString stringWithFormat:@"r=bootPicture/getBootPicture&platform=%@",platform]]];//  http://b_appsmgr.bppstore.com/i/i.php?d=

    NSURL *url = [NSURL URLWithString:getUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    NSLog(@"kpt URL %@",request.url);
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        
        NSDictionary *dataDic = [self analysisJSONToDictionary:responseString];
        
        if (![self checkNewKptData:dataDic]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowFaild)]) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowsuccessWithDic:)]) {
                    [self.delegate requestRealtimeShowsuccessWithDic:nil];
                }
                
                [self.delegate requestRealtimeShowFaild];
            }
            NSLog(@"检测数据开屏图数据错误");
            return ;
        }
        
        if (IS_NSDICTIONARY([dataDic objectForKey:@"data"]) && [[dataDic objectForKey:@"data"] objectForKey:@"imgurl"]) {
            NSMutableDictionary *datadic = [NSMutableDictionary dictionaryWithDictionary:[dataDic objectForKey:@"data"]];
            
            if (datadic != nil && [[datadic allKeys] count]) {
                
                //            BOOL isImag = YES;
                //            NSString *imgId = [dic objectForKey:@"imgid"];
                //            NSString *imgUrl = [dic objectForKey:@"imgurl"];
                //            NSString *startTime = [dic objectForKey:@"starttime"];
                //            NSString *endTime = [dic objectForKey:@"endtime"];
                
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowsuccessWithDic:)]) {
                    [self.delegate requestRealtimeShowsuccessWithDic:datadic];
                }
            }else{
                //            BOOL isImag = NO;
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowsuccessWithDic:)]) {
                    [self.delegate requestRealtimeShowsuccessWithDic:nil];
                }
                
            }
            NSLog(@"kpt 请求成功 数据  %@",dataDic);
            
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowFaild)]) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowsuccessWithDic:)]) {
                    [self.delegate requestRealtimeShowsuccessWithDic:nil];
                }
                
                [self.delegate requestRealtimeShowFaild];
            }
            NSLog(@"kpt数据错误或者没数据");
        }
        
        
        
        
    }];
    
    [request setFailedBlock:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestRealtimeShowFaild)]) {
            [self.delegate requestRealtimeShowFaild];
        }
        
        NSLog(@"kpt 请求失败");
        
    }];
    
    
}

-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSDICTIONARY(root))
        return nil;
    
    return root;
}

- (BOOL) writeFileData:(NSData*)data filePath:(NSString*)path{
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) {
        return [data writeToFile:path atomically:YES];
    }
    //打开一个文件准备写入
    NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:path];
    //将当前文件的偏移量定位到文件末尾
    [file seekToEndOfFile];
    [file writeData:data];
    [file closeFile];
    
    return file==nil?NO:YES;
}
- (NSString*)getDESString:(NSString*)str{
    return [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:str key:@"i2.0908o"]];
}
#pragma mark - 检测数据

- (BOOL)checkNewKptData:(NSDictionary *)dic
{

    if(!dic)
        return NO;
    
    NSDictionary * data = [dic getNSDictionaryObjectForKey:@"data"];

    if (data) {
        if ([data getNSStringObjectForKey:@"imgid"] &&
            [data getNSStringObjectForKey:@"imgurl"] &&
            [data getNSStringObjectForKey:@"starttime"] &&
            [data getNSStringObjectForKey:@"endtime"] &&
            [data getNSStringObjectForKey:@"platform"] &&
//            [data getNSStringObjectForKey:@"appid"] &&
            [data getNSStringObjectForKey:@"type"]) {
            return YES;
        }return NO;
    }return NO;
    
}

@end
