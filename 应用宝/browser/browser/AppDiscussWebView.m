//
//  AppDiscussWebView.m
//  browser
//
//  Created by caohechun on 14-4-3.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "AppDiscussWebView.h"

@implementation AppDiscussWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

- (void)loadURLString:(NSString *)string{
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
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
