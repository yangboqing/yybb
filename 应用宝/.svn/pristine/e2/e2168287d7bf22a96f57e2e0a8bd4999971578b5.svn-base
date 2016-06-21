//
//  LFView.m
//  browser
//
//  Created by liguiyang on 14-6-18.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#define IDEN_FINE @"Identifier_find"

#import "LFView.h"
#import "RotatingLoadView.h"

@interface LFView ()
{
    // loadingView
    RotatingLoadView *rotatingLoadView;
    UILabel *loadingLabel;
    UIImageView  *loadingView;
    
    // 加载失败View
    UIImageView *failedImageView;
    UILabel     *failedLabel;
    UIView *failedView;
}
@property (nonatomic, strong) NSString *identifier;
@end


@implementation LFView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(id)initWithLFIdentifier:(NSString *)iden
{
    self = [super init];
    if (self) {
        self.identifier = iden;
        //
        [self initLoadingView];
        [self initFailedView];
        
        [self addSubview:loadingView];
        [self addSubview:failedView];
        [self hideLoadingView];
        [self hideFailedView];
        
        [self setCustomFrame];
    }
    
    return self;
}

-(void)initLoadingView
{
    loadingView = [[UIImageView alloc] init];
    
    rotatingLoadView = [[RotatingLoadView alloc] init];
    loadingLabel = [[UILabel alloc] init];
    loadingLabel.font = [UIFont systemFontOfSize:13.0f];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    loadingLabel.text = @"努力加载中";
    
    [loadingView addSubview:rotatingLoadView];
    [loadingView addSubview:loadingLabel];
}
-(void)initFailedView
{
    failedView = [[UIView alloc] init];
    failedView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(failedViewTapAction)];
    [failedView addGestureRecognizer:tapGes];
    
    failedImageView = [[UIImageView alloc] init];
    SET_IMAGE(failedImageView.image, @"refreshIcon.png");
    [failedView addSubview:failedImageView];
    
    failedLabel = [[UILabel alloc] init];
    failedLabel.textAlignment = NSTextAlignmentCenter;
    failedLabel.backgroundColor = [UIColor clearColor];
    failedLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];
    failedLabel.text = @"加载失败 点击重新加载";
    [failedView addSubview:failedLabel];
}

#pragma mark - Utility
-(void)showLoadingView
{
    rotatingLoadView.hidden = NO;
    loadingLabel.hidden = NO;
    loadingView.hidden = NO;
    [rotatingLoadView startRotationAnimation];
}
-(void)hideLoadingView
{
    rotatingLoadView.hidden = YES;
    loadingLabel.hidden = YES;
    loadingView.hidden = YES;
    [rotatingLoadView stopRotationAnimation];
}

-(void)showFailedView
{
    failedLabel.hidden = NO;
    failedImageView.hidden = NO;
    failedView.hidden = NO;
}
-(void)hideFailedView
{
    failedLabel.hidden = YES;
    failedImageView.hidden = YES;
    failedView.hidden = YES;
}

-(void)setCustomFrame
{
    CGFloat topHeight = IOS7?64:0;
    CGSize  screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width_loading = rotatingLoadView.frame.size.width;
    
    self.frame = CGRectMake(0, topHeight, screenSize.width, screenSize.height-topHeight);
    if ([_identifier isEqualToString:IDEN_FINE]) {
        loadingView.frame = self.frame;
        rotatingLoadView.frame = CGRectMake((loadingView.frame.size.width-width_loading)*0.5, 90, width_loading, width_loading);
        loadingLabel.frame = CGRectMake(0, rotatingLoadView.frame.origin.y+rotatingLoadView.frame.size.height+7, loadingView.frame.size.width, 18);
        
        // failed
        failedView.frame = self.frame;
        failedImageView.frame = CGRectMake(139, 88, 43, 43);
        failedLabel.frame = CGRectMake(0, failedImageView.frame.origin.y+failedImageView.frame.size.height+12, failedView.frame.size.width, 18);
    }
}

-(void)failedViewTapAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedViewHasBeenTaped)]) {
        [self.delegate failedViewHasBeenTaped];
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
