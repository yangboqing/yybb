//
//  KY_UpdataSDK.m
//  browser
//
//  Created by 王毅 on 14-3-5.
//
//

#import "KY_UpdataSDK.h"
#import "FileUtil.h"

//#define SERVICE_URL_STR @"http://f_kyadvwallstat.bppstore.com/interface/appid2plist.php"
#define SERVICE_URL_STR @"http://iphoneapp.kuaiyong.com/kysdk"



#define APPVERSION @"appversion"
#define PLIST @"plist"

#define SEPARATE @"],["

#define VERSION_KEY @"version"

@interface  KY_UpdataSDK(){
    
    NSURLConnection * connection;
    
    NSMutableData * connectionData;
    
    int timeOut;
    
    NSMutableDictionary * _version;
    
    NSMutableDictionary * jsonMap;
}

@end

@implementation KY_UpdataSDK
@synthesize updataDelegate = _updataDelegate;

-(id)init{
    self = [super init];
    if(self){
        connection = [[NSURLConnection alloc]init];
        
        connectionData = [[NSMutableData alloc]init];
        
        jsonMap = [[NSMutableDictionary alloc]init];
        
        _version = [[NSMutableDictionary alloc]init];
        
        timeOut = 30;
        
    }
    return self;
}

-(void)setTimeOut:(int)flag{
    timeOut = flag;
}

- (void) checkVersionOfAppId:(NSString *)appId nowVersion:(NSString *)version{
    
    [jsonMap removeAllObjects];
    
    [_version setObject:version forKey:VERSION_KEY] ;
    
    NSURL *url = [NSURL URLWithString:SERVICE_URL_STR];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOut];
    
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"appid=%@",appId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSURLConnection * newConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    connection = newConnection;
    
    if (connection != nil){
//        NSLog(@"连接成功");
    } else {
//        NSLog(@"连接失败");
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(happenError:)]){
        [_updataDelegate happenError:error];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [connectionData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
//    itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/27/68/com.kuaiyong.browser/dizigui_zhouyi_com.kuaiyong.browser_1404057600_1.5.1.0.plist],[1.5.1.0],[更新内容],[是否强升
    
    
    /* 下载的数据 */
    NSString * dataStr = [[NSString alloc]initWithData:connectionData encoding:NSUTF8StringEncoding];
    NSArray * dataArray = [dataStr componentsSeparatedByString:SEPARATE];
    
    
    //数据解析发生异常
    if(dataArray.count < 2){
        if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(happenError:)]){
            [_updataDelegate happenError:nil];
        }
        return;
        
    }
    
    //服务器返回版本为空
    NSString * version = [dataArray objectAtIndex:1];
    if(version == nil || [version isEqualToString:@""]){
        if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(happenError:)]){
            [_updataDelegate happenError:nil];
        }
        
        return;
    }
    
    BOOL flag = YES;
    //YES为无新版本；NO为有新版本
    if([[FileUtil instance] hasNewVersion:version oldVersion:[_version objectForKey:VERSION_KEY]] == NO){
        flag = YES;
    }else{
        
        flag = NO;
        NSString * plistStr = [dataArray objectAtIndex:0];
        if(plistStr == nil || [plistStr isEqualToString:@""]){
            //服务器返回更新地址为空
            if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(happenError:)]){
                [_updataDelegate happenError:nil];
            }
            
            return;
        }else{
            [jsonMap setObject:plistStr forKey:PLIST];
        }
    }
    
    if(dataArray.count > 2){
        if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(updateInfo:updateVersion:)]){
            NSArray * infoArray = [[dataArray objectAtIndex:2] componentsSeparatedByString:@"\n"];
            [_updataDelegate updateInfo:infoArray updateVersion:version];
        }
    }
    
    //是否强制升级
    BOOL lbForceUpdate = NO;
    if(dataArray.count > 3){
        if([[dataArray objectAtIndex:3] isEqualToString:@"forceupdate"]){
            lbForceUpdate = YES;
        }
    }
    
    
    if(_updataDelegate && [_updataDelegate respondsToSelector:@selector(checkResult:forceupdate:)]){
        [_updataDelegate checkResult:flag forceupdate:lbForceUpdate];
    }
    
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [connectionData setLength:0];
}

- (void) installNewVersion {
    NSURL * plistUrl = [NSURL URLWithString:[jsonMap objectForKey:PLIST]];
    
    if([[UIApplication sharedApplication] canOpenURL:plistUrl]){
        
        [[UIApplication sharedApplication] openURL:plistUrl];
    }
}

-(void)dealloc
{
}
@end
