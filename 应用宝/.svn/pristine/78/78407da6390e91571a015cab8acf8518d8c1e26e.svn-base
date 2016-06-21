//
//  LookInfoAlertView.m
//  browser
//
//  Created by 王 毅 on 13-3-8.
//
//

#import "LookInfoAlertView.h"

@interface LookInfoAlertView (){
    UIImageView *alertImageView;
    UILabel *alertLabel;
    
}
@end

@implementation LookInfoAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        alertImageView = [[UIImageView alloc]init];
        alertLabel.userInteractionEnabled = YES;
        [self addSubview:alertImageView];
        
        //上面的非固定内容文字
        alertLabel = [[UILabel alloc]init];
        alertLabel.numberOfLines = 0;
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:alertLabel];

        SET_IMAGE(alertImageView.image, @"popBG_iphone_ky.png");
        
        alertLabel.font = [UIFont systemFontOfSize:14.0f];

    }
    return self;
}

- (void)layoutSubviews{
    
    alertImageView.frame = self.bounds;//210-140

    alertLabel.frame = CGRectMake(0, 0, 200, 80);

}

//对外接口，可以设置弹框上面的费固定文字，以及下面的按钮显示状况
- (void)setAlertLabelText:(NSString*)string{
    
    if (string  && ![string isEqualToString:@""]) {
        alertLabel.text = [NSString stringWithFormat:@"%@",string];
    }
    
}

- (void)dealloc{
}
@end
