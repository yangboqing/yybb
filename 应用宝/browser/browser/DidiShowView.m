//
//  DidiShowView.m
//  browser
//
//  Created by 王毅 on 15/1/21.
//
//

#import "DidiShowView.h"

@implementation DidiShowView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = CLEAR_COLOR;
        
        bgImageView = [UIImageView new];
        bgImageView.image = [UIImage imageNamed:@"didipop-bg"];
        bgImageView.userInteractionEnabled = YES;
        
        textLabel = [UILabel new];
        textLabel.text = @"账号绑定成功,应用宝贝送你一张滴滴打车券,输入手机号码即可领取!";
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor = CLEAR_COLOR;
        textLabel.textColor = BLACK_COLOR;
        CGFloat textFont = 14.0f;
        if (MainScreen_Width > 320) {
            textFont = 17.0f;
        }
        textLabel.font = [UIFont systemFontOfSize:textFont];
        
        self.closedidiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closedidiBtn.backgroundColor = [UIColor clearColor];
        [self.closedidiBtn setBackgroundImage:[UIImage imageNamed:@"didiclose"] forState:UIControlStateNormal];
        
        self.godidiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.godidiBtn.backgroundColor = [UIColor clearColor];
        [self.godidiBtn setBackgroundImage:[UIImage imageNamed:@" didibtn-420"] forState:UIControlStateNormal];
        
        
        
        [self addSubview:bgImageView];
        [bgImageView addSubview:textLabel];
        [self addSubview:self.closedidiBtn];
        [bgImageView addSubview:self.godidiBtn];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    bgImageView.frame = CGRectMake(0, 12*IPHONE6_XISHU, 270*IPHONE6_XISHU, 230*IPHONE6_XISHU);
    self.closedidiBtn.frame = CGRectMake(self.frame.size.width - 24*IPHONE6_XISHU, 0, 24*IPHONE6_XISHU, 24*IPHONE6_XISHU);
    textLabel.frame = CGRectMake(15*IPHONE6_XISHU, 100*IPHONE6_XISHU, bgImageView.frame.size.width - 30*IPHONE6_XISHU, 50*IPHONE6_XISHU);
    self.godidiBtn.frame = CGRectMake((bgImageView.frame.size.width - 210*IPHONE6_XISHU)/2, bgImageView.frame.size.height - 25*IPHONE6_XISHU - 40*IPHONE6_XISHU, 210*IPHONE6_XISHU, 40*IPHONE6_XISHU);

}

@end
