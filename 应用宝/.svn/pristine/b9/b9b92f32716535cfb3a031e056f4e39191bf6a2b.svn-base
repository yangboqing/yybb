//
//  BppDownloadFile.h
//  browser
//
//  Created by 刘 亮亮 on 13-1-8.
//
//

#import <Foundation/Foundation.h>


@class BppDownloadFile;


#define BPPDownloadProgressKey      @"progress"     //下载进度
#define BPPDownloadSpeedKey         @"Speed"        //下载速度
#define BPPDownloadRemainTimeKey    @"remainTime"   //剩余时间
#define BPPDownloadTotalLengthKey   @"totalLength"  //文件总长度

#define BPPDownloadUserInfoKey      @"userInfo"         //用户数据

//该错误码，不能修改，只能新增
#define DownloadErrorNet    0
#define DownloadErrorNoFreeSpace    1
#define DownloadErrorFileException  2
#define DownloadErrorFileLocalWriteException  3
#define DownloadErrorFileLengthException 4
#define DownloadErrorDownloadTypeToGetAppInfo 5



#define BPPDownloadErrorReasonUserInfoKey     @"errorReason"  //下载失败原因



@protocol BppDownloadFileDeletgate <NSObject>

//文件下载进度 (timer线程通知)
- (void) onDownloadFileProgress:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr;



//下载完成 (download线程通知)
- (void) onDidDownloadFileFinished:(BppDownloadFile*)downloadFile
                      downloadAttr:(NSDictionary*)attr;

//下载Error (download线程通知)
- (void) onDidDownloadFileError:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr;


//MD5检测中  (download线程通知)
- (void) onDownloadFileMD5Checking:(BppDownloadFile*)downloadFile
                   downloadAttr:(NSDictionary*)attr;

@end


@interface BppDownloadFile : NSObject

@property (nonatomic, retain)   NSURL * url;                //本次请求URL

@property (nonatomic, weak) id<BppDownloadFileDeletgate>  downloadDelegate;
@property (nonatomic, strong) NSString * fileMD5;
@property (nonatomic, strong) NSDictionary *httpHeaders;

//是否有跳转
@property (nonatomic, readonly)  BOOL   hasJMP;
//跳转之后的URL
@property (nonatomic, readonly)  NSString * JMPAddress;
//跳转IP地址
@property (nonatomic, readonly)  NSString * peerIPAddress;

//错误的md5
@property(nonatomic, readonly) NSString * errorMD5;


- (BOOL) DownloadFile:(NSURL*)aURL savePath:(NSString*)aFilePath userInfo:(id)userInfo;
- (void) StopDownloadFile;

- (NSString*) getSaveFilePath;

//开始下载文件长度
- (NSString *)getBeginDownloadFileLength;
//当前总得文件长度
- (NSString *)getCurrentDownloadDataLength;


//开始接收时间
- (NSString *)getBeginRecvDataTime;
//结束接收时间
- (NSString *)getOverRecvDataTime;
//总得时间
- (NSString *)getTotalRecvDataTime;


//服务器回应码
- (NSString*) getServerResponsedCode;   //本地请求失败后，服务器返回的错误码

@end



