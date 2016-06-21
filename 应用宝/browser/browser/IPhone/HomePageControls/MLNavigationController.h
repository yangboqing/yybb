//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

//可用于导航pop时各页面的清空处理

@protocol NavDelegate<NSObject>
- (void)pop;
- (void)lockBottomTabbar;//在导航控制器切换时锁定底部类tabbar,防止异常
- (void)unlockBottomTabbar;//解锁底部类tabbar
@end

@interface MLNavigationController : UINavigationController// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL canDragBack;
@property (nonatomic,assign) id<NavDelegate>navDelegate;
@property (nonatomic,assign) BOOL isPopToRoot;

- (void)cancelRightPanGestureFunction;//禁用右滑返回
- (void)useRightPanGestureFuncion;//开启右滑返回

@end
