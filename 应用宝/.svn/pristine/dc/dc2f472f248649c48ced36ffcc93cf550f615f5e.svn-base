//
//  SearchRuseltCell.m
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "SearchResultCell.h"
#import "UIImageEx.h"
#import "SettingPlistConfig.h"
#import "BppDistriPlistManager.h"
#import "FileUtil.h"
#import "BppDownloadToLocal.h"
#import "IphoneAppDelegate.h"
#import "SearchManager.h"
#import "AppStatusManage.h"
#import <objc/runtime.h>
#import "CountConvert.h"
#define DOWNLOAD_BUTTON_TOUCH_AREA 80
@implementation DownloadBtn

- (void)layoutSubviews{
    
    [super layoutSubviews];

//    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.imageView.frame = CGRectMake(2.5, 0, self.imageView.image.size.width/2, self.imageView.image.size.height/2);
    
//    self.titleLabel.frame = CGRectMake(0, self.imageView.bounds.size.width+self.imageView.frame.origin.y, self.imageView.frame.size.width+5, 12.0);
    
    self.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];

    
}

@end

@interface SearchResultCell ()<UIAlertViewDelegate>{
    UIImage *defaultImg;
    UIImageView * custumSeperateLineImageView;
    UIButton *downButtonBG;
    NSDictionary *_appInforDic;
    
    dispatch_source_t timer;
}
@property (nonatomic, strong) NSString *appPrice;

@end

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        defaultImg =  _StaticImage.icon_60x60;//icon默认图片;
        self.iconURLString = [[NSString alloc]init];

        custumSeperateLineImageView = [[UIImageView alloc]init];
        custumSeperateLineImageView.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
        //
        _iconImageView = [[CollectionViewCellImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.image = [UIImage getRoundedRectImage:defaultImg];
        _iconImageView.maskCornerRadius = 12.0f;
        _iconImageView.clipsToBounds = YES;
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = NAME_COLOR;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        typeSizeLabel = [[UILabel alloc]init];
        typeSizeLabel.textAlignment = NSTextAlignmentLeft;
        typeSizeLabel.font = [UIFont systemFontOfSize:12.0f];
        typeSizeLabel.textColor = OTHER_TEXT_COLOR;
        typeSizeLabel.backgroundColor = [UIColor clearColor];
        typeSizeLabel.numberOfLines = 1;
        
        goodIconImageView = [[UIImageView alloc]init];
        goodIconImageView.backgroundColor = [UIColor clearColor];
//        goodIconImageView.image = [UIImage imageNamed:@"zan.png"];
        SET_IMAGE(goodIconImageView.image, @"zan.png");
        
        
        self.goodNumberLabel = [[UILabel alloc]init];
        self.goodNumberLabel.textAlignment = NSTextAlignmentLeft;
        self.goodNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        self.goodNumberLabel.textColor = OTHER_TEXT_COLOR;
        self.goodNumberLabel.backgroundColor = [UIColor clearColor];
        self.goodNumberLabel.numberOfLines = 1;
        self.goodNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        downloadIconImageView = [[UIImageView alloc]init];
        downloadIconImageView.backgroundColor = [UIColor clearColor];
//        downloadIconImageView.image = [UIImage imageNamed:@"totle_down.png"];
        SET_IMAGE(downloadIconImageView.image, @"totle_down.png");
        
        self.downloadNumberLabel = [[UILabel alloc]init];
        self.downloadNumberLabel.textAlignment = NSTextAlignmentLeft;
        self.downloadNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        self.downloadNumberLabel.textColor = OTHER_TEXT_COLOR;
        self.downloadNumberLabel.backgroundColor = [UIColor clearColor];
        self.downloadNumberLabel.numberOfLines = 1;
        self.downloadNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;

//        self.downloadButton = [DownloadBtn buttonWithType:UIButtonTypeCustom];
//        self.downloadButton.backgroundColor = [UIColor clearColor];
//        [self.downloadButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
////        [self.downloadButton setImage:[UIImage imageNamed:@"state_download.png"] forState:UIControlStateNormal];
//        [LocalImageManager setImageName:@"state_download.png" complete:^(UIImage *image) {
//            [self.downloadButton setImage:image forState:UIControlStateNormal];
//        }];
//        self.downloadButton.userInteractionEnabled = YES;
//        
//        [self addSubview:self.downloadButton];
        self.downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.downLoadBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.downLoadBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        [self.downLoadBtn setTitle:@"免费" forState:UIControlStateNormal];
        
        [self addSubview:self.downLoadBtn];
        [self.contentView addSubview:custumSeperateLineImageView];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:goodIconImageView];
        [self.contentView addSubview:downloadIconImageView];
        [self.contentView addSubview:typeSizeLabel];
        [self.contentView addSubview:self.goodNumberLabel];
        [self.contentView addSubview:self.downloadNumberLabel];
    }
    return self;
}

