//
//  BppDistriPlistManager.m
//  browser
//
//  Created by 刘 亮亮 on 13-1-11.
//
//

#import "BppDistriPlistManager.h"
#import "BppDistriPlistParser.h"
#import "BppDownloadFile.h"
#import "FileUtil.h"
#import "NSDictionary+noNIL.h"
#import "TMCache.h"



#define  PLIST_NO_ARG(x)     x=[[FileUtil instance] distriPlistURLNoArg:x];
//app 图标cache Path
#define  APPIMAGES_CACHE_PATH      [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"appImages"]

//同时下载数
#define DEF_MAX_DOWNLOADING_COUNT   3


@interface BppDistriPlistManager () <BppDistriPlistParserDelegate>{
    BOOL isContinue;
}
//下载中
@property (atomic, retain) NSMutableArray * distriDownloadingPlists;

//下载中Path
@property (nonatomic, retain) NSString * downloadingFilePath;

//已下载路径
@property (nonatomic, retain) NSString * downloadedFilePath;

//plist-->parser
@property (nonatomic, retain) NSMutableDictionary * dicDistriPlistToParser;

//plist-->image
@property (atomic, retain) NSMutableDictionary * dicPlistToImage;

//回调对象集合
@property (nonatomic, retain) NSMutableArray * listeners;

//是否需要请求
@property (nonatomic) BOOL needRequest;


//取等待的个数
-(NSInteger) ItemStatusCount:(NSInteger)status;


//设置列表中，指定项的状态
- (NSUInteger) setDownloadPlistStatus:(NSMutableArray*)downloadLists
                       distriPlistURL:(NSString*)distriPListURL
                               status:(NSUInteger)status;

//取得列表中的状态
- (NSUInteger) getDownloadPlistStatus:(NSMutableArray*)downloadLists
                       distriPlistURL:(NSString*)distriPListURL ;


//存文件
- (void) DownloadPListToFile:(NSArray *)downloadlist fileName:(NSString*)filePath;

//发送PlistURL请求
- (void) SendParserListRequest:(NSString *)distriPlistURL;
//程序启动后恢复下载
- (void) restoreDownload;

//删除下载的缓存文件
- (void) removeDownloadCacheFile:(NSString*)distriPlistURL;

//打印调试信息
- (void) printStatusInfo;

//通知状态改变
- (void) notifyStatusChange:(NSString*)distriPlist dicAttr:(NSDictionary*)attr;

//相对路径-->全路径
- (NSString*) relativePathToFullPath:(NSString*)relativePath;
//全路径-->相对路径
- (NSString*) fullPathToRelativePath:(NSString*)fullPath;

#pragma mark - BppDistriPlistParserDelegate


@end


@implementation BppDistriPlistManager

@synthesize distriDownloadingPlists;
@synthesize distriAlReadyDownloadedPlists;

@synthesize dicDistriPlistToParser;

@synthesize dicPlistToImage;

@synthesize listeners;
@synthesize downloadingFilePath;
@synthesize downloadedFilePath;



@synthesize needRequest = _needRequest;

//流程代理
@synthesize controlDelegate;

+(BppDistriPlistManager *) getManager {
    
    static NSString *lock = @"lock";
    static id obj = nil;
    
    @synchronized(lock) {
        if (obj == nil) {
            obj = [[BppDistriPlistManager alloc] init];
        }
    }
    
    return obj;
}

- (id) init {
    
    if ( self=[super init] ) {
        
        
        _needRequest = YES;
        
        self.dicDistriPlistToParser = [NSMutableDictionary dictionary];
        
        //plist-->image
        self.dicPlistToImage = [NSMutableDictionary dictionary];
        
        self.listeners = [NSMutableArray array];
        
        
        isContinue = YES;
        
        //配置文件的路径
        NSString * documents = [[FileUtil instance] getDocumentsPath];
        NSString * DB = [documents stringByAppendingString:@"/DB"];
        [[NSFileManager defaultManager] createDirectoryAtPath:DB withIntermediateDirectories:YES attributes:nil error:nil];
        NSString * _DB = [documents stringByAppendingString:@"/META"];
        [[NSFileManager defaultManager] createDirectoryAtPath:_DB withIntermediateDirectories:YES attributes:nil error:nil];
        self.downloadingFilePath = [DB stringByAppendingString:@"/downloading.plist"];
        self.downloadedFilePath = [DB stringByAppendingString:@"/downloaded.plist"];
        
        self.distriDownloadingPlists = [NSMutableArray arrayWithContentsOfFile:self.downloadingFilePath];
        if ( !self.distriDownloadingPlists ) {
            self.distriDownloadingPlists = [NSMutableArray array];
        }
        
        self.distriAlReadyDownloadedPlists = [NSMutableArray arrayWithContentsOfFile:self.downloadedFilePath];
        if ( !self.distriAlReadyDownloadedPlists ) {
            self.distriAlReadyDownloadedPlists = [NSMutableArray array];
        }

        //恢复下载
        [self restoreDownload];
    }
    
    return self;
}


- (void)dealloc {
    
    self.distriDownloadingPlists = nil;
    self.distriAlReadyDownloadedPlists = nil;
    
    self.dicDistriPlistToParser = nil;
    
    self.dicPlistToImage = nil;
    
    self.listeners = nil;
    
    //[super dealloc];
}


- (void) addListener:(id<BppDistriPlistManagerDelegate>) listener {
    
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

- (void) removeListener:(id<BppDistriPlistManagerDelegate>) listener {
    
    @try {
        [self.listeners removeObject:listener];
    }
    @catch (NSException *exception) {
        //        NSLog(@"%@", [exception description]);
    }
    @finally {
    }
    
}

//从本地图片(旧版本<2.0)或者缓存中(新版本2.0)初始化字典缓存
-(void)InitImageDicCahceFromLocal {
    
    NSMutableArray * arry =  [NSMutableArray arrayWithArray:self.distriDownloadingPlists];
    [arry addObjectsFromArray:self.distriAlReadyDownloadedPlists];
    
    for ( NSMutableDictionary * dicItem in arry ) {
        
        NSString * distriPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
        
        //新版本字段
        BOOL lbOK = NO;
        NSString * imageURL = [dicItem objectForKey:DISTRI_APP_IMAGE_URL];
        if(imageURL){
            NSData * imageData = [[TMCache sharedCache] objectForKey:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            if (image) {
                [self.dicPlistToImage setObject:image forKey:distriPlistURL];
                lbOK = YES;
            }
        }else{
            //旧版本字段
            NSString * imagePath= [dicItem objectForKey:DISTRI_APP_ICON_IMAGE_PATH];
            imagePath = [self relativePathToFullPath:imagePath];
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                [self.dicPlistToImage setObject:image forKey:distriPlistURL];
                lbOK = YES;
            }
        }
        
        //通过本地新的图片缓存获取
        if(!lbOK){
            NSString * appID = [dicItem objectForKey:DISTRI_APP_ID];
            
            NSString * path = APPIMAGES_CACHE_PATH;
            path = [path stringByAppendingPathComponent:appID];
            path = [path stringByAppendingPathExtension:@"png"];
            UIImage * image = [UIImage imageWithContentsOfFile:path];
            if(image){
                [self.dicPlistToImage setObject:image forKey:distriPlistURL];
                lbOK = YES;
            }
        }
        
        //没有找到图片
        if(!lbOK){
//            NSLog(@"InitImageDicCahceFromLocal 图片没有找到");
        }
    }
}

//程序启动后恢复下载
- (void) restoreDownload {
    
    [self InitImageDicCahceFromLocal];
    
    for ( NSMutableDictionary * dicItem in self.distriDownloadingPlists ) {
        
        //重新设置状态
        [dicItem setObject:[NSNumber numberWithInt:DOWNLOAD_STATUS_STOP]
                    forKey:DISTRI_APP_DOWNLOAD_STATUS];
        
        NSString * distriPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
        
        //通知状态改变
        NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:DOWNLOAD_STATUS_STOP],
                                  @"status",
                                  nil];
        [self notifyStatusChange:distriPlistURL dicAttr:dicAttr];
    }
    
    [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
    
}

