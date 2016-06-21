//
//  PromptBoxView.m
//  browser
//
//  Created by admin on 13-9-25.
//
//

#import "PromptBoxView.h"

@implementation PromptBoxView

@synthesize labelString = _labelString, BGImageView = _BGImageView;

- (void)dealloc
{
    self.labelString = nil;
    self.BGImageView = nil;
    self.confirmBtn  = nil;
    horizontalLineView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = POPVIEW_BACKGROUND_COLOR;
        
        _BGImageView = [[UIImageView alloc] init];
        _BGImageView.backgroundColor = [UIColor whiteColor];
        _BGImageView.userInteractionEnabled = YES;
        _BGImageView.layer.cornerRadius = 10.0f;
        [self addSubview:_BGImageView];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.font = [UIFont boldSystemFontOfSize:15.0f];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        [_BGImageView addSubview:_label];

        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:35.0/255 green:96.0/255 blue:254.0/255 alpha:1.0] forState:UIControlStateNormal];
        _confirmBtn.hidden = YES;
        [_BGImageView addSubview:_confirmBtn];
        
        horizontalLineView = [[UIImageView alloc] init];
        SET_IMAGE(horizontalLineView.image, @"cuttingLine.png");
        [_BGImageView addSubview:horizontalLineView];
        
        [self addObserver:self forKeyPath:@"labelString" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    _BGImageView.frame = CGRectMake(0, 0, 270, 105);
    _BGImageView.center = self.center;
    _label.frame = CGRectMake(11, 10, 248, 40);
    horizontalLineView.frame = CGRectMake(0, 59, 270, 1);
    _confirmBtn.frame = CGRectMake(0, 60, 270, 45);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _label.text = [change objectForKey:@"new"];
    _label.font = [UIFont boldSystemFontOfSize:15.0f];
    NSLog(@"%@",[change objectForKey:@"new"]);

    if ([_label.text isEqualToString:@""])
    {
        _confirmBtn.hidden = YES;
    }else{
        _confirmBtn.hidden = NO;
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
