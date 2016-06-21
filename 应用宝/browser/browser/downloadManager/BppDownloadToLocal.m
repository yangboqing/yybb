//
//  BppDownloadToLocal.m
//  browser
//
//  Created by 王毅 on 13-11-6.
//
//

#import "BppDownloadToLocal.h"
#import "GetDevIPAddress.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "FileUtil.h"
#import "JSONKit.h"
#import "DownloadReport.h"


@interface BppDownloadToLocal ()
@property (nonatomic , retain)NSString *plistString;
@property (nonatomic , retain)NSString *dlfromString;
@end

@implementation BppDownloadToLocal
@synthesize plistString = _plistString;
@synthesize dlfromString = _dlfromString;
@synthesize plistURL;
- (id) init {
    
    if ( self=[super init] ) {
    }
    return self;
}

- (void)dealloc{
    
    self.plistURL = nil;
    self.plistString = nil;
    self.dlfromString = nil;    
}

+ (BppDownloadToLocal *)getObject{
    @synchronized(@"BppDownloadToLocal") {
        static BppDownloadToLocal *getObject = nil;
        if (getObject == nil) {
            getObject = [[BppDownloadToLocal alloc] init];
        }
        
        return getObject;
    }
}

//收集plist地址用于解析发安装日志
- (BOOL)downLoadPlistFile:(NSString *)plistUrl{
    
    //获取plist发布地址(不包含参数)
    self.plistURL = [[FileUtil instance] distriPlistURLNoArg:plistUrl];
    if( !self.plistURL ) {
        return FALSE;
    }
    
    //获取dlfrom
    self.dlfromString = [[FileUtil instance] getPlistURLArg:plistUrl argName:@"dlfrom"];
    
    //转换成系统支持方式
    self.plistURL = [self.plistURL stringByReplacingOccurrencesOfString:@"_s.plist" withString:@".plist"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.plistURL]];
    

    //创建路径
    NSString * strPath = [[FileUtil instance] getDocumentsPath];
    strPath = [strPath stringByAppendingPathComponent:@"deploy"];
    [[NSFileManager defaultManager] createDirectoryAtPath:strPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    strPath = [strPath stringByAppendingPathComponent: [plistUrl componentsSeparatedByString:@"/"].lastObject ];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:strPath]){
            [self getFileDic:strPath];
        }else{
            NSURL *url = [NSURL URLWithString:[self getPlistDownloadPath:plistUrl]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:strPath atomically:YES];
            [self getFileDic:strPath];
        }
    });
    
    return YES;
}

- (NSString *)getPlistDownloadPath:(NSString *)plist{

    NSString * plistUrl = [[FileUtil instance] plistURLNoArg:plist];
    if( !plistUrl ) {
        return nil;
    }
    
    return plistUrl;
}


//获取已经下载到本地的plist，进行解析，然后汇报日志，最后删除本地文件
- (void)getFileDic:(NSString *)pathStr{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:pathStr];
    NSString *appId = nil;
    NSString *appName = nil;
    NSString *appVersion = nil;
    NSArray *items = [dic objectForKey:@"items"];
    NSDictionary * metadata = [(NSDictionary *)[items objectAtIndex:0] objectForKey:@"metadata"];
    if (metadata) {
        appId = [metadata objectForKey:@"bundle-identifier"];
        appVersion = [metadata objectForKey:@"bundle-version"];
        appName = [metadata objectForKey:@"title"];
    }
    
    [[DownloadReport getObject] localdownloadReportByAppId:appId
                                              appVersion:appVersion
                                                  dlfrom:self.dlfromString
                                                  appUrl:self.plistURL];
    
    [[GetDevIPAddress getObject] localReportInstallAPPID:appId
                                                 appName:appName
                                              appVersion:appVersion
                                                  dlfrom:self.dlfromString
                                             downloadUrl:self.plistURL];
    
    [[NSFileManager defaultManager] removeItemAtPath:pathStr error:nil];
}


//传入appid获取相应的库里的plist
- (NSString *)getIpaPlist:(NSString *)appId{
    

    NSURL *url = [NSURL URLWithString:SERVICE_URL_STR];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:appId forKey:@"appid"];
    [request setTimeOutSeconds:5];
    
    [request setDelegate:self];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        NSArray * dataArray = [responseString componentsSeparatedByString:@"],["];
        
        if(dataArray.count < 2){
            
//            NSLog(@"安装到本地的数据解析发生异常:");
            self.plistString = nil;
            
        }else{
            NSString *plistStr = [dataArray objectAtIndex:0];
            if (plistStr == nil || [plistStr isEqualToString:@""]) {
//                NSLog(@"安装到本地的数据解析发生异常:");
                self.plistString = nil;
            }else{
                self.plistString = plistStr;
                [self downLoadPlistFile:plistStr];
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        
        //        NSLog(@"反馈失败");
        
    }];
    
    
    return self.plistString;
}

@end
