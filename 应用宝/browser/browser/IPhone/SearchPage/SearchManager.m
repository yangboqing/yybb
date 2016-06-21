//
//  SearchManager.m
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//

#import "SearchManager.h"
#import "CJSONDeserializer.h"
#import "SearchServerManage.h"

@interface SearchManager ()<SearchServerManageDelegate>{
    
}

@end

@implementation SearchManager
@synthesize delegate = _delegate;
@synthesize searchRecordPlistPath = _searchRecordPlistPath;
@synthesize recommendClickPlistPath = _recommendClickPlistPath;
@synthesize searchRecordArray = _searchRecordArray;
@synthesize recommendClickDictionary = _recommendClickDictionary;
+ (SearchManager *)getObject{
    
    @synchronized(@"SearchManager"){
        static SearchManager *object = nil;
        if (object == nil){
            object = [[SearchManager alloc] init];
        }
        return object;
    }
}
- (id) init {
    
    if ( self=[super init] ) {

        [self creatDeployFolder];
        self.searchRecordPlistPath = [self getSearchResultPath];
        self.recommendClickPlistPath = [self getRecommendClickFilePath];
        
        self.searchRecordArray = [self getSearchResultArray];
        if (!self.searchRecordArray) {
            self.searchRecordArray = [NSMutableArray array];
        }
        self.recommendClickDictionary = [self getRecommendClickFileDictionary];
        if (!self.recommendClickDictionary) {
            self.recommendClickDictionary = [NSMutableDictionary dictionary];
        }
        
        [self checkSearchResultFile];
        [self checkRecommendClickFile];
    }
    
    return self;
}


#pragma mark -
#pragma mark 搜索热词
- (void)initHotWord{
    
    [SearchServerManage getObject].delegate = self;
    [[SearchServerManage getObject] requestHotWord:YES];
    
}

-(BOOL)checkData:(NSArray *)data
{
    BOOL hotFlag = NO;
    if (IS_NSARRAY(data) && data.count>=9) {
        for (int i=0; i < 9 ;i++) {
            if (IS_NSSTRING(data[i])) {
                hotFlag = YES;
            }
            else
            {
                hotFlag = NO;
                break;
            }
        }
    }
    
    return hotFlag;
}

#pragma mark - SearchServerManageDelegate
-(void)getSearchHotWord:(NSArray *)hotArray
{ // 初次显示是调用的热刺
    if ([self checkData:hotArray]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initHotWordView" object:hotArray];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initHotWordView" object:nil];
    }
    
}

-(void)searchHotWordRequestFail
{// 搜索热词首次加载失败
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initHotWordView" object:nil];
}
#pragma mark -
#pragma mark 增、存、删 搜索记录

#define SEARCH_HISTORY_RECORD @"searchHistoryRecord"

