//
//  ResourceHomeBottom.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "ResourceHomeBottom.h"
#import "UIImageEx.h"
#import "IphoneAppDelegate.h"

#define FIRST_BRODER 0//32/2
#define OTHER_BRODER 0//28/2

@implementation ResourceHomeBottom

@synthesize homeBtn = _homeBtn;
@synthesize shareBtn = _shareBtn;
@synthesize downMangerBtn = _downMangerBtn;
@synthesize updataBtn = _updataBtn;
@synthesize moreBtn = _moreBtn;
@synthesize delegate_ = _delegate_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        UIImage *img;
//        UIImage *img1;
//        UIImage *img2;
        if (!IOS7) {
            UIView *bg = [[UIView alloc]init];
            bg.frame = CGRectMake(0, 0, MainScreen_Width, BOTTOM_HEIGHT);
            bg.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
            bg.userInteractionEnabled = YES;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, MainScreen_Width, 0.5)];
            line.backgroundColor = [UIColor colorWithRed:178.0/255 green:178.0/255 blue:178.0/255 alpha:1];
            [bg addSubview:line];
            [self addSubview:bg];
        }
        
        badgeImg = [UIImage imageNamed:@"badge.png"];
        badgeImg2 = [UIImage imageNamed:@"badge2.png"];
        
        // 搜索
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.backgroundColor = [UIColor clearColor];
        
        [LocalImageManager setImageName:@"toolbar_search.png" complete:^(UIImage *image) {
            [self.shareBtn setImage:image forState:UIControlStateNormal];
        }];
        [LocalImageManager setImageName:@"toolbar_search_selected.png" complete:^(UIImage *image) {
            [self.shareBtn setImage:image forState:UIControlStateHighlighted];
            [self.shareBtn setImage:image forState:UIControlStateSelected];
        }];
        
        [self addSubview:self.shareBtn];
        
        // 市场
        self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.homeBtn.backgroundColor = [UIColor clearColor];
//        img = LOADIMAGE(@"toolbar_market", @"png");
//        img1 = LOADIMAGE(@"toolbar_market_selected", @"png");
//        img2 = LOADIMAGE(@"toolbar_market_selected", @"png");
//        
//        [self.homeBtn setImage:img forState:UIControlStateNormal];
//        [self.homeBtn setImage:img2 forState:UIControlStateHighlighted];
//        [self.homeBtn setImage:img1 forState:UIControlStateSelected];
        
        [LocalImageManager setImageName:@"toolbar_market.png" complete:^(UIImage *image) {
            [self.homeBtn setImage:image forState:UIControlStateNormal];
        }];
        [LocalImageManager setImageName:@"toolbar_market_selected.png" complete:^(UIImage *image) {
            [self.homeBtn setImage:image forState:UIControlStateHighlighted];
            [self.homeBtn setImage:image forState:UIControlStateSelected];
        }];
        
        self.homeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.homeBtn];
        
        // 下载管理
        self.downMangerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.downMangerBtn.backgroundColor = [UIColor clearColor];

        
        [LocalImageManager setImageName:@"toolbar_manage.png" complete:^(UIImage *image) {
            [self.downMangerBtn setImage:image forState:UIControlStateNormal];
        }];
        [LocalImageManager setImageName:@"toolbar_manage_selected.png" complete:^(UIImage *image) {
            [self.downMangerBtn setImage:image  forState:UIControlStateHighlighted];
            [self.downMangerBtn setImage:image  forState:UIControlStateSelected];
        }];
        
        [self.downMangerBtn addTarget:self action:@selector(openDownManger:) forControlEvents:UIControlEventTouchUpInside];
        self.downMangerBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.downMangerBtn];
        
        badgeImgView = [[UIImageView alloc] init];
        
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:14.0f];
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self.downMangerBtn addSubview:badgeImgView];
        [self.downMangerBtn addSubview:badgeLabel];
        
        // 发现
        self.updataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.updataBtn.backgroundColor = [UIColor clearColor];

        
        [LocalImageManager setImageName:@"toolbar_discover.png" complete:^(UIImage *image) {
            [self.updataBtn setImage:image forState:UIControlStateNormal];
        }];
        [LocalImageManager setImageName:@"toolbar_discover_selected" complete:^(UIImage *image) {
            [self.updataBtn setImage:image forState:UIControlStateHighlighted];
            [self.updataBtn setImage:image forState:UIControlStateSelected];
        }];
        
        self.updataBtn.adjustsImageWhenHighlighted = NO;
        [self.updataBtn addTarget:self action:@selector(openUpdatePage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.updataBtn];
        
        // 更多
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreBtn.backgroundColor = [UIColor clearColor];
//        img = LOADIMAGE(@"toolbar_more", @"png");
//        img1 = LOADIMAGE(@"toolbar_more_selected", @"png");
//        img2 = LOADIMAGE(@"toolbar_more_selected", @"png");
//        [self.moreBtn setImage:img forState:UIControlStateNormal];
//        [self.moreBtn setImage:img2 forState:UIControlStateHighlighted];
//        [self.moreBtn setImage:img1 forState:UIControlStateSelected];
        
        [LocalImageManager setImageName:@"toolbar_more.png" complete:^(UIImage *image) {
            [self.moreBtn setImage:image forState:UIControlStateNormal];
        }];
        [LocalImageManager setImageName:@"toolbar_more_selected.png" complete:^(UIImage *image) {
            [self.moreBtn setImage:image forState:UIControlStateHighlighted];
            [self.moreBtn setImage:image forState:UIControlStateSelected];
        }];
        
        self.moreBtn.showsTouchWhenHighlighted = YES;
        self.moreBtn.adjustsImageWhenHighlighted = YES;
        [self addSubview:self.moreBtn];
        
        [self setHomeBottomSelectButton:CLICK_HOME_BUTTON];
        

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUpdateBadgeNumber) name:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:nil]; // 每次刷新下载管理顶部导航
        
        // set frame
        float y = 0;//(self.frame.size.height - HEIGHT)/2 + 2;
        float space = (MainScreen_Width-320)/6; // 暂时适配6，设计出图后重新修改
        
        self.homeBtn.frame = CGRectMake(FIRST_BRODER+space, y, BOTTOM_WIDTH, BOTTOM_HEIGHT);
        
        self.updataBtn.frame = CGRectMake(self.homeBtn.frame.origin.x + self.homeBtn.frame.size.width + OTHER_BRODER+space, y, BOTTOM_WIDTH, BOTTOM_HEIGHT);
        
        self.shareBtn.frame = CGRectMake(self.updataBtn.frame.origin.x + self.updataBtn.frame.size.width + OTHER_BRODER+space, y, BOTTOM_WIDTH, BOTTOM_HEIGHT);
        
        self.downMangerBtn.frame = CGRectMake(self.shareBtn.frame.origin.x + self.shareBtn.frame.size.width + OTHER_BRODER+space, y, BOTTOM_WIDTH, BOTTOM_HEIGHT);
        
        self.moreBtn.frame = CGRectMake(self.downMangerBtn.frame.origin.x + self.downMangerBtn.frame.size.width + OTHER_BRODER+space, y, BOTTOM_WIDTH, BOTTOM_HEIGHT);
        

    }
    return self;
}

