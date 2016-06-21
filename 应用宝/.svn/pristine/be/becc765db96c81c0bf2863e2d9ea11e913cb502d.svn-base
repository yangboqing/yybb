//
//  BottomBadge.m
//  browser
//
//  Created by caohechun on 15/6/8.
//
//

#import "DownloadedBadge.h"
#import "BppDistriPlistManager.h"
@implementation DownloadedBadge
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadgeNumber) name:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:nil]; // 每次刷新下载管理顶部导航
        
        
        badgeImgView = [[UIImageView alloc] init];
        badgeImg = [UIImage imageNamed:@"badge.png"];
        badgeImg2 = [UIImage imageNamed:@"badge2.png"];
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:14.0f];
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:badgeImgView];
        [self addSubview:badgeLabel];

    }
    return self;
}
//使badge不影响下边的按钮

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}
- (void)refreshBadgeNumber{
    CGFloat originX = 0;//self.frame.size.width*0.5+7;
    CGFloat originY = 0;//2;
    CGFloat downloaded = [BppDistriPlistManager getManager].distriAlReadyDownloadedPlists.count;
    
    if (downloaded == 0) {
        badgeImgView.frame = CGRectZero;
        badgeLabel.frame = CGRectZero;
    }
    else if (downloaded < 10) {
        badgeImgView.image = badgeImg;
        badgeImgView.frame = CGRectMake(originX, originY, 22, 22);
        badgeLabel.frame = CGRectMake(originX, originY-1, 22, 22);
        
    }
    else
    {
        badgeImgView.image = badgeImg2;
        badgeImgView.frame = CGRectMake(originX, originY, 30, 22);
        badgeLabel.frame = CGRectMake(originX, originY-1, 30, 22);
    }
    
    badgeLabel.text = [NSString stringWithFormat:@"%d",downloaded];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
