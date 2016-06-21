//
//  RotatingLoadView.m
//  HotWordSearch
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "RotatingLoadView.h"

@implementation RotatingLoadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set backgoundImage
//        UIImage *img = [UIImage imageNamed:@"loadingbg.png"];
//        self.image = img;
        SET_IMAGE(self.image, @"loadingbg.png");
        
        // rotation
//        img = [UIImage imageNamed:@"loadingArc.png"];
        rotateView = [[RotateView alloc] init];
        SET_IMAGE(rotateView.image, @"loadingArc.png");
        [self addSubview:rotateView];
        
        // set frame
        [self setRotatingLoadFrame];
    }
    return self;
}

#pragma mark - Utility
-(void)startRotationAnimation
{
    [rotateView startRotation];
}

-(void)stopRotationAnimation
{
    [rotateView stopRotation];
}

-(void) setRotatingLoadFrame
{// 根据图片固定加载loading大小
//    self.frame = CGRectMake(0, 0, 50, 50);
    self.frame = CGRectMake(0, 0, 35, 35);
    rotateView.frame = self.frame;
}

- (void)setRotatingLoadFrame:(CGRect)frame
{
    self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    rotateView.frame = self.frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
