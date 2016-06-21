//
//  BppDistriPlistParser.m
//  browser
//
//  Created by 刘 亮亮 on 13-1-9.
//
//

#import "BppDistriPlistParser.h"
#import "BppDownloadFile.h"
#import "FileUtil.h"
#import "AppStoreDownload.h"
#import "NSDictionary+noNIL.h"
#import "DownloadReport.h"
#import "TMCache.h"
#import "AppStoreNewDownload.h"
#define IPASTATE_HEAD @"ipastatehead"
#define BPPEnterpriseDistribution_PlistKey      @"DownloadPlistKey"
#define BPPEnterpriseDistribution_IPAKey        @"DownloadIPAKey"
#define BPPEnterpriseDistribution_IPAIconKey    @"DownloadIPAIconKey"



//用于汇报日志
//下载失败类型
#define DOWNLOAD_ERROR_NULL         @"errorNull"       //无错误
#define DOWNLOAD_PLIST_PARSER_ERROR @"plistParserError" //PLIST解析失败
#define DOWNLOAD_SINF_OR_PATCH_MIX_ERROR @"sinforpatchError" //sinf或者patch合成失败


@interface BppDistriPlistParser ()  <BppDownloadFileDeletgate>


//@property (atomic, copy)  NSString * appKind;            //plist文件URL

@property (atomic, strong)  NSString * plistURL;           //plist文件URL

@property (atomic, strong)  NSString * ipaURL;             //IPA的下载地址

@property (atomic, strong)  NSString * plistCacheDir;    //该IPA存储的本地地址


@property (atomic, assign)  BOOL  bUserStop;             //用于停止了下载地址
@property (atomic, strong)  BppDownloadFile*  curDownloadFile;   //用于停止了下载地址

@property (atomic, strong) NSRecursiveLock * parserLock;

@property (atomic, strong) NSString * ipaMD5;           //ipa文件的md5

@property (atomic, strong) NSString *dlFrom;
@property (atomic, strong) NSString * ipaLocalDir;     //本地数据保存路径

@property (atomic, assign)  BOOL  isLogin; //判断是否已经登录

@property (atomic, assign) BOOL isMixSucess;

- (BOOL) ParsePlistInfo:(NSString*)plistPath;

@property (atomic, strong) NSDictionary * errorType;  //失败类型


@property (atomic, strong) AppStoreDownload * appStoreDownload; //AU下载
@property (atomic, strong) AppStoreNewDownload *appStoreNewDownload;

//文件下载进度
- (void) onDownloadFileProgress:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr;

//下载完成
- (void) onDidDownloadFileFinished:(BppDownloadFile*)downloadFile
                      downloadAttr:(NSDictionary*)attr;

//下载Error
- (void) onDidDownloadFileError:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr;

//从plist url中取出md5字符串
- (NSString *) getPlistMD5:(NSString*)plist;

@end


@implementation BppDistriPlistParser

@synthesize ipaIconURL;
//@synthesize appKind;

@synthesize appID;
@synthesize appVersion;
@synthesize appName;


@synthesize plistURL;

@synthesize ipaURL;

@synthesize ipaPath;

@synthesize plistCacheDir;
@synthesize ipaLocalDir;

@synthesize userInfo;

@synthesize bUserStop;
@synthesize curDownloadFile;

@synthesize parserDelegate;

@synthesize parserLock;
@synthesize ipaMD5;

@synthesize downType;

@synthesize dlFrom;

@synthesize orignalDistriPlistURL;

@synthesize plistCachePath;

@synthesize errorType;


