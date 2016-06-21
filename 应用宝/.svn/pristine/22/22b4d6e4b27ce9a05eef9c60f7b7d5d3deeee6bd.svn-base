//
//  BppDownloadFile.m
//  browser
//
//  Created by 刘 亮亮 on 13-1-8.
//
//

#import "BppDownloadFile.h"
#import <CommonCrypto/CommonDigest.h>  
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "FileUtil.h"


#define BPPCfgFileSize          @"FileSize"          //文件总大小
#define BPPCfgDownlaodFileSize  @"DownloadFileSize"  //已经下载的大小


#define LIMIT_SPEED       200.0

#define RETRY_COUNT       3



@interface NSURLRequest(ForSSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@implementation NSURLRequest(ForSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{}
@end




@interface BppDownloadFile () <NSURLConnectionDataDelegate>


@property (atomic, strong)  NSString * filePath;           //最终保存的文件路径
@property (atomic, strong)  NSString * tempFilePath;       //临时保存的文件路径
@property (atomic, assign)  int64_t fileLength;            //要下载文件的总长度
@property (atomic, assign)  int64_t downloadFileLength;    //已下载的长度(包括临时文件大小)

@property (atomic, strong)  NSURLConnection * urlConnection;

@property (nonatomic, assign)   BOOL isSupport206;          //是否支持断点续传

@property (nonatomic, strong)   id userData;                //用户传入参数

@property (atomic, assign)      NSUInteger retryCount;              //下载失败重试次数(连续3次下载失败，报错)
@property (atomic, assign)      NSUInteger retryCount_MD5Error;     //MD5验证失败重试次数
@property (atomic, assign)      NSUInteger retryCount_fileNoFull; //文件不完整重试次数

@property (atomic, strong)      NSRecursiveLock * calcVLock;
@property (atomic, assign)      int64_t  totalRecvDataLength; //本次接收的所有数据
@property (atomic, assign)      int64_t  tmBeginRecvDataTime; //开始接收数据的时间
@property (atomic, assign)      int64_t  tmCurrentRecvDataTime; //当前接收数据的时间

@property (atomic, assign)      BOOL stopTime;                //停止定时器

@property (atomic, assign)      CFRunLoopRef  downloadRunLoopRef;

@property (nonatomic , assign)  int64_t beginDownloadFileLength; //开始下载时的长度(考虑重试)

@property (nonatomic , assign)  NSInteger servResponseCode; //下载失败时 服务器返回的错误码


//取得下载临时文件的大小
- (int64_t) tempFileSize:(NSString*)tempFile;
- (BOOL) writeFileData:(NSData*)data filePath:(NSString*)path;
- (BOOL) cacheData:(NSData*)data;
//计算平均下载速度
- (float) caculateDownloadV;

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void) onthreadMainMethod:(id)arg;
- (void) onthreadTimerMethod:(id)arg;

//计算速度
- (void)timerCalculateV:(NSTimer*)timer;

- (NSString*)getFileMD5:(NSString*)path;
@end


@implementation BppDownloadFile

@synthesize tempFilePath;
@synthesize filePath;
@synthesize urlConnection;
@synthesize url;
@synthesize isSupport206;
@synthesize fileLength;
@synthesize downloadFileLength;
@synthesize beginDownloadFileLength;

@synthesize userData;

@synthesize downloadDelegate;

@synthesize retryCount;
@synthesize retryCount_MD5Error;
@synthesize retryCount_fileNoFull;

@synthesize calcVLock;
@synthesize totalRecvDataLength ;
@synthesize stopTime;
@synthesize tmBeginRecvDataTime; //接收数据的开始时间


@synthesize downloadRunLoopRef;

@synthesize fileMD5;

@synthesize httpHeaders;

@synthesize tmCurrentRecvDataTime;

@synthesize hasJMP = _hasJMP;
@synthesize JMPAddress = _JMPAddress;
@synthesize peerIPAddress = _peerIPAddress;
@synthesize errorMD5 = _errorMD5;


- (void) writeLog:(NSString*)log{
    
    return ;
    
    @synchronized(@"writeLog:"){
        //获取系统当前的时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        
        //日志数据
        NSString * logData = [NSString stringWithFormat:@"[%@] %@\n", currentDate, log];
        
        //日志文件名
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy_MM_dd"];
        
        NSString * path = [[FileUtil instance] getDocumentsPath];
        path = [path stringByAppendingString:@"/log"];
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        path = [path stringByAppendingFormat:@"/log%@.log",  [dateFormatter stringFromDate:[NSDate date]]];
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            //没有文件， 创建文件
            [logData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }else{
            //有文件， 追加
            NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:path];
            [file seekToEndOfFile];
            [file writeData:[logData dataUsingEncoding:NSUTF8StringEncoding]];
            [file closeFile];
        }
    }
}



