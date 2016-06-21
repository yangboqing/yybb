//
//  HorizontalSlidingCell.m
//  Mymenu
//
//  Created by mingzhi on 14/11/22.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import "HorizontalSlidingCell.h"

@implementation HorizontalSlidingCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _horizontalSlidingView = [[HorizontalSlidingView alloc] initWithFrame:frame];
        _horizontalSlidingView.delegate = self;
        [self.contentView addSubview:_horizontalSlidingView];
        
        _bottomlineView = [UIImageView new];
        _bottomlineView.backgroundColor = BottomColor;
        [self.contentView addSubview:_bottomlineView];
        
    }
    return self;
}
- (void)setColor:(UIImage *)img andName:(NSString *)name
{
    [_horizontalSlidingView setColor:img andName:name];
}

#pragma mark - 设置数据
- (void)setDataArray:(NSArray *)dataArray
{
    //数据检测
    if (!IS_NSARRAY(dataArray) || ![dataArray count])  return;
    [_horizontalSlidingView setDataArr:dataArray];
}
- (void)setType:(MenuType)type
{
    _type = type;
    _horizontalSlidingView.mytype = type;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
     _horizontalSlidingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _bottomlineView.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
}

#pragma mark - setapBlock
- (void)setapBlock:(ClickBlock)block{
    
    _clickBlock = block;
}
- (void)clickViewApp:(NSString *)appid path:(NSIndexPath *)indexpath{
    
    if (_clickBlock) {
        _clickBlock(appid ,indexpath);
    }
}
#pragma mark - HorizontalSlidingDelegate
- (void)tapHorizontalApp:(NSString *)appid path:(NSIndexPath *)indexPath
{
    [self clickViewApp:appid path:indexPath];
}
- (void)theAllBtnClick:(id)sender
{
    [self clickViewApp:@"点击全部按钮" path:nil];
}

@end
