//
//  RotationView.h
//  33
//
//  Created by niu_o0 on 14-4-28.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//
//轮播图
#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger index);

typedef void(^BaoguangBlock)(NSInteger index);

@interface RotationView : UIView <UIScrollViewDelegate>{
    ClickBlock _clickBlock;
}

@property (nonatomic, assign) CGFloat offsetY; //
@property (nonatomic, copy) BaoguangBlock baoguangBlock;

- (id)initWithFrame:(CGRect)frame andScrollTimer:(NSUInteger)timer;

- (void)setLunbo_data:(NSArray *)_array;

- (void)setClickWithBlock:(ClickBlock)block;

@end