- (id) init {
    
    if ( self=[super init] ) {

        self.retryCount = 0;
        self.retryCount_MD5Error = 0;
        self.retryCount_fileNoFull = 0;
        
        self.downloadDelegate = nil;
        
        self.calcVLock = [[NSRecursiveLock alloc] init];
        
        self.downloadRunLoopRef = nil;
    }
    
    return self;
}

- (void) dealloc {
    
    self.fileMD5 = nil;

    _JMPAddress = nil;
    
    _peerIPAddress = nil;
    
    self.filePath = nil;
    self.tempFilePath = nil;
    self.isSupport206 = NO;
    self.urlConnection = nil;
    self.url = nil;
    
    self.userData = nil;
    
    self.downloadDelegate = nil;
    
    self.calcVLock = nil;
    
}


- (void) StopDownloadFile {
    
    @synchronized(@"stopdownload"){
    self.stopTime = YES;
    
    [self.urlConnection cancel];
    self.urlConnection = nil;
    
    if ( self.downloadRunLoopRef ) {
        CFRunLoopStop(self.downloadRunLoopRef);
        self.downloadRunLoopRef = nil;
    }
}
}

//取得下载临时文件的大小
- (int64_t) tempFileSize:(NSString*)tempFile {
    
    NSDictionary * attr = [[NSFileManager defaultManager]  attributesOfItemAtPath:tempFile error:nil];    
    return [attr fileSize];
}

- (void) onthreadTimerMethod:(id)arg {
    
    @autoreleasepool {
        
        [[NSThread currentThread] setName: @"timer"];
        
        __strong id __delegate = self.downloadDelegate;
        
        while( !self.stopTime ) {
            [self timerCalculateV:nil];
            
            //暂停0.1s
            usleep(1000000 * 0.1);
        }
        
        __delegate = nil;
    }
}

- (void) onthreadMainMethod:(id)arg {

    @autoreleasepool {
        [[NSThread currentThread] setName: @"download"];
        
        //异步请求
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url];
        if (self.downloadFileLength > 0) {
            [request setValue:[NSString stringWithFormat:@"bytes=%lld-", self.downloadFileLength]
           forHTTPHeaderField:@"Range"];
        }
        
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setValue:@"bppstore kuaiyong ios" forHTTPHeaderField:@"User-Agent"];
        [request setNetworkServiceType:NSURLNetworkServiceTypeVoIP];
        
        
        //设置http header
        for (NSString *key in [self.httpHeaders allKeys]) {
            [request setValue:[self.httpHeaders objectForKey:key] forHTTPHeaderField:key];
        }
        
        if( [self.url.scheme  isEqualToString:@"https"] )
            [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[self.url host]];
        
        
        self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        self.downloadRunLoopRef = [[NSRunLoop currentRunLoop] getCFRunLoop];
        
        //手动启动
        [[NSRunLoop currentRunLoop] run];
        
        self.downloadRunLoopRef = nil;
    }
}

