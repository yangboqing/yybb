//
//  MumView.m
//  Huanxinhuanxin
//
//  Created by 王毅 on 14/12/14.
//  Copyright (c) 2014年 王毅. All rights reserved.
//

#import "MumView.h"

@implementation MumView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CLEAR_COLOR;
        self.userInteractionEnabled = YES;
        
        loadingBgImageView = [UIImageView new];
        loadingBgImageView.backgroundColor = hllColor(0, 0, 0, 0.5);
        loadingBgImageView.layer.cornerRadius = 5;
        loadingBgImageView.clipsToBounds = YES;
        loadingBgImageView.userInteractionEnabled = YES;
        
        loadingLabel = [UILabel new];
        loadingLabel.text = @"验证中,请稍候";
        loadingLabel.font = [UIFont systemFontOfSize:16.0f];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.backgroundColor = CLEAR_COLOR;
        loadingLabel.textColor = WHITE_COLOR;

        bizhiSettingBaseView = [UIImageView new];
        SET_IMAGE(bizhiSettingBaseView.image, @"validation-loading-bg.png");
        
        
        bizhiSettingTurnView = [UIImageView new];
        SET_IMAGE(bizhiSettingTurnView.image, @"validation-loading.png");
        
        
        endBgImageView = [UIImageView new];
        endBgImageView.backgroundColor = hllColor(0, 0, 0, 0.5);
        endBgImageView.layer.cornerRadius = 5;
        endBgImageView.clipsToBounds = YES;
        endBgImageView.userInteractionEnabled = YES;
        
        endLabel = [UILabel new];
        endLabel.text = @"验证失败,请检查用户名和密码是否正确";
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.font = [UIFont systemFontOfSize:16.0f];
        endLabel.numberOfLines = 0;
        endLabel.backgroundColor = CLEAR_COLOR;
        endLabel.textColor = WHITE_COLOR;
        endLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        
        didiBgImageView = [UIImageView new];
        didiBgImageView.backgroundColor = hllColor(0, 0, 0, 0.5);
        didiBgImageView.userInteractionEnabled = YES;
        
        didiShowView = [DidiShowView new];
        [didiShowView.closedidiBtn addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
        [didiShowView.godidiBtn addTarget:self action:@selector(clickToDidi:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        [loadingBgImageView addSubview:bizhiSettingBaseView];
        [loadingBgImageView addSubview:bizhiSettingTurnView];
        [loadingBgImageView addSubview:loadingLabel];
        [self addSubview:loadingBgImageView];
        
        [self addSubview:didiBgImageView];
         [self addSubview:didiShowView];
        
        
        [endBgImageView addSubview:endLabel];
        [self addSubview:endBgImageView];
        
        [self isShowState:99];
        
    }
    return self;
}

- (void)layoutSubviews{
    loadingBgImageView.frame = CGRectMake((self.frame.size.width - 160*IPHONE6_XISHU)/2, (self.frame.size.height - 120*IPHONE6_XISHU)/2, 160*IPHONE6_XISHU, 120*IPHONE6_XISHU);

    bizhiSettingBaseView.frame = CGRectMake((loadingBgImageView.frame.size.width - 40*IPHONE6_XISHU)/2, 25*IPHONE6_XISHU, 40*IPHONE6_XISHU, 40*IPHONE6_XISHU);
    bizhiSettingTurnView.frame = bizhiSettingBaseView.frame;
    
    loadingLabel.frame = CGRectMake(0, loadingBgImageView.frame.size.height - 25*IPHONE6_XISHU, loadingBgImageView.frame.size.width, 20*IPHONE6_XISHU);
    
    
    endBgImageView.frame = CGRectMake((self.frame.size.width - 270*IPHONE6_XISHU)/2, (self.frame.size.height - 180*IPHONE6_XISHU)/2, 270*IPHONE6_XISHU, 180*IPHONE6_XISHU);
    endLabel.frame = CGRectMake(0, 0, endBgImageView.frame.size.width, endBgImageView.frame.size.height);
    didiBgImageView.frame = self.bounds;
    didiShowView.frame = CGRectMake((self.frame.size.width - 282*IPHONE6_XISHU)/2 + 12*IPHONE6_XISHU, (self.frame.size.height - 242*IPHONE6_XISHU)/2, 282*IPHONE6_XISHU, 242*IPHONE6_XISHU);
    
}

- (void)startGif{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSNotFound;
    
    [bizhiSettingTurnView.layer addAnimation:rotationAnimation forKey:@"rotationAnimationA"];
    
}

- (void)stopGif{
    [bizhiSettingTurnView.layer removeAnimationForKey:@"rotationAnimationA"];
}

- (void)isShowState:(int)state{
    
    loadingBgImageView.hidden = YES;
    endBgImageView.hidden = YES;
    didiShowView.hidden = YES;
    [self stopGif];
    didiBgImageView.hidden = YES;
    
    switch (state) {
        case 0:
            loadingBgImageView.hidden = NO;
            [self startGif];
            break;
        case 1:
//            didiShowView.hidden = NO;
//            didiBgImageView.hidden = NO;
            break;
        case 2:
            endBgImageView.hidden = NO;
            if ([[TMCache sharedCache] objectForKey:@"savefailstring"]) {
                endLabel.text = [[TMCache sharedCache] objectForKey:@"savefailstring"];
            }else{
                endLabel.text = @"验证失败,请检查用户名和密码是否正确";
            }
            break;
        case 3:
            endBgImageView.hidden = NO;
            endLabel.text = @"赠送账号已完毕，请明天认领！";
            break;
        default:
            break;
    }
}

- (void)clickClose:(UIButton *)sender{
    [self saveAccountToAccounts];
    [self closeSelf];
}
- (void)clickToDidi:(UIButton *)sender{
    [self saveAccountToAccounts];
    [self closeSelf];
//    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_CLOSE_DIDI_WEB object:@"open"];
}
- (void)closeSelf{

    if (self.delegate && [self.delegate respondsToSelector:@selector(hideMumView)]) {
        [self.delegate hideMumView];
    }
    
//    NSDictionary *map = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNTPASSWORD];
//    if (!map) {
//        NSLog(@"========================----账号密码不存在----============");
//    }
//    
//    AppStoreNewDownload* appstore = [[AppStoreNewDownload alloc] init];
//    [appstore downloadIPAByAU:@"com.dianping.dpscope" download:^(NSDictionary *httpHeaders, NSString *ipaURL) {
//        
//    }];
    
}

- (void)saveAccountToAccounts{
    NSString*account = [[[FileUtil instance] getAccountPasswordInfo] objectForKey:SAVE_ACCOUNT];
    [[LoginServerManage getManager] addAccountToAccounts:account];
}

@end