- (id) init {
    
    if (self = [super init]) {
        
        self.parserLock = [[NSRecursiveLock alloc] init];
        self.isMixSucess = NO;
        //失败原因对照表
        self.errorType = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"DownloadErrorNet",
                          [NSNumber numberWithInteger:DownloadErrorNet],
                          @"DownloadErrorNoFreeSpace",
                          [NSNumber numberWithInteger:DownloadErrorNoFreeSpace],
                          @"DownloadErrorFileException",
                          [NSNumber numberWithInteger:DownloadErrorFileException],
                          @"DownloadErrorFileLocalWriteException",
                          [NSNumber numberWithInteger:DownloadErrorFileLocalWriteException],
                          @"DownloadErrorFileLengthException",
                          [NSNumber numberWithInteger:DownloadErrorFileLengthException],
                          @"DownloadErrorDownloadTypeToGetAppInfo",
                          [NSNumber numberWithInteger:DownloadErrorDownloadTypeToGetAppInfo],
                          nil];
        
        //创建IPA目录
        NSString * strPath = [[FileUtil instance] getDocumentsPath];
        self.plistCacheDir = [strPath stringByAppendingPathComponent:@"/IPA/plistCache"];
        [[NSFileManager defaultManager] createDirectoryAtPath:self.plistCacheDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];

        //AU下载类
        self.appStoreDownload = [[AppStoreDownload alloc] init];
        //新AU下载类
        self.appStoreNewDownload = [[AppStoreNewDownload alloc] init];
        
        self.isLogin = NO;
        
        NSDictionary *dataDic = [[FileUtil instance] getLoginKey];
        if (dataDic.allKeys.count >0) {
            self.isLogin = YES;
        }

    }
    
    return self;
}

- (void) dealloc {
    
    self.curDownloadFile.downloadDelegate = nil;
    [self.curDownloadFile StopDownloadFile];
    self.curDownloadFile = nil;
    
    self.appID = nil;
    self.appVersion = nil;
    self.appName = nil;
    
    self.plistURL = nil;
    
    self.ipaURL = nil;
    self.ipaPath = nil;
    
    self.ipaIconURL = nil;
    
    self.plistCacheDir = nil;
    self.ipaLocalDir = nil;
    
    self.userInfo = nil;
    
    self.parserLock = nil;
    
    self.ipaMD5 = nil;
    
    self.orignalDistriPlistURL = nil;
    
    self.plistCachePath = nil;
    
    
    self.errorType = nil;
    
    self.appStoreDownload = nil;
    
    //[super dealloc];
}