- (void)timerCalculateV:(NSTimer *)theTimer {
    
    //时间过滤
    static int64_t oldtimer = 0;
    int64_t nowTimer = [[NSDate date] timeIntervalSince1970]*1000;
    if(nowTimer - oldtimer < 800) {    //0.8s 过滤
        return ;
    }
    oldtimer = nowTimer;
    
    

    @try {
        [self.calcVLock lock];
        
        float v = [self caculateDownloadV];
        if ( v > 0.0 ) {
//            NSString * strV = [NSString stringWithFormat:@"downloading:%.2f%%  %.2fk/s 剩余时间:%.1f min",
//                               (float)self.downloadFileLength/(float)self.fileLength*100,
//                               v,
//                               (float)(self.fileLength - self.downloadFileLength)/1024.0/v/60.0];
//            NSLog(@"%@", strV);
        }
        
        
        //回调通知
        if ( [self.downloadDelegate respondsToSelector:@selector(onDownloadFileProgress:downloadAttr:)] ) {
            
            NSMutableDictionary * dicAttr = [NSMutableDictionary dictionary];
            if (self.fileLength == 0) {
                [dicAttr setObject:[NSNumber numberWithFloat:-100.0] forKey:BPPDownloadProgressKey];
            }else{
                [dicAttr setObject:[NSNumber numberWithFloat:self.downloadFileLength/(float)self.fileLength]
                            forKey:BPPDownloadProgressKey];
            }
            [dicAttr setObject:self.userData forKey:BPPDownloadUserInfoKey];
            [dicAttr setObject:[NSNumber numberWithFloat:v] forKey:BPPDownloadSpeedKey];
            //计算剩余时间
            if (v > 0.0){
                [dicAttr setObject:[NSNumber numberWithInteger: (float)(self.fileLength - self.downloadFileLength)/1024.0/v]
                            forKey:BPPDownloadRemainTimeKey];
            }else{
                [dicAttr setObject:[NSNumber numberWithInteger: (float)0]
                            forKey:BPPDownloadRemainTimeKey];
            }
            //文件总长度
            [dicAttr setObject:[NSNumber numberWithLongLong: (float)self.fileLength]
                        forKey:BPPDownloadTotalLengthKey];
            
            
            //禁止从此处跳转到主线程，会导致进度显示异常(进度条不动，一下到头)
            //            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downloadDelegate onDownloadFileProgress:self downloadAttr:dicAttr ];
            //            });

        }
    }
    @catch (NSException *exception) {
//        NSLog(@"%@", [exception description]);
    }
    @finally {
        [self.calcVLock unlock];
    }
    
}


- (BOOL) DownloadFile:(NSURL*)aURL
             savePath:(NSString*)aFilePath
             userInfo:(id)userInfo {
    if(!aURL)
        return NO;
    
    self.retryCount = 0;
    self.retryCount_MD5Error = 0;
    
    self.url = aURL;
    self.filePath = aFilePath;
    self.tempFilePath = [self.filePath stringByAppendingString:@".tmp"];
    self.fileLength = 0;
    self.userData = userInfo;
    
    //获取已经下载的文件大小
    self.downloadFileLength = [self tempFileSize: self.tempFilePath];
    //记录本次开始的初始大小
    self.beginDownloadFileLength = [self tempFileSize: self.tempFilePath];
    
    self.stopTime = NO;
    
    //接收数据长度，置0
    self.totalRecvDataLength = 0;
    self.tmBeginRecvDataTime = 0;

    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:aFilePath] ) {
        //下载完成回调通知
        if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileFinished:downloadAttr:)] ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableDictionary * dicAttr = [NSMutableDictionary dictionary];
                [dicAttr setObject:self.userData forKey:BPPDownloadUserInfoKey];
                [self.downloadDelegate onDidDownloadFileFinished:self downloadAttr:dicAttr];
            });
        }
        return YES;
    }
    
    [self performSelectorInBackground:@selector(onthreadTimerMethod:) withObject:self];

    [self performSelectorInBackground:@selector(onthreadMainMethod:) withObject:self];
    

    return YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    
    //NSLog(@"response--url:%@ heads:\n%@ ", response.URL.absoluteString, [(NSHTTPURLResponse *)response allHeaderFields]);
    //tmp
    //http://27.195.145.137/8ee3076e00000000-1403178378-2008844847/data5/ccpic.wanmeiyueyu.com/Data/APPINFOR/46/11/com.xiaoxian.fenkuang.chengyu/dizigui_zhouyi_com.xiaoxian.fenkuang.chengyu_1396627200_2.1.ipa
    //self.url
    //http://ccpic.wanmeiyueyu.com/Data/APPINFOR/46/11/com.xiaoxian.fenkuang.chengyu/dizigui_zhouyi_com.xiaoxian.fenkuang.chengyu_1396627200_2.1.ipa
    
    _peerIPAddress = [[FileUtil instance] resolveDNS:[(NSHTTPURLResponse *)response URL].host];
    if(_peerIPAddress.length<=0)
       _peerIPAddress = @"unkown_host";
    _JMPAddress = [(NSHTTPURLResponse *)response URL].absoluteString;

    
    _hasJMP = YES;
    if( [self.url.host isEqualToString: [(NSHTTPURLResponse *)response URL].host] )
        _hasJMP = NO;
    
    
    //记录服务器返回值
    self.servResponseCode = responseCode;
    
    if (responseCode == 206) {
        self.isSupport206 = YES;
    }else{
        self.isSupport206 = NO;
    }
    
    //不支持断点续传, 删除文件
    if ( !self.isSupport206 ) {
        [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:nil];
        self.downloadFileLength = 0;
        
        [self writeLog:[NSString stringWithFormat:@"url:%@ no support206", self.url]];
    }
    
    
