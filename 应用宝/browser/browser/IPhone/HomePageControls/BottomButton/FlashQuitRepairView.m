//
//  FlashQuitRepairView.m
//  browser
//
//  Created by 王 毅 on 13-2-1.
//
//

#import "FlashQuitRepairView.h"
#import "PopViewController.h"
@implementation FlashQuitRepairView
@synthesize repairBtn = _repairBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 修复首页
        repairBgImgView = [[UIImageView alloc]init];
        repairBgImgView.backgroundColor = [UIColor whiteColor];
        repairBgImgView.userInteractionEnabled = YES;
        repairBgImgView.layer.cornerRadius = 10.0f;
        [self addSubview:repairBgImgView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = OTHER_TEXT_COLOR;
        titleLabel.text = @"闪退修复";
        [repairBgImgView addSubview:titleLabel];
        
        repairInfoLabel = [[UILabel alloc] init];
        repairInfoLabel.backgroundColor = [UIColor clearColor];
        repairInfoLabel.textColor = OTHER_TEXT_COLOR;
        repairInfoLabel.numberOfLines = 0;
        repairInfoLabel.font = [UIFont systemFontOfSize:15.0f];
        repairInfoLabel.text = @"1.修复开启应用时要求输入账号密码的问题\n2.修复应用启动后立刻退出的问题";
        [repairBgImgView addSubview:repairInfoLabel];
        
        shortLineView = [[UIImageView alloc] init];
        SET_IMAGE(shortLineView.image, @"cuttingLine.png")
        [repairBgImgView addSubview:shortLineView];
        
        repairInfoTipView = [[UIImageView alloc] init];
        SET_IMAGE(repairInfoTipView.image, @"more_attention.png");
        [repairBgImgView addSubview:repairInfoTipView];
        
        infoTipLabel = [[UILabel alloc] init];
        infoTipLabel.backgroundColor = [UIColor clearColor];
        infoTipLabel.textColor = OTHER_TEXT_COLOR;
        infoTipLabel.numberOfLines = 0;
        infoTipLabel.font = [UIFont systemFontOfSize:11.0f];
        infoTipLabel.text = @"仅适用于iOS6.0系统\n请保持手机一直处于wifi状态";
        [repairBgImgView addSubview:infoTipLabel];
        
        self.repairCloseBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.repairCloseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.repairCloseBtn setTitle:@"取消" forState:UIControlStateNormal];
        [repairBgImgView addSubview:self.repairCloseBtn];
        
        self.repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.repairBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.repairBtn setTitle:@"修复" forState:UIControlStateNormal];
        [repairBgImgView addSubview:self.repairBtn];
        
        horizontalLineView = [[UIImageView alloc] init];
        SET_IMAGE(horizontalLineView.image, @"cuttingLine.png");
        verticalLineView = [[UIImageView alloc] init];
        SET_IMAGE(verticalLineView.image, @"verticalLine.png");
        [repairBgImgView addSubview:horizontalLineView];
        [repairBgImgView addSubview:verticalLineView];
        
        // 修复中
        activityIndicator = [[UIActivityIndicatorView alloc]init];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.hidden = YES;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [repairBgImgView addSubview:activityIndicator];
        
        self.repairLabel = [[UILabel alloc]init];
        self.repairLabel.text = @"修复中，请稍候...";
        self.repairLabel.backgroundColor = [UIColor clearColor];
        self.repairLabel.textColor = OTHER_TEXT_COLOR;
        self.repairLabel.hidden = YES;
        self.repairLabel.numberOfLines = 0;
        self.repairLabel.textAlignment = NSTextAlignmentCenter;
        [repairBgImgView addSubview:self.repairLabel];
        
        // lesson
        self.lessonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.lessonButton setTitle:@"查看" forState:UIControlStateNormal];
        [self.lessonButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.lessonButton.hidden = YES;
        [self.lessonButton addTarget:self action:@selector(showRepairLesson) forControlEvents:UIControlEventTouchUpInside];
        [repairBgImgView addSubview:self.lessonButton];
        
    }
    return self;
}
- (void)layoutSubviews{
    // repairStateFlag 0:readyView 1:repairingView 2:success 3:faild
    if (repairStateFlag==0) {
        repairBgImgView.frame = CGRectMake(0, 0, 270, 235);
        repairBgImgView.center = self.center;
        
        titleLabel.frame = CGRectMake(0, 10, repairBgImgView.frame.size.width, 25);
        repairInfoLabel.frame = CGRectMake(22, 45, 226, 75);
        shortLineView.frame = CGRectMake(22, repairInfoLabel.frame.origin.y+repairInfoLabel.frame.size.height+14, 220, 1);
        repairInfoTipView.frame = CGRectMake(40, shortLineView.frame.origin.y+shortLineView.frame.size.height+12, 32, 32);
        infoTipLabel.frame = CGRectMake(87, shortLineView.frame.origin.y+shortLineView.frame.size.height+12, 145, 30);
        horizontalLineView.frame = CGRectMake(0, infoTipLabel.frame.origin.y+infoTipLabel.frame.size.height+17, repairBgImgView.frame.size.width, 1);
        verticalLineView.frame = CGRectMake(135, horizontalLineView.frame.origin.y, 1, 40);
        self.repairCloseBtn.frame = CGRectMake(0, horizontalLineView.frame.origin.y, 134, repairBgImgView.frame.size.height-horizontalLineView.frame.origin.y);
        self.repairBtn.frame = CGRectMake(136, horizontalLineView.frame.origin.y, 134, repairBgImgView.frame.size.height-horizontalLineView.frame.origin.y);
    }
    else if (repairStateFlag == 1)
    {
        repairBgImgView.frame = CGRectMake(0, 0, 150, 100);
        repairBgImgView.center = self.center;
        
        activityIndicator.frame = CGRectMake(55, 20, 40, 40);
        self.repairLabel.frame = CGRectMake(0, 60, repairBgImgView.frame.size.width, 15);
    }
    else if (repairStateFlag == 2)
    {
        repairBgImgView.frame = CGRectMake(0, 0, 150, 100);
        repairBgImgView.center = self.center;
        
        self.repairLabel.frame = CGRectMake(0, 15, repairBgImgView.frame.size.width, 25);
        horizontalLineView.frame = CGRectMake(0, 55, repairBgImgView.frame.size.width, 1);
        self.repairCloseBtn.frame = CGRectMake(0, horizontalLineView.frame.origin.y+1, repairBgImgView.frame.size.width, 44);
    }
    else if (repairStateFlag == 3)
    {
        repairBgImgView.frame = CGRectMake(0, 0, 270, 130);
        repairBgImgView.center = self.center;
        
        self.repairLabel.frame = CGRectMake(0, 25, repairBgImgView.frame.size.width, 34);
        horizontalLineView.frame = CGRectMake(0, repairBgImgView.frame.size.height-45, repairBgImgView.frame.size.width, 1);
        verticalLineView.frame = CGRectMake(repairBgImgView.frame.size.width*0.5, horizontalLineView.frame.origin.y, 1, 44);
        self.repairCloseBtn.frame = CGRectMake(0, repairBgImgView.frame.size.height-45, repairBgImgView.frame.size.width*0.5, 44);
        self.lessonButton.frame = CGRectMake(_repairCloseBtn.frame.size.width, _repairCloseBtn.frame.origin.y, _repairCloseBtn.frame.size.width, 44);
    }
    
}

