//
//  PromptBoxView_newVersion.m
//  browser
//
//  Created by caohechun on 14-2-26.
//
//

#import "PromptBoxView_newVersion.h"

@implementation PromptBoxView_newVersion

- (void)dealloc
{
    self.BGImageView = nil;
    self.confirmBtn  = nil;
    self.cancelBtn = nil;
    self.contentTF = nil;
    horizontalLineView = nil;
    verticalLineView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:0.8];
        
        _BGImageView = [[UIImageView alloc] init];
        _BGImageView.backgroundColor = [UIColor whiteColor];
        _BGImageView.layer.cornerRadius = 10.0f;
        _BGImageView.userInteractionEnabled = YES;
        
        _titile = [[UILabel alloc]init];
        _titile.text = @"发现新版本！";
        _titile.font = [UIFont systemFontOfSize:17];
        _titile.textAlignment = NSTextAlignmentCenter;
        
        titleLine = [[UIImageView alloc] init];
        SET_IMAGE(titleLine.image, @"cuttingLine.png");
 
        _contentTF = [[UITextView alloc]init];
        _contentTF.font = [UIFont boldSystemFontOfSize:15.0f];
        _contentTF.showsVerticalScrollIndicator = YES;
        _contentTF.userInteractionEnabled = YES;
        _contentTF.editable = YES;
        _contentTF.scrollEnabled = YES;
        _contentTF.delegate = self;
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"升级" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:35.0/255 green:96.0/255 blue:254.0/255 alpha:1.0] forState:UIControlStateNormal];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:35.0/255 green:96.0/255 blue:254.0/255 alpha:1.0] forState:UIControlStateNormal];
        
        horizontalLineView = [[UIImageView alloc] init];
        SET_IMAGE(horizontalLineView.image, @"cuttingLine.png");
        verticalLineView = [[UIImageView alloc] init];
        SET_IMAGE(verticalLineView.image, @"verticalLine.png");
     
        [_BGImageView addSubview:_titile];
        [_BGImageView addSubview:titleLine];
        [_BGImageView addSubview:_contentTF];
        [_BGImageView addSubview:_confirmBtn];
        [_BGImageView addSubview:_cancelBtn];
        [_BGImageView addSubview:horizontalLineView];
        [_BGImageView addSubview:verticalLineView];
        [self addSubview:_BGImageView];

    }
    return self;
}

- (void)layoutSubviews
{
    _BGImageView.frame = CGRectMake(0, 0, 270, 290);
    _BGImageView.center = self.center;
    _titile.frame =  CGRectMake(0, 12, 270, 20);
    titleLine.frame = CGRectMake(0, _titile.frame.origin.y + _titile.frame.size.height + 10, _BGImageView.frame.size.width, 1);
    _contentTF.frame = CGRectMake(11, 45, _BGImageView.frame.size.width-22, 180);
    _cancelBtn.frame = CGRectMake(0, _contentTF.frame.origin.y + _contentTF.frame.size.height + 20, 134, 45);
    _confirmBtn.frame = CGRectMake(136, _cancelBtn.frame.origin.y, 134, 45);
    horizontalLineView.frame = CGRectMake(0, _contentTF.frame.origin.y+_contentTF.frame.size.height+19, _BGImageView.frame.size.width, 1);
    verticalLineView.frame = CGRectMake(135, horizontalLineView.frame.origin.y, 1, 46);

}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
