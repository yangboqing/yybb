//
//  BlackCoverBackgroundView.m
//  browser
//
//  Created by caohechun on 14-5-26.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "BlackCoverBackgroundView.h"

@implementation BlackCoverBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.alpha = 0.0;
        alphaValue = 0.9;
        showDuration = SHOW_TIME/2;
        fadeDuration = HIDE_TIME/2;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        self.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fade_)];
        [self addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(fade_)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipe];
        
    }
    return self;
}

- (void)setAnimationShowDuration:(float)duration{
    showDuration = duration;
}
- (void)setAnimationFadeDuration:(float)duration{
    fadeDuration = duration;
}
- (void)setViewAlpha:(float)value{
    self.alpha = value;
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:showDuration animations:^{
        self.alpha = alphaValue;
    } completion:^(BOOL finished) {
        //
    }];
}
- (void)showWithoutAnimation{
    self.hidden = NO;
    self.alpha = alphaValue;
}

- (void)fade_{
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_CATEGORY object:nil];
    [self fade];
}
- (void)fade{
    [UIView animateWithDuration:fadeDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)fade_withoutAnimation{
    self.alpha = 0;
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
