//
//  ResourceHomeBottom.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "SettingPlistConfig.h"

#define CLICK_HOME_BUTTON 10
#define CLICK_SEARCH_BUTTON 11
#define CLICK_UPDATA_BUTTON 12
#define CLICK_DOWNLOAD_BUTTON 13
#define CLICK_MORE_BUTTON 14

@protocol ResourceHomeBottomDelegate <NSObject>

- (void)openDownloadPage;
- (void)openUpdataPage;
@end

@interface ResourceHomeBottom : UIToolbar{
    // 更新图标（导航）
    UIImage *badgeImg;
    UIImage *badgeImg2;
    UILabel *badgeLabel;
    UIImageView *badgeImgView;
}

@property (nonatomic , retain) UIButton *homeBtn;//首页
@property (nonatomic , retain) UIButton *shareBtn;//搜索页面
@property (nonatomic , retain) UIButton *downMangerBtn;//下载管理
@property (nonatomic , retain) UIButton *updataBtn;//更新按钮
@property (nonatomic , retain) UIButton *moreBtn;//设置按钮
@property (nonatomic , weak) id<ResourceHomeBottomDelegate>delegate_;
@property (nonatomic, assign) int flag;
- (void) setHomeBottomSelectButton:(int)flag;
@end
