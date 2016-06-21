//
//  SettingPlistConfig.m
//  browser
//
//  Created by 王 毅 on 13-4-9.
//
//

#import "SettingPlistConfig.h"
#import "FileUtil.h"


@interface SettingPlistConfig ()

//创建plist文件
- (void)creatIphonePlistFile;
//获取plist的字典
- (NSMutableDictionary *)getPlistDictionary;
@end

@implementation SettingPlistConfig

+ (SettingPlistConfig *)getObject{
    
    @synchronized(@"SettingPlistConfig"){
        static SettingPlistConfig *object = nil;
        if (object == nil){
            object = [[SettingPlistConfig alloc] init];
            
            //将下载数量和下载优先级设置为默认
            [object changePlistObject:@"3" key:DOWNLOADCOUNT];
            [object changePlistObject:@"2" key:AUDIO_HOLD_STRENGTH];
        }
        

        return object;
        
    }
}

- (BOOL)checkIphonePlistFile{
    NSString *path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:SETTING_FILE_NAME];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
    if(!isExist){
        [self creatIphonePlistFile];
        return NO;
    }
    
    return YES;
}

- (void)creatIphonePlistFile{
    
    NSString *filename = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:SETTING_FILE_NAME];

    NSMutableDictionary *iphoneSetDic = [NSMutableDictionary dictionary];

    [iphoneSetDic setObject:SWITCH_YES forKey:DOWNLOAD_TO_LOCAL];
    
    [iphoneSetDic setObject:SWITCH_YES forKey:QUICK_INSTALL];
    [iphoneSetDic setObject:@"2" forKey:AUDIO_HOLD_STRENGTH];
    [iphoneSetDic setObject:@"3"   forKey:DOWNLOADCOUNT];
    
    
     [iphoneSetDic setObject:SWITCH_YES forKey:DOWN_ONLY_ON_WIFI];
    
    
    [iphoneSetDic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:CAN_UPDATA_VERSION];
    
    [iphoneSetDic setObject:SWITCH_YES forKey:DELETE_PACK_AFTER_INSTALLING];
    
    [iphoneSetDic writeToFile:filename atomically:YES];

    
}

- (BOOL)changePlistObject:(NSString *)objectName key:(NSString *)keyName{
    
    if(objectName.length <= 0 || keyName.length <= 0)
        return NO;
    
    if ([self checkIphonePlistFile] == YES) {
        NSString* path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:SETTING_FILE_NAME];

        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [dic setObject:objectName forKey:keyName];
        [dic writeToFile:path atomically:YES];
        
        return YES;
    }
    return NO;
}

- (NSMutableDictionary *)getPlistDictionary{

    NSString* path = [[[FileUtil instance] getDocumentsPath] stringByAppendingPathComponent:SETTING_FILE_NAME];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

- (BOOL)getPlistObject:(NSString *)keyName{
    
    NSMutableDictionary* dic = [self getPlistDictionary];
    if ([[dic objectForKey:keyName] isEqualToString:SWITCH_YES]) {
        return YES;
    }else{
        return NO;
    }
    
}

- (int)getPlistObject_holdStrength_downCount:(NSString *)keyName{
    NSMutableDictionary* dic = [self getPlistDictionary];
    
    if ([[dic objectForKey:keyName] isEqualToString:@"1"]) {
        return 1;
    }else if ([[dic objectForKey:keyName] isEqualToString:@"2"]){
        return 2;
    }else{
        return 3;
    }
}



@end
