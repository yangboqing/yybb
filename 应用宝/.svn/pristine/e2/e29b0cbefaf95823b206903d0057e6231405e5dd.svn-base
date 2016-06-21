//
//  BackgroundDownloadAlertView.m
//  browser
//
//  Created by 王 毅 on 13-8-21.
//
//

#import "BackgroundDownloadAlertView.h"


@interface BackgroundDownloadAlertView (){
    
    UIImageView *alertImageView;
    UILabel *alertLabel;
    
}

@end

@implementation BackgroundDownloadAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //背景图
        alertImageView = [[UIImageView alloc]init];
        alertImageView.backgroundColor = [UIColor clearColor];
        alertLabel.userInteractionEnabled = YES;
        [self addSubview:alertImageView];
        
        
        //上面的非固定内容文字
        alertLabel = [[UILabel alloc]init];
        alertLabel.numberOfLines = 0;
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:alertLabel];
        
        SET_IMAGE(alertImageView.image, @"notice_BG_iphone.png");
        
        alertLabel.font = [UIFont systemFontOfSize:14.0f];
        
    }
    return self;
}

- (void)layoutSubviews{
    alertImageView.frame = self.bounds;
    
    alertLabel.frame = CGRectMake(10, 30, 188, 80);
    
    
}
//对外接口，可以设置弹框上面的费固定文字，以及下面的按钮显示状况
- (void)setUseMainAudioAlertLabelText:(int)index{
    
    switch (index) {
        case 1:
            alertLabel.text = @"此选项会影响到正在运行\n的音频应用,请酌情开启";
            break;
        case 2:
            alertLabel.text = @"仅在无音频类应用运行时\n保持后台下载";
            break;
        case 3:
            alertLabel.text = @"仅保持后台下载几分钟";
            break;
            
        default:
            break;
    }
    
    CGRect textRect = [alertLabel textRectForBounds:CGRectMake(0, 0, 188, 999) limitedToNumberOfLines:0];
    alertLabel.frame = CGRectMake(10, (self.frame.size.height - textRect.size.height)/2 - 37, 188, textRect.size.height);
}


@end
