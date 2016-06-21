//
//  RequestAppidResultView.m
//  browser
//
//  Created by caohechun on 15/3/18.
//
//

#import "RequestAppidResultView.h"
@interface RequestAppidResultView()
{
    UIImageView *coverView;
    UIButton *handleButton;
}
@end
@implementation RequestAppidResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        
        coverView = [[UIImageView alloc] init];
        coverView.userInteractionEnabled = YES;

        handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        handleButton.backgroundColor = [UIColor clearColor];
        [handleButton addTarget:self action:@selector(handleResult:) forControlEvents:UIControlEventTouchUpInside];
        [coverView addSubview:handleButton];
        
        
        [self addSubview:coverView];
        
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    coverView.frame = CGRectMake(MainScreen_Width - 180, MainScreen_Height - 157, 180, 157);
    handleButton.frame = CGRectMake(0, 0, 180, 157);
}

- (void)showRequestAppidResultViewWithType:(ResuletType)result{
    handleButton.tag = result;
    NSString *imageName = [NSString stringWithFormat:@"cover_%d",result];
    coverView.image = [UIImage imageNamed:imageName];
    
}

- (void)handleResult:(UIButton *)sender{

    if (self.appidResultDelegate &&[self.appidResultDelegate respondsToSelector:@selector(handleAppidResult:)]) {
        self.hidden = YES;
        [self.appidResultDelegate handleAppidResult:sender.tag];
    }
}

@end
