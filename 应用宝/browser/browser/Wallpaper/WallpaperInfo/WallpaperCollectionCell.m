//
//  WallpaperCollectionCell.m
//  browser
//
//  Created by 王毅 on 14-8-27.
//
//

#import "WallpaperCollectionCell.h"

@implementation WallpaperCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        self.wallpaperImageView = [[UIImageView alloc] init];
        self.wallpaperImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.wallpaperImageView];
        
        
        _progressBackgroundView = [[UIImageView alloc] init];
        _progressBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _progressBackgroundView.hidden = NO;
        _progressBackgroundView.userInteractionEnabled = YES;
        [self.contentView addSubview:_progressBackgroundView];
        
        self.progressView = [[PICircularProgressView alloc]init];
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.progress = 0;
        self.progressView.userInteractionEnabled = YES;
        [_progressBackgroundView addSubview:self.progressView];
    }
    return self;
}

- (void)isProgressHidden:(BOOL)isHidden{
    _progressBackgroundView.hidden = isHidden;
    
}

- (void)layoutSubviews{
    self.wallpaperImageView.frame = self.bounds;
    _progressBackgroundView.frame = self.bounds;
    self.progressView.frame = CGRectMake((self.frame.size.width - 45)/2, 236, 45, 47);
}
- (void)setProgress:(double)progress
{
    self.progressView.progress = MIN(1.0, MAX(0.0, progress));
    
    [self setNeedsDisplay];
}


@end
