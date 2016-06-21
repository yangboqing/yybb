//
//  DetailHeaderView.m
//  browser
//
//  Created by niu_o0 on 14-6-10.
//
//

#import "DetailHeaderView.h"
@interface DetailHeaderView(){
    float instanceImageHeight;//图片实时高度
    float instanceTextContentHeight;//简介占用高度
    UIImageView *shadowCover;//阴影遮盖

}
@end

@implementation DetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = WHITE_BACKGROUND_COLOR;
        instanceImageHeight = ORIGINAL_IMAGE_HEIGHT;
        instanceTextContentHeight = 100;
        
        _imageView = [TopicImageView new];
        _imageView.clipsToBounds = YES;
        SET_IMAGE(_imageView.image, @"icon_topic.png");
        [self addSubview:_imageView];
        
        shadowCover = [[UIImageView alloc]init];
        SET_IMAGE(shadowCover.image, @"topicShadow.png");
        [shadowCover.image stretchableImageWithLeftCapWidth:10 topCapHeight:1];
        shadowCover.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:shadowCover];
        
        _contentView = [UILabel new];
        _contentView.font = [UIFont systemFontOfSize:textFont];
        _contentView.numberOfLines = 0;
        _contentView.textAlignment = NSTextAlignmentLeft;
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float instanceHeaderHeight = self.frame.size.height;
    instanceImageHeight = instanceHeaderHeight - 20 - instanceTextContentHeight;
    if (instanceImageHeight  == ORIGINAL_IMAGE_HEIGHT) {
        //默认图片
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, instanceImageHeight);
    }else if (instanceImageHeight >ORIGINAL_IMAGE_HEIGHT&&instanceImageHeight <NORMAL_IMAGE_HEIGHT){
        //图片还未完整显示
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, instanceImageHeight);
    }else if (instanceImageHeight >=NORMAL_IMAGE_HEIGHT){
        //图片放大
        _imageView.frame = CGRectMake(0 - (instanceImageHeight - NORMAL_IMAGE_HEIGHT)*(300/147.5)/2, 0 , MainScreen_Width + (instanceImageHeight - NORMAL_IMAGE_HEIGHT)*(300/147.5), instanceImageHeight);    }
    _contentView.frame = CGRectMake(10, _imageView.frame.origin.y+_imageView.frame.size.height+10,MainScreen_Width - 20, instanceTextContentHeight);
    shadowCover.frame = _imageView.frame;

}


- (void)reset{
//    _imageView.image = [UIImage imageNamed:@"icon_topic.png"];
    SET_IMAGE(_imageView.image, @"icon_topic.png");
    instanceImageHeight = ORIGINAL_IMAGE_HEIGHT;
    instanceTextContentHeight = 100;
}


- (void)recover{
    
}
- (void)setContentText:(NSString *)contentText{
    _contentView.text = contentText;
//    _size = [contentText sizeWithFont:_contentView.font constrainedToSize:CGSizeMake(300, 100)];
    _contentView.frame = CGRectMake(10, _imageView.frame.origin.y+_imageView.frame.size.height + 10, MainScreen_Width - 20, instanceTextContentHeight);
}
- (void)setIntroTextHeight:(float)theHeight{
    instanceTextContentHeight = theHeight;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetLineWidth(context, 0.5);
    
    CGContextSetRGBStrokeColor(context, 100.0/255.0, 100.0/255.0, 100.0/255.0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 12, rect.size.height);
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    CGContextStrokePath(context);
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
