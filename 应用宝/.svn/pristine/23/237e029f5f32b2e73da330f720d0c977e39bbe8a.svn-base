//
//  ShowStorageView.m
//  browser
//
//  Created by mingzhi on 14-5-5.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "ShowStorageView.h"
#import "BPPProgressView.h"
#import "FileUtil.h"

#define USEDCOLOR MY_YELLOW_COLOR
#define UNUSEDCOLOR [UIColor colorWithRed:139.0/255 green:137.0/255 blue:137.0/255 alpha:1]

@interface ShowStorageView (){
    
    UILabel *showusedLabel;
    UILabel *usedLabel;
    
    UILabel *showtotalLabel;
    UILabel *totalLabel;
    
    //下载进度
    //UIProgressView *myProgressView;
    BPPProgressView *_downProgress;
    
    float totalSpace;
    float totalFreeSpace;
    
    NSString *usedStr;
    NSString *spaceStr;
}

@end

@implementation ShowStorageView

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        
//        usedLabel = [[UILabel alloc] init];
//        usedLabel.backgroundColor = USEDCOLOR;
//        totalLabel = [[UILabel alloc] init];
//        totalLabel.backgroundColor = UNUSEDCOLOR;
        
        showusedLabel = [[UILabel alloc] init];
        showusedLabel.backgroundColor = [UIColor clearColor];
        [showusedLabel setTextColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1]];
        [showusedLabel setFont:[UIFont systemFontOfSize:10]];
        [showusedLabel setTextAlignment:NSTextAlignmentLeft];
        
        showtotalLabel = [[UILabel alloc] init];
        showtotalLabel.backgroundColor = [UIColor clearColor];
        [showusedLabel setTextColor:[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1]];
        [showtotalLabel setFont:[UIFont systemFontOfSize:10]];
        [showtotalLabel setTextAlignment:NSTextAlignmentRight];
        
        //下载进度
        _downProgress = [[BPPProgressView alloc] init];
        
        [LocalImageManager setImageName:@"storageprogressBG_iphone.png" complete:^(UIImage *image) {
            image = [image stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];
            _downProgress.trackImage = image;
        }];
        [LocalImageManager setImageName:@"storageprogressShow_iphone.png" complete:^(UIImage *image) {
            image = [image stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];
            _downProgress.progressImage = image;
        }];
        
        
//        [self addSubview:usedLabel];
//        [self addSubview:totalLabel];
        [self addSubview:showusedLabel];
        [self addSubview:showtotalLabel];
        [self addSubview:_downProgress];
        
        usedStr = [[NSString alloc] init];
        spaceStr = [[NSString alloc] init];
    }
    return self;
}
- (void)layoutSubviews
{
    _downProgress.frame = CGRectMake((self.frame.size.width-301)/2, 9/2+3, 301, 5);
    
    //usedLabel.frame = CGRectMake(myProgressView.frame.origin.x, 20, 15, 15);
    showusedLabel.frame = CGRectMake(_downProgress.frame.origin.x, 11, _downProgress.frame.size.width/2, 20);
    //totalLabel.frame = CGRectMake(showusedLabel.frame.origin.x+110, 20, 15, 15);
    showtotalLabel.frame = CGRectMake(showusedLabel.frame.origin.x+showusedLabel.frame.size.width, 11, _downProgress.frame.size.width/2, 20);
    
    [self setProgressView];
}
- (void)setProgressView
{
    [self getFreeDiskspace];
    [_downProgress setProgress:(totalSpace-totalFreeSpace)/totalSpace animated:YES];
}

- (void)getFreeDiskspace {
    
    NSError *error = nil;
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[[FileUtil instance] getDocumentsPath]
                                                                                       error:&error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        
        float totalUsedSpace = totalSpace - totalFreeSpace;
        
        //NSLog(@"总空间大小：%fM 可用空间大小：%fM", ((totalSpace/1024.0f)/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f));
        
        if (totalUsedSpace/1024.0f/1024.0f/1024.0f > 1) {
            showusedLabel.text = [NSString stringWithFormat:@"已用 %.2fG",totalUsedSpace/1024.0f/1024.0f/1024.f];
        }else
        {
            showusedLabel.text = [NSString stringWithFormat:@"已用 %.2fM",totalUsedSpace/1024.0f/1024.0f];
        }
        
        if (totalFreeSpace/1024.0f/1024.0f/1024.0f > 1) {
            showtotalLabel.text = [NSString stringWithFormat:@"可用 %.2fG",totalFreeSpace/1024.0f/1024.0f/1024.0f];
        }else
        {
            showtotalLabel.text = [NSString stringWithFormat:@"可用 %.2fM",totalFreeSpace/1024.0f/1024.0f];
        }
        
        
        
    } else {
        
        showusedLabel.text = @"获取已用空间失败";
        showtotalLabel.text = @"获取可用空间失败";
        
        NSLog(@"获得系统内存错误信息: Domain = %@, Code = %@", [error domain], error);
    }
}

//- (void)dealloc
//{
//    [super dealloc];
//    
//    [usedLabel release],usedLabel = nil;
//    [totalLabel release],totalLabel = nil;
//    
//    [showusedLabel release],showusedLabel = nil;
//    [showtotalLabel release],showtotalLabel = nil;
//    
//    [_downProgress release],_downProgress = nil;
//    
//    [usedStr release];
//    [spaceStr release];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