//  "Content-Range" = "bytes 1035276-198225938/198225939";
    //兼容CDN，没有Content-Length时，expectedContentLength 返回-1
    int64_t expectedContentLength = [response expectedContentLength];
    if (expectedContentLength < 0) { 
        NSString * contentRange = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Range"];
        NSRange range = [contentRange rangeOfString:@"/" options:NSBackwardsSearch];
        int64_t totalLength = [[contentRange substringFromIndex:range.location+1]  longLongValue];
        expectedContentLength = totalLength - self.downloadFileLength;
    }
    
    //记录文件大小
    self.fileLength = self.downloadFileLength + expectedContentLength;
    
    


    //判断文件是否已经下载， 通过大小判断
    NSDictionary * dicAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
    if (dicAttr.fileSize != 0 &&
        dicAttr.fileSize == self.fileLength) {
        
        //取消下载过程
        [self StopDownloadFile];

        //下载完成回调通知
        if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileFinished:downloadAttr:)] ) {
            NSMutableDictionary * dicAttr = [NSMutableDictionary dictionary];
            [dicAttr setObject:self.userData forKey:BPPDownloadUserInfoKey];
            
            [self.downloadDelegate onDidDownloadFileFinished:self downloadAttr:dicAttr];
        }
    }
    
    
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

//计算平均下载速度
- (float) caculateDownloadV  {
    
    self.tmCurrentRecvDataTime = (NSUInteger)[[NSDate date] timeIntervalSince1970];
    if (self.tmCurrentRecvDataTime > self.tmBeginRecvDataTime) {
        //计算平均速度
        float v = (float)(self.totalRecvDataLength/(float)(self.tmCurrentRecvDataTime-self.tmBeginRecvDataTime)/(float)1024);
        return v;
    }
    
    return 0;
}

- (BOOL) cacheData:(NSData*)data {

    return [self writeFileData:data filePath:self.tempFilePath];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //NSLog(@"接收数据 %@", self.url.absoluteString);
    
    //空间不足则出错
    int64_t freeSize = (int64_t)[[FileUtil instance] getFreeDiskspace]/1024.0/1024.0;
    if (freeSize < 5) {
        //提示出错
        [self connection:self.urlConnection didFailWithError:nil];
        return ;
    }
    
    //恢复重试次数(收到数据了 要恢复重试次数)
    self.retryCount = 0;

    //接收文件的总长度（包括上次下载的）
    self.downloadFileLength += data.length;
    if( ![self cacheData:data] ) { //写入下载文件失败
        
        //停止下载，退出下载和定时器线程
        [self StopDownloadFile];
        //汇报错误
        if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileError:downloadAttr:)] ) {
            NSMutableDictionary * dicAttr = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.userData, BPPDownloadUserInfoKey, nil];
            //本地写入文件错误，给出错误原因
            NSNumber * reason = [NSNumber numberWithInt:DownloadErrorFileLocalWriteException];
            [dicAttr setObject:reason forKey:BPPDownloadErrorReasonUserInfoKey];
            
            [self.downloadDelegate onDidDownloadFileError:self downloadAttr:dicAttr];
        }
        
        return ;
    }
    
    
    
    @try {
        //计算速度变量保护
        [self.calcVLock lock];
        
        
        //从起始时间点到现在收到的数据
        if (self.tmBeginRecvDataTime == 0) {
            self.tmBeginRecvDataTime = (NSUInteger)[[NSDate date] timeIntervalSince1970];
//            NSLog(@"%lld", self.tmBeginRecvDataTime);
        }
        self.totalRecvDataLength += data.length;
    }
    @catch (NSException *exception) {
        NSLog(@"didReceiveData的异常捕获%@", [exception description]);
    }
    @finally {
        [self.calcVLock unlock];
    }
}