//保存数组
- (void) DownloadPListToFile:(NSArray *)downloadlist fileName:(NSString*)filePath {
    
    @synchronized(self) {
        [downloadlist writeToFile:filePath atomically:NO];
    }
}

- (void) SendParserListRequest:(NSString *)distriPlistURL {
    
    BppDistriPlistParser * parser = [self.dicDistriPlistToParser objectForKey:distriPlistURL];
    if (!parser) {
        //开始网络请求
        parser = [[BppDistriPlistParser alloc] init];
        parser.parserDelegate = self;
        //plist --> parser
        [self.dicDistriPlistToParser setObject:parser forKey:distriPlistURL];
    }
    
    [parser ParserPlist:distriPlistURL userData:distriPlistURL];
}

- (DOWNLOAD_STATUS) addPlistURL: (NSString*)distriPlistURL appInfoDic:(NSDictionary*)dicAppInfo{
    
    [self notifyAppAddOrStart:dicAppInfo];
    
    //去除plist地址参数
    distriPlistURL = [[FileUtil instance] distriPlistURLNoArg:distriPlistURL];
    if(distriPlistURL.length <= 0) {
//        NSLog(@"addPlistURL：%@ 失败", distriPlistURL);
        return STATUS_NONE;
    }
    

    @synchronized(self) {
        //在已下载中
        if (NSNotFound != [self indexItemInDownloadedByAttriValue:DISTRI_PLIST_URL value:distriPlistURL] ) {
            return STATUS_ALREADY_IN_DOWNLOADED_LIST;
        }
        
        //在下载中
        if ( NSNotFound != [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL value:distriPlistURL] ) {
            return STATUS_ALREADY_IN_DOWNLOADING_LIST;
        }
    }
    
    //添加到下载中
    //解析完毕， 添加到下载列表中
    
    //添加dlfrom参数
    NSString * dlFrom = [dicAppInfo objectNoNILForKey:DISTRI_APP_FROM];
    if(dlFrom.length <= 0)
        dlFrom = @"unknown";
    distriPlistURL = [distriPlistURL stringByAppendingFormat:@"?dlfrom=%@", dlFrom ];
    
    NSMutableDictionary * dicItem = [NSMutableDictionary dictionary];
    [dicItem setObjectNoNIL:distriPlistURL forKey:DISTRI_PLIST_URL];
    [dicItem setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_ID]   forKey:DISTRI_APP_ID];
    [dicItem setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_NAME] forKey:DISTRI_APP_NAME];
    [dicItem setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_VERSION]  forKey:DISTRI_APP_VERSION];
    [dicItem setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_IMAGE_URL]  forKey:DISTRI_APP_IMAGE_URL];
    [dicItem setObjectNoNIL:dlFrom  forKey:DISTRI_APP_FROM];
    [dicItem setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_PRICE]  forKey:DISTRI_APP_PRICE];
    //设置免流字段
    if( [dicAppInfo objectForKey:DISTRI_FREE_FLOW] ){
        [dicItem setObject:[dicAppInfo objectForKey:DISTRI_FREE_FLOW] forKey:DISTRI_FREE_FLOW];
    }
    
    //向缓存里存应用的价格
    [[TMCache sharedCache] setObject:[dicAppInfo objectNoNILForKey:DISTRI_APP_PRICE] forKey:[APP_PRICE_HEAD stringByAppendingString:[dicAppInfo objectNoNILForKey:DISTRI_APP_ID]]];
    
    
    //    //ipa的保存路径，相对路径(此时为NULL)
    //    [dicItem setObject:@"" forKey:DISTRI_APP_IPA_LOCAL_PATH];
    //    //缓存的plist地址
    //    [dicItem setObject:@"" forKey:DISTRI_PLIST_CACHE_LOCAL_PATH];
    //    //传入参数的plist发布地址，不带参数
    
    //设置 等待状态
    [dicItem setObject:[NSNumber numberWithInt:DOWNLOAD_STATUS_WAIT] forKey:DISTRI_APP_DOWNLOAD_STATUS];
    //设置文件长度
    if (![dicItem objectForKey:DISTRI_IPA_TOTAL_LENGTH]) {
        [dicItem setObject:[NSNumber numberWithInt:0] forKey:DISTRI_IPA_TOTAL_LENGTH];
    }
    
//    NSLog(@"添加下载:%@ AppID:%@", distriPlistURL, [dicAppInfo objectNoNILForKey:DISTRI_APP_ID]);
    [self.distriDownloadingPlists insertObject:dicItem atIndex:0];
    
    BOOL  lbNeedRequest = NO;
    if(_needRequest) {
        //检查正在下载的个数
        NSInteger count = [self ItemStatusCount:DOWNLOAD_STATUS_RUN];
        if(count < [self maxDowndingCount]){
            [self setDownloadPlistStatus:self.distriDownloadingPlists
                          distriPlistURL:distriPlistURL
                                  status:DOWNLOAD_STATUS_RUN];
            lbNeedRequest = YES;
        }
    }
    
    {//记录该应用的基本信息,用于汇报日志
        
        NSString * appid = [dicAppInfo objectNoNILForKey:DISTRI_APP_ID];
        
        //先清空该Item信息
        [[DownloadReport getObject] deleteItemInfoByAppID: appid ];
        
        NSMutableDictionary *dic = [[DownloadReport getObject] getReportFileDicByAppID: appid ];
        if (!dic)
            dic = [NSMutableDictionary dictionary];
        
        [dic setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_ID]  forKey:REPORT_APPID];
        [dic setObjectNoNIL:[dicAppInfo objectNoNILForKey:DISTRI_APP_VERSION] forKey:REPORT_APPVERSION];
        [dic setObjectNoNIL:distriPlistURL forKey:REPORT_URL];
        [dic setObjectNoNIL:@"download" forKey:REPORT_TYPE];
        [dic setObjectNoNIL:dlFrom forKey:REPORT_DLFROM];
        
        [[DownloadReport getObject] updateReportFile:dic];
    }

    
    //开始请求
    if(lbNeedRequest) {
        [self SendParserListRequest:distriPlistURL];
    }
    
    //同步数据
    [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
    
    
    //删除AppID相同，版本不同的应用
    BOOL bDeleteDiffApp = [self DeleteAppIDWithDiffVersion:[dicAppInfo objectNoNILForKey:DISTRI_APP_ID]
                                                newVersion:[dicAppInfo objectNoNILForKey:DISTRI_APP_VERSION]];
    
    //通知界面，成功添加一个
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if(bDeleteDiffApp) {
                //通知上层界面，当新添加进一个应用的时候，删掉与其不同版本的app
                if( [obj respondsToSelector:@selector(onDidPlistMgrInAlreayDownloadDeleteSameAppid:DiffenertVersion:)] ) {
                    [obj onDidPlistMgrInAlreayDownloadDeleteSameAppid: [dicAppInfo objectNoNILForKey:DISTRI_APP_ID]
                                                     DiffenertVersion: [dicAppInfo objectNoNILForKey:DISTRI_APP_VERSION]];
                }
            }
            
            //通知上层 成功添加了一个下载条目
            if( [obj respondsToSelector:@selector(onDidPlistMgrAddDownloadItem:)] ) {
                [obj onDidPlistMgrAddDownloadItem: distriPlistURL];
            }
        }];
    });
    
    //请求图片
    NSString * imageURL = [dicAppInfo objectNoNILForKey:DISTRI_APP_IMAGE_URL];
    if(imageURL.length > 0) {
        [self RequestImageForPlistURL:distriPlistURL imageURL:imageURL];
    }
    
    
    //通知应用的下载状态变化了
    [self notifyAppDownloadStatusChange:dicAppInfo];


    
    return STATUS_SUCCESS;
}


