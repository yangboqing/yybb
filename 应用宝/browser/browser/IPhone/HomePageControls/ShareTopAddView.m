//
//  ShareTopAddView.m
//  BppStoreBrowser
//
//  Created by 毅 王 on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareTopAddView.h"

@implementation ShareTopAddView

@synthesize moveToDesktopBtn = _moveToDesktopBtn;
@synthesize sinaWeiboBtn = _sinaWeiboBtn;
@synthesize smsBtn = _smsBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = LOADIMAGE(@"弹出", @"png");//[UIImage imageNamed:@"弹出.png"];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        [imageView release];
        
        
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(25 + 100*i, (self.frame.size.height - 30)/2, 64, 30);
            [self addSubview:btn];
            
            if (btn.tag == 0) {
                self.moveToDesktopBtn = btn;
            }else if (btn.tag == 1) {
                self.sinaWeiboBtn = btn;
                self.sinaWeiboBtn.backgroundColor = [UIColor greenColor];
            }else {
                self.smsBtn = btn;
                self.smsBtn.backgroundColor = [UIColor blueColor];
            }
            
            
        }
        
    }
    return self;
}

- (void) dealloc {
    
    self.moveToDesktopBtn = nil;
    self.sinaWeiboBtn = nil;
    self.smsBtn = nil;
    
    [super dealloc];
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
