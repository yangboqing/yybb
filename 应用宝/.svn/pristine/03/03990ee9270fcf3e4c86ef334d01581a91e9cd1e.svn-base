//
//  LoginCancellationView.m
//  browser
//
//  Created by 王毅 on 15/1/13.
//
//


#define BUTTON_HEIGHT 44
#define BUTTON_SIDE 7

#import "LoginCancellationView.h"

@implementation LoginCancellationView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = hllColor(0, 0, 0, 0.5);
        self.userInteractionEnabled = YES;
        
        self.cancellationBtn = [self creatButton:@"确定"color:[UIColor redColor]];
        
        self.cannelBtn = [self creatButton:@"取消" color:[UIColor blueColor]];
        
        [self addSubview:self.cancellationBtn];
        [self addSubview:self.cannelBtn];
        
    }
    return self;
}

- (void)layoutSubviews{
    self.cannelBtn.frame = CGRectMake(BUTTON_SIDE, self.frame.size.height - BUTTON_SIDE - BUTTON_HEIGHT, self.frame.size.width - BUTTON_SIDE*2, BUTTON_HEIGHT);
    self.cancellationBtn.frame = CGRectMake(BUTTON_SIDE, self.cannelBtn.frame.origin.y - BUTTON_SIDE - BUTTON_HEIGHT , self.cannelBtn.frame.size.width, BUTTON_HEIGHT);
}

- (UIButton *)creatButton:(NSString*)text color:(UIColor*)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = WHITE_COLOR;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    
    return btn;
}


@end
