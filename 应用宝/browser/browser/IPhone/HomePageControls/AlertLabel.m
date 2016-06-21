//
//  AlertLabel.m
//  browser
//
//  Created by liguiyang on 14-9-19.
//
//

#import "AlertLabel.h"

@implementation AlertLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = hllColor(44, 62, 80, 0.8);
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"数据请求失败，请检查网络后重试";
    }
    return self;
}

-(void)startAnimationFromOriginY:(CGFloat)originY
{
    static BOOL animationFlag = NO;
    
    if (!animationFlag) {
        animationFlag = YES;
        self.alpha = 1.0;
        self.frame = CGRectMake(0, originY-30, MainScreen_Width, 30);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, originY-30, MainScreen_Width, 30);
            self.frame = CGRectMake(0, originY, MainScreen_Width, 30);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alpha = 1.0;
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.alpha = 0.0;
                self.frame = CGRectMake(0, originY-30, MainScreen_Width, 30);
                
                animationFlag = NO;
            }];
        }];
    }
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
