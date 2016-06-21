//
//  PublicCollectionCell.m
//  Mymenu
//
//  Created by mingzhi on 14/11/22.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import "PublicCollectionCell.h"
#import "AppStatusManage.h"
#import "IphoneAppDelegate.h"
#import "MyServerRequestManager.h"

#pragma mark - CollectionViewCellButton

@implementation CollectionViewCellButton_my
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat StartX = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
    self.imageView.frame = CGRectMake(StartX, (self.bounds.size.height-26/2)/2, 22/2, 26/2);
    self.titleLabel.frame = CGRectMake(self.imageView.frame.size.width+StartX+5, 0, self.bounds.size.width-self.imageView.frame.size.width-StartX-5, self.bounds.size.height);
    
    if (self.down) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.frame = CGRectMake((self.bounds.size.width-100/2)/2, (self.bounds.size.height-170/2)/2-30, 100/2, 170/2);
        self.titleLabel.frame = CGRectMake(0, self.imageView.bounds.size.width+self.imageView.frame.origin.y+20, self.bounds.size.width-15, 12.0);
    }
}
@end



@implementation CollectionViewCellImageView_my
- (instancetype)init
{
    self = [super init];
    if (self) {
        _maskLayer = [CAShapeLayer new];
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:_maskLayer];
    }
    return self;
}

- (void)setMaskCornerRadius:(CGFloat)maskCornerRadius{
    _maskCornerRadius = maskCornerRadius;
    _maskLayer.borderWidth = 0.5;
    _maskLayer.borderColor = hllColor(120, 120, 120, 0.3).CGColor;
    _maskLayer.cornerRadius = maskCornerRadius;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _maskLayer.frame = self.layer.bounds;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.maskCornerRadius]];
    _maskLayer.path = path.CGPath;
}
@end


@interface PublicCollectionCell ()
{
    CGSize cellBtnSize;
    dispatch_source_t tapTimerSource;
    
    UIImage *freeImg;
    UIImage *chargeImg;
    UIImage *installImg;
    UIImage *reinstallImg;
    UIImage *downloadingImg;
    UIImage *updateImg;
}

@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *iconURLString;
@property (nonatomic, strong) NSString *appPrice;

@end


@implementation PublicCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews{
    self.backgroundColor = [UIColor whiteColor];
    
    freeImg = [UIImage imageNamed:@"free.png"];
    chargeImg = [UIImage imageNamed:@"charge.png"];
    downloadingImg = [UIImage imageNamed:@"downloadingImgs.png"];
    installImg = [UIImage imageNamed:@"install.png"];
    updateImg = [UIImage imageNamed:@"update.png"];
    
    
    //图标
    _iconImageView = [CollectionViewCellImageView_my new];
    _iconImageView.backgroundColor = [UIColor clearColor];
    _iconImageView.maskCornerRadius = 12.f;
    [self.contentView addSubview:_iconImageView];
    
    //名字
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor=namelableColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:titleFontSize];
    _nameLabel.numberOfLines = 1;
    [self.contentView addSubview:_nameLabel];
    
    
    
    //简介
    _subLabel = [UILabel new];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
    _subLabel.textColor = subtitleColor;
    _subLabel.numberOfLines = 1;
    _subLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
    [self.contentView addSubview:_subLabel];
    
    //下载量
    _downButton = [CollectionViewCellButton_my buttonWithType:UIButtonTypeCustom];
    _downButton.titleLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
    [_downButton setTitleColor:_downButtonColor forState:UIControlStateNormal];
    _downButton.backgroundColor = [UIColor clearColor];
    [_downButton setImage:[UIImage imageNamed:@"totle_down2.png"] forState:UIControlStateNormal];
    _downLoadBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_downButton];
    
    //大小
