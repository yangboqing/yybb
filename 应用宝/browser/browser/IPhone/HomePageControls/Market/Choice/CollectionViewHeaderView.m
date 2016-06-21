//
//  CollectionViewHeaderView.m
//  33
//
//  Created by niu_o0 on 14-4-28.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import "CollectionViewHeaderView.h"

#define IMAGE_SIZE CGSizeMake(318/2,32/2)

@implementation CollectionViewHeaderView

@synthesize indexPath = _indexPath, imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}

- (void)dealloc{
    __ind = nil;
}

-(void)makeViews{
    //分隔条
    seperateView = [[UIView alloc]init];
    seperateView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    seperateView.layer.borderWidth = 0.5;
    seperateView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0].CGColor;
    [self addSubview:seperateView];
    
    
    //标题图片
    _imageView = [[UIImageView alloc] init];
    
    _imageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_imageView];
    
    //按钮
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_button setExclusiveTouch:YES];
    
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [LocalImageManager setImageName:@"all_btn.png" complete:^(UIImage *image) {
      [_button setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    [_button addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
}

- (void)layoutSubviews{
    seperateView.frame = CGRectMake(0, 0, MainScreen_Width, 10);
    
    _imageView.frame = CGRectMake(12, seperateView.frame.size.height + 15, IMAGE_SIZE.width, IMAGE_SIZE.height);
    
    _button.frame = CGRectMake(self.bounds.size.width - 60, _imageView.frame.origin.y - 7, 60, 25);
}

- (void)press{
    if (__ind) {
        __ind(_indexPath);
    }
    
}

- (void)setIndexWithBlock:(ind)_indP{
    __ind = _indP;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetLineWidth(context, 0.5);
    
    CGContextSetRGBStrokeColor(context, 100.0/255.0, 100.0/255.0, 100.0/255.0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 12, 0);
    
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    CGContextStrokePath(context);
}


@end
