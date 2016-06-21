//
//  PhotosAlbumManager.m
//  browser
//
//  Created by mingzhi on 14-4-16.
//
//

#import "PhotosAlbumManager.h"
#import<AssetsLibrary/AssetsLibrary.h>

@interface PhotosAlbumManager ()
{
    ALAssetsLibrary *assetsLibrary;     //相册实例
    
    NSInteger customAlbum;              //判断保存到什么相册 0：系统相册    1：自定义相册
    
    NSString *albumName;                //自定义相册名字
    
    NSInteger _mediaItemCount;          //多媒体总个数
}

@end

@implementation PhotosAlbumManager
@synthesize delegate;



- (id)initWithDelegate:(id)thedelegate {
    
    if (self=[super init]) {
        assetsLibrary = [[ALAssetsLibrary alloc]init];
        self.delegate = thedelegate;
        albumName = [[NSString alloc] init];
    }
    return self;
}

- (ALBUMVISITSTATE)ifCanVisitTheAlbum
{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//获取对摄像头的访问权限。
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
            
        case ALAuthorizationStatusNotDetermined:
            return CHOOCESTATE;
            break;
            
        case ALAuthorizationStatusRestricted:
        case ALAuthorizationStatusDenied:
            return REFUSESTATE;
            break;
        
        case ALAuthorizationStatusAuthorized:
            return VISIABLESTATE;
            break;
            
        default:
            break;
    }
    
}

//保存到自定义相册
- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *tempassetsLibrary, NSURL *assetURL) {
        [tempassetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [tempassetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    
    __weak ALAssetsLibrary *assetsLibrarySelf = assetsLibrary;
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrarySelf addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrarySelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrarySelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrarySelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
    
}

- (void)saveImageToNewAlbum:(NSArray*)mediaArray AlbumName:(NSString *)albumname{
    NSLog(@"将保存图片%@",mediaArray);
    customAlbum = 1;
    albumName = albumname;
    
    const int filecount = mediaArray.count;
    _mediaItemCount = filecount;
    
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:albumname])
                {
                    haveHDRGroup = YES;
                    break;
                }
            }
            
            if (!haveHDRGroup)
            {
                //do add a group named "HDR"
                [assetsLibrary addAssetsGroupAlbumWithName:albumname
                                               resultBlock:^(ALAssetsGroup *group){
                                                   
                                                   [groups addObject:group];
                                               
                                               }
                                              failureBlock:nil];            
            }
        }
        
    };
    //创建相簿
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
    NSString *item = [mediaArray objectAtIndex:0];
    
    item = [NSHomeDirectory() stringByAppendingString:item];
    
    NSFileManager *tmpManager = [NSFileManager defaultManager];
    
    if ([tmpManager fileExistsAtPath:item]) {
        
        NSLog(@"文件存在本地路径");
        UIImage *image = [UIImage imageWithContentsOfFile:item];
        
        NSData *imageData = [NSData dataWithContentsOfFile:item];
        
        [self saveToAlbumWithMetadata:nil imageData:imageData customAlbumName:albumname completionBlock:^{
            //成功
            NSLog(@"%@保存到相册成功",image);
            [self image:image didFinishSavingWithError:nil contextInfo:(__bridge void *)(mediaArray)];
        }failureBlock:^(NSError *error){
            //失败
            NSLog(@"%@保存到相册失败",image);
            [self image:image didFinishSavingWithError:error contextInfo:(__bridge void *)(mediaArray)];
        }];
    }else
    {
        NSLog(@"文件不存在本地路径");
        NSError *error = nil;
        [self image:nil didFinishSavingWithError:error contextInfo:(__bridge void *)(mediaArray)];
        
    }
    
}

- (void)saveMediaToCameraRoll:(NSArray *)mediaArray
{
    customAlbum = 0;
    
    const int filecount = mediaArray.count;
    _mediaItemCount = filecount;
    
    // 递归保存图片
    NSString *item = [mediaArray objectAtIndex:0];
    UIImage *image = [UIImage imageWithContentsOfFile:item];
    
    __weak PhotosAlbumManager * weakSelf = nil;
    [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [weakSelf image:image didFinishSavingWithError:error contextInfo:(__bridge void *)(mediaArray)];
    }];
    
    
//    // 保存视频
//    for (id item in mediaArray) {
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(item)) {
//            
//            UISaveVideoAtPathToSavedPhotosAlbum(item, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
//        }else {
//            [self updateProcessWithError:[NSError errorWithDomain:@"copy video error" code:-1 userInfo:nil]];
//        }
//    }
}
#pragma mark -
#pragma mark 保存进度

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSMutableArray *tmpFileArray = (__bridge NSMutableArray *)contextInfo;
    
    //成功失败都删除
    NSError *deleteError = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[tmpFileArray objectAtIndex:0] error:&deleteError];
    
    [self updateProcessWithError:error andPath:[tmpFileArray objectAtIndex:0]];
    [tmpFileArray removeObjectAtIndex:0];
    NSLog(@"保存一张后剩余%@",tmpFileArray);
    
    //递归执行保存图片
    if (tmpFileArray.count) {
        if (customAlbum) {
            [self saveImageToNewAlbum:tmpFileArray AlbumName:albumName];
        }else
        {
            [self saveMediaToCameraRoll:tmpFileArray];
        }
    }
}

- (void)video: (NSString *)videoPath didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    [self updateProcessWithError:error andPath:nil];
}

- (void)updateProcessWithError:(NSError *)error andPath:(NSString *)path
{
    BOOL isSuccess = YES;
    if (error) {
        isSuccess = NO;
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if (delegate && [delegate respondsToSelector:@selector(mediaItemCopiedIsSuccess:andPath:)]) {
        [delegate mediaItemCopiedIsSuccess:isSuccess andPath:path];//完成一个
    }
    
}

- (void)dealloc
{
}

@end
