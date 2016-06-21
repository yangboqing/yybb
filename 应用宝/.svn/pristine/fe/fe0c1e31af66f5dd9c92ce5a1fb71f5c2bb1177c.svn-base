//
//  DownLoadManageTopView.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "DownLoadManageTopView.h"
#import "UIImageEx.h"
#import "BppDistriPlistManager.h"
#import "IphoneAppDelegate.h"


@interface DownLoadManageTopView (){
    UIImageView *bgImageView;
    UIImageView *spaceBtnLine1;
    UIImageView *spaceBtnLine2;
    
    // UpdateIcon
    UIImage *badgeImg;
    UIImage *badgeImg2;
    UILabel *badgeLabel;
    UIImageView *badgeImgView;
}

@end

#define selectcolor MY_YELLOW_COLOR
#define unselectcolor [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1]
//新春版
//#define unselectcolor hllColor(244, 188, 184, 1)
//
//#define selectcolor hllColor(255, 255, 255, 1)

#define MINFONT 15.0
#define MAXFONT 18.0

@implementation DownLoadManageTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //2.7
        badgeImg = [UIImage imageNamed:@"badge.png"];
        badgeImg2 = [UIImage imageNamed:@"badge2.png"];
        
        bgImageView = [[UIImageView alloc]init];
        bgImageView.userInteractionEnabled = YES;
        if (!IOS7) {
            bgImageView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        }
        [self addSubview:bgImageView];
        
        self.downingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.downingBtn.backgroundColor = [UIColor clearColor];
        self.downingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.downingBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.downingBtn addTarget:self action:@selector(manageDowningClick:) forControlEvents:UIControlEventTouchUpInside];
        
        spaceBtnLine1 = [[UIImageView alloc] init];
        spaceBtnLine1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        //新春版
        spaceBtnLine1.image = [UIImage imageNamed:@"cut_41.png"];
        
        self.downedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.downedBtn.backgroundColor = [UIColor clearColor];
        self.downedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.downedBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.downedBtn addTarget:self action:@selector(manageDownedClick:) forControlEvents:UIControlEventTouchUpInside];
        
        spaceBtnLine2 = [[UIImageView alloc] init];
        spaceBtnLine2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        //新春版
        spaceBtnLine2.image = [UIImage imageNamed:@"cut_41.png"];
        
        self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.updateBtn.backgroundColor = [UIColor clearColor];
        [self.updateBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.updateBtn addTarget:self action:@selector(manageUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.font = [UIFont systemFontOfSize:14.0f];
        badgeLabel.textColor = [UIColor whiteColor];
        //新春版
//        badgeLabel.textColor = NEWYEAR_RED;

        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        
        badgeImgView = [[UIImageView alloc] init];
        
        [self.updateBtn addSubview:badgeImgView];
        [self.updateBtn addSubview:badgeLabel];
        
        
        [bgImageView addSubview:_downingBtn];
        [bgImageView addSubview:_downedBtn];
//        [bgImageView addSubview:_updateBtn];
        [bgImageView addSubview:spaceBtnLine1];
        [bgImageView addSubview:spaceBtnLine2];
        
        self.downingBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        self.downedBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        
        [self.downingBtn setTitle:[NSString stringWithFormat:@"下载中"] forState:UIControlStateNormal];
        [self.downedBtn setTitle:[NSString stringWithFormat:@"已下载"] forState:UIControlStateNormal];
        [self.updateBtn setTitle:[NSString stringWithFormat:@"更   新"] forState:UIControlStateNormal];
        
        
        [self setViewFrame:frame];
        
    }
    
    return self;
}

#pragma mark - 外露接口
- (void)refreshManageTopButton{
    
    int downingCount = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    int downOverCount = [BppDistriPlistManager getManager].distriAlReadyDownloadedPlists.count;
    
    // 下载中
    if (downingCount > 0) {
        [self.downingBtn setTitle:[NSString stringWithFormat:@"下载中(%d)",downingCount] forState:UIControlStateNormal];
    }
    else
    {
        [self.downingBtn setTitle:@"下载中" forState:UIControlStateNormal];
    }
    
    // 已下载
    if (downOverCount > 0) {
        [self.downedBtn setTitle:[NSString stringWithFormat:@"已下载(%d)",downOverCount] forState:UIControlStateNormal];
    }
    else
    {
        [self.downedBtn setTitle:@"已下载" forState:UIControlStateNormal];
    }
    
    // 更新
    [self.updateBtn setTitle:@"更 新" forState:UIControlStateNormal];
    
    //MY助手弃用badge
//    [self setUpdateBadgeNumber];
}

