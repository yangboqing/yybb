//
//  DownloadStatus.m
//  browser
//
//  Created by niu_o0 on 14-6-9.
//
//

#import "DownloadStatus.h"
#import "BppDistriPlistManager.h"
#import "IphoneAppDelegate.h"
#import <objc/runtime.h>
#import "CollectionViewCell.h"
#import "DlfromDefine.h"

@interface DownloadStatus () <UIAlertViewDelegate>

@end

@implementation DownloadStatus

+ (void)checkButton:(UIButton *)_button WithAppID:(NSString *)_appID Version:(NSString*)ver{
    
    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:_appID appVersion:ver];
    
    switch (status) {
        case STATE_DOWNLOAD:
            _button.enabled = YES;
            _button.tag = STATE_DOWNLOAD;
            [_button setImage:_StaticImage.download forState:UIControlStateNormal];
//            [_button setTitle:@"下载" forState:UIControlStateNormal];
//            [_button setTitleColor:hllColor(222, 53, 46, 1.0) forState:UIControlStateNormal];
            break;
        
        case STATE_DOWNLONGING:
            _button.enabled = YES;
            _button.tag = STATE_DOWNLONGING;
            [_button setImage:_StaticImage.downloading forState:UIControlStateNormal];
//            [_button setTitleColor:hllColor(244, 188, 184, 1.0) forState:UIControlStateNormal];
//            [_button setTitle:@"下载中" forState:UIControlStateNormal];
            break;
            
        case STATE_UPDATE:
            _button.enabled = YES;
            _button.tag = STATE_UPDATE;
            [_button setImage:_StaticImage.update forState:UIControlStateNormal];
//            [_button setTitleColor:hllColor(96, 202, 174, 1.0) forState:UIControlStateNormal];
//            [_button setTitle:@"更新" forState:UIControlStateNormal];
            break;
            
        case STATE_INSTALL:
            _button.enabled = YES;
            _button.tag = STATE_INSTALL;
            [_button setImage:_StaticImage.install forState:UIControlStateNormal];
//            [_button setTitleColor:hllColor(222, 53, 46, 1.0) forState:UIControlStateNormal];
//            [_button setTitle:@"安装" forState:UIControlStateNormal];
            break;
            
        case STATE_REINSTALL:
            _button.enabled = YES;
            _button.tag = STATE_REINSTALL;
            [_button setImage:_StaticImage.install_again forState:UIControlStateNormal];
//            [_button setTitleColor:hllColor(222, 53, 46, 1.0) forState:UIControlStateNormal];
//            [_button setTitle:@"重装" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

static const NSString * buttonInfoKey = @"buttonInfoKey";
static const NSString * clickButtonKey = @"ClickButtonInfoKey";

+ (void)checkButton:(UIButton *)_button WithAppInfo:(NSDictionary *)_dic{
    
    [DownloadStatus checkButton:_button
                      WithAppID:[_dic objectForKey:APPID]
                        Version:[_dic objectForKey:APPVERSION] ];
    
    
    [_button addTarget:[DownloadStatus class] action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(_button, (__bridge const void *)(buttonInfoKey), _dic, OBJC_ASSOCIATION_ASSIGN);
}

+ (void)downloadClick:(CollectionViewCellButton *)_button{

    NSDictionary * infoDic = objc_getAssociatedObject(_button, (__bridge const void *)(buttonInfoKey));
    NSMutableDictionary * _dic = [infoDic mutableCopy];
    
    [_dic setObject:[DownloadStatus dlfrom:_button.buttonIndexPath] forKey:DISTRI_APP_FROM];

    //NSLog(@"%@",[DownloadStatus dlfrom:_button.buttonIndexPath]);
//    if (_button.tag == STATE_REINSTALL || _button.tag == STATE_INSTALL) {
//        
//        _button.enabled = NO;
//        objc_setAssociatedObject(self, (__bridge const void *)(clickButtonKey), _button, OBJC_ASSOCIATION_ASSIGN);
//        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(disableButtonOneSecond) userInfo:nil repeats:NO];
//        NSString * distriPlist = [_dic objectForKey:@"plist"];
//        [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
//        
//        return ;
//    }
//    else if (_button.tag == STATE_DOWNLONGING)
//    { // 跳转到下载中（下载管理）
//        [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_DOWNLOADING object:[_dic objectForKey:@"plist"]];
//    }
    
    [browserAppDelegate addDistriPlistURL:[_dic objectForKey:@"plist"] appInfo:_dic];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

}

+ (NSString *)dlfrom:(NSIndexPath *)_indexPath{
    NSString * str = nil;
    switch (_indexPath.section) {
        case GAME:
            str = GOOD_GAME((long)_indexPath.row);
            break;
            
        case APP:
            str = GOOD_APP((long)_indexPath.row);
            break;
            
        case RECOMMEND:
            str = HOME_PAGE_RECOMMEND((long)_indexPath.row);
            break;
        case -1:
            str = HOME_PAGE_JINGXUAN;
            break;
            
        default:
            str = SPECIAL_APP(([NSString stringWithFormat:@"%ld",_indexPath.section-100]), (long)_indexPath.row);
            break;
    }
    return str;
}

+ (NSString *)changeValue:(NSString *)_value WithValueClass:(_Value)_class{
    
    BOOL value = _class > Value_MB;
    
    if ([_value integerValue] >=_class) return [NSString stringWithFormat:@"%.1f%@",[_value floatValue]/_class, !value ? @"G" : @"万"];
    
    if (!value) return [NSString stringWithFormat:@"%@M",_value];
    
    return _value;
}

//#pragma mark - 安装/重装按钮禁用1s
//
//+(void)disableButtonOneSecond
//{
//    UIButton *btn = objc_getAssociatedObject(self, (__bridge const void *)(clickButtonKey));
//    btn.enabled = YES;
//}

@end
