//
//  WYNotBindingAlertView.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "WYNotBindingAlertView.h"

@interface WYNotBindingAlertView (){
    UIImageView *mbImageView;
    UIImageView *bgImageView;
    
    
    UILabel *msgLabel;
    UIImageView *hLine;
    UIImageView *sLine;
    UIButton *leftBtn;
    UIButton *rightBtn;
}

@end


@implementation WYNotBindingAlertView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
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
        msgLabel.font = [UIFont systemFontOfSize:16.0f];
        msgLabel.textAlignment  = NSTextAlignmentCenter;
        msgLabel.text = @"不绑定ID\n下载应用会不稳定哦";
        
        

        
        hLine = [UIImageView new];
        hLine.backgroundColor = hllColor(209, 209, 209, 1);
        
        sLine = [UIImageView new];
        sLine.backgroundColor = hllColor(209, 209, 209, 1);
        
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = CLEAR_COLOR;
        [leftBtn setTitleColor:hllColor(11, 98, 251, 1) forState:UIControlStateNormal];
        [leftBtn setTitle:@"坚持退出" forState:UIControlStateNormal];
        leftBtn.tag = 1;
        [leftBtn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = CLEAR_COLOR;
        [rightBtn setTitleColor:hllColor(11, 98, 251, 1) forState:UIControlStateNormal];
        [rightBtn setTitle:@"继续绑定" forState:UIControlStateNormal];
        rightBtn.tag = 2;
        [rightBtn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:mbImageView];
        [self addSubview:bgImageView];
        [bgImageView addSubview:msgLabel];
        [bgImageView addSubview:hLine];
        [bgImageView addSubview:sLine];
        [bgImageView addSubview:leftBtn];
        [bgImageView addSubview:rightBtn];
        
        
        
        
    }
    
    return self;
    
}
#define BTN_WIDTH (bgImageView.frame.size.width - 1)/2
#define BTN_Y bgImageView.frame.size.height - 44*IPHONE6_XISHU
- (void)layoutSubviews{
    
    mbImageView.frame = self.bounds;
    bgImageView.frame = CGRectMake((self.frame.size.width - 270*IPHONE6_XISHU)/2, (self.frame.size.height - 129*IPHONE6_XISHU)/2, 270*IPHONE6_XISHU, 129*IPHONE6_XISHU);
    msgLabel.frame = CGRectMake((bgImageView.frame.size.width - 221*IPHONE6_XISHU)/2, 20*IPHONE6_XISHU, 221*IPHONE6_XISHU, 40*IPHONE6_XISHU);

    hLine.frame = CGRectMake(0, msgLabel.frame.origin.y + msgLabel.frame.size.height + 20*IPHONE6_XISHU, self.frame.size.width, 1);
    leftBtn.frame = CGRectMake(0, BTN_Y, BTN_WIDTH, 44*IPHONE6_XISHU);
    sLine.frame = CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width, hLine.frame.origin.y + hLine.frame.size.height, 1, bgImageView.frame.size.height - hLine.frame.origin.y - hLine.frame.size.height);
    rightBtn.frame = CGRectMake(sLine.frame.origin.x + sLine.frame.size.width, BTN_Y, BTN_WIDTH, 44*IPHONE6_XISHU);
    
}


- (void)clickaction:(UIButton *)sender{
    if (sender.tag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:QUIT_BINDING_PAGE object:nil];
        
    }
    self.hidden = YES;
    
}


@end