- (void)touchTopButton:(NSString*)pageName{
    if ([pageName isEqualToString:@"downing"]) {
        [self manageDowningClick:nil];
    }
    else if ([pageName isEqualToString:@"downover"]){
        [self manageDownedClick:nil];
    }
    else if ([pageName isEqualToString:@"update"])
    {
        [self manageUpdateClick:nil];

    }
}

#pragma mark - ButtonActions

- (void)manageDowningClick:(id)sender{
    
    [self.downingBtn setTitleColor:selectcolor forState:UIControlStateNormal];
    [self.downedBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    self.downingBtn.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    self.downedBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
//    [self setUpdateBadgeNumber];
    if (self.topViewDelegate && [self.topViewDelegate respondsToSelector:@selector(downloadManageTopButtonClick:)]) {
        [self.topViewDelegate downloadManageTopButtonClick:@"downing"];
    }
}

- (void)manageDownedClick:(id)sender{
    
    [self.downingBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    [self.downedBtn setTitleColor:selectcolor forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    self.downingBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    self.downedBtn.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
//    [self setUpdateBadgeNumber];
    if (self.topViewDelegate && [self.topViewDelegate respondsToSelector:@selector(downloadManageTopButtonClick:)]) {
        [self.topViewDelegate downloadManageTopButtonClick:@"downed"];
    }
}

- (void)manageUpdateClick:(id)sender
{
    [self.downingBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    [self.downedBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:selectcolor forState:UIControlStateNormal];
    self.downingBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    self.downedBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    
//    [self setUpdateBadgeNumber];
    if (self.topViewDelegate && [self.topViewDelegate respondsToSelector:@selector(downloadManageTopButtonClick:)]) {
        [self.topViewDelegate downloadManageTopButtonClick:@"update"];
    }
}

#pragma mark -  Utility

-(void)setUpdateBadgeNumber
{
    
    int updateCount = 0;
    
    if (updateCount == 0) {
        badgeImgView.frame = CGRectZero;
        badgeLabel.frame = CGRectZero;
    }
    else if (updateCount < 10) {
        badgeImgView.image = badgeImg;
        badgeImgView.frame = CGRectMake(75, 12, 20, 20);
        badgeLabel.frame = CGRectMake(75, 11, 20, 20);
        
    }
    else
    {
        badgeImgView.image = badgeImg2;
        badgeImgView.frame = CGRectMake(75, 12, 30, 22);
        badgeLabel.frame = CGRectMake(75, 11, 30, 22);
    }
    
    badgeLabel.text = [NSString stringWithFormat:@"%d",updateCount];
}

- (void)setViewFrame:(CGRect)tmpFrame{
    
    bgImageView.frame = tmpFrame;
    
#define BUTTON_HEIGHT 44
#define BUTTON_WIDTH 106
#define BUTTON_Y 0
#define SIDE_WIDTH 1
    
    self.downingBtn.frame = CGRectMake((tmpFrame.size.width-2*BUTTON_WIDTH-1*SIDE_WIDTH)/2 - 50, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
    spaceBtnLine1.frame = CGRectMake(self.downingBtn.frame.origin.x+BUTTON_WIDTH , 11, 1, 22);
    self.downedBtn.frame = CGRectMake(self.downingBtn.frame.origin.x+BUTTON_WIDTH+SIDE_WIDTH, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    //My助手不显示更新,暂时注释掉
//    spaceBtnLine2.frame = CGRectMake(self.downedBtn.frame.origin.x+BUTTON_WIDTH, 11, 1, 22);
//    
//    self.updateBtn.frame = CGRectMake(self.downedBtn.frame.origin.x+BUTTON_WIDTH+SIDE_WIDTH, BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
}

- (void)dealloc{
    bgImageView  = nil;
    spaceBtnLine1 = nil;
    spaceBtnLine2 = nil;
}

@end
