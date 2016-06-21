//
//  LoginLabelView.m
//  browser
//
//  Created by 王毅 on 15/1/12.
//
//

#import "LoginLabelView.h"

@implementation LoginLabelView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        headImageView = [UIImageView new];
        headImageView.backgroundColor = CLEAR_COLOR;
        headImageView.image = [UIImage imageNamed:@"icon-circle"];
        
        
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.text = @"";
        titleLabel.textColor = hllColor(160, 160, 160, 1);
        titleLabel.backgroundColor = CLEAR_COLOR;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:headImageView];
        [self addSubview:titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    headImageView.frame = CGRectMake(0, (self.frame.size.height - 7*IPHONE6_XISHU)/2, 7*IPHONE6_XISHU, 7*IPHONE6_XISHU);
    titleLabel.frame = CGRectMake(headImageView.frame.size.width, 0, self.frame.size.width - headImageView.frame.size.width, self.frame.size.height);
    
}
- (void)setTitleLabelText:(NSString*)text{
    
    titleLabel.text = text;
    
}
@end
