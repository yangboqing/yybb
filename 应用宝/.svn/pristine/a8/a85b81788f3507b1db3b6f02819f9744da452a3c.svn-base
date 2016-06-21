//
//  StaticImage.m
//  browser
//
//  Created by niu_o0 on 14-6-4.
//
//   定义 全局图片  防止重复从本地加载图片 浪费资源


#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "StaticImage.h"

static StaticImage * _staticImage = nil;

#define LOAD(a)     LOADIMAGE(a, @"png")

#define IMAGE(a,b)       if (!a)             \
                            a = LOAD(b);   \
                         return a;             \

@implementation StaticImage


+ (instancetype)defaults{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticImage = [StaticImage new];
    });
    return _staticImage;
}

- (NSArray *)titleArray{
    return @[@"优秀游戏",@"优秀应用", @"专题", @"精彩推荐", @"免费应用",@"免费游戏",@"活动",@"礼包",@"必备"];
}

- (UIImage *)jiantou{
    IMAGE(_jiantou, @"箭头")
}

- (UIImage *)zan{
    IMAGE(_zan, @"zan")
}

- (UIImage *)down{
    IMAGE(_down, @"totle_down")
}

- (UIImage *)acti{
    IMAGE(_acti, @"acti")
}

- (UIImage *)icon_60x60{
    IMAGE(_icon_60x60, @"icon60x60");
}

- (UIImage *)icon_acti{
    IMAGE(_icon_acti, @"icon_acti")
}

- (UIImage *)icon_topic{
    IMAGE(_icon_topic, @"icon_topic")
}

- (UIImage *)download{
    IMAGE(_download, @"state_download")
}

- (UIImage *)downloading{
    IMAGE(_downloading, @"state_downloading")
}

- (UIImage *)install{
    IMAGE(_install, @"state_install")
}

- (UIImage *)installed{
    IMAGE(_installed, @"state_installed")
}

- (UIImage *)install_again{
    IMAGE(_install_again, @"state_reinstall")
}

- (UIImage *)update{
    IMAGE(_update, @"state_update")
}

- (UIImage *)lunbo{
    IMAGE(_lunbo, @"lunbo");
}

- (UIImage *)backnav{
    IMAGE(_backnav, @"nav_back")
}

- (UIImage *)collectionViewItemImage:(_CHOICE)_choice{
    UIImage * image = nil;
    switch (_choice) {
        case TOPIC:
            image = _StaticImage.icon_topic;
            break;
        case ACTIVITY:
            image = _StaticImage.icon_acti;
            break;
        default:
            image = _StaticImage.icon_60x60;
            break;
    }
    return image;
}

+ (UIBarButtonItem *)navBarTarget:(id)_target action:(SEL)_select{

    UIImage * image = _StaticImage.backnav;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:_target action:_select forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return backButton;
}






#pragma mark -  数据 类型 检查




- (BOOL)check:(NSArray *)array{
    __block BOOL isFail = NO;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSDictionary class]]){
            isFail = YES;
            *stop = YES;
        }
        NSDictionary * __dic = (NSDictionary *)obj;
        if (GETSTRING(APPDOWNCOUNT) || GETSTRING(APPICON) || GETSTRING(APPID) || GETSTRING(APPINTRO) || GETSTRING(APPNAME) || GETSTRING(APPREPUTATION) || GETSTRING(APPSIZE) || GETSTRING(APPUPDATETIME) || GETSTRING(APPVERSION) || GETSTRING(APPCATEGROY) || GETSTRING(APP_IPADETAILINFOR) || GETSTRING(APP_PLIST) || GETSTRING(SHARE_URL)) {
            isFail = YES;
            *stop = YES;
        }
    }];
    if (isFail) return NO;
    return YES;
}

- (BOOL) checkFlag:(NSDictionary *)dic{
    if ([dic getNSStringObjectForKey:@"dataend"] && [dic getNSNumberObjectForKey:@"expire"] && [dic getNSStringObjectForKey:@"md5"]) return YES;
    return NO;
}

- (BOOL)checkAppList:(NSDictionary *)dic{
    
    NSArray * array = [dic getNSArrayObjectForKey:@"data"];
    if (!array) return NO;
    NSDictionary * _dic = [dic getNSDictionaryObjectForKey:@"flag"];
    if (!_dic) return NO;
    
    return [self check:array] && [self checkFlag:_dic];
}

- (BOOL)checkSpecial:(NSDictionary *)dic{
    
    NSArray * array = [dic getNSArrayObjectForKey:@"data"];
    if (!array) return NO;
    __block BOOL isFail = NO;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSDictionary class]]){
            isFail = YES;
            *stop = YES;
        }
        NSDictionary * __dic = (NSDictionary *)obj;
        if (!IS_NSDICTIONARY(__dic)) {
            *stop = YES; // 数据类型不对
        }
        if ([[__dic getNSStringObjectForKey:SPECIALID] isEqualToString:@"mianliu"]){
            return ;
        }
        
        if (GETSTRING(SPECIALID) || GETSTRING(SPECIALCONTENT) || GETSTRING(SPECIAL_PIC_URL) || GETSTRING(SPECIALNAME)) {
            isFail = YES;
            *stop = YES;
        }
        
    }];
    
    if (isFail) return NO;
    
    return YES;
}

- (BOOL)checkActivity:(NSDictionary *)dic{
    NSArray * array = [dic getNSArrayObjectForKey:@"data"];
    if (!array) return NO;
    __block BOOL isFail = NO;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSDictionary class]]){
            isFail = YES;
            *stop = YES;
        }
        
        NSDictionary * __dic = (NSDictionary *)obj;
        
        if (GETSTRING(CONTENT) || GETSTRING(CONTENT_URL_OPEN_TYPE) || GETSTRING(DATE) || GETSTRING(HUODONG_TYPE) || GETSTRING(HUODONG_ID) || GETSTRING(PIC_URL) || GETSTRING(Shar_word) || GETSTRING(TITLE) || GETSTRING(VIEW_COUNT)){
            isFail = YES;
            *stop = YES;
        }
    }];
    
    if (isFail) return NO;
    return YES;
}

@end
