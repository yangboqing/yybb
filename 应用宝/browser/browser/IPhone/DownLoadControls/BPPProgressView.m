//
//  BPPProgressView.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  

#import "BPPProgressView.h"

@implementation BPPProgressView

@synthesize progressImage;
@synthesize trackImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _progress = [[UIImageView alloc] initWithFrame: self.bounds ];
        
        _maskView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, self.bounds.size.height)];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _maskView.clipsToBounds = YES;
        
        [self addSubview: _maskView];
        [ _maskView addSubview: _progress];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) layoutSubviews {
    
    _progress.frame = self.bounds;
}

- (void) setProgress:(CGFloat)progress animated:(BOOL)animated {
    float time = 0.7;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        CGFloat width = progress * self.bounds.size.width;
        _maskView.frame = CGRectMake(0, 0, width, _maskView.frame.size.height);
        return;
    }
    
    CGFloat duration = animated?time:0;
    [ UIView animateWithDuration:duration animations:^{
        CGFloat width = progress * self.bounds.size.width;
        _maskView.frame = CGRectMake(0, 0, width, _maskView.frame.size.height);
    } ];
}

- (void) dealloc {    
    _maskView = nil;
    _progress = nil;
}

- (void) setProgressImage:(UIImage *)image {
    
    _progress.image = image;
}

- (void) setTrackImage:(UIImage *)image {
    
    self.image = image;
}
@end

