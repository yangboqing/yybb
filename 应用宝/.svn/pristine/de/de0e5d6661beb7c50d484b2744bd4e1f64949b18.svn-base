//
//  AfterLaunchPopView.m
//  
//
//  Created by mingzhi on 14-4-10.
//  Copyright (c) 2014年 ___mingzhi___. All rights reserved.
//

#import "AfterLaunchPopView.h"
#import "RealtimeShowAdvertisement.h"
#import "FileUtil.h"
#import "IphoneAppDelegate.h"

@implementation AfterLaunchPopView
//测试图片链接  @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg"
@synthesize imageDataPath;

- (void)dealloc{
    self.imageDataPath = nil;
}
- (id)initWithFrame:(CGRect)frame andRemoveAfterDelay:(int)time
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        waitTime = time;
        
        //目录
        NSString *tmpStr = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search"];
        BOOL isDirExist = [[FileUtil instance] isExistFile:tmpStr];
        if(!isDirExist){
            NSError *error = nil;
            BOOL creatFile = [[NSFileManager defaultManager] createDirectoryAtPath:tmpStr
                                                       withIntermediateDirectories:YES attributes:nil
                                                                             error:&error];
            if (creatFile) {
                NSLog(@"创建成功");
            }
            else
            {
                NSLog(@"%@创建失败  %@",tmpStr,error);
            }
        }
        
        //图片目录
        if (MainScreen_Height > 500) {
            self.imageDataPath =   [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search/iphone5realtimeshow.png"];
        }else{
            self.imageDataPath = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"/Search/iphone4realtimeshow.png"];
        }
        
        //本地realtimeshow  Plist文件地址
        imagePlistPath = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:@"Search/realtimeshow.plist"];
        plistDic = [NSMutableDictionary dictionaryWithContentsOfFile:imagePlistPath];
        if (!plistDic) {
            plistDic = [NSMutableDictionary dictionary];
        }
        
        //设备str
        if (MainScreen_Height > 500) {
            deviceStr = @"iphone5Show";
        }else{
            deviceStr = @"iphone4Show";
        }
        self.userInteractionEnabled = YES;
        imageView = [[UIImageView alloc] init];
        imageView.frame = frame;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKaipinDetail)];
        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
        
    }
    return self;
}

- (void)showWithDic:(NSDictionary *)dic
{
    //有数据则更新数据
    if (dic) {
        
        //每次启动删除旧开屏图信息,直接请求新开屏图
        [self  deleteTheImage];
        
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        if (![[dataDic allKeys] containsObject:@"imgurl"]) {
//            [self deleteTheImage];
            return;
        }else{
            if (![[plistDic allKeys] containsObject:deviceStr]||![[plistDic objectForKey:deviceStr] isEqualToDictionary:dataDic]) {
                [self saveTheFileWithDic:dataDic];
            }
            
        }
        
    }else{//无数据显示kpt
        if ([[plistDic allKeys] containsObject:deviceStr]) {
            NSString *startTime = [[plistDic objectForKey:deviceStr] objectForKey:@"starttime"];
            NSString *endTime = [[plistDic objectForKey:deviceStr] objectForKey:@"endtime"];
            if (endTime&&startTime) {
                float now = [[NSDate date] timeIntervalSince1970];
                float start = [startTime floatValue];
                float end = [endTime floatValue];
                if (now < end && now > start) {
                    
                    UIImage *img = [UIImage imageWithContentsOfFile:self.imageDataPath];
                    imageView.image = img;
                    [browserAppDelegate.window.rootViewController.view addSubview:self];
                    [browserAppDelegate.window.rootViewController.view bringSubviewToFront:self];
                    [[ReportManage instance] reportKaipingLaunchedWithType:[[plistDic objectForKey:deviceStr] objectForKey:@"type"] andImgid:[[plistDic objectForKey:deviceStr] objectForKey:@"imgid"]];
                }else if([[FileUtil instance] timeIntervalFromNow:endTime] > 0){
                    NSLog(@"kpt  图片过期");
                    [self deleteTheImage];
                    return;
                }
            }
            

            
        }
    }

}

- (void)showKaipinDetail{
    NSDictionary *data = [plistDic objectForKey:deviceStr];
    if (!data) {
        return;
    }
    if (data) {
        NSString *type = [data objectForKey:@"type"];
        NSString *linkOpenType = [data objectForKey:@"linkopentype"];
        NSString *linkUrl = [data objectForKey:@"linkurl"];
        NSString *appId = [data objectForKey:@"appid"];

        if (type) {
            
            [self _hide];
            if ([type isEqualToString:@"toWebUrl"]&&linkOpenType) {
                if ([linkOpenType isEqualToString:@"kuaiyong"]) {
                    //内部跳转
                    [[NSNotificationCenter defaultCenter] postNotificationName:CLICK_KAIPING object:@{@"kaiping_type":type,@"kaiping_detail":linkUrl}];
                }else if ([linkOpenType isEqualToString:@"safari"]){
                    //safari跳转
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkUrl]];
                }
                [[ReportManage instance] reportKaipingClickedWithType:type andContentid:linkUrl];
                return;
            }
            if ([type isEqualToString:@"toAppDetail"]&&appId&&![appId isEqualToString:@""]){
                //跳转详情
                [[NSNotificationCenter defaultCenter] postNotificationName:CLICK_KAIPING object:@{@"kaiping_type":type,@"kaiping_detail":appId}];
                [[ReportManage instance] reportKaipingClickedWithType:type andContentid:appId];
            }
        }
    }
    
}
- (void)hide{
    [self performSelector:@selector(_hide) withObject:nil afterDelay:waitTime];
}
- (void)_hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}


//保存资源
- (void)saveTheFileWithDic:(NSDictionary *)realtimeshowDic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        imageURL =[realtimeshowDic objectForKey:@"imgurl"];//测试链接
        NSURL *url = [NSURL URLWithString:imageURL];
        
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:resultData];
        
        imageView.image = img;
        [plistDic setValue:realtimeshowDic forKey:deviceStr];
        [plistDic writeToFile:imagePlistPath atomically:YES];
        
        [[RealtimeShowAdvertisement getObject] writeFileData:resultData filePath:self.imageDataPath];
        
    });
}

//删除资源
- (void)deleteTheImage
{
    NSFileManager *tmpManger = [NSFileManager defaultManager];
    BOOL fileExist = [tmpManger isReadableFileAtPath:self.imageDataPath];
    
    if (fileExist) {
        
        NSError *error;
        if ([tmpManger removeItemAtPath:self.imageDataPath error:&error]) {
            NSLog(@"删除成功");
            
        }else
        {
            NSLog(@"删除失败");
        }
        
        if ([tmpManger removeItemAtPath:imagePlistPath error:&error]) {
            NSLog(@"删除plist成功");
        }else
        {
            NSLog(@"删除plist成功");
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