-(BOOL)DeleteAppIDWithDiffVersion:(NSString*)newAppid newVersion:(NSString*)newVer {
    
    @synchronized(self) {
        
        NSMutableArray *deleteItems = [NSMutableArray array];
        
        //记录需要删除的
        [[BppDistriPlistManager getManager].distriAlReadyDownloadedPlists indexesOfObjectsPassingTest:
         ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
             
             NSString *downAppid = [obj objectForKey:DISTRI_APP_ID];
             NSString *downVer = [obj objectForKey:DISTRI_APP_VERSION];
             if ([downAppid isEqualToString:newAppid] && ![downVer isEqualToString:newVer]) {
                 [deleteItems addObject:[obj objectForKey:DISTRI_PLIST_URL]];
                 return TRUE;
             }
             
             return FALSE;
         }];
        
        //从已下载中删除
        if(deleteItems.count > 0) {
            for(NSString * plistURL in deleteItems) {
                [self removeDownloadedPlistURL:plistURL];
            }
            
            return TRUE;
        }
        
        return FALSE;
    }
}

-(void)RequestImageForPlistURL:(NSString*)distriPlistURL  imageURL:(NSString*)imageURL {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //找字典缓存
        UIImage * image = [self.dicPlistToImage objectForKey:distriPlistURL];
        if(image){ //有图
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(onDidPlistMgrDownloadIconComplete:icon:)] ) {
                        [obj onDidPlistMgrDownloadIconComplete:distriPlistURL icon:image];
                    }
                }];
            });
            
            return ;
        }
        
        
        //字典缓存中没有，找其他地方
        BOOL  lbOK = NO;
        NSData * imageData = nil;
        while (YES) {
            //找本地缓存
            imageData = [[TMCache sharedCache] objectForKey:imageURL];
            if (imageData) {
                image = [UIImage imageWithData:imageData];
                if(image){
                    lbOK = YES;
                    break;
                }
            }
            
            //自己下载
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            if(imageData){
                image = [UIImage imageWithData:imageData];
                if(image){
                    //保存缓存
                    [[TMCache sharedCache] setObject:imageData forKey:imageURL];
                    lbOK = YES;
                    break;
                }
            }
            
            break;
        }
        
        //没有找到 返回
        if(!lbOK) {
            //通知下载失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if( [obj respondsToSelector:@selector(onDidPlistMgrDownloadIconError:)] ) {
                        [obj onDidPlistMgrDownloadIconError:distriPlistURL];
                    }
                }];
            });
            return ;
        }
        
        //有图片了,保存
        [self.dicPlistToImage setObject:image forKey:distriPlistURL];
        
        //保存图片缓存，不用TMCache缓存，防止清缓存时 图片被清理
        if(imageData){
            NSDictionary * dicItem = [self ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
            NSString * appID = [dicItem objectForKey:DISTRI_APP_ID];

            NSString * path = APPIMAGES_CACHE_PATH;
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
            path = [path stringByAppendingPathComponent:appID];
            path = [path stringByAppendingPathExtension:@"png"];
            [imageData writeToFile:path atomically:YES];
        }
        
        
        //通知下载成功
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(onDidPlistMgrDownloadIconComplete:icon:)] ) {
                    [obj onDidPlistMgrDownloadIconComplete:distriPlistURL icon:image];
                }
            }];
        });
    });
}

- (DOWNLOAD_STATUS) getPlistURLStatus: (NSString*)distriPlistURL {
    
    @synchronized(self){
        
        if (NSNotFound !=  [self indexItemInDownloadedByAttriValue:DISTRI_PLIST_URL value:distriPlistURL] ) {
            return STATUS_ALREADY_IN_DOWNLOADED_LIST;
        }
        
        if ( NSNotFound != [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL value:distriPlistURL] ) {
            return STATUS_ALREADY_IN_DOWNLOADING_LIST;
        }
    }
    
    //没有下载呢
    return STATUS_NONE;
}

- (DOWNLOAD_STATUS) getAppIdStatus: (NSString*)appID {
    
    @synchronized(self){
        if(NSNotFound != [self indexItemInDownloadedByAttriValue:DISTRI_APP_ID value:appID] ) {
            return STATUS_ALREADY_IN_DOWNLOADED_LIST;
        }
        
        if(NSNotFound != [self indexItemInDownloadingByAttriValue:DISTRI_APP_ID value:appID] ) {
            return STATUS_ALREADY_IN_DOWNLOADING_LIST;
        }
    }
    
    //没有下载呢
    return STATUS_NONE;
}

- (void) removeDownloadCacheFile:(NSString*)distriPlistURL {
    
    NSUInteger  index = 0;
    
    @synchronized(self) {
        //从已下载的列表中删除
        index = [self indexItemInDownloadedByAttriValue:DISTRI_PLIST_URL value:distriPlistURL];
        if ( NSNotFound !=  index) {
            NSDictionary * dicItem = [self.distriAlReadyDownloadedPlists objectAtIndex:index];
            //特定某个IPA存储的文件夹
            NSString * strIPADirPath = [self relativePathToFullPath:[dicItem objectForKey:DISTRI_APP_IPA_LOCAL_PATH]];
            strIPADirPath = [strIPADirPath stringByDeletingLastPathComponent];
            
            //缓存的plist地址
            NSString * plistCachePath = [dicItem objectForKey:DISTRI_PLIST_CACHE_LOCAL_PATH];
            if(plistCachePath) { //兼容就版本数据
                plistCachePath = [self relativePathToFullPath:plistCachePath];
            }
        
            
            //删除相关联的本地图片缓存
            NSString * appID = [dicItem objectForKey:DISTRI_APP_ID];
            NSString * imageCachePath = [APPIMAGES_CACHE_PATH stringByAppendingPathComponent:appID];
            imageCachePath = [imageCachePath stringByAppendingPathExtension:@"png"];
            [[NSFileManager defaultManager] removeItemAtPath:imageCachePath error:nil];

            
            //删除本地文件夹
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSFileManager defaultManager] removeItemAtPath:strIPADirPath error:nil];
                //兼容就版本数据
                if(plistCachePath) {
                    [[NSFileManager defaultManager] removeItemAtPath:plistCachePath error:nil];
                }
            });
        }
    }
    
    @synchronized(self) {
        index = [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL  value: distriPlistURL];
        if ( NSNotFound !=  index) {
            NSDictionary * dicItem = [self.distriDownloadingPlists objectAtIndex:index];
            if ([dicItem objectForKey:DISTRI_APP_IPA_LOCAL_PATH]) {
                NSString * strIPADirPath = [self relativePathToFullPath: [dicItem objectForKey:DISTRI_APP_IPA_LOCAL_PATH] ];
                strIPADirPath = [strIPADirPath stringByDeletingLastPathComponent];
                
                //缓存的plist地址
                NSString * plistCachePath = [dicItem objectForKey:DISTRI_PLIST_CACHE_LOCAL_PATH];
                if(plistCachePath) {
                    plistCachePath = [self relativePathToFullPath:plistCachePath];
                }
                
                //删除相关联的本地图片缓存
                NSString * appID = [dicItem objectForKey:DISTRI_APP_ID];
                NSString * imageCachePath = [APPIMAGES_CACHE_PATH stringByAppendingPathComponent:appID];
                imageCachePath = [imageCachePath stringByAppendingPathExtension:@"png"];
                [[NSFileManager defaultManager] removeItemAtPath:imageCachePath error:nil];
                

                //删除本地文件夹
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[NSFileManager defaultManager] removeItemAtPath:strIPADirPath error:nil];
                    if(plistCachePath) {
                        [[NSFileManager defaultManager] removeItemAtPath:plistCachePath error:nil];
                    }
                });
                
            }
        }
    }
}

//通过特定的属性值来获取 指定的Item
- (NSDictionary*) ItemInfoByAttriName:(NSString*)attriName  value:(id)value{
    
    NSMutableArray * items = [NSMutableArray arrayWithArray:self.distriDownloadingPlists];
    [items addObjectsFromArray:self.distriAlReadyDownloadedPlists];
    
    
    for ( NSMutableDictionary * dicItem in items ) {
        id attriValue =  [dicItem objectForKey:attriName];
        
        //通过plistURL来查找
        if( [attriName isEqualToString:DISTRI_PLIST_URL] ) {
            PLIST_NO_ARG(value);
            PLIST_NO_ARG(attriValue);
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }else if( [attriName isEqualToString:DISTRI_APP_DOWNLOAD_STATUS] ) {
            //通过下载状态来查找
            if( [value integerValue] == [attriValue integerValue] ) {
                return dicItem;
            }
        }else
        {
            //通过其他属性来查找
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }
    }
    
    return nil;
}

