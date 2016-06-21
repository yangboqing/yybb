//
//  NavBarTitleView.m
//  browser
//
//  Created by mingzhi on 14-6-25.
//
//

#import "NavBarTitleView.h"

@implementation NavBarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = [UIColor colorWithRed:231.0/255 green:73.0/255 blue:51.0/255 alpha:1];
        
        self.titleLabel = [[UILabel alloc] init];
        if (!IOS7) {
            self.titleLabel.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        }
        
//        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
        
        //返回按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.backgroundColor = [UIColor clearColor];
//        [self.backButton setImage:LOADIMAGE(@"nav_back", @"png") forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
            [self.backButton setImage:image forState:UIControlStateNormal];
        }];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.backButton];
        [self addSubview:self.line];
        
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    self.line.frame = CGRectMake(0, 44, MainScreen_Width, 0.5);
    
    self.backButton.frame = CGRectMake(12, (44-34)/2, 34, 34);
    
    self.titleLabel.frame = self.bounds;
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
