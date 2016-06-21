//
//  MaskAlertView.m
//  MyHelper
//
//  Created by liguiyang on 15-1-8.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "MaskAlertView.h"

@interface MaskAlertView ()<UITextViewDelegate>
{
    // 更新AlertView
    UILabel     *titleLabel;
    UITextView  *contentTextView;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UILabel  *headLine;
    UILabel  *bottomLine;
    UILabel  *verticalLine;
    UIView   *alertBgView;
    BOOL forceFlag;
    
    //loading AlertView
    UIView *_loadingView;
    UILabel * _label;
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, strong) NSDictionary *infoDic;

@end

@implementation MaskAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = hllColor(30.0, 30.0, 30.0, 0.8);
        UIColor *lineColor = hllColor(199.0, 199.0, 199.0, 1.0);
        
        // DataSource
        headLine = [[UILabel alloc] init];
        headLine.backgroundColor = lineColor;
        bottomLine = [[UILabel alloc] init];
        bottomLine.backgroundColor = lineColor;
        verticalLine = [[UILabel alloc] init];
        verticalLine.backgroundColor = lineColor;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        
        contentTextView = [[UITextView alloc] init];
        contentTextView.showsVerticalScrollIndicator = YES;
        contentTextView.userInteractionEnabled = YES;
        contentTextView.editable = YES;
        contentTextView.scrollEnabled = YES;
        contentTextView.delegate = self;
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:hllColor(35.0, 96.0, 254.0, 1.0) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setTitle:@"升级" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:hllColor(35.0, 96.0, 254.0, 1.0) forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        alertBgView = [[UIView alloc] init];
        alertBgView.layer.cornerRadius = 10.0f;
        alertBgView.backgroundColor = [UIColor whiteColor];
        
        [alertBgView addSubview:titleLabel];
        [alertBgView addSubview:headLine];
        [alertBgView addSubview:contentTextView];
        [alertBgView addSubview:bottomLine];
        [alertBgView addSubview:cancelBtn];
        [alertBgView addSubview:verticalLine];
        [alertBgView addSubview:confirmBtn];
        [self addSubview:alertBgView];
        
        // UI loading
        _loadingView = [[UIView alloc]init];
        _loadingView.backgroundColor = [UIColor whiteColor];
        _loadingView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _loadingView.layer.borderWidth = 1;
        _loadingView.layer.cornerRadius = 5;
        
        _label = [[UILabel alloc]init];
        _label.backgroundColor = [UIColor clearColor];
        _label.text = [NSString stringWithFormat:@"正在检验更新..."];
        _label.textAlignment = NSTextAlignmentCenter;
        
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicator.hidden = YES;
        [_activityIndicator startAnimating];
        
        [_loadingView addSubview:_label];
        [_loadingView addSubview:_activityIndicator];
        [self addSubview:_loadingView];
        
        //
        [self setCustomFrame];
    }
    
    return self;
}

- (void)setCustomFrame
{
    self.frame = MainScreeFrame;
    alertBgView.frame = CGRectMake(0, 0, 270, 290);
    alertBgView.center = self.center;
    titleLabel.frame =  CGRectMake(0, 12, 270, 20);
    headLine.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, alertBgView.frame.size.width, 0.5);
    contentTextView.frame = CGRectMake(11, 45, alertBgView.frame.size.width-22, 180);
    
    if (forceFlag) {
        confirmBtn.frame = CGRectMake(0, contentTextView.frame.origin.y + contentTextView.frame.size.height + 20, alertBgView.frame.size.width, 45);
    }
    else
    {
        cancelBtn.frame = CGRectMake(0, contentTextView.frame.origin.y + contentTextView.frame.size.height + 20, 134, 45);
        confirmBtn.frame = CGRectMake(136, contentTextView.frame.origin.y + contentTextView.frame.size.height + 20, 134, 45);
    }
    
    bottomLine.frame = CGRectMake(0, contentTextView.frame.origin.y+contentTextView.frame.size.height+19, alertBgView.frame.size.width, 0.5);
    verticalLine.frame = CGRectMake(135, bottomLine.frame.origin.y, 0.5, 46);
    
    _loadingView.frame = CGRectMake((MainScreen_Width-150)*0.5, (MainScreen_Height - 20-100)*0.5, 150, 100);
    _activityIndicator.frame = CGRectMake(60, 20, 30, 30);
    _label.frame = CGRectMake(0, 55, 150, 30);
}

#pragma mark Utility

- (void)cancelBtnClick:(id)sender
{
    self.hidden = YES;
}

- (void)confirmBtnClick:(id)sender
{
    self.hidden = !forceFlag; // 强制更新 则不消失
    
    if (_delegate && [_delegate respondsToSelector:@selector(maskAlertViewConfirmButtonClick:)]) {
        [self.delegate maskAlertViewConfirmButtonClick:_infoDic];
    }
}

- (void)setUpdateInfo:(NSDictionary *)updateDic
{
    // title
    NSDictionary *appInfoDic = [updateDic objectForKey:@"appinfo"];
    titleLabel.text = [NSString stringWithFormat:@"发现新版本%@",[appInfoDic objectForKey:@"displayversion"]];
    
    // content
    UIFont *font = [UIFont systemFontOfSize:15.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 2.0f;
    
    NSArray *contentArr = [updateDic objectForKey:@"upgradeinfo"];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"更新内容\n" attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font}];
    for (int i=0 ; i<contentArr.count; i++) {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:contentArr[i] attributes:@{NSFontAttributeName:font}];
        [content appendAttributedString:attrStr];
        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    contentTextView.attributedText = content;
}

- (void)setMaskAlertViewType:(AlertViewType)alertType updateInfo:(NSDictionary *)infoDic;
{
    self.infoDic = infoDic;
    
    if (alertType == AlertViewUpdate) {
        // text
        forceFlag = ([[_infoDic objectForKey:@"forcedupgrade"] isEqualToString:@"y"])?YES:NO;
        [self setUpdateInfo:_infoDic];
        
        // force
        verticalLine.hidden = forceFlag;
        cancelBtn.hidden = forceFlag;
        
        //
        self.hidden = NO;
        alertBgView.hidden = NO;
        _loadingView.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        alertBgView.hidden = YES;
        _loadingView.hidden = NO;
    }
    
    [self setCustomFrame];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