//    _sizeLabel = [UILabel new];
//    _sizeLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
//    [_sizeLabel setTextColor:_downButtonColor];
//    [_sizeLabel setText:@""];
//    
//    [_sizeLabel setTextAlignment:NSTextAlignmentRight];
//    _sizeLabel.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:_sizeLabel];
    
    //UIButton
    cellBtnSize = freeImg.size;
    
    self.downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downLoadBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.downLoadBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
    [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
    [self.downLoadBtn setTitle:@"免费" forState:UIControlStateNormal];
    
    [self.contentView addSubview:_downLoadBtn];
    
    //价格
    _priceLabel = [UILabel new];
//    _priceLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
    [_priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:subtitleFontSize]];

    [_priceLabel setTextColor:hllColor(238.0, 139.0, 18.0, 1.0)];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    _priceLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_priceLabel];
    
    lineView2 = [UIImageView new];
    [self.contentView addSubview:lineView2];
    lineView2.backgroundColor = CellBottomColor;
    //下线
    _bottomlineView = [UIImageView new];
    _bottomlineView.backgroundColor = CellBottomColor;
    [self.contentView addSubview:_bottomlineView];
    
    //排行
    _orderLabel = [UILabel new];
    _orderLabel.font = [UIFont systemFontOfSize:16.f];
    [_orderLabel setText:@"1"];
    [_orderLabel setTextAlignment:NSTextAlignmentCenter];
    _orderLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_orderLabel];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //排行
    if ([self.reuseIdentifier isEqualToString:LISTVIEWCELLS]) {
        CGFloat listPianyi = 30;
        _iconImageView.frame = CGRectMake(ThestartX+listPianyi, (self.bounds.size.height-64*MULTIPLE)/2, 64*MULTIPLE, 64*MULTIPLE);
        _orderLabel.frame = CGRectMake(0, 0, listPianyi+ThestartX, self.bounds.size.height);
        _bottomlineView.frame = CGRectMake(ThestartX+listPianyi, self.bounds.size.height-1, self.bounds.size.width-ThestartX+listPianyi, 0.5);
        _bottomlineView.backgroundColor = CellBottomColor;
    }
    //普通
    else{
        _iconImageView.frame = CGRectMake(ThestartX, (self.bounds.size.height-64*MULTIPLE)/2, 64*MULTIPLE, 64*MULTIPLE);
        _orderLabel.frame = CGRectZero;
    }
    
    _nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+12*MULTIPLE, _iconImageView.frame.origin.y+3, 180*MULTIPLE, 20*MULTIPLE);
    _subLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5*MULTIPLE-5, 180*MULTIPLE, 18*MULTIPLE);
    
//    _downButton.frame = CGRectMake(_downloadIconImageView.frame.origin.x + _downloadIconImageView.frame.size.width, _subLabel.frame.origin.y+_subLabel.frame.size.height+5*MULTIPLE-4, (MainScreen_Width-ThestartX-2-(ThestartX+70+30))/3, 16*MULTIPLE);
    [_downButton setFrame:CGRectMake(_nameLabel.frame.origin.x, _subLabel.frame.origin.y+_subLabel.frame.size.height+5*MULTIPLE-4, self.frame.size.width, 16*MULTIPLE)];
    
    self.downLoadBtn.frame = CGRectMake(self.bounds.size.width-12-cellBtnSize.width, (self.bounds.size.height-cellBtnSize.height)*0.5, cellBtnSize.width, cellBtnSize.height);
    _priceLabel.frame = _downLoadBtn.frame;
    
}
- (void)setBottomLineLong:(BOOL)bl
{
    CGFloat start = bl?0:ThestartX;
    _bottomlineView.frame = CGRectMake(start, self.bounds.size.height-1, self.bounds.size.width-start, 0.5);
    _bottomlineView.backgroundColor = bl? BottomColor :CellBottomColor;
}

- (void)setCellData:(NSDictionary *)showCellDic
{
    if (showCellDic) {
        //设置属性
        _cellDataDic = showCellDic;
        self.appPrice = [showCellDic objectForKey:APPPRICE];
        
        _appdigitalid = [showCellDic objectForKey:APPDIGITALID];
        _appID = [showCellDic objectForKey:APPID];
        self.appVersion = [showCellDic objectForKey:APPVERSION];
        self.iconURLString = [showCellDic objectForKey:APPICON];
        _plist = [showCellDic objectForKey:PLIST];
        _installtype = [showCellDic objectForKey:INSTALLTYPE];
        //设置显示
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[showCellDic objectForKey:APPICONURL]] placeholderImage:[UIImage imageNamed:@"icon60x60"] size:CGSizeMake(175, 175) radius:(_iconImageView.maskCornerRadius)*175/(70*MULTIPLE)];
        _nameLabel.text = [showCellDic objectForKey:APPNAME];
        _subLabel.text = [showCellDic objectForKey:APPINTRO];
        
        if ([_appPrice isEqualToString:@"0.00"]) {
            [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
            [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];

            [self.downLoadBtn setTitle:@"免费" forState:UIControlStateNormal];
            
        }else{
            [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"chargess.png"] forState:UIControlStateHighlighted];

        }
        
        NSString *size = [showCellDic objectForKey:@"appdisplaysize"];
        NSString *mSize = size;//[NSString stringWithFormat:@"%.2f",size.integerValue/1024.0/1024.0];