#pragma mark - Utility

- (void)openUpdatePage:(id)sender{
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(openUpdataPage)]) {
        [self.delegate_ openUpdataPage];
    }
    [self setHomeBottomSelectButton:CLICK_UPDATA_BUTTON];
    
}
- (void)openDownManger:(id)sender{
    [self setHomeBottomSelectButton:CLICK_DOWNLOAD_BUTTON];
    if (self.delegate_ && [self.delegate_ respondsToSelector:@selector(openDownloadPage)]) {
        [self.delegate_ openDownloadPage];
    }

}

//-(void)refreshUpdateBadgeNumber
//{
//    CGFloat originX = _downMangerBtn.frame.size.width*0.5+7;
//    CGFloat originY = 2;
//    int updateCount = 0;
//    
//    if (updateCount == 0) {
//        badgeImgView.frame = CGRectZero;
//        badgeLabel.frame = CGRectZero;
//    }
//    else if (updateCount < 10) {
//        badgeImgView.image = badgeImg;
//        badgeImgView.frame = CGRectMake(originX, originY, 22, 22);
//        badgeLabel.frame = CGRectMake(originX, originY-1, 22, 22);
//        
//    }
//    else
//    {
//        badgeImgView.image = badgeImg2;
//        badgeImgView.frame = CGRectMake(originX, originY, 30, 22);
//        badgeLabel.frame = CGRectMake(originX, originY-1, 30, 22);
//    }
//    
//    badgeLabel.text = [NSString stringWithFormat:@"%d",updateCount];
//}

int _tabBarIndex = 0;
- (void) setHomeBottomSelectButton:(int)flag{
    self.flag = flag;
    _tabBarIndex = flag-CLICK_HOME_BUTTON;
    switch (flag) {
        case CLICK_HOME_BUTTON:
            self.homeBtn.selected = YES;
            self.shareBtn.selected = NO;
            self.updataBtn.selected = NO;
            self.downMangerBtn.selected = NO;
            self.moreBtn.selected = NO;
            break;
        case CLICK_SEARCH_BUTTON:
            self.homeBtn.selected = NO;
            self.shareBtn.selected = YES;
            self.updataBtn.selected = NO;
            self.downMangerBtn.selected = NO;
            self.moreBtn.selected = NO;
            break;
        case CLICK_UPDATA_BUTTON:
            self.homeBtn.selected = NO;
            self.shareBtn.selected = NO;
            self.updataBtn.selected = YES;
            self.downMangerBtn.selected = NO;
            self.moreBtn.selected = NO;
            break;
        case CLICK_DOWNLOAD_BUTTON:
            self.homeBtn.selected = NO;
            self.shareBtn.selected = NO;
            self.updataBtn.selected = NO;
            self.downMangerBtn.selected = YES;
            self.moreBtn.selected = NO;
            break;
        case CLICK_MORE_BUTTON:
            self.homeBtn.selected = NO;
            self.shareBtn.selected = NO;
            self.updataBtn.selected = NO;
            self.downMangerBtn.selected = NO;
            self.moreBtn.selected = YES;
            break;
            
        default:
            break;
    }
    
    // 此时shareBtn 为搜索按钮
    if (self.shareBtn.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ForbidPhoneShakeAction" object:@"NO"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchBecomeFirstResponder" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ForbidPhoneShakeAction" object:@"YES"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignSearchFirstResponder" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:CALL_MOTION_ENDED_ACTION object:nil];
    }
    
    if (self.moreBtn.selected) {
        // 更新更多界面缓存数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCacheSizeLabel" object:nil];
    }
}

- (void) dealloc{
    self.shareBtn = nil;
}


@end
