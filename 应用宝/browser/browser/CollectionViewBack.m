//
//  CollectionViewBack.m
//  33
//
//  Created by niu_o0 on 14-4-29.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import "CollectionViewBack.h"
#import "GifView.h"

#define Spacing 10
#define FontSize 16.0f

@implementation BackAnimation

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"loadingbg.png"];
        imageview2 = [UIImageView new];
        imageview2.image = img;
        [self addSubview:imageview2];
        
        img = [UIImage imageNamed:@"loadingArc.png"];
        imageView = [UIImageView new];
        imageView.image = img;
        [self addSubview:imageView];
        
        label = [UILabel new];
        label.text = @"正在加载中";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1];
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    imageview2.frame = CGRectMake((self.bounds.size.width-imageview2.image.size.width/2)/2, (self.bounds.size.height-imageview2.image.size.height/2)/2-(imageview2.image.size.height/2+Spacing+FontSize)/2, imageview2.image.size.width/2, imageview2.image.size.height/2);
    imageView.frame = CGRectMake(imageview2.frame.origin.x, imageview2.frame.origin.y+imageview2.frame.size.height+Spacing, 17, 17.0);//imageview2.frame;
    label.frame = CGRectMake(imageView.frame.origin.x + 22, imageview2.frame.origin.y+imageview2.frame.size.height+Spacing, self.bounds.size.width, FontSize);
}

//添加快用菊花动画
- (void)start{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.5f;
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    animation.repeatCount = MAXFLOAT;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    [imageView.layer addAnimation:animation forKey:@"rotation"];
}
//移除快用菊花动画
- (void)stop{
    [imageView.layer removeAnimationForKey:@"rotation"];
}

@end

@implementation AnimationView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"mainLoading" withExtension:@"gif"];
        gifView = [[GifView alloc] initWithUrl:url];
        [self addSubview:gifView];
        
        label = [UILabel new];
        label.text = @"应用宝贝";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = [UIColor colorWithRed:254.0/255.0 green:199.0/255.0 blue:46.0/255.0 alpha:0.5];
        [self addSubview:label];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat scale = MainScreen_Width/414;
    CGFloat width = 372/3*0.8*scale;
    CGFloat height = 100/3*0.8*scale;
    
    gifView.frame = CGRectMake((self.bounds.size.width-width)*0.5, (self.bounds.size.height-height-Spacing-FontSize)*0.5, width, height);
    label.frame = CGRectMake(0, gifView.frame.origin.y+gifView.frame.size.height+Spacing, self.bounds.size.width, FontSize);
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    gifView.hidden = hidden;
    label.hidden = hidden;
    
    if (hidden) {
        [gifView stopGif];
    } else {
        [gifView startGif];
    }
}

@end


@implementation BackFail

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"loadingFailed.png"];
        [self addSubview:imageView];
        
        label = [UILabel new];
        label.text = @"加载失败 点击重新加载";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    imageView.frame = CGRectMake((self.bounds.size.width-imageView.image.size.width/2)/2, (self.bounds.size.height-imageView.image.size.height/2)/2-(imageView.image.size.height/2+Spacing+FontSize)/2, imageView.image.size.width/2, imageView.image.size.height/2);
    label.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+Spacing, self.bounds.size.width, FontSize);
}

@end


@interface CollectionViewBack ()

@end

@implementation CollectionViewBack

-(id)init{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _animation = [[BackAnimation alloc] init];
        _animation.hidden = YES;
        [self addSubview:_animation];
        
        _failView = [BackFail new];
        [self addSubview:_failView];
        _failView.hidden = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [_failView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloading) name:RELOADING object:nil];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _animation.frame = self.bounds;
    _failView.frame = self.bounds;
}

- (void)click{
    _failView.hidden = YES;
    _animation.hidden = NO;
    [_animation start];
    if (_tap) _tap();
    
}

- (void)setClickActionWithBlock:(tap)_block{
    _tap = _block;
}

- (void)setStatus:(Request_status)status{
    
    if (status == Loading){
        _failView.hidden = YES;
        _animation.hidden = NO;
        [_animation start];
        self.alpha = 1.0f;
    }else if (status == Failed){
        _failView.hidden = NO;
        [_animation stop];
        _animation.hidden = YES;
        self.alpha = 1.0f;
    }else if (status == Hidden){
        [_animation stop];
        _animation.hidden = YES;
        _failView.hidden = YES;
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)reloading
{
    if (_status == Loading) {
//        [_animation->gifView startGif];
    }
}

@end

#import "GifView.h"
@implementation RefreshView

- (id)init
{
    self = [super init];
    if (self) {
        _gifView = [GifView new];
        _gifView.backgroundColor = [UIColor clearColor];
        [self addSubview:_gifView];
        
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:11.f];
        _textLabel.textColor = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1.0];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)startGif{
    _textLabel.text = REQUESTINGTEXT;
    [_gifView startGif];
}

- (void)stopGif{
    _textLabel.text = REQUESTEDTEXT;
    [_gifView stopGif];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(10, 0, self.bounds.size.width-10, self.bounds.size.height);
    _gifView.frame = CGRectMake(100, (self.bounds.size.height-20)/2, 20, 20);
}

@end
