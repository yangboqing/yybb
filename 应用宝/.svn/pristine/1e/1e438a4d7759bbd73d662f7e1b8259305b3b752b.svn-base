//
//  CarouselView.h
//  MyHelper
//
//  Created by liguiyang on 15-1-8.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarouselViewDelegate <NSObject>

- (void)carouselViewClick:(NSInteger)index;
- (void)carouselViewScroll:(NSInteger)index;

@end

@interface CarouselView : UIView

@property (nonatomic, weak) id <CarouselViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setCarous_dataSource:(NSArray *)array;
- (void)setCarousViewFrame:(CGRect)frame;
- (void)setCarousTimerStop:(BOOL)stopFlag; // YES:停止滚动；NO:开始滚动（计时器）
- (void)setCarousTrackHide:(BOOL)hideFlag; // YES:隐藏底部标识；NO:显示底部标识

@end