-(BOOL) ParserPlist:(NSString*)plist  userData:(id)userData{
    
    self.orignalDistriPlistURL = plist;
    self.userInfo = userData;
    //参考: https://github.com/bendytree/Objective-C-RegEx-Categories
    //获取plist地址(不包含参数)
    self.plistURL = [[FileUtil instance] plistURLNoArg:plist];
    
    //https://dinfo.wanmeiyueyu.com/gxltest/my/My_YiJing_com.KYK.SzeKiPiano_0_f3a60e411e55dcb1152be9d0420e88fc.plist

    
    if( !self.plistURL ) {
        return FALSE;
    }
    
    //获取dlfrom
    self.dlFrom = [[FileUtil instance] getPlistURLArg:plist argName:@"dlfrom"];
    
    //下载plist 到cache目录
    self.plistCachePath = [self.plistCacheDir stringByAppendingPathComponent: [self.plistURL lastPathComponent] ];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSURLResponse *response = nil;
        NSData *plistData = nil;
        //查本地
        NSDictionary * dicPlist =  [NSDictionary dictionaryWithContentsOfFile:self.plistCachePath];
        if(!dicPlist) {
            //网络请求
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:self.plistURL]];
            [request setHTTPMethod:@"GET"];
            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            plistData = [NSURLConnection sendSynchronousRequest:request
                                                       returningResponse:&response
                                                                   error:nil];

            if(plistData) {
                //下载完数据
                [plistData writeToFile:self.plistCachePath atomically:YES];
            }
        }

        //开始解析数据
        BOOL isSucc = [self ParsePlistInfo: self.plistCachePath ];
        if (isSucc == NO) {
            //解析plist失败
            
            //删除无用文件
            [[NSFileManager defaultManager] removeItemAtPath:self.plistCachePath error:nil];
            
            
            NSMutableDictionary * downloadFileDic = nil;
            if(plistData){ //网络通畅
                //汇报日志
                downloadFileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         DOWNLOAD_PLIST_PARSER_ERROR, REPORT_ERROR_TYPE, nil];
            }else{ //网络不通
                NSString * errortype = [self.errorType objectForKey: [NSNumber numberWithInteger:DownloadErrorNet]];
                downloadFileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: errortype, REPORT_ERROR_TYPE, nil];
            }

            //解析plist失败
            NSString * code = [NSString stringWithFormat:@"%d", ((NSHTTPURLResponse*)response).statusCode ];
            [downloadFileDic setObject:code forKey:REPORT_ERROR_SERVER_RESPONSE_CODE];
            BOOL hasJMP = YES;
            if( [self.plistURL isEqualToString: [response.URL absoluteString]] ) {
                hasJMP = NO;
                //没有跳转，保存对端的IP地址
                NSString * peerip = [[FileUtil instance] resolveDNS: [NSURL URLWithString:self.plistURL].host ];
                [downloadFileDic setObjectNoNIL:peerip forKey:REPROT_URL_CDN_IP_ADDRESS];
            }else{
                //有跳转(或网络不通)
                [downloadFileDic setObjectNoNIL:response.URL.host forKey:REPROT_URL_CDN_IP_ADDRESS];
            }

            downloadFileDic[REPROT_HAS_URL_JMP] = hasJMP?@"1":@"0"; //是否有跳转
            [downloadFileDic setObjectNoNIL:[response.URL absoluteString] forKey:REPROT_URL_JMP_ADDRESS];
            downloadFileDic[REPORT_ERROR_SERVER_RESPONSE_CODE] = code; //服务器返回码
            downloadFileDic[REPORT_IPA_DOWNLOAD_URL]=@"";   //清空ipa url信息
            
            [self report:downloadFileDic currentState:@"fail"];
            
            
            //回调通知,网络失败
            NSDictionary * attr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:DownloadErrorNet],
                                   BPPDownloadErrorReasonUserInfoKey,
                                   nil];
            if ( [self.parserDelegate respondsToSelector:@selector(onDidParserDistriPlistResult:errorAttr:)] ) {
                [self.parserDelegate onDidParserDistriPlistResult:self errorAttr:attr];
            }
            
            return;
        }

    
        //回调通知已经分析完毕了
        if ( [self.parserDelegate respondsToSelector:@selector(onDidParserDistriPlistResult:errorAttr:)] ) {
            [self.parserDelegate onDidParserDistriPlistResult:self errorAttr:nil];
        }

        
        //下载 IPA
        //用户点击了停止下载，如果还没有下载IPA，则停止
        if (self.bUserStop) {
            return ;
        }
        
        //下载plist完毕, 可以继续下载IPA
        [self onDidDownloadFileFinished:nil
                           downloadAttr: [NSDictionary dictionaryWithObjectsAndKeys:BPPEnterpriseDistribution_PlistKey,BPPDownloadUserInfoKey,nil] ];
    });
    
    return YES;
}

//文件下载进度
- (void) onDownloadFileProgress:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr {
    
    if (self.bUserStop) {
        return ;
    }
    
    NSString * userData = [attr objectForKey:BPPDownloadUserInfoKey];
    
    if ( [(NSString*)userData isEqualToString:BPPEnterpriseDistribution_IPAKey] ) {
        if ( [self.parserDelegate respondsToSelector:@selector(onDistriPlistParserIPAProgress:attr:)] ) {
            [self.parserDelegate onDistriPlistParserIPAProgress:self attr:attr];
        }
    }
}

