//
//  AppInforView.m
//  browser
//
//  Created by caohechun on 14-4-2.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppInforView.h"
#import "SearchResultCell.h"
#import "AppStatusManage.h"
@interface AppInforView()
{
    UILabel *nameLabel;
    UILabel *praiseCountLabel;
    UILabel *downloadCountLabel;
    UIImageView *praiseCountImageView;
    UIImageView *downloadCountImageView;
}
@property (nonatomic,retain) NSString *appVersion;
@property (nonatomic,retain) NSString *appPrice;

@end
@implementation AppInforView
- (void)dealloc{

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        iconImageView = [[UIImageView alloc]initWithImage:_StaticImage.icon_60x60];
        iconImageView.layer.cornerRadius = 10;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderWidth = 0.5;
        iconImageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        //初始化该页面显示的appID;
        self.appID = nil;
        
        self.appStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.appStateButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.appStateButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.appStateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        [self.appStateButton setTitle:@"免费" forState:UIControlStateNormal];
        
//        [self.appStateButton setImage:LOADIMAGE(@"state_download", @"png") forState:UIControlStateNormal];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
//        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.numberOfLines = 2;
        nameLabel.backgroundColor = [UIColor clearColor];
#define LABEL_FONT_SIZE 12
        
        praiseCountLabel = [[UILabel alloc]init];
        praiseCountLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        praiseCountLabel.textAlignment = NSTextAlignmentLeft;
        praiseCountLabel.textColor = OTHER_TEXT_COLOR;
        praiseCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        praiseCountLabel.numberOfLines = 1;
        praiseCountLabel.backgroundColor = [UIColor clearColor];
        
        downloadCountLabel = [[UILabel alloc]init];
        downloadCountLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        downloadCountLabel.textAlignment = NSTextAlignmentLeft;
        downloadCountLabel.textColor = OTHER_TEXT_COLOR;
        downloadCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        downloadCountLabel.numberOfLines = 1;
        downloadCountLabel.backgroundColor = [UIColor clearColor];
        
        praiseCountImageView = [[UIImageView alloc]init];
        downloadCountImageView = [[UIImageView alloc]init];
        SET_IMAGE(praiseCountImageView.image, @"zan.png");
        SET_IMAGE(downloadCountImageView.image,@"totle_down.png");
        
        [self addSubview:iconImageView];
        [self addSubview:nameLabel];
        [self addSubview:self.appStateButton];
        [self addSubview:praiseCountLabel];
        [self addSubview:downloadCountLabel];
        [self addSubview:praiseCountImageView];
        [self addSubview:downloadCountImageView];
    }
    return self;
}
- (void)layoutSubviews{
    
#define label_space_y 7
#define label_font_size 12
    iconImageView.frame = CGRectMake(21, 18, 60, 60);
    //    self.appStateButton.frame = CGRectMake(self.frame.size.width - 17 - 32, 35, 32, 45);
    
    self.appStateButton.frame = CGRectMake(self.frame.size.width - 53 - 25, iconImageView.center.y - 27/2, 53, 27);
    nameLabel.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 13, 18, self.frame.size.width-(iconImageView.frame.origin.x + iconImageView.frame.size.width + 13) - (self.frame.size.width - self.appStateButton.frame.origin.x), 38);
    praiseCountImageView.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 8, 15, 15);
    praiseCountLabel.frame = CGRectMake(praiseCountImageView.frame.origin.x + praiseCountImageView.frame.size.width + 3, praiseCountImageView.frame.origin.y+1 , 55, label_font_size);
    downloadCountImageView.frame = CGRectMake(praiseCountLabel.frame.origin.x + praiseCountLabel.frame.size.width , praiseCountLabel.frame.origin.y , 15, 15);
    downloadCountLabel.frame = CGRectMake(downloadCountImageView.frame.origin.x + downloadCountImageView.frame.size.width + 3, downloadCountImageView.frame.origin.y+1 , 70, label_font_size);
}

- (void)initAppInforWithData:(NSDictionary *)dataDic{
    //待确定数据类型

    NSDictionary *tmpDic = [dataDic objectForKey:@"data"];
    nameLabel.text = [tmpDic objectForKey:@"appname"];
    praiseCountLabel.text = CountConver([tmpDic objectForKey:@"appreputation"]) ;
    downloadCountLabel.text = CountConver([tmpDic objectForKey:@"appdowncount"]);
    self.appID = [tmpDic objectForKey:@"appid"];
    self.appPrice = [tmpDic objectForKey:APPPRICE];
    //2.7
    self.appVersion = [tmpDic objectForKey:@"appversion"];//appversion,displayversion
    [self initDownloadButtonState];
    
}

- (void)initDownloadButtonState{
    
    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:self.appID appVersion:self.appVersion];
    //    UIImage *stateImg = nil;
    NSString *title = nil;
    
    [self.appStateButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    switch (status) {
        case STATE_DOWNLOAD:{
            title= [_appPrice isEqualToString:@"0.00"]?@"免费":_appPrice;
            if ([_appPrice isEqualToString:@"0.00"]) {
                [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
                [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
                
            }else{
                [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"charge.png"] forState:UIControlStateNormal];
                [self.appStateButton setBackgroundImage:[UIImage imageNamed:@"chargess.png"] forState:UIControlStateHighlighted];
            }
            //            NSString*mianfei=@"免费";
//            [self.appStateButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_UPDATE:{
            title=@"更新";
//            [self.appStateButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
            //            self.priceLabel.text = @"";
        }
            break;
        case STATE_INSTALL:{
            title=@"安装";
            
//            [self.appStateButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            //            self.priceLabel.text = @"";
        }
            break;
        case STATE_REINSTALL:{
            title = @"重新安装";
//            [self.appStateButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            //            self.priceLabel.text = @"";
        }
            break;
        case STATE_DOWNLONGING:{
            title = @"下载中";
//            [self.appStateButton addTarget:self action:@selector(downloadingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            //            self.priceLabel.text = @"";
        }
            break;
        default:
            break;
    }
    
    [self.appStateButton setTitle:title forState:UIControlStateNormal];
    
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateNormal];
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateDisabled];
}
- (NSString *)getPraiseCount{
    return praiseCountLabel.text;
}
- (void)resetPraiseCount:(NSString *)count{
    praiseCountLabel.text = count;
}
- (void)setIconImage:(UIImage *)iconImage{
    iconImageView.image  = iconImage;
}


@end