- (NSMutableDictionary*) ItemInfoInDownloadedByAttriName:(NSString*)attriName  value:(id)value {
    
    for ( NSMutableDictionary * dicItem in self.distriAlReadyDownloadedPlists ) {
        id attriValue =  [dicItem objectForKey:attriName];
        
        //通过plistURL来查找
        if( [attriName isEqualToString:DISTRI_PLIST_URL] ) {
            PLIST_NO_ARG(value);
            PLIST_NO_ARG(attriValue);
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }else if( [attriName isEqualToString:DISTRI_APP_DOWNLOAD_STATUS] ) {
            //通过下载状态来查找
            if( [value integerValue] == [attriValue integerValue] ) {
                return dicItem;
            }
        }else
        {
            //通过其他属性来查找
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }
    }
    
    return nil;
}

- (NSMutableDictionary*) ItemInfoInDownloadingByAttriName:(NSString*)attriName  value:(id)value {
    
    for ( NSMutableDictionary * dicItem in self.distriDownloadingPlists ) {
        id attriValue =  [dicItem objectForKey:attriName];
        
        //通过plistURL来查找
        if( [attriName isEqualToString:DISTRI_PLIST_URL] ) {
            PLIST_NO_ARG(value);
            PLIST_NO_ARG(attriValue);
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }else if( [attriName isEqualToString:DISTRI_APP_DOWNLOAD_STATUS] ) {
            //通过下载状态来查找
            if( [value integerValue] == [attriValue integerValue] ) {
                return dicItem;
            }
        }else
        {
            //通过其他属性来查找
            if( [value isEqualToString:attriValue] ) {
                return dicItem;
            }
        }
    }
    
    return nil;
}
//通过属性值，在下载中查找
-(NSInteger) indexItemInDownloadingByAttriValue:(NSString*)attriName  value:(id)value {
    
    NSInteger index = -1;
    BOOL  lbFind = NO;
    
    @synchronized(self) {
        for ( NSMutableDictionary * dicItem in self.distriDownloadingPlists ) {
            
            index ++;
            
            lbFind = YES;
            
            id attriValue =  [dicItem objectForKey:attriName];
            
            //通过plistURL来查找
            if( [attriName isEqualToString:DISTRI_PLIST_URL] ) {
                PLIST_NO_ARG(value);
                PLIST_NO_ARG(attriValue);
                if( [value isEqualToString:attriValue] ) {
                    break;
                }
            }else if( [attriName isEqualToString:DISTRI_APP_DOWNLOAD_STATUS] ) {
                //通过下载状态来查找
                if( [value integerValue] == [attriValue integerValue] ) {
                    break;
                }
            }else
            {
                //通过其他属性来查找
                if( [value isEqualToString:attriValue] ) {
                    break;
                }
            }
            
            lbFind = NO;
        }
        
        if(lbFind)
            return index;
        
    }
    
    return NSNotFound;
}



//通过属性值，在已下载中查找
-(NSInteger) indexItemInDownloadedByAttriValue:(NSString*)attriName  value:(id)value {

    NSInteger index = -1;
    BOOL  lbFind = NO;
    
    @synchronized(self) {
        for ( NSMutableDictionary * dicItem in distriAlReadyDownloadedPlists ) {
            
            index++;
            lbFind = YES;
            
            id attriValue =  [dicItem objectForKey:attriName];
            
            //通过plistURL来查找
            if( [attriName isEqualToString:DISTRI_PLIST_URL] ) {
                PLIST_NO_ARG(value);
                PLIST_NO_ARG(attriValue);
                if( [value isEqualToString: attriValue] ) {
                    break;
                }
            }else if( [attriName isEqualToString:DISTRI_APP_DOWNLOAD_STATUS] ) {
                //通过下载状态来查找
                if( [value integerValue] == [attriValue integerValue] ) {
                    break;
                }
            }else
            {
                //通过其他属性来查找
                if( [value isEqualToString:attriValue] ) {
                    break;
                }
            }
            
            lbFind = NO;
        }
        
        if(lbFind)
            return index;
    }
    
    return NSNotFound;
}


-(BOOL) removeAllDownloadingPlistURL {
    
    @synchronized(self){
        
        //删除status不等于DOWNLOAD_STATUS_RUN
        NSMutableArray * noRuns = [NSMutableArray array];
        [self.distriDownloadingPlists indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary * dicItem = obj;
            NSNumber * status = [dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS];
            if( [status integerValue] != DOWNLOAD_STATUS_RUN) {
                [noRuns addObject:[dicItem objectForKey:DISTRI_PLIST_URL] ];
                return YES;
            }
            return NO;
        }];
        
        [noRuns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self removePlistURL:obj];
        }];
        
        //删除== RUN 的
        for (int last = self.distriDownloadingPlists.count-1 ; last>=0; last--) {
            NSDictionary * dicItem =  [distriDownloadingPlists objectAtIndex:last];
            NSString * distriPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
            //打印每个Item状态
            //NSNumber * status = [dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS];
            //NSLog(@"index:%d status:%ld", last, (long)[status integerValue]);
            
            [self removePlistURL:distriPlistURL];
        }
        
        
        //删除不再下载列表中的(正在请求plist)
        //释放对应的 parser 对象
        NSArray * keys = [ NSArray arrayWithArray:[self.dicDistriPlistToParser allKeys] ];
        for (NSString * key in keys) {
            
            //停止并删除解析
            BppDistriPlistParser * parser = [self.dicDistriPlistToParser objectForKey:key];
            [parser StopParser];
            [self.dicDistriPlistToParser removeObjectForKey:key];
        }
        
    }
    return YES;
}

- (BOOL) removeAllDownloadedPlistURL {
    @synchronized(self) {
        for (int last = self.distriAlReadyDownloadedPlists.count-1 ; last>=0; last--) {
            NSDictionary * dicItem =  [distriAlReadyDownloadedPlists objectAtIndex:last];
            NSString * distriPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
            [self removePlistURL:distriPlistURL];
        }
    }
    
    return YES;
}

- (int) removePlistURL: (NSString*)distriPlistURL {
    
    if (distriPlistURL.length <= 0) {
        return NSNotFound;
    }
    
    NSUInteger index = 0;
    
    do {
        @synchronized(self)  {
            
            //尝试从下载中删除
            index = [self removeDownloadingPlistURL:distriPlistURL];
            if ( NSNotFound != index ) {
                break;
            }
            //尝试从已下载删除
            index = [self removeDownloadedPlistURL:distriPlistURL];
            if ( NSNotFound != index ) {
                break;
            }
        }
        
        break;
    } while (0);
    
    //通知应用的下载状态变化了
    [self notifyAppDownloadStatusChange:nil];
    
    return index;
}