//下载完成
- (void) onDidDownloadFileFinished:(BppDownloadFile*)downloadFile
                      downloadAttr:(NSDictionary*)attr {
    
    [self.parserLock lock];

    //自己锁定
    __strong BppDistriPlistParser * strongSelf = self;
    
    @try {
        
        NSString * userData = [attr objectForKey:BPPDownloadUserInfoKey];
        
        
        //plist下载完成
        if ( [(NSString*)userData isEqualToString:BPPEnterpriseDistribution_PlistKey] ) {

            if (self.bUserStop) {
                return ;
            }
            
            //从缓存里读应用的价格
            self.appPrice = [[TMCache sharedCache] objectForKey:[APP_PRICE_HEAD stringByAppendingString:self.appID]];
            
            self.curDownloadFile = nil;
            
//            NSLog(@"价格%@",self.appPrice);
            
            //my助手免费定义价格为"0.00",快用判断使用"0"
            if ([self.appPrice isEqualToString:@"0.00"]) {
                
                //my助手修改逻辑,添加是否走企签判断,以及downloadtype判断
                
                BOOL downloadFlag = NO;//无论哪种方式,是否已经添加下载
                
                //允许企签,且有企签包,直接企签下载
                BOOL flag = ENABLE_EU;
                BOOL flag_ = HAS_CONNECTED_PC;
                BOOL flag__ = DIRECTLY_GO_APPSTORE;
//                NSLog(@"企签开关~~%d,是否激活~~%d,跳转store~~%d",flag,flag_,flag__);
                
                if (ENABLE_EU  && [self.downType isEqualToString:@"3"]) {
//                    NSLog(@"开始非AU下载");
                    //非AU下载
                    self.curDownloadFile = [[BppDownloadFile alloc] init];
                    self.curDownloadFile.downloadDelegate = self;
                    self.curDownloadFile.fileMD5 = self.ipaMD5;
                    [self.curDownloadFile DownloadFile:[NSURL URLWithString: self.ipaURL]
                                              savePath:self.ipaPath
                                              userInfo:BPPEnterpriseDistribution_IPAKey];
                    self.isMixSucess = YES;
                    
                    [[TMCache sharedCache] setObject:self.appID forKey:[IPASTATE_HEAD stringByAppendingString:self.appID]];
                    downloadFlag = YES;
                }
                
                
                //允许企签但无企签包或者不允许企签,同时已登录账号,走au
                
                NSString *_switch = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SWITCH];
                if (!DIRECTLY_GO_APPSTORE && !downloadFlag && (self.isLogin && [_switch isEqualToString:@"on"])&&((ENABLE_EU && ![self.downType isEqualToString:@"3"])||!ENABLE_EU)) {
                    
//                    NSLog(@"价格为0登陆成功");
                    downloadFlag = YES;
                    NSUInteger isCanGet = [self.appStoreNewDownload downloadIPAByAU:self.appID download:^(NSDictionary *httpHeaders, NSString *aipaURL) {
                        if (self.bUserStop) return ;
                        
                        //下载Icon完毕, 开始下载 IPA
                        self.curDownloadFile = [[BppDownloadFile alloc] init];
                        self.curDownloadFile.downloadDelegate = self;
                        self.curDownloadFile.fileMD5 = self.appStoreNewDownload.md5Str;
                        self.curDownloadFile.httpHeaders = httpHeaders;
                        
                        [self.curDownloadFile DownloadFile:[NSURL URLWithString: aipaURL]
                                                  savePath:self.ipaPath
                                                  userInfo:BPPEnterpriseDistribution_IPAKey];
                    }];
                    
                    
                    if (isCanGet == GET_BUYINFO_ERROR) {
                        //获取购买信息失败
                        NSString *auappid = self.appStoreNewDownload.currentAppid;
                        if (self.parserDelegate && [self.parserDelegate respondsToSelector:@selector(onDidDownloadAUIPAError:appid:)]) {
                            
                            
                            //My助手打开注释,快用注释掉了本行
                            [self.parserDelegate onDidDownloadAUIPAError:self appid:auappid];
                            
                            
//                            NSLog(@"获取购买信息失败:%@", auappid);
                        }
                        
                        //au下载失败时,也需要标记为yes,否则会直接跳store
                        downloadFlag = YES;
                    }
                }
                
                //最后的方式,直接跳转App Store
                if (!downloadFlag) {
                    
                    //通知底部弹出提示框
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *digitalid = [[NSUserDefaults standardUserDefaults] objectForKey:self.appID];
                        if (digitalid) {
                            [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:digitalid];
                        }

                        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_APP_BECAUSE_DOWNLOAD_FAIL object:self.appID];
                    });

                    
//                    NSLog(@"其他方式都没成功,跳转到Store");
                    self.curDownloadFile.downloadDelegate = nil;
                    self.curDownloadFile = nil;
                }
            }
            
            
        }else if ( [(NSString*)userData isEqualToString:BPPEnterpriseDistribution_IPAKey] ) {
            
//            NSLog(@"ipa download ok:%@", downloadFile.url );

            self.curDownloadFile.downloadDelegate = nil;
            self.curDownloadFile = nil;

            
            //合并sinf文件
            NSString *_switch = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_SWITCH];
            if ((self.isLogin && [_switch isEqualToString:@"on"])&&((ENABLE_EU && ![self.downType isEqualToString:@"3"])||!ENABLE_EU)) {
                
                if (![[TMCache sharedCache] objectForKey:[IPASTATE_HEAD stringByAppendingString:self.appID]]) {
//                    NSLog(@"新AU合包");
                    
                    self.isMixSucess = [self.appStoreNewDownload packageIPA:self.ipaPath
                                                                      appid:self.appID];
                }

                
            }//新增不需要合包的情况,默认成功
            else{
                    self.isMixSucess = YES;
            }
        
            if (self.isMixSucess == NO) {
                //汇报日志
                NSMutableDictionary * downloadFileDic = [self downloadInfo:downloadFile];
                [downloadFileDic setObjectNoNIL:DOWNLOAD_SINF_OR_PATCH_MIX_ERROR forKey:REPORT_ERROR_TYPE];
                [self report:downloadFileDic currentState:@"fail"];
                
                //通知下载已经完毕
                if ( [self.parserDelegate respondsToSelector:@selector(onDidPlistDownloadIPAError:dicAttr:)] ) {
                    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:BPPEnterpriseDistribution_IPAKey,BPPDownloadUserInfoKey,[NSNumber numberWithInt:DownloadErrorFileException],BPPDownloadErrorReasonUserInfoKey, nil];
                    
                    [self.parserDelegate onDidPlistDownloadIPAError:self dicAttr:attr];
                }
            }else{
                //汇报日志
                NSMutableDictionary * downloadFileDic = [self downloadInfo:downloadFile];
                [downloadFileDic setObjectNoNIL:DOWNLOAD_ERROR_NULL forKey:REPORT_ERROR_TYPE];
                [self report:downloadFileDic currentState:@"success"];
                
                //通知下载已经完毕
                if ( [self.parserDelegate respondsToSelector:@selector(onDidPlistDownloadIPASuccess:)] ) {
                    [self.parserDelegate onDidPlistDownloadIPASuccess:self];
                }
            }

            [[TMCache sharedCache] removeObjectForKey:[IPASTATE_HEAD stringByAppendingString:self.appID]];
            
        }

    }
    @catch (NSException *exception) {
//            NSLog(@"下载完成回调里的异常捕获%@", [exception description]);
    }
    @finally {
        
        //释放对象
        [self.parserLock unlock];
        
        //配对
        strongSelf = nil;
    }
    
}


