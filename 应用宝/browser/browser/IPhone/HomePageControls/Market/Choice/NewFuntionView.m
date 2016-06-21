//
//  NewFuntionView.m
//  browser
//
//  Created by caohechun on 15/1/6.
//
//

#import "NewFuntionView.h"
#import "IphoneAppDelegate.h"

@interface NewFuntionButton : UIButton

@end

@implementation NewFuntionButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    IphoneAppDelegate *appDelegate = (IphoneAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.isSafeURL) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:28/2];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        self.titleLabel.frame = CGRectMake(self.frame.size.height + 22/2*PHONE_SCALE_PARAMETER, 0, self.frame.size.width - self.imageView.frame.size.width - 22/2*PHONE_SCALE_PARAMETER, self.frame.size.height);
    }else{
        
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.frame = CGRectMake(0, 0, 45, 45);
        self.titleLabel.frame = CGRectMake(0, self.imageView.bounds.size.width+self.imageView.frame.origin.y + 7, self.imageView.frame.size.width, 12.0);
    }

    
}

@end


@interface NewFuntionView ()
{
    clickFuntionBlock _block;
}
@end

@implementation NewFuntionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (UIView *)init{
    self = [super init];
    if (self) {
        
        
        IphoneAppDelegate *appDelegate = (IphoneAppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSArray *title = @[@"省钱",@"活动",@"礼包",@"必备"];
        NSArray *imgNames = @[@"entrance-free.png",@"entrance-active.png",@"entrance-gift.png",@"entrance-necessary.png"];
        
        if (appDelegate.isSafeURL) {

#define kBoarderWidth_ 36/2*PHONE_SCALE_PARAMETER
#define kButtonCount_ 3
#define kButtonWidth_ (66/2 + 22/2 + 86/2)*PHONE_SCALE_PARAMETER
#define kClipeWidth_ 36/2*PHONE_SCALE_PARAMETER//((MainScreen_Width - 2*kBoarderWidth_ - kButtonWidth_*kButtonCount_)/(kButtonCount_ - 1))
#define kButtonImageHeight_ 66/2*PHONE_SCALE_PARAMETER
            
            for (int i = 0; i < kButtonCount_ ; i ++) {
                NewFuntionButton *button = [NewFuntionButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(kBoarderWidth_ + i * MainScreen_Width /3, (NEW_FUNCTION_HEIGHT_SAFEURL - kButtonImageHeight_)/2, kButtonWidth_, kButtonImageHeight_);
                button.tag = i + 1;
                [button setTitle:title[i + 1] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setImage:[UIImage imageNamed:imgNames[i + 1]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(goPage:) forControlEvents:UIControlEventTouchUpInside];
                
                if (i<2) {
                    UIImageView *seperateView = [[UIImageView alloc] init];
                    seperateView.image = [UIImage imageNamed:@"cut_41.png"];
                    seperateView.frame = CGRectMake(button.frame.origin.x + button.frame.size.width , button.frame.origin.y, 1, button.frame.size.height);
                    [self addSubview:seperateView];
                }

                
                [self addSubview:button];
            }
        }else{

#define kBoarderWidth 22*PHONE_SCALE_PARAMETER
#define kButtonCount 4
#define kButtonWidth 45*PHONE_SCALE_PARAMETER
#define kClipeWidth ((MainScreen_Width - 2*kBoarderWidth - kButtonWidth*kButtonCount)/(kButtonCount - 1))
            for (int i = 0; i < kButtonCount; i ++) {
                NewFuntionButton *button = [NewFuntionButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(kBoarderWidth + i * (kClipeWidth + kButtonWidth), 17.5, kButtonWidth, 70);
                button.tag = i;
                [button setTitle:title[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(goPage:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
            }
        }

    }
    return self;
}

- (void)goPage:(UIButton *)functionButton{
    _block(functionButton.tag);
}

- (void)setFunctionButtonBlock:(clickFuntionBlock)block{
    _block = block;
}

@end
