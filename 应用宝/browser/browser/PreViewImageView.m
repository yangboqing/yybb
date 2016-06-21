//
//  PreViewImageView.m
//  browser
//
//  Created by caohechun on 14-5-9.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "PreViewImageView.h"

@interface PreViewImageView()
{
    UIImageView *pictureView;
}
@end
@implementation PreViewImageView
- (void)dealloc{

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pictureView = [[UIImageView alloc]init];
        [self resetBackgroundImgForIphone4];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        [self addSubview:pictureView];
        
    }
    return self;
}

-(void)setPicture:(UIImage *)image{
    if (image == nil) {
        pictureView.image =  [UIImage imageNamed:@"previewBG_default.png"];
    }else{
        pictureView.image = image;
    }
}

- (void)resetBackgroundImgForIphone5{
    pictureView.frame = CGRectMake(0,0, IMAGES_SCROLLVIEW_WEIGHT_IPHONE5, IMAGES_SCROLLVIEW_HEIGHT);
    pictureView.image = [UIImage imageNamed:@"previewBG_default_5.png"];
}
- (void)resetBackgroundImgForIphone4{
    pictureView.frame = CGRectMake(0,0, IMAGES_SCROLLVIEW_WEIGHT, IMAGES_SCROLLVIEW_HEIGHT);
    pictureView.image = [UIImage imageNamed:@"previewBG_default.png"];

}


@end
