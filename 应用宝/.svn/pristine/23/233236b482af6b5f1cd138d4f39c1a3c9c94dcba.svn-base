//
//  UIHotWordLabel.m
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "UIHotWordLabel.h"

@implementation UIHotWordLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.lineBreakMode = NSLineBreakByClipping;
        self.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.text isEqualToString:@""] && self.text != nil &&[self.delegate respondsToSelector:@selector(aHotWordLabelHasBeenSelected:)]) {
        [self.delegate aHotWordLabelHasBeenSelected:self.text];
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