-(NSMutableDictionary *)downloadInfo:(BppDownloadFile*)downloadFile {
    
    //开始，结束，总的时间
    NSString *beginTime = [downloadFile getBeginRecvDataTime];
    NSString *overTime = [downloadFile getOverRecvDataTime];
    NSString * totalTime = [downloadFile getTotalRecvDataTime];
    //是否跳转，跳转后URL，IP地址
    NSString * hasjmp = downloadFile.hasJMP?@"1":@"0";
    NSString * JMPAddress = downloadFile.JMPAddress;
    NSString * cdnIP = downloadFile.peerIPAddress;
    //开始，结束 文件的数据大小
    NSString *startDataLength = [downloadFile getBeginDownloadFileLength];
    NSString* currentDataLength = [downloadFile getCurrentDownloadDataLength];
    //服务器回应码
    NSString * responseCode = [downloadFile getServerResponsedCode];
    //用于校验的文件MD5
    NSString * md5 = downloadFile.fileMD5;
    if(md5.length <= 0)
        md5 = @"";
    
    //错误的MD5
    NSString * errorMD5 = downloadFile.errorMD5;
    if(errorMD5.length <= 0)
        errorMD5 = @"";
    
    NSMutableDictionary * downloadFileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      beginTime,REPORT_BTICK,
                                      overTime, REPORT_ETICK,
                                      totalTime, REPORT_TOTAL_TICK,
                                      
                                      startDataLength, REPORT_B,
                                      currentDataLength, REPORT_E,
                                      
                                      hasjmp,REPROT_HAS_URL_JMP,
                                      JMPAddress,REPROT_URL_JMP_ADDRESS,
                                      cdnIP,REPROT_URL_CDN_IP_ADDRESS,
                                      
                                      responseCode, REPORT_ERROR_SERVER_RESPONSE_CODE,
                                      md5, REPORT_MD5,
                                      errorMD5, REPROT_IPA_ERROR_MD5,
                                      nil];
    
    //IPA的下载类型
    [downloadFileDic setObjectNoNIL:self.downType forKey:REPORT_IPA_DOWNLOAD_TYPE];
    //ipa的下载URL
    [downloadFileDic setObjectNoNIL:self.ipaURL forKey:REPORT_IPA_DOWNLOAD_URL];
    
    return downloadFileDic;
}

