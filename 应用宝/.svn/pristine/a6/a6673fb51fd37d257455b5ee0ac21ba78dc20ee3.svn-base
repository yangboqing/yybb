//
//  WYInstallKKKView.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "WYInstallKKKView.h"


@interface WYInstallKKKView (){
    
    UIImageView *mbImageView;
    UIImageView *bgImageView;
    
    
    UILabel *msgLabel;
    UIButton *gouBtn;
    UILabel *gouLabel;
    UIImageView *hLine;
    UIImageView *sLine;
    UIButton *leftBtn;
    UIButton *rightBtn;
    
    BOOL isSelect;
    
}

@end

@implementation WYInstallKKKView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        isSelect = YES;
        
        mbImageView = [UIImageView new];
        mbImageView.backgroundColor = BLACK_COLOR;
        mbImageView.alpha = 0.2;
        
        bgImageView = [UIImageView new];
        bgImageView.layer.cornerRadius = 5;
        bgImageView.clipsToBounds = YES;
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor = WHITE_COLOR;
        
        
        
        msgLabel = [UILabel new];
        msgLabel.numberOfLines = 0;
        msgLabel.textColor = hllColor(81, 81, 81, 1);
        msgLabel.font = [UIFont systemFontOfSize:14.0f];
        msgLabel.textAlignment  = NSTextAlignmentCenter;
        msgLabel.text = @"检测到您的设备已越狱,建议使用最专业的越狱助手--3K助手";
        
        
        gouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gouBtn.backgroundColor = CLEAR_COLOR;
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"check-box-checked"] forState:UIControlStateNormal];
        [gouBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        gouLabel = [UILabel new];
        gouLabel.textColor = hllColor(160, 160, 160, 1);
        gouLabel.font = [UIFont systemFontOfSize:14.0f];
        gouLabel.text = @"不再显示";
        
        hLine = [UIImageView new];
        hLine.backgroundColor = hllColor(209, 209, 209, 1);
        
        sLine = [UIImageView new];
        sLine.backgroundColor = hllColor(209, 209, 209, 1);
        
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = CLEAR_COLOR;
        [leftBtn setTitleColor:hllColor(11, 98, 251, 1) forState:UIControlStateNormal];
        [leftBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        leftBtn.tag = 1;
        [leftBtn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = CLEAR_COLOR;
        [rightBtn setTitleColor:hllColor(11, 98, 251, 1) forState:UIControlStateNormal];
        [rightBtn setTitle:@"立刻下载" forState:UIControlStateNormal];
        rightBtn.tag = 2;
        [rightBtn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:mbImageView];
        [self addSubview:bgImageView];
        [bgImageView addSubview:msgLabel];
        [bgImageView addSubview:gouBtn];
        [bgImageView addSubview:gouLabel];
        [bgImageView addSubview:hLine];
        [bgImageView addSubview:sLine];
        [bgImageView addSubview:leftBtn];
        [bgImageView addSubview:rightBtn];
        
        
        
        
    }
    
    return self;
    
}

#define ALERT_WIDTH 230
#define ALERT_HEIGHT 137
#define MESSAGE_WIDTH 200
#define MESSAGE_HEIGHT 35
#define BUTTON_HEIGHT 75.0/2
#define BTN_WIDTH (bgImageView.frame.size.width - 1)/2
#define BTN_Y bgImageView.frame.size.height - BUTTON_HEIGHT*IPHONE6_XISHU
- (void)layoutSubviews{
    
    mbImageView.frame = self.bounds;
    bgImageView.frame = CGRectMake((self.frame.size.width - ALERT_WIDTH*IPHONE6_XISHU)/2, (self.frame.size.height - ALERT_HEIGHT*IPHONE6_XISHU)/2, ALERT_WIDTH*IPHONE6_XISHU, ALERT_HEIGHT*IPHONE6_XISHU);
    msgLabel.frame = CGRectMake((bgImageView.frame.size.width - MESSAGE_WIDTH*IPHONE6_XISHU)/2, 20*IPHONE6_XISHU, MESSAGE_WIDTH*IPHONE6_XISHU, MESSAGE_HEIGHT*IPHONE6_XISHU);
    gouBtn.frame = CGRectMake(msgLabel.frame.origin.x, msgLabel.frame.origin.y + msgLabel.frame.size.height + 20*IPHONE6_XISHU, 16*IPHONE6_XISHU, 16*IPHONE6_XISHU);
    gouLabel.frame = CGRectMake(gouBtn.frame.origin.x + gouBtn.frame.size.width + 7, gouBtn.frame.origin.y, 100*IPHONE6_XISHU, gouBtn.frame.size.height);
    hLine.frame = CGRectMake(0, gouBtn.frame.origin.y + gouBtn.frame.size.height + 10*IPHONE6_XISHU, self.frame.size.width, 1);
    
    leftBtn.frame = CGRectMake(0, BTN_Y, BTN_WIDTH, BUTTON_HEIGHT*IPHONE6_XISHU);
    sLine.frame = CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width, hLine.frame.origin.y + hLine.frame.size.height, 1, bgImageView.frame.size.height - hLine.frame.origin.y - hLine.frame.size.height);
    rightBtn.frame = CGRectMake(sLine.frame.origin.x + sLine.frame.size.width, BTN_Y, BTN_WIDTH, BUTTON_HEIGHT*IPHONE6_XISHU);
    
}

- (void)clickSelectBtn:(UIButton *)sender{
    if (!isSelect) {
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"check-box-checked"] forState:UIControlStateNormal];
    }else{
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"check-box-normal"] forState:UIControlStateNormal];
    }
    isSelect = !isSelect;
}

- (void)clickaction:(UIButton *)sender{
    if (isSelect == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"kkkA"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"kkkA"];
    }
    if (sender.tag == 1) {
        self.hidden = YES;
    }else{
        if (self.kInstallString.length > 5) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.kInstallString]];
        }
        self.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"kkkA"];

        
    }
}


@end