- (int) removeDownloadingPlistURL: (NSString*)distriPlistURL {
    @synchronized(self) {
        if (distriPlistURL.length <= 0) {
            return NSNotFound;
        }
        
        NSUInteger index = [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL  value: distriPlistURL];
        if ( NSNotFound != index ) {
            
            [self.distriDownloadingPlists removeObjectAtIndex:index];

            //停止PlistURL
            [self stopPlistURL:distriPlistURL];
            //删除下载的文件
            [self removeDownloadCacheFile:distriPlistURL];
            
            [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
        }
        
        return index;
    }
}
- (int) removeDownloadedPlistURL: (NSString*)distriPlistURL {
    
    @synchronized(self) {
        if (distriPlistURL.length <= 0) {
            return NSNotFound;
        }
        
        NSUInteger index = [self indexItemInDownloadedByAttriValue:DISTRI_PLIST_URL value:distriPlistURL];
        if (index != NSNotFound) {
            [self removeDownloadCacheFile:distriPlistURL];
            
            [self.distriAlReadyDownloadedPlists removeObjectAtIndex:index];
            
            [self DownloadPListToFile:self.distriAlReadyDownloadedPlists fileName:self.downloadedFilePath];
        }
        
        return index;
    }
}

-(NSString*)localDistriPlistURL:(NSString *)distriPlistURL{
    
    NSDictionary * dicItem = [self ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
    //特定某个IPA存储的文件夹
    NSString * localIPAPath = [dicItem objectForKey:DISTRI_APP_IPA_LOCAL_PATH];
    NSString * ipaURL = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",
                         [self.controlDelegate currentWebServerPort], localIPAPath];
    
    
    NSString * imagePath = [[localIPAPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[dicItem objectForKey:DISTRI_APP_ID]];
    imagePath = [imagePath stringByAppendingPathExtension:@"png"];
    //指向本地服务器image
    NSString * imageURL = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",
                           [self.controlDelegate currentWebServerPort],imagePath];
    
    UIImage * appIcon = [self imageForPlistURL: [dicItem objectForKey:DISTRI_PLIST_URL] ];
    if(appIcon){
        //写入文件
        
        NSString * fileImagePath = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:imagePath];
        NSData * imageData = UIImagePNGRepresentation(appIcon);
        [imageData writeToFile:fileImagePath atomically:NO];
    }else{
        //指向外网服务器image
        if( [dicItem objectForKey:DISTRI_APP_IMAGE_URL] ) {
            imageURL = [dicItem objectForKey:DISTRI_APP_IMAGE_URL];
        }
    }
    
    //组装plist文件
    NSString * tmpPListPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tmpPlist.txt"];
    NSString * tmpPList = [NSString stringWithContentsOfFile:tmpPListPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    

    NSString * appid = [dicItem objectForKey:DISTRI_APP_ID];
//    NSLog(@"isChangeAppid==%@",[UpdateAppManager getManager].isChangeAppid == YES?@"yes":@"no");
    if([self.controlDelegate IsChangeAppid] == YES && ![self.controlDelegate IsAppInstalling:appid]){
        NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
        appid = [appid stringByAppendingFormat:@".%d", nowDate];
//        NSLog(@"###########修改appid!!!!!!!!!!!!!!!!!!");
        
    }

//    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-IDENTIFIER}"
//                                                   withString:[dicItem objectForKey:DISTRI_APP_ID]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-IDENTIFIER}"
                                                   withString:appid];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-VERSION}"
                                                   withString:[dicItem objectForKey:DISTRI_APP_VERSION]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${TITLE}"
                                                   withString:[dicItem objectForKey:DISTRI_APP_NAME]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${IPA-URL}"
                                                   withString:ipaURL];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${ICON-URL}"
                                                   withString:imageURL];
    
    NSString * plistName = [dicItem objectForKey:DISTRI_APP_ID];
    NSString * nowTimer = [NSString stringWithFormat:@"%lld", (int64_t)([[NSDate date] timeIntervalSince1970]*1000)];
    plistName = [plistName stringByAppendingFormat:@"_t_%@",nowTimer];
    plistName = [plistName stringByAppendingPathExtension:@"plist"];
    
    NSString * path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:plistName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [tmpPList writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //修改ssl域名
    NSString * plistURL = [NSString stringWithFormat:@"https://local.kysjzs.com:%d/%@", [self.controlDelegate currentSSLPort], plistName];
    plistURL = [@"itms-services://?action=download-manifest&url=" stringByAppendingString:plistURL];
    
    return plistURL;
}


//适合本地https发布的地址
-(NSString*)localDistriPlistURL_Fast:(NSString *)distriPlistURL{
    
    NSDictionary * dicItem = [self ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
    //特定某个IPA存储的文件夹
    NSString * localIPAPath = [self relativePathToFullPath:[dicItem objectForKey:DISTRI_APP_IPA_LOCAL_PATH]];
    localIPAPath = [localIPAPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString * nowtimeStamp = [NSString stringWithFormat:@"%d", (NSInteger)[[NSDate date ] timeIntervalSince1970]];
    
    
    //准备图片
    NSString * imagePath = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent: [dicItem objectForKey:DISTRI_APP_ID]];
    imagePath = [imagePath stringByAppendingFormat:@"_t_%@", nowtimeStamp];
    imagePath = [imagePath stringByAppendingPathExtension:@"png"];
    //修改ssl域名
    NSString * urlLocalImage = [NSString stringWithFormat:@"https://local.kysjzs.com:%d/%@",
                                [self.controlDelegate currentSSLPort],
                                [imagePath lastPathComponent]];
    
    //图片地址
    UIImage * appIcon = [self imageForPlistURL: [dicItem objectForKey:DISTRI_PLIST_URL] ];
    if( appIcon ) {
        NSData * imageData = UIImagePNGRepresentation(appIcon);
        //写入文件
        [imageData writeToFile:imagePath atomically:NO];
    }else{
        //指向外网服务器image
        if( [dicItem objectForKey:DISTRI_APP_IMAGE_URL] ) {
            urlLocalImage = [dicItem objectForKey:DISTRI_APP_IMAGE_URL];
        }
    }
    
    
    //创建软连接, 必须通过软连接的方式安装，因为系统安装完毕后会删除本地IPA
    NSString * linkIPAPath = [localIPAPath stringByAppendingPathExtension:@"link"];
    [[NSFileManager defaultManager] removeItemAtPath:linkIPAPath error:nil];
    [[NSFileManager defaultManager] createSymbolicLinkAtPath:linkIPAPath
                                         withDestinationPath:localIPAPath
                                                       error:nil];
    NSString *urlLocalIPA = [@"file://localhost" stringByAppendingString:linkIPAPath];
    
    
    //组装plist文件
    NSString * tmpPListPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tmpPlist.txt"];
    NSString * tmpPList = [NSString stringWithContentsOfFile:tmpPListPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    NSString * appid = [dicItem objectForKey:DISTRI_APP_ID];
//    NSLog(@"isChangeAppid==%@",[UpdateAppManager getManager].isChangeAppid == YES?@"yes":@"no");
    if([self.controlDelegate IsChangeAppid] == YES){
        NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
        appid = [appid stringByAppendingFormat:@".%d", nowDate];
    }
//    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-IDENTIFIER}"
//                                                   withString:[dicItem objectForKey:DISTRI_APP_ID]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-IDENTIFIER}"
                                                   withString:appid];

    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${BUNDLE-VERSION}"
                                                   withString:[dicItem objectForKey:DISTRI_APP_VERSION]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${TITLE}"
                                                   withString:[dicItem objectForKey:DISTRI_APP_NAME]];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${IPA-URL}"
                                                   withString:urlLocalIPA];
    tmpPList = [tmpPList stringByReplacingOccurrencesOfString:@"${ICON-URL}"
                                                   withString:urlLocalImage];
    
    NSString * plistName = [dicItem objectForKey:DISTRI_APP_ID];
    plistName = [plistName stringByAppendingFormat:@"_t_%@", nowtimeStamp];
    plistName = [plistName stringByAppendingPathExtension:@"plist"];
    
    NSString * path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:plistName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [tmpPList writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//更改ssl服务器域名
    NSString * plistURL = [NSString stringWithFormat:@"https://local.kysjzs.com:%d/%@", [self.controlDelegate currentSSLPort], plistName];//kysjzs
    plistURL = [@"itms-services://?action=download-manifest&url=" stringByAppendingString:plistURL];
    
    return plistURL;
}

