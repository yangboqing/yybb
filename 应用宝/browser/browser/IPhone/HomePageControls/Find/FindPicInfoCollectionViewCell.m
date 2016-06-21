//
//  FindPicInfoCollectionViewCell.m
//  browser
//
//  Created by 王毅 on 14-10-30.
//
//

#import "FindPicInfoCollectionViewCell.h"

@implementation FindPicInfoCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        self.wallpaperImageView = [[UIImageView alloc] init];
        self.wallpaperImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.wallpaperImageView];
        
        wallSubImageView = [[UIImageView alloc] init];
        wallSubImageView.backgroundColor = [UIColor blackColor];
        [self.wallpaperImageView addSubview:wallSubImageView];
        
        
        
        _progressBackgroundView = [[UIImageView alloc] init];
        _progressBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _progressBackgroundView.hidden = NO;
        _progressBackgroundView.userInteractionEnabled = YES;
        [self.contentView addSubview:_progressBackgroundView];
        
        self.progressView = [[PICircularProgressView alloc]init];
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.progress = 0;
        //        self.progressView.hidden = NO;
        self.progressView.userInteractionEnabled = YES;
        [_progressBackgroundView addSubview:self.progressView];
        
        
        //        self.contentView.layer.borderWidth = 1.0f;
        //        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)isProgressHidden:(BOOL)isHidden{
    
    //    self.progressView.hidden = isHidden;
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

- (void)setCurrentBoundsToImage:(UIImage*)image{
    
#define PIC_FRAME_HEIGHT [[UIScreen mainScreen] bounds].size.height
    
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    
    if (height <= PIC_FRAME_HEIGHT && width <= MainScreen_Width) {
        wallSubImageView.frame = CGRectMake((self.frame.size.width - width)/2, (self.frame.size.height - height)/2, width, height);
        
    }else{
        if (width > MainScreen_Width && height > PIC_FRAME_HEIGHT) {
            
//            CGFloat widthCha = width - MainScreen_Width;
//            CGFloat heightCha = height - MainScreen_Height;
//            
//            if (widthCha > heightCha) {
//                
//                
//                CGFloat Ex = MainScreen_Width/height;
//                CGFloat _width = width*Ex;
//                wallSubImageView.frame = CGRectMake((MainScreen_Width - _width)/2, 0, _width, MainScreen_Height);
//            }else{
                CGFloat Ex = MainScreen_Width/width;
                CGFloat _height = height*Ex;
            if (_height > PIC_FRAME_HEIGHT) {
                _height = PIC_FRAME_HEIGHT;
            }
                wallSubImageView.frame = CGRectMake(0, (PIC_FRAME_HEIGHT - _height)/2, MainScreen_Width, _height);
//            }

//            wallSubImageView.frame = self.bounds;

        }else if (width > MainScreen_Width){
            CGFloat Ex = MainScreen_Width/width;
            CGFloat _height = height*Ex;
            wallSubImageView.frame = CGRectMake(0, (PIC_FRAME_HEIGHT - _height)/2, MainScreen_Width, _height);
            
        }else if (height > PIC_FRAME_HEIGHT){
            CGFloat Ex = MainScreen_Width/height;
            CGFloat _width = width*Ex;
            wallSubImageView.frame = CGRectMake((MainScreen_Width - _width)/2, 0, _width, PIC_FRAME_HEIGHT);
        }
    }
    
    wallSubImageView.image = image;
    
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