- (void)retryDownloadFile {
    
    //取消本次下载
    [self.urlConnection cancel];
    
    //获取已经下载的文件大小
    self.downloadFileLength = [self tempFileSize: self.tempFilePath];
    //本次开始的总长度
    self.beginDownloadFileLength = [self tempFileSize: self.tempFilePath];
    
    //异步请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url];
    if (self.downloadFileLength > 0) {
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-", self.downloadFileLength]
       forHTTPHeaderField:@"Range"];
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:@"bppstore kuaiyong ios" forHTTPHeaderField:@"User-Agent"];
    [request setNetworkServiceType:NSURLNetworkServiceTypeVoIP];
    

    //设置http header
    for (NSString *key in [self.httpHeaders allKeys]) {
        [request setValue:[self.httpHeaders objectForKey:key] forHTTPHeaderField:key];
    }
    //不验证证书
    if( [self.url.scheme isEqualToString:@"https"] ) {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[self.url host]];
    }
    
    //禁用cookie
    [request setHTTPShouldHandleCookies:NO];
    //清空cookie
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL: self.url];
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    
    //第一次1秒， 第二次2秒，第三次3秒
    [NSThread sleepForTimeInterval:1 + self.retryCount];
    @synchronized(@"stopdownload"){
        if(self.urlConnection){
            //没有被停止，则可以继续
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        }else{
            NSLog(@"++++++++++！！！！ 下载已经被暂停了");
        }
    }
}
//失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.retryCount < 3) {
        
        //再次启动下载
        [self retryDownloadFile];
        self.retryCount ++;

        NSLog(@"连接失败:%@  重试:%d", self.url, self.retryCount);
        return ;
    }
    
    [self StopDownloadFile];
    
    
    if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileError:downloadAttr:)] ) {
        
        if ([connection respondsToSelector:@selector(originalRequest)]) {
            NSLog(@"连接错误 %@", [[connection originalRequest].URL absoluteString]);
        }
        
        //下载失败原因
        NSNumber * reason = [NSNumber numberWithInt:error?DownloadErrorNet:DownloadErrorNoFreeSpace];
        NSDictionary * dicAttr = [ NSDictionary dictionaryWithObjectsAndKeys: self.userData, BPPDownloadUserInfoKey,
                                  reason, BPPDownloadErrorReasonUserInfoKey,
                                  nil];
        [self.downloadDelegate onDidDownloadFileError:self downloadAttr:dicAttr];
    }
    
    

}