- (void)layoutSubviews{
    #define icon_size 45
    #define icon_size_list 60
    #define other_icon_size 32/2
    #define other_icon_size_list 15
    _iconImageView.frame = CGRectMake(12, 13, icon_size_list, icon_size_list);
    self.nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + 10, 14, MainScreen_Width-12-icon_size_list-10-68, 18);
    typeSizeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4, self.nameLabel.frame.size.width, 15);
    goodIconImageView.frame = CGRectMake(self.nameLabel.frame.origin.x, typeSizeLabel.frame.origin.y + typeSizeLabel.frame.size.height + 4, other_icon_size_list, other_icon_size_list);
    self.goodNumberLabel.frame = CGRectMake(goodIconImageView.frame.origin.x + goodIconImageView.frame.size.width + 2, goodIconImageView.frame.origin.y + 2, 40, 10);
    downloadIconImageView.frame = CGRectMake(self.goodNumberLabel.frame.origin.x + self.goodNumberLabel.frame.size.width + 2, goodIconImageView.frame.origin.y, other_icon_size_list, other_icon_size_list);
    self.downloadNumberLabel.frame = CGRectMake(downloadIconImageView.frame.origin.x + downloadIconImageView.frame.size.width + 2, downloadIconImageView.frame.origin.y + 2, 40, 10);
    
    CGSize cellBtnSize = [UIImage imageNamed:@"free.png"].size;
    
    self.downLoadBtn.frame = CGRectMake(self.bounds.size.width-12-cellBtnSize.width, (self.bounds.size.height-cellBtnSize.height)*0.5, cellBtnSize.width, cellBtnSize.height);
    custumSeperateLineImageView.frame = CGRectMake(8, self.frame.size.height -0.5, self.frame.size.width, 0.5);
}

- (void)setNameLabelText:(NSString *)nameStr{
    if (nameStr) {
        self.nameLabel.text = nameStr;
    }else{
        self.nameLabel.text = @"--";
    }
}
- (void)setGoodNumberLabelText:(NSString *)goodNumberStr{
    self.goodNumberLabel.text = CountConver(goodNumberStr);
}
- (void)setDownloadNumberLabelText:(NSString *)downloadNumberStr{
    self.downloadNumberLabel.text = CountConver(downloadNumberStr);
}


-(void)setDetailText:(NSString *)detailText{
    if (!detailText) {
        detailLabel.text = @"-----------";
    }else{
        detailLabel.text = detailText;

    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backgroundColor = CONTENT_BACKGROUND_COLOR;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _iconImageView.maskLayer.fillColor = CONTENT_BACKGROUND_COLOR.CGColor;
        [CATransaction commit];
    }else{
        
        self.backgroundColor = WHITE_BACKGROUND_COLOR;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _iconImageView.maskLayer.fillColor = WHITE_BACKGROUND_COLOR.CGColor;
        [CATransaction commit];
    }
    [super setHighlighted:highlighted animated:animated];
}
- (void)setLabelType:(NSString *)typeStr Size:(NSString *)sizeStr{
    
    if (typeStr) {
        self.typeString = typeStr;
    }else{
        self.typeString = @"--";
    }
    
    if (sizeStr) {
        self.sizeString = sizeStr;
    }else{
        self.sizeString = @"--";
    }
    
    typeSizeLabel.text = [NSString stringWithFormat:@"%@ | %@M",self.typeString,self.sizeString];
    
}

