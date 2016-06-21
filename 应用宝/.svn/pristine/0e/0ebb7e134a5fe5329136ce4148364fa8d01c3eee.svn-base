//
//  dowloadCompetAlertView.m
//  browser
//
//  Created by 王毅 on 13-11-11.
//
//

#import "dowloadCompetAlertView.h"

@interface dowloadCompetAlertView (){
    UILabel *appNameLabel;
    UILabel *fixedTextLabel;
}

@end


@implementation dowloadCompetAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        appNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        appNameLabel.textAlignment = NSTextAlignmentRight;
        appNameLabel.backgroundColor = [UIColor clearColor];
        appNameLabel.numberOfLines = 1;
        appNameLabel.font = [UIFont systemFontOfSize:15.0f];
        appNameLabel.textColor = [UIColor whiteColor];
        appNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:appNameLabel];
        
        
        fixedTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        fixedTextLabel.backgroundColor = [UIColor clearColor];
        fixedTextLabel.textAlignment = NSTextAlignmentLeft;
        fixedTextLabel.font = [UIFont systemFontOfSize:15.0f];
        fixedTextLabel.textColor = [UIColor whiteColor];
        fixedTextLabel.numberOfLines = 1;
        [self addSubview:fixedTextLabel];

    }
    return self;
}

- (void)setAppNameLabelFrame:(NSString *)appNameStr fixedText:(NSString *)striing{

    appNameLabel.text = nil;
    fixedTextLabel.text = nil;
    
#define MAX_WIDTH 486/2
#define MIX_WIDTH self.frame.size.width/2
    appNameLabel.text = [NSString stringWithFormat:@"【%@】",appNameStr];
    fixedTextLabel.text = striing;
    appNameLabel.textAlignment = NSTextAlignmentRight;
    CGRect textRect = [appNameLabel textRectForBounds:CGRectMake(0, 0, 999, self.frame.size.height) limitedToNumberOfLines:1];
    CGRect textRect1 = [fixedTextLabel textRectForBounds:CGRectMake(0, 0, 999, self.frame.size.height) limitedToNumberOfLines:1];
    
    
    if (textRect.size.width + textRect1.size.width >= MainScreen_Width) {
        appNameLabel.frame = CGRectMake(0, 0, MAX_WIDTH, self.frame.size.height);
        fixedTextLabel.frame = CGRectMake(MAX_WIDTH, 0, self.frame.size.width - MAX_WIDTH, self.frame.size.height);
    }
    else
    {
        CGFloat x = (MainScreen_Width - (textRect.size.width + textRect1.size.width))/2;
        appNameLabel.frame = CGRectMake(x, 0, textRect.size.width, self.frame.size.height);
        fixedTextLabel.frame = CGRectMake(appNameLabel.frame.origin.x + appNameLabel.frame.size.width, 0, textRect1.size.width, self.frame.size.height);
    }

}

- (void)setDownloadFailMessage:(NSString *)msn{
    
    appNameLabel.text = nil;
    fixedTextLabel.text = nil;
    
    appNameLabel.text = msn;
    appNameLabel.textAlignment = NSTextAlignmentCenter;

    appNameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    fixedTextLabel.frame = CGRectZero;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downAlertClickItselfStaut:)]) {
        [self.delegate downAlertClickItselfStaut:fixedTextLabel.text];
    }
    
}

@end
