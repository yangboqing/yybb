//
//  TopicDetailHeadView.m
//  MyHelper
//
//  Created by mingzhi on 15/1/4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "TopicDetailHeadView.h"

@interface TopicDetailHeadView(){
    UIImageView *coverImageView;
    UILabel * _contentView;
    CGSize _size;
    
    float instanceImageHeight;//图片实时高度
    float instanceTextContentHeight;//简介占用高度
}
@end
@implementation TopicDetailHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = WHITE_BACKGROUND_COLOR;
        instanceImageHeight = ORIGINAL_IMAGE_HEIGHT;
        instanceTextContentHeight = 44;
        
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        SET_IMAGE(_imageView.image, @"jingxuan_topic");
        [self addSubview:_imageView];
        
        coverImageView = [UIImageView new];
        coverImageView.image = [UIImage imageNamed:@"menghei"];
        coverImageView.userInteractionEnabled = NO;
        [_imageView addSubview:coverImageView];
        
        _contentView = [UILabel new];
        _contentView.font = [UIFont systemFontOfSize:textFont];
        _contentView.numberOfLines = 3;
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
    
    if (instanceImageHeight <= ORIGINAL_IMAGE_HEIGHT) {
        //默认图片
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, instanceImageHeight);
    }else if (instanceImageHeight>ORIGINAL_IMAGE_HEIGHT && instanceImageHeight<NORMAL_IMAGE_HEIGHT){
        //图片还未完整显示
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, instanceImageHeight);
    }else if (instanceImageHeight>=NORMAL_IMAGE_HEIGHT){
        //图片放大
        _imageView.frame = CGRectMake(0 - (instanceImageHeight - NORMAL_IMAGE_HEIGHT)*(300/147.5)/2, 0 , MainScreen_Width + (instanceImageHeight - NORMAL_IMAGE_HEIGHT)*(300/147.5), instanceImageHeight);
    }
    
    coverImageView.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, instanceImageHeight);
    _contentView.frame = CGRectMake(10, _imageView.frame.origin.y+_imageView.frame.size.height+10,self.frame.size.width-20, instanceTextContentHeight);
}

- (void)setContentText:(NSString *)contentText{
    _contentView.text = contentText;
    [self setNeedsDisplay];
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
