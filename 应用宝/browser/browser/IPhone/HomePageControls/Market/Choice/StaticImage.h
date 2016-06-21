//
//  StaticImage.h
//  browser
//
//  Created by niu_o0 on 14-6-4.
//
//

#import <Foundation/Foundation.h>


#define APPINTRO        @"appintro"
#define LUNBO_INTRO     @"lunbo_intro"
#define LUNBO_TYPE      @"lunbo_type"
#define SHARE_URL       @"share_url"
#define PIC_URL         @"pic_url"

#define APPNAME         @"appname"
#define APPID           @"appid"
#define APPICON         @"appiconurl"
#define APPDOWNCOUNT    @"appdowncount"
#define APPREPUTATION   @"appreputation"
#define APPUPDATETIME   @"appupdatetime"
#define APPCATEGROY     @"category"
#define APPSIZE         @"appsize"
#define APPVERSION      @"appversion"
#define APP_IPADETAILINFOR @"ipadetailinfor"
#define APP_PLIST       @"plist"

//专题
#define SPECIALID       @"special_auto_id"
#define SPECIALNAME     @"special_name"
#define SPECIALCONTENT  @"special_intro"
#define SPECIAL_PIC_URL @"special_pic_url"

#define PIC_URL         @"pic_url"
#define DATE            @"date"
#define TITLE           @"title"
#define VIEW_COUNT      @"view_count"
#define CONTENT         @"content"
#define CONTENT_URL_OPEN_TYPE @"content_url_open_type"
#define HUODONG_TYPE    @"huodong_type"
#define HUODONG_ID              @"id"
#define Shar_word       @"share_word"


#define _StaticImage        [StaticImage defaults]

#define lunboHeight     130*PHONE_SCALE_PARAMETER//(210*(MainScreen_Width/320))




#define addNavgationBarBackButton(_target, sel)   \
            [self.navigationItem setHidesBackButton:YES animated:YES];    \
            self.navigationItem.leftBarButtonItem= [StaticImage navBarTarget:_target action:@selector(sel)];



#define _baoguang(tableView, index)     \
        __block CollectionViewCell * cell = nil;    \
        NSMutableArray * array = [NSMutableArray new];  \
                                                            \
        [tableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { \
        cell = (CollectionViewCell *)obj;   \
        if (!cell.baoguang) return ;  \
        NSIndexPath * indexPath = cell.indexPath;   \
        if (indexPath.row > 50) return ;  \
        [array addObject:cell.baoguang];    \
                                            \
        }]; \
        [[ReportManage instance] ReportAppBaoGuang:[DownloadStatus dlfrom:index] appids:array];\
        //NSLog(@"%@",[DownloadStatus dlfrom:index]);




#define GETSTRING(s) ![__dic getNSStringObjectForKey:s]

typedef  enum {
    GAME = 0,
    APP,
    TOPIC,
    RECOMMEND,
    FREE_APP,
    FREE_GAME,
    ACTIVITY,
    GIFT,
    NECESSARY
}_CHOICE;
//@[@"优秀游戏",@"优秀应用", @"专题", @"精彩推荐", @"免费应用",@"免费游戏",@"活动",@"礼包",@"必备"];

@interface StaticImage : NSObject

@property (nonatomic, strong) UIImage * jiantou;

@property (nonatomic, strong) UIImage * zan;
@property (nonatomic, strong) UIImage * down;
@property (nonatomic, strong) UIImage * acti;
@property (nonatomic, strong) UIImage * icon_60x60;
@property (nonatomic, strong) UIImage * icon_topic;
@property (nonatomic, strong) UIImage * icon_acti;

@property (nonatomic, strong) UIImage * download;
@property (nonatomic, strong) UIImage * downloading;
@property (nonatomic, strong) UIImage * update;
@property (nonatomic, strong) UIImage * install;
@property (nonatomic, strong) UIImage * installed;
@property (nonatomic, strong) UIImage * install_again;
@property (nonatomic, strong) UIImage * backnav;

@property (nonatomic, strong) UIImage * lunbo;

+ (instancetype) defaults;

- (NSArray *)titleArray;

- (UIImage *)collectionViewItemImage:(_CHOICE)_choice;

+ (UIBarButtonItem *)navBarTarget:(id)_target action:(SEL)_select;

- (BOOL)checkAppList:(NSDictionary *)dic;
- (BOOL) checkFlag:(NSDictionary *)dic;
- (BOOL)check:(NSArray *)array;

- (BOOL)checkSpecial:(NSDictionary *)dic;

- (BOOL)checkActivity:(NSDictionary *)dic;

@end