//下载Error
- (void) onDidDownloadFileError:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr {
    
    NSString * userData = [attr objectForKey:BPPDownloadUserInfoKey];
    
    [self.parserLock lock];
    __strong BppDistriPlistParser * strongSelf = self;

    
    @try {
        if ( NSOrderedSame == [ (NSString*)userData compare:BPPEnterpriseDistribution_IPAKey
                                                          options:NSCaseInsensitiveSearch] ) {
            
            //汇报日志
            //<<<<<<<<<<<<<<<<<<<<<
            //错误类型
            NSMutableDictionary * downloadFileDic = [self downloadInfo:downloadFile];
            //错误类型
            NSNumber * code = [attr objectForKey:BPPDownloadErrorReasonUserInfoKey];
            NSString * errortype = [self.errorType objectForKey:code];
            [downloadFileDic setObject:errortype forKey:REPORT_ERROR_TYPE];
            
            [self report:downloadFileDic currentState:@"fail"];
            //>>>>>>>>>>>>>>>>>>>>>>>>>>
            
            if ( [self.parserDelegate respondsToSelector:@selector(onDidPlistDownloadIPAError:dicAttr:)] ) {
                [self.parserDelegate onDidPlistDownloadIPAError:self dicAttr:attr];
            }
        }
        
    }
    @catch (NSException *exception) {
//        NSLog(@"下载error里的异常捕获%@", [exception description] );
    }
    @finally {
        
        self.curDownloadFile.downloadDelegate = nil;
        self.curDownloadFile = nil;
        
        [self.parserLock unlock];
        
        strongSelf = nil;
    }
    
}


//正在进行md5验证
- (void) onDownloadFileMD5Checking:(BppDownloadFile*)downloadFile
                      downloadAttr:(NSDictionary*)attr {
    
    if ( [self.parserDelegate respondsToSelector:@selector(onPlistDownloadMD5Checking:)] ) {
        [self.parserDelegate onPlistDownloadMD5Checking:self];
    }
}

- (void) StopParser {
    
    @try {

        //上报日志
        NSMutableDictionary * downloadFileDic = [self downloadInfo: self.curDownloadFile];
        [downloadFileDic setObjectNoNIL:DOWNLOAD_ERROR_NULL forKey:REPORT_ERROR_TYPE];
        [self report:downloadFileDic  currentState:@"pause"];
        
        //设置停止下载标志
        self.bUserStop = YES;
        
        //停止下载文件
        self.curDownloadFile.downloadDelegate = nil;
        [self.curDownloadFile StopDownloadFile];
        self.curDownloadFile = nil;
    }
    @catch (NSException *exception) {
//        NSLog(@"停止下载里的异常捕获%@", exception);
    }
    @finally {

    }
    
}