#pragma mark - Utility
- (void)isFirstRepairOrRepairAgain:(int)index{
    //0:修复界面 1:失败界面
    if (index == 0) {
    }else{
        self.repairBtn.hidden = YES;
    }
}

- (void)closeLesson{
    if (self.lessonDelegate && [self.lessonDelegate respondsToSelector:@selector(closeLesson)]) {
        [self.lessonDelegate closeLesson];
    }
}
#pragma mark - Show Or Hide

- (void)isShowReadyOrIng:(int)index{
    //0:ready repair 1:repairing repair 1:repairing 2:success 3:fail
    repairStateFlag = index;
    switch (index) {
        case 0:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showRepairingView:NO];
                [self showRepairReadyView:YES];
                self.lessonButton.hidden = YES;
                [self layoutSubviews];
            });
        }
            break;
        case 1:{
            [self startRepairingAnimation];
        }
        default:
            break;
    }
}
- (void)startRepairingAnimation{
    [self showRepairReadyView:NO];
    [self showRepairingView:YES];
    self.lessonButton.hidden = YES;
    [self layoutSubviews];
}

-(void)showRepairingResult:(NSInteger)result
{ // 0:success 1:fail
    [self showRepairReadyView:NO];
    [self showRepairingView:NO];
    [self showRepairedView:result];
    
    [self layoutSubviews];
    
}

- (void)showRepairReadyView:(BOOL)flag
{
    titleLabel.hidden = !flag;
    repairInfoLabel.hidden = !flag;
    shortLineView.hidden = !flag;
    repairInfoTipView.hidden = !flag;
    infoTipLabel.hidden = !flag;
    horizontalLineView.hidden = !flag;
    verticalLineView.hidden = !flag;
    self.repairCloseBtn.hidden = !flag;
    self.repairBtn.hidden = !flag;
}

-(void)showRepairingView:(BOOL)flag
{
    if (flag) {
        self.repairLabel.text = @"修复中，请稍候...";
    }
    
    activityIndicator.hidden = !flag;
    self.repairLabel.hidden = !flag;
    self.repairLabel.font = [UIFont systemFontOfSize:13.0f];
    flag?[activityIndicator startAnimating]:[activityIndicator stopAnimating];
}

-(void)showRepairedView:(NSInteger)flag
{ // 0:success 1:fail
    if (flag == 0) {
        self.repairLabel.text = @"修复成功";
        self.repairLabel.hidden = NO;
        horizontalLineView.hidden = NO;
        self.repairCloseBtn.hidden = NO;
        
        repairStateFlag = 2;
    }
    else
    {
        self.repairLabel.text = @"闪退修复失败\n多次修复失败建议尝试其他方法";
        self.repairLabel.font = [UIFont systemFontOfSize:14.0f];
        self.repairLabel.hidden = NO;
        horizontalLineView.hidden = NO;
        verticalLineView.hidden = NO;
        self.repairCloseBtn.hidden = NO;
        self.lessonButton.hidden = NO;
        
        repairStateFlag = 3;
    }
}

- (void)showRepairLesson{
    if (self.lessonDelegate && [self.lessonDelegate respondsToSelector:@selector(openLesson)]) {
        [self.lessonDelegate openLesson];
    }
}

- (void)dealloc{

}

@end