- (void)creatDeployFolder{
    NSString * strPath = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search"];
    [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
}



//检查plist文件是否存在
- (BOOL)checkSearchResultFile{
    BOOL isDirExist = [[FileUtil instance] isExistFile:self.searchRecordPlistPath];
    if(!isDirExist){
        [self creatSearchResultFile];
        return NO;
    }else{
        return YES;
    }
}

//创建plist文件
- (void)creatSearchResultFile{
    [[NSFileManager defaultManager] createFileAtPath:self.searchRecordPlistPath contents:nil attributes:nil];
    NSMutableArray *array = [NSMutableArray array];
    [self writeFile:array path:self.searchRecordPlistPath];
    
}

//保存数组
- (void) writeFile:(NSMutableArray *)updatalist path:(NSString *)path{
    [updatalist writeToFile:path atomically:NO];
}

//获取文件路径
- (NSString *)getSearchResultPath{
    
    return [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search/SearchResult.plist"];
}

//获取数组
- (NSMutableArray *)getSearchResultArray{
    return [NSMutableArray arrayWithContentsOfFile:self.searchRecordPlistPath];
}

-(NSInteger)isThereAWordInHistoryRecord:(NSString *)historyStr
{ // 返回值，如果是-1则不存在historyStr字符串，否则为historyStr在数组中的索引
    if (_searchRecordArray == nil) {
        return -1;
    }
    
    __block NSUInteger index = -1;
    [_searchRecordArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([historyStr isEqualToString:obj]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

//获取数组
- (NSMutableArray *)getSearchHistoryArray{
    return [NSMutableArray arrayWithContentsOfFile:self.searchRecordPlistPath];
}

//获取文件路径
- (NSString *)getSearchHistoryPath{
    return [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search/SearchHistory.plist"];
}



- (void)saveSearchHistoryRecord:(NSString *)historyRecord{

    BOOL isTwenty = NO;
    if (_searchRecordArray && _searchRecordArray.count >= 20) {
        isTwenty = YES;
    }
    
    //
    NSString *_historyRecord = nil;
    _historyRecord = [[FileUtil instance] urlEncode:historyRecord];
    
    // 判断存储的记录中是否包含historyRecord
    int statement = [self isThereAWordInHistoryRecord:_historyRecord];
    if (statement == 0)
    {
        return ;
    }
    else if(statement != -1)
    {
        [self deleteSearchHistoryRecord:statement];
    }
    else if(isTwenty)
    { // 新纪录（20个记录已满且为新记录则删除最后一个）
        [self deleteSearchHistoryRecord:_searchRecordArray.count-1];
    }
    
    // 插入新的搜索词
    [self.searchRecordArray insertObject:_historyRecord atIndex:0];
    [self writeFile:self.searchRecordArray path:self.searchRecordPlistPath];
    
}

- (NSString *)getSearchHistoryLastoneRecord{

    if (self.searchRecordArray.count < 1) {
        return NOT_SEARCH_RESULT;
    }
    
    NSString *record = nil;
    record = [[FileUtil instance] urlDecode:[self.searchRecordArray objectAtIndex:0]];
    return record;
}
- (NSString *)getSearchHistoryRecord:(NSUInteger)index{
    if (self.searchRecordArray.count <= 0) {
        return NOT_SEARCH_RESULT;
    }
    
    if (index >= self.searchRecordArray.count) {
        return NOT_SEARCH_RESULT;
    }
    NSString *record = [[FileUtil instance] urlDecode:[self.searchRecordArray objectAtIndex:index]];
    return record;

}

- (BOOL)deleteSearchHistoryRecord:(NSUInteger)index{
    if (self.searchRecordArray.count <= 0) {
        return NO;
    }
    if (index >= self.searchRecordArray.count) {
        return NO;
    }
    [self.searchRecordArray removeObjectAtIndex:index];
    
    [self writeFile:self.searchRecordArray path:self.searchRecordPlistPath];
    return YES;
}

#pragma mark -
#pragma mark 保存推荐点击

//检查plist文件是否存在
- (BOOL)checkRecommendClickFile{;
    BOOL isDirExist = [[FileUtil instance] isExistFile:self.recommendClickPlistPath];
    if(!isDirExist){
        [self creatRecommendClickFile];
        return NO;
    }else{
        return YES;
    }
}

//创建plist文件
- (void)creatRecommendClickFile{
    [[NSFileManager defaultManager] createFileAtPath:self.recommendClickPlistPath contents:nil attributes:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self writeDicToFile:dic path:self.recommendClickPlistPath];
    
}

//获取文件路径
- (NSString *)getRecommendClickFilePath{
        
    return [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search/Recommend.plist"];
}

- (void)writeDicToFile:(NSMutableDictionary*)dic path:(NSString *)path{
    [dic writeToFile:path atomically:NO];
}

//获取字典
- (NSMutableDictionary *)getRecommendClickFileDictionary{
    return [NSMutableDictionary dictionaryWithContentsOfFile:self.recommendClickPlistPath];
}

- (void)setRecommendIsClick:(NSString *)kid{;
    [self.recommendClickDictionary setObject:kid forKey:kid];
    [self writeDicToFile:self.recommendClickDictionary path:self.recommendClickPlistPath];
}
- (BOOL)getRecommendButtonState:(NSString *)kid{
    
    if (![self.recommendClickDictionary objectForKey:kid]) {
        return NO;
    }

    return YES;
}

#pragma  mark -
#pragma mark 从缓存取图片或者下载
- (void)downloadImageURL:(NSURL *)url  userData:(id)userdata
{
    
    NSData *ret = [[TMCache sharedCache] objectForKey:[url absoluteString]];
    if (ret) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(getImageSucessFromImageUrl:image:userData:)]) {
                
                UIImage * image = [UIImage imageWithData:ret];
                if(image)
                    [self setImageOnMainThread:image url:[url absoluteString] userData:userdata];
                else
                    [self setImageOnMainThread:nil url:[url absoluteString] userData:userdata];
            }
        });
    }else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError) {
                    [self setImageOnMainThread:nil url:[url absoluteString] userData:userdata];
                }else{
                    if (data) {
                        UIImage * image = [UIImage imageWithData:data];
                        if(image){
                            [[TMCache sharedCache] setObject:data forKey:[url absoluteString]];
                            
                            [self setImageOnMainThread:image url:[url absoluteString] userData:userdata];
                            return ;
                        }
                    }
                    
                    [self setImageOnMainThread:nil url:[url absoluteString] userData:userdata];
                }
        }];
    }
}

