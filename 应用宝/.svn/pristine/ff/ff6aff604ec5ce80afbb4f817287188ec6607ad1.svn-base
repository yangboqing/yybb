//
//  YulanPageView.m
//  browser
//
//  Created by 王毅 on 14-9-1.
//
//

#import "YulanPageView.h"

@interface YulanPageView (){
    BOOL isTurn;
}

@end

@implementation YulanPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        choiceLabelY = YES;
        isTurn = NO;
        
        backGroundImageView = [UIImageView new];
        backGroundImageView.backgroundColor = [UIColor blackColor];
        backGroundImageView.alpha = 0.4;
        [self addSubview:backGroundImageView];
        
        //启动只显示一次的预览
        YulanTubiao = [UIImageView new];
        SET_IMAGE(YulanTubiao.image, @"yulanbizhi.png");
        [self addSubview:YulanTubiao];
        
        
        //图标的背景
        tubiaoBackgroundImageView = [UIImageView new];
        tubiaoBackgroundImageView.backgroundColor = [UIColor blackColor];
        tubiaoBackgroundImageView.alpha = 0.4;
        tubiaoBackgroundImageView.layer.masksToBounds = YES;
        tubiaoBackgroundImageView.layer.cornerRadius = 8.0;
        [self addSubview:tubiaoBackgroundImageView];
        
        
        //没网
        notWebImageVIew = [UIImageView new];
        SET_IMAGE(notWebImageVIew.image, @"bizhinonet.png");
        [self addSubview:notWebImageVIew];
        
        //设置中
//        bizhiSettingBaseView = [UIImageView new];
//        SET_IMAGE(bizhiSettingBaseView.image, @"biaozhizhuanquanditu.png");
//        [self addSubview:bizhiSettingBaseView];
//        
//        bizhiSettingTurnView = [UIImageView new];
//        SET_IMAGE(bizhiSettingTurnView.image, @"biaozhizhuanquanzhuantu.png");
//        [self addSubview:bizhiSettingTurnView];
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        [self addSubview:_activityIndicator];
        
        //设置成功
        bizhiSetSuccessImageView = [UIImageView new];
        SET_IMAGE(bizhiSetSuccessImageView.image, @"bizhishezhichenggong.png");
        [self addSubview:bizhiSetSuccessImageView];
        
        
        
        imageVIewLabel = [UILabel new];
        imageVIewLabel.text = @"";
        imageVIewLabel.textColor = [UIColor whiteColor];
        imageVIewLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:imageVIewLabel];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelfView)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)layoutSubviews{
    backGroundImageView.frame = self.bounds;
    YulanTubiao.frame = CGRectMake((self.frame.size.width - 55)/2, 213, 55, 55);
    
    tubiaoBackgroundImageView.frame = CGRectMake((self.frame.size.width - 120)/2, (self.frame.size.height - 120)/2, 120, 120);
    notWebImageVIew.frame = CGRectMake((self.frame.size.width - 50)/2, tubiaoBackgroundImageView.frame.origin.y + 26, 50, 50);
//    bizhiSettingBaseView.frame = CGRectMake((self.frame.size.width - 50)/2, notWebImageVIew.frame.origin.y, 50, 50);
//    bizhiSettingTurnView.frame = bizhiSettingBaseView.frame;
    _activityIndicator.frame = CGRectMake((self.frame.size.width - 50)/2, notWebImageVIew.frame.origin.y, 50, 50);
    bizhiSetSuccessImageView.frame = CGRectMake((self.frame.size.width - 50)/2, notWebImageVIew.frame.origin.y, 50, 50);
    if (choiceLabelY == YES) {
        imageVIewLabel.frame = CGRectMake(0, tubiaoBackgroundImageView.frame.origin.y + 100, self.frame.size.width, 19);
    }else{
        imageVIewLabel.frame = CGRectMake(0, tubiaoBackgroundImageView.frame.origin.y + 88, self.frame.size.width, 19);
    }
    
}

//0:只显示一次的预览引导图 1：没网  2：设置中  3：设置成功
- (void)isShowWhatImageVIew:(NSInteger)showState  isSave:(BOOL)isSave{
    backGroundImageView.hidden = showState <= 4?NO:YES;
    YulanTubiao.hidden = YES;
    if (showState < 1 || showState > 10) {
        tubiaoBackgroundImageView.hidden = YES;
    }else{
        tubiaoBackgroundImageView.hidden = NO;
    }
//    bizhiSettingBaseView.hidden = YES;
//    bizhiSettingTurnView.hidden = YES;
    [_activityIndicator stopAnimating];
    notWebImageVIew.hidden = YES;
    bizhiSetSuccessImageView.hidden = YES;
    imageVIewLabel.hidden = YES;
    choiceLabelY = NO;
    switch (showState) {
        case 0:
            YulanTubiao.hidden = NO;
            imageVIewLabel.hidden = NO;
            choiceLabelY = YES;
            imageVIewLabel.text = CLICK_YULAN_TEXT;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"YulanTubiao"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            notWebImageVIew.hidden = NO;
            imageVIewLabel.hidden = NO;
            imageVIewLabel.text = NET_TROBLEM_TEXT;
            [self delayHidden:99 time:2];
            break;
        case 2:
//            bizhiSettingBaseView.hidden = NO;
//            bizhiSettingTurnView.hidden = NO;
//            [self startGif];
            [_activityIndicator startAnimating];
            imageVIewLabel.hidden = NO;
            if (isSave == YES) {
                imageVIewLabel.text = BIZHI_SAVING_TEXT;
            }else{
                imageVIewLabel.text = BIZHI_SETTING_TEXT;
            }
            
            if (isSave == YES) {
                [self delayHidden:4 time:2];
            }else{
                [self delayHidden:3 time:2];
            }
            
            break;
        case 3:{
            bizhiSetSuccessImageView.hidden = NO;
            SET_IMAGE(bizhiSetSuccessImageView.image, @"bizhishezhichenggong.png");
            [self stopGif];
            imageVIewLabel.hidden = NO;
            imageVIewLabel.text = BIZHI_SETTING_COMPLTE_TEXT;
            [self delayHidden:99 time:2];
        }
            break;
        case 4:{
            bizhiSetSuccessImageView.hidden = NO;
            SET_IMAGE(bizhiSetSuccessImageView.image, @"bizhisavesucess.png");
            [self stopGif];
            imageVIewLabel.hidden = NO;
            imageVIewLabel.text = BIZHI_SAVE_COMPLTE_TEXT;
            [self delayHidden:99 time:2];
        }
            break;
            
        default:
            break;
    }
    [self setNeedsLayout];
    
    if (showState > 10) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickFirstYulanPage:)]) {
            [self.delegate clickFirstYulanPage:0];
        }
    }
    
}

- (void)delayHidden:(NSTimeInterval)hiddenIndex time:(NSInteger)time{
    
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(delayHiddenMethod:) userInfo:[NSNumber numberWithInteger:hiddenIndex] repeats:NO];
}
- (void)delayHiddenMethod:(NSTimer *)timer{
    NSInteger index = [timer.userInfo integerValue];
    [self isShowWhatImageVIew:index isSave:NO];
}

//- (void)startGif{
//
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 3;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = NSNotFound;
//    
//    [bizhiSettingTurnView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    
//}

- (void)stopGif{
    [bizhiSettingTurnView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)clickSelfView{
    if (YulanTubiao.hidden == YES) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFirstYulanPage:)]) {
        [self.delegate clickFirstYulanPage:1];
    }
    
}

@end