- (BOOL) installPlistURL:(NSString*)distriPlistURL {
    
    @synchronized(self){
        NSDictionary * attrs = [self ItemInfoInDownloadedByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
        if (attrs) {
            
            //兼容旧版本HTTP数据
            NSString * tmp = [attrs objectForKey:DISTRI_HTTP_PLIST_URL];
            if(tmp.length != 0) {
                distriPlistURL = tmp;
            }
            
#define USE_LOCAL_HTTPS_SERVER  1
#if (USE_LOCAL_HTTPS_SERVER == 1)
            NSString * localHttpsDistriURL = nil;
            if( [[[UIDevice currentDevice] systemVersion] floatValue] < 8 ) {
                localHttpsDistriURL = [self localDistriPlistURL_Fast:distriPlistURL];
            }else{
                localHttpsDistriURL = [self localDistriPlistURL:distriPlistURL];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:localHttpsDistriURL] ];
#else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[FileUtil instance] distriPlistURLNoArg:distriPlistURL]] ];
#endif
        }
    }
    
    return YES;
}

//停止所有下载
- (BOOL) stopAllPlistURL {
    
    @synchronized(self) {
        for (NSDictionary * dicItem in self.distriDownloadingPlists) {
            
            NSNumber * status =  [dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS];
            if ([status integerValue] == DOWNLOAD_STATUS_WAIT ||
                [status integerValue] == DOWNLOAD_STATUS_RUN ||
                [status integerValue] == DOWNLOAD_STATUS_ERROR ) {
                
                NSString * disPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
                [self stopPlistURLNoContinue: disPlistURL];
            }
        }
        
    }
    
    
    return YES;
}


-(NSInteger)countOfDownloadingItem {
    return self.distriDownloadingPlists.count;
}
-(NSDictionary*)ItemInfoInDownloadingByIndex:(NSInteger)index {
    return [self.distriDownloadingPlists objectAtIndex:index];
}

-(NSInteger)countOfDownloadedItem {
    return self.distriAlReadyDownloadedPlists.count;
}
-(NSMutableDictionary*)ItemInfoInDownloadedByIndex:(NSInteger)index {
    return [self.distriAlReadyDownloadedPlists objectAtIndex:index];
}


//停止单个下载
- (BOOL) stopPlistURLNoContinue: (NSString*)distriPlistURL {
    @synchronized(self) {
        //下载中修改状态
        NSUInteger index = [self setDownloadPlistStatus:self.distriDownloadingPlists
                                         distriPlistURL:distriPlistURL
                                                 status:DOWNLOAD_STATUS_STOP];
        if (index == NSNotFound) {
            return NO;
        }
        //修改状态
        [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
        
        //停止底层下载分析
        BppDistriPlistParser * parser = [self.dicDistriPlistToParser objectForKey:distriPlistURL];
        if (parser) {
            [parser StopParser];
        }
        
        //释放对应的 parser 对象
        [self.dicDistriPlistToParser removeObjectForKey:distriPlistURL];
    }
    
    //通知状态改变
    NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:DOWNLOAD_STATUS_STOP],
                              @"status",
                              nil];
    [self notifyStatusChange:distriPlistURL dicAttr:dicAttr];
    
    return YES;
}

- (BOOL) stopPlistURL: (NSString*)distriPlistURL {
    
    [self stopPlistURLNoContinue:distriPlistURL];
    
    //wait-->run
    [self waitToRun];
    
    return YES;
}


//取得对应的Image
- (UIImage *) imageForPlistURL:(NSString*)distriPlistURL {
    
    return [self.dicPlistToImage objectForKey:distriPlistURL];
}

- (BOOL) startPlistURL: (NSString*)distriPlistURL {
    
    @synchronized(self) {

        NSDictionary * itemInfo = [self ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
        [self notifyAppAddOrStart: itemInfo];
        
        //获取当前Item状态
        NSUInteger status = [self getDownloadPlistStatus:self.distriDownloadingPlists distriPlistURL:distriPlistURL];
        if ( status ==  DOWNLOAD_STATUS_UNKOWN) {
            return NO;
        }
        
        //状态为停止，尝试开始，或者等待
        if ( status == DOWNLOAD_STATUS_STOP || status == DOWNLOAD_STATUS_ERROR ) {
            
            BOOL  lbNeedRequest = NO;
            //检查正在下载的个数
            NSInteger count = [self ItemStatusCount:DOWNLOAD_STATUS_RUN];
            NSInteger status = DOWNLOAD_STATUS_WAIT;
            if(count < [self maxDowndingCount]){
                //设置RUN状态
                status = DOWNLOAD_STATUS_RUN;
                lbNeedRequest = YES;
            }
            
            //设置WAIT或RUN
            [self setDownloadPlistStatus:self.distriDownloadingPlists
                          distriPlistURL:distriPlistURL
                                  status:status];
            //保存文件
            [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
            
            
            //通知状态改变
            NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:status],
                                      @"status",
                                      nil];
            [self notifyStatusChange:distriPlistURL dicAttr:dicAttr];
            
            //发送网络请求
            if(lbNeedRequest) {
                [self SendParserListRequest:distriPlistURL];
            }
            
            
            //检查图片是否存在
            NSMutableDictionary * dicItem = nil;
            @synchronized( self ) {
                NSUInteger index = NSNotFound;
                index = [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL  value: distriPlistURL];
                dicItem = [self.distriDownloadingPlists objectAtIndex:index];
            }
            
            
            NSString * imageURL = [dicItem objectNoNILForKey:DISTRI_APP_IMAGE_URL];
            if(imageURL.length > 0)
                [self RequestImageForPlistURL:distriPlistURL imageURL:imageURL];
            
            return YES;
        }
        
    }
    
    return NO;
}


- (BOOL) startAllPlistURL {

    @synchronized(self) {
    int count = [self ItemStatusCount:DOWNLOAD_STATUS_RUN];
    
    for (NSMutableDictionary * dicItem in self.distriDownloadingPlists) {
        
        NSNumber * status =  [dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS];
        if([status integerValue] == DOWNLOAD_STATUS_STOP ||  //暂停
           [status integerValue] == DOWNLOAD_STATUS_ERROR ){ //错误
            
            NSString * disPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
            int index = [self maxDowndingCount];
            if (count < index) {
                //可以启动网络请求
                [self startPlistURL:disPlistURL];
            }else{
                [dicItem setObject:[NSNumber numberWithInteger:DOWNLOAD_STATUS_WAIT] forKey:DISTRI_APP_DOWNLOAD_STATUS];
                
                //通知状态改变
                NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:DOWNLOAD_STATUS_WAIT],
                                          @"status",
                                          nil];
                [self notifyStatusChange:disPlistURL dicAttr:dicAttr];
            }
            
            count++;
        }
    }
    
    
    [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
    
    }
    
    return YES;
}

//取得下载的个数
-(NSInteger) ItemStatusCount:(NSInteger)status {
    
    __block NSInteger count = 0;
    
    [self.distriDownloadingPlists indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber * number = [(NSMutableDictionary *)obj objectForKey:DISTRI_APP_DOWNLOAD_STATUS];
        if ([number integerValue] == status) {
            count ++;
        }
        return NO;
    }];
    
    return count;
}


//相对路径-->全路径
- (NSString*) relativePathToFullPath:(NSString*)relativePath {
    NSString * Documents = [[FileUtil instance] getDocumentsPath];
    NSString * fullPath = [Documents stringByAppendingPathComponent:relativePath];
    return fullPath;
}

//全路径-->相对路径
- (NSString*) fullPathToRelativePath:(NSString*)fullPath {
    
    NSString * Documents = [[FileUtil instance] getDocumentsPath];
    Documents = [Documents stringByAppendingString:@"/"];
    
    NSMutableString * relativePath = [NSMutableString stringWithString:fullPath];
    [relativePath replaceOccurrencesOfString:Documents
                                  withString:@""
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, relativePath.length)];
    
    return relativePath;
}


#pragma mark - BppDistriPlistParserDelegate