//完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    BOOL  downloadFialed = NO;
    BOOL  bMD5Error = FALSE;
    
    //检测下载是否完整
    int64_t fileSize = [self tempFileSize: self.tempFilePath];
    if (fileSize != self.fileLength) {
        
        //下载出错了，要重试吗？
        if (self.retryCount_fileNoFull < 2) {
            [self retryDownloadFile];
            self.retryCount_fileNoFull ++;
            return ;
        }else{
            downloadFialed = YES;
        }
    }
    

    //检测文件MD5
    if(downloadFialed == NO &&  //文件大小正确, 进一步检测MD5
       self.fileMD5 && self.fileMD5.length>0) {
        
        //通知上层, 正在MD5校验
        if ( [self.downloadDelegate respondsToSelector:@selector(onDownloadFileMD5Checking:downloadAttr:)] ) {
            NSDictionary * dicAttr = [ NSDictionary dictionaryWithObjectsAndKeys:
                                      self.userData, BPPDownloadUserInfoKey, nil];
            [self.downloadDelegate onDownloadFileMD5Checking:self downloadAttr:dicAttr];
        }
        
        NSString * downloadMD5 = [self getFileMD5: self.tempFilePath];
        if (downloadMD5.length<=0 || //MD5 计算失败，可能文件不存在
            NSOrderedSame != [downloadMD5 compare:self.fileMD5 options:NSCaseInsensitiveSearch] ) //MD5不一致
        {
            
            if (self.retryCount_MD5Error < 1) {
                self.retryCount_MD5Error ++;
                
                //删除已下载的数据
                [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:nil];
                [self retryDownloadFile];
                
                return ;
            }else {
                downloadFialed = YES;
                bMD5Error = YES;
                _errorMD5 = downloadMD5;
            }
        }
    }
    
    
    //停止下载，退出下载和定时器线程
    [self StopDownloadFile];
    
    
    //通知界面下载失败了
    if ( downloadFialed == YES) {
        if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileError:downloadAttr:)] ) {
            NSMutableDictionary * dicAttr = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.userData, BPPDownloadUserInfoKey, nil];
            
            if (bMD5Error){
                //是MD5错误，给出错误原因
                NSNumber * reason = [NSNumber numberWithInt:DownloadErrorFileException];
                [dicAttr setObject:reason forKey:BPPDownloadErrorReasonUserInfoKey];
            }else{
                //文件不完整
                NSNumber * reason = [NSNumber numberWithInt:DownloadErrorFileLengthException];
                [dicAttr setObject:reason forKey:BPPDownloadErrorReasonUserInfoKey];
            }
            [self.downloadDelegate onDidDownloadFileError:self downloadAttr:dicAttr];
        }
        return ;
    }

    
    //下载成功，把临时文件-->最终文件
    NSError * error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error];
    [[NSFileManager defaultManager] moveItemAtPath:self.tempFilePath toPath:self.filePath error:nil];
    
    
    //下载完成回调通知
    if ( [self.downloadDelegate respondsToSelector:@selector(onDidDownloadFileFinished:downloadAttr:)] ) {
        NSMutableDictionary * dicAttr = [NSMutableDictionary dictionary];
        [dicAttr setObject:self.userData forKey:BPPDownloadUserInfoKey];
        [self.downloadDelegate onDidDownloadFileFinished:self downloadAttr:dicAttr];
    }
    
}


-(BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace {
    return[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (NSString*) getSaveFilePath {
    
    return self.filePath;
}


- (NSString*)getFileMD5:(NSString*)path {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        @autoreleasepool {
            NSData* fileData = [handle readDataOfLength: 1024*1024*1 ];
            CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
            if( [fileData length] <= 0 ) {
                done = YES;
            }
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15] ];
    
    
    return s;
}


- (NSString *)getBeginDownloadFileLength{
    return [NSString stringWithFormat:@"%lld", self.beginDownloadFileLength];
}

- (NSString *) getCurrentDownloadDataLength{
    if( [[NSFileManager defaultManager] fileExistsAtPath: self.tempFilePath] ) {        
        return [NSString stringWithFormat:@"%lld", [self tempFileSize: self.tempFilePath]];
    }
    
    return [NSString stringWithFormat:@"%lld", [self tempFileSize: self.filePath]];
}

- (NSString *)getBeginRecvDataTime{
    return [NSString stringWithFormat:@"%lld",self.tmBeginRecvDataTime];
}

- (NSString *)getOverRecvDataTime{
    return [NSString stringWithFormat:@"%lld",self.tmCurrentRecvDataTime];
}
- (NSString *)getTotalRecvDataTime {
    return [NSString stringWithFormat:@"%lld",self.tmCurrentRecvDataTime - self.tmBeginRecvDataTime];
}

-(NSString *)getServerResponsedCode {
    return [NSString stringWithFormat:@"%ld",(long)self.servResponseCode];
}


@end