- (BOOL) ParsePlistInfo:(NSString*)aplistPath {
    
    NSUInteger index = 0;
    
    NSDictionary * dicPlist = [NSDictionary dictionaryWithContentsOfFile: aplistPath ];
    if (!dicPlist) {
        return NO;
    }
    if (dicPlist) {
        
        self.ipaMD5 = [dicPlist objectForKey:@"kycode"];
        self.downType = [dicPlist objectForKey:@"downloadtype"];
        
        NSArray * items = [dicPlist objectForKey:@"items"];
        NSArray * assets = [[items objectAtIndex:0] objectForKey:@"assets"];
        
        for (NSDictionary * dic in assets) {
            
            //找IPA下载地址
            if ( [[dic objectForKey:@"kind"] isEqualToString: @"software-package"] ) {
                
                NSString *tempPath = [dic objectForKey:@"url"];
                //兼容旧版本的服务器plist格式
                if( [tempPath hasPrefix:@"http://127.0.0.1:8080"] ) {
                    //确定IPA的下载地址
                    self.ipaURL = [dic objectForKey:@"downloadPath"];
                }else{
                    self.ipaURL = tempPath;
                }
                if ( !self.ipaURL )
                    return NO;

                
                NSString * documents = [[FileUtil instance] getDocumentsPath];

                if([tempPath hasPrefix:@"http://127.0.0.1:8080"]){
                    
                    //快用专用plist格式
                    
                    self.ipaPath = [documents stringByAppendingPathComponent: [tempPath stringByReplacingOccurrencesOfString:@"http://127.0.0.1:8080" withString:@""]];
                    self.ipaLocalDir = [self.ipaPath stringByDeletingLastPathComponent];
                    
                }else{
                    //标准OTA plist格式
                    
                    //IPA保存路径
                    self.ipaLocalDir = [documents stringByAppendingPathComponent:@"IPA"];
                    self.ipaLocalDir = [self.ipaLocalDir stringByAppendingPathComponent: [[self.ipaURL lastPathComponent] stringByDeletingPathExtension]];
                    self.ipaPath = [self.ipaLocalDir stringByAppendingPathComponent: [self.ipaURL lastPathComponent] ];
                }
                
                //IPA文件夹路径
                [[NSFileManager defaultManager] createDirectoryAtPath:self.ipaLocalDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
                index++;
            }
            
            //找IPA ICON下载地址
            if ([[dic objectForKey:@"kind"] isEqualToString:@"full-size-image" ]) {
                self.ipaIconURL = (NSString *)[dic objectForKey:@"url"];
                index++;
            }
            
            //全找到了吗？YES！中断
            if (index >= 2) {
                break;
            }
        }
        
        NSDictionary * metadata = [[items objectAtIndex:0] objectForKey:@"metadata"];
        if (metadata) {
            
            self.appID = [metadata objectForKey:@"bundle-identifier"];
            if (self.appID) {
                index++;
            }
            
            self.appVersion = [metadata objectForKey:@"bundle-version"];
            if (self.appVersion) {
                index++;
            }
            
            self.appName = [metadata objectForKey:@"title"];
            if (self.appName) {
                index++;
            }
        }
    }
    
    return index >=4 ? YES : NO;
}


//从plist url中取出md5字符串
- (NSString *) getPlistMD5:(NSString*)plist {
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=kycode@)[0-9a-zA-Z]{32}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:plist options:0 range:NSMakeRange(0, [plist length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *substringForFirstMatch = [plist substringWithRange:rangeOfFirstMatch];
//        NSLog(@"plist md5: %@", substringForFirstMatch);
        return substringForFirstMatch;
    }
    
    return nil;
}



- (void)report:(NSDictionary *)InfoDic currentState:(NSString *)state{
    
    //插入日志
    NSMutableDictionary *dic = [[DownloadReport getObject] getReportFileDicByDistriPlist:self.orignalDistriPlistURL];
    if(!dic)
        return ;

    [InfoDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dic setObject:obj forKey:key];
    }];
    
    //结果
    [dic setObject:state forKey:REPORT_RESULT];
    
    [[DownloadReport getObject] updateReportFile:dic];
    
    [[DownloadReport getObject] downloadReportByDistriPlist: self.orignalDistriPlistURL ];
}

@end