- (void) onDidParserDistriPlistResult:(BppDistriPlistParser *)parser errorAttr:(NSDictionary*)attr{
    
    @synchronized(self) {
        
        NSString * distriPlist = parser.userInfo;
        
        //回调返回时，该条目已经被删除了
        if( ![self.dicDistriPlistToParser objectForKey:distriPlist] ) {
            return ;
        }
        
        //数组中已经有了
        NSUInteger index = [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL  value: distriPlist];
        
        //成功了!
        if(attr == nil){
            //更新数据
            if (index != NSNotFound) {
                //数组中没有
                
                
                //解析完毕 更新列表数据
                NSMutableDictionary * dicItem = [self.distriDownloadingPlists objectAtIndex:index];
                
                [dicItem setObject:distriPlist forKey:DISTRI_PLIST_URL];
                [dicItem setObject:parser.appID forKey:DISTRI_APP_ID];
                [dicItem setObject:parser.appName forKey:DISTRI_APP_NAME];
                //界面没有传入version,则用info.plist中得
                NSString * version = [dicItem objectForKey:DISTRI_APP_VERSION];
                if(version.length <= 0){
                    [dicItem setObject:parser.appVersion forKey:DISTRI_APP_VERSION];
                }

                //ipa的保存路径，相对路径
                [dicItem setObject:[self fullPathToRelativePath:parser.ipaPath] forKey:DISTRI_APP_IPA_LOCAL_PATH];
                //缓存的plist地址
                [dicItem setObject:[self fullPathToRelativePath:parser.plistCachePath] forKey:DISTRI_PLIST_CACHE_LOCAL_PATH];
                
                //是否包含了图标地址
                if( [[dicItem objectForKey:DISTRI_APP_IMAGE_URL] length] <= 0 ) {
                    [dicItem setObject:parser.ipaIconURL forKey:DISTRI_APP_IMAGE_URL];
                    //用户没有传入, 用plist中得url
                    [self RequestImageForPlistURL:distriPlist imageURL:parser.ipaIconURL];
                }
                
                //[self deleteLowVersionInDownloading:parser.appID version:parser.appVersion];
                
                [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
            }
            
            return ;
        }
        
        
        //下载失败了!!
        [self setDownloadPlistStatus:self.distriDownloadingPlists
                      distriPlistURL:distriPlist
                              status:DOWNLOAD_STATUS_ERROR];
        
        [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
        
        
        
        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj respondsToSelector:@selector(downloadFailCause:failCause:)] ) {
                [obj downloadFailCause:distriPlist failCause:GET_HTTP_PLIST_URL_FAIL];
            }
        }];
        
        //线程通知上层
        NSMutableDictionary * dicAttr = [NSMutableDictionary dictionaryWithDictionary:attr];
        [dicAttr setObject:[NSNumber numberWithInt:DOWNLOAD_STATUS_ERROR] forKey:@"status"];
        [self notifyStatusChange:distriPlist dicAttr:dicAttr];
        
        
        //删除 parser 解析对象
        [self.dicDistriPlistToParser removeObjectForKey: distriPlist];
        
        //下载失败，等待-->下载中
        [self waitToRun];
    }
}



- (NSUInteger) setDownloadPlistStatus:(NSMutableArray*)downloadLists
                       distriPlistURL:(NSString*)distriPListURL
                               status:(NSUInteger)status {
    @synchronized(self){
        NSUInteger  index = [downloadLists indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSString * distriPlist = [(NSMutableDictionary *)obj objectForKey:DISTRI_PLIST_URL];
            if ( [distriPlist isEqualToString:distriPListURL] ) {
                //修改下载状态
                [(NSMutableDictionary *)obj setObject:[NSNumber numberWithInteger:status] forKey:DISTRI_APP_DOWNLOAD_STATUS];
                *stop = YES;
                return YES;
            }
            
            return NO;
        }];
        return index;
    }
}

- (NSUInteger) getDownloadPlistStatus:(NSMutableArray*)downloadLists   //取得列表中的状态
                       distriPlistURL:(NSString*)distriPListURL {
    
    __block  NSUInteger status = DOWNLOAD_STATUS_UNKOWN;
    
    [downloadLists indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString * distriPlist = [(NSMutableDictionary *)obj objectForKey:DISTRI_PLIST_URL];
        if ( [distriPlist isEqualToString:distriPListURL] ) {
            //获取下载状态
            status = [(NSNumber *)[(NSMutableDictionary *)obj objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue];
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    
    return status;
}

- (void) printStatusInfo {
    return ;
    
    NSUInteger runCount = 0;
    NSUInteger waitCount = 0;
    NSUInteger errorCount = 0;
    
    for ( NSMutableDictionary * dicItem in self.distriDownloadingPlists ) {
        
        if ( [[dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue] == DOWNLOAD_STATUS_RUN ) {
            runCount ++;
            continue;
        }
        
        if ( [[dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue] == DOWNLOAD_STATUS_WAIT ) {
            waitCount ++;
            continue;
        }
        
        if ( [[dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue] == DOWNLOAD_STATUS_ERROR ) {
            errorCount ++;
            continue;
        }
    }
    
//    NSLog(@"printStatusInfo: run:%d wait:%d error:%d", runCount, waitCount, errorCount);
}

//从wait状态->下载中状态
- (void) waitToRun {
    
    @synchronized(self) {
        int index = [self maxDowndingCount];
        if ( [self ItemStatusCount:DOWNLOAD_STATUS_RUN] < index ) {
            
            //取一个 wait-->run
            for (NSMutableDictionary * dicItem in self.distriDownloadingPlists) {
                
                if ( [[dicItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue] ==  DOWNLOAD_STATUS_WAIT ) {
                    
                    //设置运行状态
                    NSString * distriPlistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
                    [self setDownloadPlistStatus:self.distriDownloadingPlists
                                  distriPlistURL:distriPlistURL
                                          status:DOWNLOAD_STATUS_RUN];
                    
                    //保存文件
                    [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
                    
                    //通知状态改变
                    NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:DOWNLOAD_STATUS_RUN],
                                              @"status",
                                              nil];
                    [self notifyStatusChange:distriPlistURL dicAttr:dicAttr];
                    
                    
                    //发送网络请求
                    [self SendParserListRequest:distriPlistURL];
                    
                    //NSLog(@"wait->run: appName:%@", [dicItem objectForKey:DISTRI_APP_NAME]);
                    
                    //启动它
                    break;
                }
            }
            
        }
    }
    
    
}

//相关IPA ICON等全部下载完毕
- (void) onDidPlistDownloadIPASuccess:(BppDistriPlistParser *)parser {
    
    NSString * distriPlist = parser.userInfo;
    
    NSUInteger  index = 0;
    @synchronized(self) {
        
        //修改状态
        index = [self setDownloadPlistStatus:self.distriDownloadingPlists
                              distriPlistURL:distriPlist
                                      status:DOWNLOAD_STATUS_SUCCESS];
        if (index != NSNotFound) {
            //从 下载中 --> 已下载
            NSMutableDictionary * dic = [self.distriDownloadingPlists objectAtIndex:index];
            
            //转成相对地址
            NSString *fullPath = [self relativePathToFullPath:[dic objectForKey:DISTRI_APP_IPA_LOCAL_PATH]];
            NSDictionary * fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            [dic setObject:[NSNumber numberWithLongLong:fileInfo.fileSize] forKey:DISTRI_IPA_TOTAL_LENGTH];
            
            [self.distriAlReadyDownloadedPlists addObject: dic ];
            
            [self.distriDownloadingPlists removeObjectAtIndex:index];
        }
        
        [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
        
        [self DownloadPListToFile:self.distriAlReadyDownloadedPlists fileName:self.downloadedFilePath];
        
        //NSLog(@"删除distriPlist:%@ 相关parser", distriPlist);
        [self.dicDistriPlistToParser removeObjectForKey:distriPlist];
        
        //wait-->run
        [self waitToRun];
    }
    
    
    //在主线程中通知下载完毕
    dispatch_async(dispatch_get_main_queue(), ^{
        //通知界面上层, IPA下载完毕
        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj respondsToSelector:@selector(onDidPlistMgrDownloadIPAComplete:index:)] ) {
                [obj onDidPlistMgrDownloadIPAComplete:distriPlist index:index ];
            }
        }];
        
    });
    
    //通知应用的下载状态变化了
    [self notifyAppDownloadStatusChange:nil];
    
}

- (void) onDidDownloadAUIPAError:(BppDistriPlistParser *)parser  appid:(NSString*)appid{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            //修改状态信息
            NSMutableDictionary *dic = [self ItemInfoInDownloadingByAttriName:DISTRI_APP_ID value:appid];
            if(dic) {
                [dic setObject:[NSNumber numberWithInt:DOWNLOAD_STATUS_ERROR] forKey:DISTRI_APP_DOWNLOAD_STATUS];
                [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
            }
                        
            [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if( [obj respondsToSelector:@selector(onDidPlistMgrDownloadAUIPAError:)] ) {
                    [obj onDidPlistMgrDownloadAUIPAError: appid];
                }
            }];
            
            
            //wait-->run
            [self  waitToRun];
        }
    });
    
}