//        [showCellDic objectForKey:APPSIZE_MY]
        NSString *content = [NSString stringWithFormat:@"%@   |   %@M",[showCellDic objectForKey:APPDOWNCOUNT],mSize];
        [_downButton setTitle:content forState:UIControlStateNormal];
        
        
        
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
                [self.downLoadBtn setBackgroundImage:chargeImg forState:UIControlStateNormal];
//                 [self.downLoadBtn setBackgroundImage:[UIImage imageNamed:@"chargess.png"] forState:UIControlStateHighlighted];
            }
            //            NSString*mianfei=@"免费";
            [self.downLoadBtn addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_UPDATE:{
            title=@"更新";
            [self.downLoadBtn addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
            self.priceLabel.text = @"";
        }
            break;
        case STATE_INSTALL:{
            title=@"安装";
            
            [self.downLoadBtn addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            self.priceLabel.text = @"";
        }
            break;
        case STATE_REINSTALL:{
            title = @"重新安装";
            [self.downLoadBtn addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            self.priceLabel.text = @"";
        }
            break;
        case STATE_DOWNLONGING:{
            title = @"下载中";
            [self.downLoadBtn addTarget:self action:@selector(downloadingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            self.priceLabel.text = @"";
        }
            break;
        default:
            break;
    }
    
    [self.downLoadBtn setTitle:title forState:UIControlStateNormal];
    
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateNormal];
    //    [self.downLoadBtn setImage:stateImg forState:UIControlStateDisabled];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 120.0/255.0, 120.0/255.0, 120.0/255.0, 0.2);
        CGContextFillRect(context, self.bounds);
    }else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextFillRect(context, self.bounds);
    }
}

#pragma mark DownloadButtonAction

// 下载
- (void)beginDownload{
    NSString *version = [NSString stringWithFormat:@"%@",[_cellDataDic objectForKey:@"displayversion"]?[_cellDataDic objectForKey:@"displayversion"]:[_cellDataDic objectForKey:@"appversion"]];
    [[MyServerRequestManager getManager] downloadCountToAPPID:self.appdigitalid version:version];
    [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:self.appdigitalid];
    return;
    
    //增加点击下载应用的appid和appdigitalid的对应关系
    [[NSUserDefaults standardUserDefaults] setObject:self.appdigitalid forKey:self.appID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.plist) {
        BOOL flag = SHOW_REAL_VIEW_FLAG;
        flag = DIRECTLY_GO_APPSTORE;
        
//        if (!HAS_CONNECTED_PC) {
//            //跳转store
//            [[NSNotificationCenter  defaultCenter] postNotificationName:OPEN_APPSTORE object:self.appdigitalid];
//            return;
//        }
        
        
        NSDictionary * AppInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appID, DISTRI_APP_ID,
                                  self.appVersion, DISTRI_APP_VERSION,
                                  self.nameLabel.text, DISTRI_APP_NAME,
                                  self.downLoadSource,DISTRI_APP_FROM,
                                  self.iconURLString, DISTRI_APP_IMAGE_URL,
                                  self.appPrice,DISTRI_APP_PRICE,
                                  [_cellDataDic objectForKey:@"appminosver"],@"appminosver",nil];
        
        [browserAppDelegate addDistriPlistURL:self.plist appInfo:AppInfo];
        
    }else{
        NSLog(@"plistURL is null");
    }
}

// 安装或重装
- (void)beginInstall:(id)sender{
    
    [self disableInstallBtnOneSecond:sender];// 禁用按钮1秒
    
    if( ![[BppDistriPlistManager getManager] ItemInfoInDownloadedByAttriName:DISTRI_PLIST_URL
                                                                       value:self.plist] ) {
        //需要下载
    }
    else
    { //直接安装
        [[BppDistriPlistManager getManager] installPlistURL:self.plist];
    }
}

- (void)downloadingButtonClick:(id)sender
{ // 跳转到下载中页面（管理）
    [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_DOWNLOADING object:_plist];
}

// 禁用按钮1秒钟（安装、重装）
-(void)disableInstallBtnOneSecond:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    self.userInteractionEnabled = NO;
    
    tapTimerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(tapTimerSource, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), 0, 0);
    dispatch_source_set_event_handler(tapTimerSource, ^{
        btn.enabled = YES;
        self.userInteractionEnabled = YES;
        dispatch_source_cancel(tapTimerSource);
    });
    
    dispatch_resume(tapTimerSource);
}




@end
