//
//  LoginWindowView.m
//  browser
//
//  Created by 王毅 on 15/1/6.
//
//

#import "LoginWindowView.h"

@implementation LoginWindowView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = hllColor(0, 0, 0, 0.5);
        self.userInteractionEnabled = YES;
        
        
        showView = [[UIImageView alloc] init];
        showView.image = [UIImage imageNamed:@"firstclickinstall"];
        [self addSubview:showView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenself)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)layoutSubviews{
    showView.frame = CGRectMake((self.frame.size.width - 275*IPHONE6_XISHU)/2, (self.frame.size.height - 350*IPHONE6_XISHU), 275*IPHONE6_XISHU, 350*IPHONE6_XISHU);
}

-(void)hiddenself{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenself)]) {
        [self.delegate hiddenself];
    }
}
@end