- (void) onDidPlistDownloadIPAError:(BppDistriPlistParser *)parser dicAttr:(NSDictionary*)attr{
    
    //主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            NSString * distriPlist = parser.userInfo;
            
            //更新内存中状态
            [self setDownloadPlistStatus:self.distriDownloadingPlists
                          distriPlistURL:distriPlist
                                  status:DOWNLOAD_STATUS_ERROR];
            //保存到文件
            [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
            
            
            //通知界面上层, IPA下载完毕
            NSMutableDictionary * dicAttr = [NSMutableDictionary dictionaryWithDictionary:attr];
            [dicAttr setObject:[NSNumber numberWithInt:DOWNLOAD_STATUS_ERROR] forKey:@"status"];
            [self notifyStatusChange:distriPlist dicAttr:dicAttr];
            
            //wait-->run
            [self  waitToRun];
        }
    });
    
}


- (void) notifyStatusChange:(NSString*)distriPlist dicAttr:(NSDictionary*)attr {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj respondsToSelector:@selector(onDidPlistMgrStatusChange:dicAttr:)] ) {
                [obj onDidPlistMgrStatusChange:distriPlist dicAttr:attr];
            }
        }];
    });
    
}


//解析处理
- (void) onDistriPlistParserIPAProgress:(BppDistriPlistParser *)parser  attr:(NSDictionary*)dicAttr {
    
    NSString * distriPlist = parser.userInfo;
    
    //获取进度, 保存文件
    NSNumber * progress = [dicAttr objectForKey:BPPDownloadProgressKey];
    //获取文件总长度
    NSNumber * length = [dicAttr objectForKey:BPPDownloadTotalLengthKey];
    
    @synchronized(self){
        
        for (NSMutableDictionary * dicItem in self.distriDownloadingPlists) {
            NSString * plistURL = [dicItem objectForKey:DISTRI_PLIST_URL];
            if ( [plistURL isEqualToString:distriPlist] ) {
                if( [progress integerValue] != -100 ){
                    //保存下载进度
                    [dicItem setObject:progress forKey:DISTRI_APP_DOWNLOAD_PROGRESS];
                }else{
//                    NSLog(@"%@ 进度为 -100", dicAttr);
                }
                //设置文件总长度
                [dicItem setObject:length forKey:DISTRI_IPA_TOTAL_LENGTH];
                break;
            }
        }
        
        [self DownloadPListToFile:self.distriDownloadingPlists fileName:self.downloadingFilePath];
    }
    
    
    //主线程回调
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listeners  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj respondsToSelector:@selector(onDidPlistMgrDownloadIPAProgress:attr:)] ) {
                [obj onDidPlistMgrDownloadIPAProgress:distriPlist attr:dicAttr];
            }
        }];
    });
}

//文件正在md5验证
- (void) onPlistDownloadMD5Checking:(BppDistriPlistParser *)parser {
    
    //通知界面
    NSString * distriPlist = parser.userInfo;
    
    NSDictionary * dicAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:DOWNLOAD_STATUS_MD5_CHECK],
                              @"status",
                              nil];
    [self notifyStatusChange:distriPlist dicAttr:dicAttr];
}

//如果是3g是否可以继续下载ipa
- (void)isCan3gDownload:(BOOL)isCan{
    isContinue = isCan;
}

/*
 //删除同一appid在下载中和已下载里的低级版本
 - (void)deleteLowVersionInDownloading:(NSString *)appid version:(NSString *)version{
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 //从下载中列表里删除同appid不同version的应用
 NSMutableArray *downingArray = [NSMutableArray array];
 for (NSMutableDictionary *downingDic in self.distriDownloadingPlists) {
 NSString *downingAppid = [downingDic objectForKey:DISTRI_APP_ID];
 NSString *downingVer = [downingDic objectForKey:DISTRI_APP_VERSION];
 if ([downingAppid isEqualToString:appid] && ![downingVer isEqualToString:version]) {
 NSString *downingPlist = [downingDic objectForKey:DISTRI_PLIST_URL];
 [downingArray addObject:downingPlist];
 }
 }
 
 BOOL needDel = downingArray.count > 0?YES:NO;
 
 
 while (downingArray.count > 0) {
 NSUInteger index;
 index = [self indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL value:[downingArray objectAtIndex:0]];
 if (index != NSNotFound) {
 [self.distriDownloadingPlists removeObjectAtIndex:index];
 }
 [downingArray removeObjectAtIndex:0];
 }
 
 NSMutableArray *downloadedArray = [NSMutableArray array];
 for (NSMutableDictionary *downloadedDic in self.distriDownloadingPlists) {
 NSString *downloadedAppid = [downloadedDic objectForKey:DISTRI_APP_ID];
 NSString *downloadedVer = [downloadedDic objectForKey:DISTRI_APP_VERSION];
 if ([downloadedAppid isEqualToString:appid] && ![downloadedVer isEqualToString:version]) {
 NSString *downloadedPlist = [downloadedDic objectForKey:DISTRI_PLIST_URL];
 [downloadedArray addObject:downloadedPlist];
 }
 }
 
 BOOL _needDel = downloadedArray.count > 0?YES:NO;
 
 
 while (downloadedArray.count > 0) {
 NSUInteger index;
 index = [self indexItemInDownloadedByAttriValue:DISTRI_PLIST_URL value:[downloadedArray objectAtIndex:0]];
 if (index != NSNotFound) {
 [self.distriAlReadyDownloadedPlists removeObjectAtIndex:index];
 }
 [downingArray removeObjectAtIndex:0];
 }
 
 NSString *rushUIList = nil;
 if (needDel == YES && _needDel == YES) {
 rushUIList = @"all";
 }else if (needDel == YES && _needDel == NO){
 rushUIList = @"downing";
 }else if (needDel == NO && _needDel == YES){
 rushUIList = @"downloaded";
 }
 
 if (rushUIList) {
 [[NSNotificationCenter defaultCenter] postNotificationName:RUSH_LIST object:rushUIList];
 }
 
 });
 
 }
 
 */

//最大下载数
-(NSInteger)maxDowndingCount {
    
    if( [self.controlDelegate respondsToSelector:@selector(maxDowndingCount)] ){
        return [self.controlDelegate maxDowndingCount];
    }
    
    return DEF_MAX_DOWNLOADING_COUNT;    
}


-(NSInteger)getIPASize:(NSString*)distriPlistURL {
    
    NSDictionary * itemInfo = [self ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlistURL];
    NSString * ipaPath = [itemInfo objectForKey:DISTRI_APP_IPA_LOCAL_PATH];
    ipaPath = [self relativePathToFullPath:ipaPath];
    
    NSDictionary * fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:ipaPath error:nil];
    
    return fileInfo.fileSize;
}

//通知应用添加或者开始下载, 用于解决3G流量提醒
-(void)notifyAppAddOrStart:(NSDictionary*)appInfo {

    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter  defaultCenter] postNotificationName:DISTRI_PLIST_MANAGER_NOTIFICATION_ADD_OR_START_DOWNLOAD object:appInfo];
    });
}


//通知应用下载状态变化
-(void)notifyAppDownloadStatusChange:(NSDictionary*)appInfo {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter  defaultCenter] postNotificationName:DOWNLOAD_ITEM_STATUS_CHANGE_NOTIFICATION object:appInfo];
    });
}


-(void)setNeedRequest:(BOOL)request {
    _needRequest = request;
}


@end