- (void)initCellwithInfor:(NSDictionary *)appInfor{
    
    _appInforDic = appInfor;
    NSNumber *number = [appInfor objectForKey:@"appreputation"];
    NSString *reputation = [NSString stringWithFormat:@"%@",number];
    [self setNameLabelText:[appInfor objectForKey:@"appname"]];
    [self setGoodNumberLabelText: reputation];
    [self setDownloadNumberLabelText:[appInfor objectForKey:@"appdowncount"]];
    [self setLabelType:[appInfor objectForKey:@"category"] Size:[appInfor objectForKey:@"appdisplaysize"]];
    [self setDetailText:[appInfor objectForKey:@"appintro"]];
    self.iconURLString = [appInfor objectForKey:@"appiconurl"];
    

        //下载来源
    
    
    //按钮状态显示
    self.appID = [appInfor objectForKey:@"appid"];
    self.appPrice = [appInfor objectForKey:APPPRICE];
    self.plistURL = [appInfor objectForKey:@"plist"];
    //2.7
    self.appVersion = [appInfor objectForKey:@"appversion"];//appversion,displayversion
    
    if ([_appPrice isEqualToString:@"0.00"]) {
        [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        
        [self.downLoadBtn setTitle:@"免费" forState:UIControlStateNormal];
        
    }else{
        [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"chargess.png"] forState:UIControlStateHighlighted];
        
    }
}