- (void)setImageOnMainThread:(UIImage *)image url:(NSString *)urlStr  userData:(id)userdata
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!image){
            if (self.delegate && [self.delegate respondsToSelector:@selector(getImageFailFromUrl:userData:)]) {
                [self.delegate getImageFailFromUrl:urlStr userData:userdata];
            }
        }else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getImageSucessFromImageUrl:image:userData:)]) {
                [self.delegate getImageSucessFromImageUrl:urlStr image:image userData:userdata];
            }
            
        }
    });
}

#pragma mark -
#pragma mark 下载存缓存
- (void)downloadDictionaryFromUrlString:(NSString*)str  userData:(id)userdata
{
    
    //NSDictionary *tet = @{};
    NSDictionary *tet = (NSDictionary *)[[TMCache sharedCache] objectForKey:str];
    if (tet) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(getDictionarySucessFromUrl:Dictionary:userData:)]) {
                [self.delegate getDictionarySucessFromUrl:str Dictionary:tet userData:userdata];
            }
        });
    }else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError) {
                [self getDictionaryFromUrlDownload:nil urlStr:str userData:userdata];
            }else{
                if (data) {
                    NSDictionary *dic = [self getDetailAppDetailIntroStr:data];
                    [[TMCache sharedCache] setObject:dic forKey:str];
                    
                    [self getDictionaryFromUrlDownload:dic urlStr:str userData:userdata];                                        
                }else{
                    [self getDictionaryFromUrlDownload:nil urlStr:str userData:userdata];
                }
            }
        }];
    }
    
}

- (void)getDictionaryFromUrlDownload:(NSDictionary *)Dictionary urlStr:(NSString *)urlStr  userData:(id)userdata
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!Dictionary){
            if (self.delegate && [self.delegate respondsToSelector:@selector(getDictionaryFailFromUrl:userData:)]) {
                [self.delegate getDictionaryFailFromUrl:urlStr userData:userdata];
            }
        }else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(getDictionarySucessFromUrl:Dictionary:userData:)]) {
                [self.delegate getDictionarySucessFromUrl:urlStr Dictionary:Dictionary userData:userdata];
            }
            
        }
    });
}
- (NSArray *)getIpaDetailContent:(NSString *)urlStr
{ // 获取文件中图片urls
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSDictionary *dic = [self getDetailAppDetailIntroStr:data];
    return [dic objectForKey:@"APPPREVIEWURLS"];
}

#pragma mark 
#pragma mark -


- (NSDictionary *)getDetailAppDetailIntroStr:(NSData*)data{
    if (!data) {
        return nil;
    }
    NSString* cdnStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *_cdnStr = nil;

    cdnStr = [cdnStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];//@""
    
    NSRange range = [cdnStr rangeOfString:@"{" options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    _cdnStr = [cdnStr substringFromIndex:range.location];
    
    NSDictionary *dic = [self analysisJSONToDictionary:_cdnStr];
    
    NSDictionary *subDic = [dic objectForKey:@"APPINFOR"];
    //应用介绍
//    NSString *introStr = [subDic objectForKey:@"APPDETAILINTRO"];
    //应用截图所在数组
//    NSArray *apppreviewurls = [subDic objectForKey:@"APPPREVIEWURLS"];
    return subDic;
    
}

-(NSDictionary *)analysisJSONToDictionary:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSDICTIONARY(root))
        return nil;
    
    return root;
}

- (void)setAppRecommendKid:(NSString *)kid{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:APP_RECOMMEND]];

    if ([array containsObject:kid]) return;
    [array addObject:kid];
    [user setValue:array forKey:APP_RECOMMEND];
    [user synchronize];
    
    
}

- (BOOL)getRecommendState:(NSString *)kid{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:APP_RECOMMEND]) {
        return NO;
    }
    
    NSMutableArray *array = [user objectForKey:APP_RECOMMEND];
    for (NSString *_kid in array) {
        if ([_kid isEqualToString:kid]) {
            return YES;
        }
    }
    
    
    return NO;
}

- (void)storeActivityId:(NSString *)activityId;
{ //发现点击过的活动进行保存
    
    // 容错
    if (activityId == nil) return;
    
    //
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:ACTIVITY_CLICKED]];
    
    if ([array containsObject:activityId]) return;
    [array addObject:activityId];
    [user setObject:array forKey:ACTIVITY_CLICKED];
    [user synchronize];
}

- (NSMutableArray *)getActivityIDs;
{ //发现点击过的活动id获取
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:ACTIVITY_CLICKED]) {
        return nil;
    }
    
    NSMutableArray *array = [user objectForKey:ACTIVITY_CLICKED];
    return array;
}

- (void)dealloc{
    self.delegate = nil;
    self.searchRecordPlistPath = nil;
    self.recommendClickPlistPath = nil;
}

@end
