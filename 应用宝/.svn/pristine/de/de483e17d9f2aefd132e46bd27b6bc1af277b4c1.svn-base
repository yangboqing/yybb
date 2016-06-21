//
//  MumView.h
//  Huanxinhuanxin
//
//  Created by 王毅 on 14/12/14.
//  Copyright (c) 2014年 王毅. All rights reserved.
//
//绑定APPID的登录的加载中、失败的界面

#import <UIKit/UIKit.h>
#import "DidiShowView.h"
#import "LoginServerManage.h"
#import "AppStoreNewDownload.h"
@protocol MumDelegate <NSObject>

- (void)hideMumView;

@end

@interface MumView : UIView{

    UIImageView *loadingBgImageView;
    UILabel *loadingLabel;
    UIImageView *bizhiSettingBaseView;
    UIImageView *bizhiSettingTurnView;
    
    UIImageView *endBgImageView;
    UILabel *endLabel;
    DidiShowView *didiShowView;
    UIImageView *didiBgImageView;
    
}
@property (nonatomic , assign) id<MumDelegate>delegate;
// 0：进行中  1：成功 2：失败
- (void)isShowState:(int)state;
@end
