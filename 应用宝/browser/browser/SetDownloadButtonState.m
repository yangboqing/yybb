//
//  SetDownloadButtonState.m
//  browser
//
//  Created by caohechun on 14-4-22.
//
//

#import "SetDownloadButtonState.h"
#import "BppDistriPlistManager.h"
#import "FileUtil.h"
#import "IphoneAppDelegate.h"
#import "NSDictionary+noNIL.h"
#import "AppStatusManage.h"
#import <objc/runtime.h>
#import "MyServerRequestManager.h"


@interface SetDownloadButtonState () <BppDistriPlistManagerDelegate, UIAlertViewDelegate>{
    NSString *plistURL;
    UIButton *targetButton_;
    NSDictionary *appInforDic;
    NSString *detailSoure;
    
    dispatch_source_t timer;
}
@end

@implementation SetDownloadButtonState
- (void)dealloc{
    [[BppDistriPlistManager  getManager] removeListener:self];
}

+(id)getObject{
    @synchronized(@"SetDownloadButtonState"){
        static SetDownloadButtonState * manager = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[SetDownloadButtonState alloc] init];
        });
        return manager;        
    }
}


- (id)init{
    self  = [super init];
    if (self) {
        [[BppDistriPlistManager  getManager] addListener:self];
    }
    return self;
}

#pragma mark -  下载代理方法
//添加了一个下载条目
- (void) onDidPlistMgrAddDownloadItem:(NSString*)distriPlist {
    //去掉参数
    distriPlist = [[FileUtil instance] distriPlistURLNoArg:distriPlist];
    if ( [distriPlist isEqualToString:plistURL] ) {
        [self updateStatus];
    }
}
//IPA下载完毕
- (void) onDidPlistMgrDownloadIPAComplete:(NSString*)distriPlist index:(NSUInteger)index {
    //去掉参数
    distriPlist = [[FileUtil instance] distriPlistURLNoArg:distriPlist];
    if ( [distriPlist isEqualToString:plistURL] ) {
        [self updateStatus];
    }
}


- (void)setDownloadButton:(UIButton *)targetButton withAppInforDic:(NSDictionary *)appInforDic_ andDetailSoure:(NSString *)detailSource_ andUserData:(id)userData{
    appInforDic = appInforDic_;
    detailSoure = detailSource_;
    plistURL = [appInforDic_ objectForKey:@"plist"];
    targetButton_ = targetButton;
    
    
    
    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:[appInforDic objectForKey:@"appid"]
                                appVersion:[appInforDic objectForKey:@"appversion"]];
    
//    UIImage *image = nil;
//    NSString *imgName = nil;
    
    //设置状态图
//    if (status == STATE_DOWNLOAD ) {
//        imgName = @"免费";// free_.png
//    }else if (status == STATE_INSTALL){
//        imgName = @"安装";//  install_.png
//    }else if (status == STATE_REINSTALL){
//        imgName = @"安装";//  install_.png
//    }else if (status == STATE_DOWNLONGING){
//        imgName = @"下载中";// downLoading_.png
//    }else if (status == STATE_UPDATE){
//        imgName = @"更新";//  state_update.png
//    }

//    [targetButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//    [targetButton setTitle:imgName forState:UIControlStateNormal];

    //设置响应方法
    
    //移除可能已存在的方法
    [targetButton_ removeTarget:self action:nil  forControlEvents:UIControlEventTouchUpInside];
    
    
    if (status == STATE_DOWNLOAD) {
        targetButton_.enabled  = YES;
        [targetButton_ addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (status == STATE_DOWNLONGING){
        targetButton_.enabled  = YES;
        [targetButton_ addTarget:self action:@selector(downloadingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == STATE_INSTALL){
        targetButton_.enabled  = YES;
        [targetButton_ addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == STATE_REINSTALL){
        targetButton_.enabled  = YES;
        [targetButton_ addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if (status == STATE_UPDATE){
            targetButton_.enabled = YES;
            [targetButton_ addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }else{
//            targetButton_.enabled = NO;
        }
    }
}
//下载
- (void)beginDownload{

    if (!detailSoure) {
        detailSoure = @"";
    }
    
    NSMutableDictionary *tmpDic  = [[NSMutableDictionary alloc ]init];
    
    //增加点击下载应用的appid和appdigitalid的对应关系
    NSString *appdigitalid = [appInforDic objectForKey:@"appdigitalid"];
    if (appdigitalid) {
        [[NSUserDefaults standardUserDefaults] setObject:appdigitalid forKey:[appInforDic objectForKey:@"appid"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"appid"] forKey:@"appid"];
    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"displayversion"] forKey:@"appversion"];
    [tmpDic setObjectNoNIL:[appInforDic objectNoNILForKey:@"appminosver"] forKey:@"appminosver"];
    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"appicon"] forKey:@"appiconurl"];
    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"appname"] forKey:@"appname"];
    [tmpDic setObjectNoNIL:detailSoure forKey:@"dlfrom"];
    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"appprice"] forKey:@"appprice"];
    [tmpDic setObjectNoNIL:[appInforDic objectForKey:@"appdigitalid"] forKey:@"distriAppID"];
    
    [[MyServerRequestManager getManager] downloadCountToAPPID:appdigitalid version:[tmpDic objectForKey:@"appversion"]];

    
    if ([detailSoure hasPrefix:@"kyclient_unicomfreeflow_"]) {
        [browserAppDelegate add3GFreeFlowDistriPlistURL:plistURL appInfo:tmpDic];
    }
    else
    {
        [browserAppDelegate addDistriPlistURL:plistURL appInfo:tmpDic];
    }

}
- (void)updateStatus{
    [self setDownloadButton:targetButton_
            withAppInforDic:appInforDic
             andDetailSoure:detailSoure
                andUserData:nil];
}
//安装
- (void)beginInstall:(id)sender{
    
    targetButton_.enabled = NO;
    
    NSString * distriPlist = plistURL;
    [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
    [self disableInstallButtonOneSecond:sender];
}

-(void)disableInstallButtonOneSecond:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), 0, 0);
    dispatch_source_set_event_handler(timer, ^{
        btn.enabled = YES;
        //刷新状态
        [self setDownloadButton:targetButton_ withAppInforDic:appInforDic andDetailSoure:detailSoure andUserData:nil];
        dispatch_source_cancel(timer);
    });
    
    dispatch_resume(timer);
}

-(void)downloadingBtnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_DOWNLOADING object:plistURL];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

@end