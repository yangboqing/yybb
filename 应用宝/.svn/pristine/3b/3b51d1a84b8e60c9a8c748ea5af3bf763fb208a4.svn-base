//
//  ResourceHomeToolBar.h
//  MyAssistant
//
//  Created by liguiyang on 14-11-18.
//  Copyright (c) 2014年 myAssistant. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DownloadedBadge.h"
@protocol ResourceHomeToolBarDelegate <NSObject>

-(void)homeBottomToolBarItemClick:(HomeToolBarItemType)barItemType;

@end

@interface ResourceHomeToolBar : UIToolbar
//{
//    DownloadedBadge *downloadedBadge;
//}
@property (nonatomic, weak) id <ResourceHomeToolBarDelegate>RHBardelegate;

@property (nonatomic, strong) UIButton *choiceButton; // 精选
@property (nonatomic, strong) UIButton *gameButton; // 游戏
@property (nonatomic, strong) UIButton *appButton; // 应用
@property (nonatomic, strong) UIButton *searchButton; // 搜索
@property (nonatomic, strong) UIButton *mineButton; // 我的

//@property (nonatomic, strong) UIButton *wallPaperButton; // 壁纸
//@property (nonatomic, strong) UIButton *discoveryButton; // 发现

-(void)bottomToolBarSelectItemType:(HomeToolBarItemType)itemType;

@end
