//
//  AppUpdateNewVersion.m
//  browser
//
//  Created by liull on 14-8-29.
//
//

#import "AppUpdateNewVersion.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "UserActiveLog.h"
#import "NSDictionary+noNIL.h"
#import "FileUtil.h"
#import "encryAppID.h"

#import "NSString+Hashing.h"


@implementation AppUpdateNewVersion

+(id)shareInstance {
    
    @synchronized(@"AppUpdateNewVersion") {
        static id _self = nil;
        if(!_self) {
            _self = [[[self class] alloc] init];
        }
        return _self;
    }
    
}



-(void)udpateNewVersion:(id<AppUpdateNewVersionProtocol>)delegate  userinfo:(id)userinfo {
    
    NSString * urlStr = IPHONE_REQUEST_ADDRESS;
    NSString *bodyS = [NSString stringWithFormat:@"r=update/selfUpdate&channel=%@&certificate=%@&systemVersion=%@",[[FileUtil instance] channelInfoForKey:CHANNEL_ID],[[FileUtil instance] Certificate],[[UIDevice currentDevice] systemVersion]];
    bodyS = [DESUtils encryptUseDES:bodyS key:@"i2.0908o"];
    bodyS = [[FileUtil instance] urlEncode:bodyS];
    urlStr = [urlStr stringByAppendingString:bodyS];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //助手版本
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];

    //设置POST表单
    NSString * appID = [DecryAppID getBundlePesudoAppID];
    
    [request setPostValue:appID  forKey:@"appid"];
    [request setPostValue:clientVer  forKey:@"clientversion"];
    [request setPostValue:[[UserActiveLog getUserLoginInfo] JSONString]  forKey:@"useractive"];
    [request setPostValue:[[FileUtil instance] channelInfoForKey:CHANNEL_ID]  forKey:@"chid"];
    
    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        while (YES) {
            
            NSString *responseString = [requestSelf responseString];

            //对数据进行检测
            NSDictionary * map = [responseString objectFromJSONString];
            if(!IS_NSDICTIONARY(map))
                break;
            
            NSDictionary * flag = [map getNSDictionaryObjectForKey:@"flag"];
            if( !flag )
                break;
            
            NSDictionary * data = [map getNSDictionaryObjectForKey:@"data"];
            if(!data)
                break;
            
            NSString * urlPlist = [[data objectForKey:@"appinfo"] objectForKey:@"plist"];
            if(urlPlist && urlPlist.length > 0) {
                //成功
                if( [delegate respondsToSelector:@selector(AppUpdateNewVersionSuccess:userinfo:)] ){
                    [delegate AppUpdateNewVersionSuccess:data userinfo:userinfo];
                    return ;
                }
            }
            
            break;
        }
        
        //失败
        if( [delegate respondsToSelector:@selector(AppUpdateNewVersionFail:userinfo:)] ){
            [delegate AppUpdateNewVersionFail:nil userinfo:userinfo];
        }
    }];
    
    [request setFailedBlock:^{
        //失败
        NSError *error = [requestSelf error];
//        NSLog(@"快用更新失败---%@",error);
        if( [delegate respondsToSelector:@selector(AppUpdateNewVersionFail:userinfo:)] ){
            [delegate AppUpdateNewVersionFail:nil userinfo:userinfo];
        }
    }];
    
}

- (void)requestKKKDownloadAdress{
    
    NSURL *url = [NSURL URLWithString:GET_KKK_IPADOWNURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];

    __weak ASIFormDataRequest *requestSelf = request;
    [request startAsynchronous];
    [request setCompletionBlock:^{
     
            
        NSString *responseString = [requestSelf responseString];
        responseString = [responseString substringWithRange:NSMakeRange(1, responseString.length -1)];
        NSDictionary * map = [[FileUtil instance] analysisJSONToDictionary:responseString];
        
        if (map && [map objectForKey:@"plist"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KKK_DOWNLOAD_ADDRESS object:nil userInfo:map];
            });
            
        }
        
        
        //失败
        {
            
        }
    }];
    
    [request setFailedBlock:^{
        //失败
        NSError *error = [requestSelf error];
//        NSLog(@"获取3K下载地址失败失败---%@",error);
 
    }];

    
    
}



@end
