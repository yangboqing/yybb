//
//  MyUpdateSelfManager.m
//  MyHelper
//
//  Created by liguiyang on 14-12-27.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "MyUpdateSelfManager.h"
#import "FileUtil.h"

static MyUpdateSelfManager *updateSelfManager = nil;

@implementation MyUpdateSelfManager

+ (MyUpdateSelfManager *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateSelfManager = [[MyUpdateSelfManager alloc] init];
    });
    
    return updateSelfManager;
}

- (void)detectVersionOfMyHelper:(NSString *)userData
{
    NSString *path = @"/update/selfUpdate";
    NSString *osVer = [UIDevice currentDevice].systemVersion;
    NSString *clientVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *parameters = [NSString stringWithFormat:@"osVer=%@&appVer=%@",osVer,clientVer];
    
    NSString *updateStr = [NSString stringWithFormat:@"%@%@?cry=%@",HEAD_REQSTR,path,[self getDESString:parameters]];
    NSURL *reqUrl = [NSURL URLWithString:updateStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqUrl];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSError *error = nil;
        NSString *responseStr = [requestSelf responseString];
        NSDictionary *map = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        
        if (map && error==nil && IS_NSDICTIONARY(map) && IS_NSDICTIONARY([map objectForKey:@"data"]) && IS_NSDICTIONARY([map objectForKey:@"flag"])) {
            [self update:map userData:userData];
        }
        else
        {
            // 数据有误
            if (_delegate && [_delegate respondsToSelector:@selector(hasNoVersionUpdate:userData:)]) {
                [self.delegate hasNoVersionUpdate:@"更新失败" userData:userData];
            }
        }
    }];
    
    [request setFailedBlock:^{
        // 请求失败
        if (_delegate && [_delegate respondsToSelector:@selector(hasNoVersionUpdate:userData:)]) {
            [self.delegate hasNoVersionUpdate:@"更新失败" userData:userData];
        }
    }];
}

- (void)update:(NSDictionary *)dataDic userData:(NSString *)userData
{
    /*
     * appversion: 实际版本
     * forcedupgrade:是否强升
     * selfupdatetype:自更新方式 ota/ota 升级,appStore/苹果商店升级,
     * appdigitalid: 数字ID
     * plist: plist地址
     * upgradeinfo: 升级提示信息
     */
    
    // 校验数据
    if ([[MyVerifyDataValid instance] verifySelfUpdateInfoData:dataDic]) {
        // 数据有效
        NSDictionary *updateDic = [dataDic objectForKey:@"data"];
        if ([self hasNewVersion:updateDic]) {
            // 有高版本
            if (_delegate && [_delegate respondsToSelector:@selector(hasNewVersion:userData:)]) {
                [self.delegate hasNewVersion:updateDic userData:userData];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(hasNoVersionUpdate:userData:)]) {
                [self.delegate hasNoVersionUpdate:@"当前已是最新版本" userData:userData];
            }
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(hasNoVersionUpdate:userData:)]) {
            [self.delegate hasNoVersionUpdate:@"更新失败" userData:userData];
        }
    }
}

- (BOOL)hasNewVersion:(NSDictionary *)updateDic
{
    BOOL hasNewVersionFlag = NO;
    
    NSString *serverVer = [[updateDic objectForKey:@"appinfo"]objectForKey:@"appversion"];
    NSString *localVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    // 本地版本低
    if (NSOrderedAscending==[localVer compare:serverVer]) {
        hasNewVersionFlag = YES;
    }
    
    return hasNewVersionFlag;
}

- (NSString *)getDESString:(NSString *)string{
    return [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:string key:@"i2.0908o"]];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}


@end
