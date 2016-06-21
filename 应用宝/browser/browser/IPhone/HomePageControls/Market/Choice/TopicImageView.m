//
//  TopPicImageView.m
//  browser
//
//  Created by caohechun on 14-9-12.
//
//

#import "TopicImageView.h"
@interface TopicImageView(){
    BOOL isOldTopicImage;
}
@end
@implementation TopicImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    
    //加入对不同图片大小的处理:站位图290x148,600x295,640x420等
    isOldTopicImage = NO;
    CGSize orginSize = image.size;
    UIImage *resizedImage;
    if (orginSize.height == 295) {
        resizedImage = [UIImage reSizeImage:image toSize:CGSizeMake(300*210/147.5, 210)];
        isOldTopicImage = YES;
      self.contentMode =  UIViewContentModeCenter;
    }else if(orginSize.height == 420){
        resizedImage = image;
        self.contentMode =  UIViewContentModeScaleAspectFill;
    }else{
        resizedImage = image;
        self.contentMode =  UIViewContentModeScaleAspectFill;
    }
    
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    self.contentMode =  UIViewContentModeScaleAspectFill;
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    super.image = resizedImage;
}

- (void)layoutSubviews{
    if (isOldTopicImage) {
        if (self.frame.size.height > 210) {
            self.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            self.contentMode = UIViewContentModeCenter;
        }
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
