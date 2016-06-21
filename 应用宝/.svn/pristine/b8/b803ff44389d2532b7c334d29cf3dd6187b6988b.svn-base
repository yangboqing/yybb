//
//  HotWordHomeViewController.h
//  HotWordSearch
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol SearchHotWordHomeViewDelegate <NSObject>

-(void)hotWordHasBeenSelected:(NSString *)hotWord;

@end

@interface SearchHotWordHomeViewController : UIViewController

@property (nonatomic, weak) id <SearchHotWordHomeViewDelegate>delegate;
@property (nonatomic, assign) BOOL isHotWordHomeViewHidden; // 热词页是否显示

// 控制显示加载动画
@property (nonatomic, assign) BOOL isShaking; // 是否在震动
@property (nonatomic, assign) BOOL isHotWordDataReturn; // 搜索热词是否已经返回数据
@property (nonatomic, assign) BOOL isShakedForReturn; // 是否在代理方法中为设置数据震动

-(id)initWithHotWords:(NSArray *)hotWords;

// 重新从服务器 请求热词数据(摇一摇)
-(void)initilizationRequestHotWord;
-(void)reloadHotWordRequest;

-(void)showHomeView;
-(void)showLoadingView;
-(void)showFailedView;
@end
