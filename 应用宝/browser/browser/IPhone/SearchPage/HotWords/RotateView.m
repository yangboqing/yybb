//
//  RotatingLoadView.m
//  KYSearchForWords
//
//  Created by liguiyang on 14-3-31.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "RotateView.h"

@implementation RotateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImage *img = [UIImage imageNamed:@"loadingArc.png"];
//        self.image = img;
        SET_IMAGE(self.image, @"loadingArc.png");
    }
    return self;
}
-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.image = image;
    }
    return self;
}
#pragma mark - Utility
-(void)startRotation
{
    CABasicAnimation *rotatingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotatingAnimation.toValue = [NSNumber numberWithFloat:(2*M_PI)*2];
    rotatingAnimation.duration = 1.50f;
    rotatingAnimation.repeatCount = MAXFLOAT;
    rotatingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotatingAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:rotatingAnimation forKey:@"rotateAnimation"];
}

-(void)stopRotation
{
    [self.layer removeAnimationForKey:@"rotateAnimation"];
}

//// 将图片周边1px的透明来消除图片旋转时的锯齿(在此类中并未实现，留作以后使用)
//-(UIImage *)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale
//{
//    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
//    [centerImageView.image drawInRect:CGRectMake(1, 1, size.width-2, size.height-2)];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