- (void)initDownloadButtonState{
    
    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:self.appID appVersion:self.appVersion];
    //    UIImage *stateImg = nil;
    NSString *title = nil;
    
    [self.downLoadBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    switch (status) {
        case STATE_DOWNLOAD:{
            title= [_appPrice isEqualToString:@"0.00"]?@"免费":_appPrice;
            if ([_appPrice isEqualToString:@"0.00"]) {
                [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
                //                [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
                
            }else{
                [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"charge.png"] forState:UIControlStateNormal];
                 [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"chargess.png"] forState:UIControlStateHighlighted];
            }
            //            NSString*mianfei=@"免费";
            [self.downLoadBtn addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_UPDATE:{
            title=@"更新";
            [self.downLoadBtn addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
//            self.priceLabel.text = @"";
        }
            break;
        case STATE_INSTALL:{
            title=@"安装";
            
            [self.downLoadBtn addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
//            self.priceLabel.text = @"";
        }
            break;
        case STATE_REINSTALL:{
            title = @"重新安装";
            [self.downLoadBtn addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
//            self.priceLabel.text = @"";
        }
            break;
        case STATE_DOWNLONGING:{
            title = @"下载中";
            [self.downLoadBtn addTarget:self action:@selector(downloadingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            self.priceLabel.text = @"";
        }
            break;
        default:
            break;
    }
    
    [self.downLoadBtn setTitle:title forState:UIControlStateNormal];
    
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateNormal];
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateDisabled];
}


- (void)setInforNil{
    [self setNameLabelText:nil];
    [self setGoodNumberLabelText: nil];
    [self setDownloadNumberLabelText:nil];
    [self setLabelType:nil Size:nil];
    [self setDetailText:nil];
    introImageView.image = defaultImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)initDownloadButtonState{
//    
//    
//    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:self.appID
//                                                        appVersion:self.appVersion];
//    
//    NSString *imgName = nil;
//    
//    //设置状态图
//    if (status == STATE_DOWNLOAD ) {
//        imgName = @"state_download.png";
//    }else if (status == STATE_INSTALL){
//        imgName = @"state_install.png";
//    }else if (status == STATE_REINSTALL){
//        imgName = @"state_reinstall.png";
//    }else if (status == STATE_DOWNLONGING){
//        imgName = @"state_downloading.png";
//    }else if (status == STATE_UPDATE){
//        imgName = @"state_update.png";
//    }
//    [LocalImageManager setImageName:imgName complete:^(UIImage *image) {
//        [self.downloadButton setImage:image forState:UIControlStateNormal];
//        [self.downloadButton setImage:image forState:UIControlStateDisabled];
//    }];
//    //设置响应方法
//    
//    [_downloadButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    if (status == STATE_DOWNLOAD) {
//        [_downloadButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
//        
//    }else if (status == STATE_DOWNLONGING){
//        [_downloadButton addTarget:self action:@selector(downloadingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }else if (status == STATE_INSTALL){
//        [_downloadButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
//    }else if (status == STATE_REINSTALL){
//        [_downloadButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        if (status == STATE_UPDATE){
//            [_downloadButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
//        }else{
//            _downloadButton.enabled = NO;
//        }
//    }
//    
//}

#pragma mark - Actions

- (void)downloadingBtnClick:(id)sender
{ // 跳转到下载中页面-（下载管理）
    [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_DOWNLOADING object:_plistURL];
}

#pragma mark - 连续点击两次崩溃bug

- (void)disableInstallButtonOneSecond:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), 0, 0);
    dispatch_source_set_event_handler(timer, ^{
        btn.enabled = YES;
        [self initDownloadButtonState];
        dispatch_source_cancel(timer);
    });
    
    dispatch_resume(timer);
}



//下载
- (void)beginDownload{
    
    if (self.plistURL) {
        
        NSMutableDictionary *tmpDic  = [[NSMutableDictionary alloc ]init];
        
        //增加点击下载应用的appid和appdigitalid的对应关系
        NSString *appdigitalid = [_appInforDic objectForKey:@"appdigitalid"];
        if (appdigitalid) {
            [[NSUserDefaults standardUserDefaults] setObject:appdigitalid forKey:[_appInforDic objectForKey:@"appid"]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
//        临时处理,需要再完善
        if (_appInforDic&&self.source) {
            [tmpDic setObject:[_appInforDic objectForKey:@"appid"] forKey:@"appid"];
            [tmpDic setObject:[_appInforDic objectForKey:@"appversion"] forKey:@"appversion"];
            [tmpDic setObject:[_appInforDic objectNoNILForKey:@"appminosver"] forKey:@"appminosver"];
            [tmpDic setObject:[_appInforDic objectForKey:@"appiconurl"] forKey:@"appiconurl"];
            [tmpDic setObject:[_appInforDic objectForKey:@"appname"] forKey:@"appname"];
            [tmpDic setObjectNoNIL:[_appInforDic objectForKey:@"appprice"] forKey:@"appprice"];
            [tmpDic setObjectNoNIL:[_appInforDic objectForKey:@"appdigitalid"] forKey:@"distriAppID"];

            [tmpDic setObject:self.source forKey:@"dlfrom"];
        }else{
            [tmpDic setObject:@"" forKey:@"appid"];
            [tmpDic setObject:@"" forKey:@"appversion"];
            [tmpDic setObject:@"" forKey:@"appminosver"];
            [tmpDic setObject:@"" forKey:@"appiconurl"];
            [tmpDic setObject:@"" forKey:@"appname"];
            [tmpDic setObject:@"" forKey:@"dlfrom"];
            [tmpDic setObject:@"" forKey:@"appprice"];
        }
        
        if ([_source hasPrefix:@"kyclient_unicomfreeflow_"]) {
            [browserAppDelegate add3GFreeFlowDistriPlistURL:self.plistURL appInfo:tmpDic];
        }
        else
        {
            [browserAppDelegate addDistriPlistURL:self.plistURL appInfo:tmpDic];
        }
        //

    }else{
        NSLog(@"plistURL is null");
    }

}
//安装
- (void)beginInstall:(id)sender{
    NSString * distriPlist = self.plistURL;
    [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
    [self disableInstallButtonOneSecond:sender];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

- (void)dealloc{
    
    
}

@end
