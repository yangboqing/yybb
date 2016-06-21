//
//  PublicTableViewCell.m
//
//
//  Created by mingzhi on 14-5-8.
//  
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "PublicTableViewCell.h"
#import "SettingPlistConfig.h"
#import "BppDistriPlistManager.h"
#import "FileUtil.h"
#import "IphoneAppDelegate.h"
#import "AppStatusManage.h"
#import <objc/runtime.h>


@implementation IconImageView

-(id)init
{
    self = [super init];
    if (self) {
        CAShapeLayer *imgLayer = [[CAShapeLayer alloc] init];
        imgLayer.fillColor = [UIColor whiteColor].CGColor;
        imgLayer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:imgLayer];
        self.imageLayer = imgLayer;
    }
    
    return self;
}
- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.imageLayer.borderWidth = 0.5;
    self.imageLayer.borderColor = hllColor(50, 50, 50, 0.2).CGColor;
    self.imageLayer.cornerRadius = radius;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageLayer.frame = self.layer.bounds;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.radius]];
    self.imageLayer.path = path.CGPath;
}

@end

@interface PriceLabel : UILabel
{
    UIImageView *line;
}

@end

@implementation PriceLabel
- (id)init{
    self = [super init];
    if (self) {
        //
        self.backgroundColor = [UIColor orangeColor];
        line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"price0.png"]];
        line.frame = CGRectMake(0, 0, 55, 12);
        line.center = self.center;
        [self addSubview:line];

    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)setLineFrame{
    line.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 2);
    [self setNeedsLayout];
}

@end

@interface PublicTableViewCell (){
    
    UIImage *defaultImg;//默认图片
    
    UILabel *detailLabel;//图片模式时简介Label
    
    UIImageView * custumSeperateLineImageView;//cell下面线
    
    UIImageView *goodIconImageView;//赞图
    UIImageView *downloadIconImageView;//下载数图
    
    UILabel *typeSizeLabel;//大小类型Label
    
    dispatch_source_t tapTimerSource;
    
    // 详情信息
    NSDictionary *infoDic;
    
    UIImage *downloadImg;
    UIImage *installImg;
    UIImage *reinstallImg;
    UIImage *downloadingImg;
    UIImage *updateImg;
    
}

@end

@implementation PublicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        downloadImg = [UIImage imageNamed:@"state_download.png"];
        downloadingImg = [UIImage imageNamed:@"state_downloading.png"];
        installImg = [UIImage imageNamed:@"state_install.png"];
        reinstallImg = [UIImage imageNamed:@"state_reinstall.png"];
        updateImg = [UIImage imageNamed:@"state_update.png"];
        
        defaultImg = _StaticImage.icon_60x60;//icon默认图片
        
        self.iconURLString = [[NSString alloc]init];
        self.previewURLString = [[NSString alloc]init];
        
        //cell下线
        custumSeperateLineImageView = [[UIImageView alloc]init];
        custumSeperateLineImageView.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
        
        //icon
        self.iconImageView = [[IconImageView alloc]init];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView.radius = 12.0f;
        self.iconImageView.clipsToBounds = YES;
        
        //名字
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = NAME_COLOR;
        self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //类型大小
        typeSizeLabel = [[UILabel alloc]init];
        typeSizeLabel.font = [UIFont systemFontOfSize:12.0f];
        typeSizeLabel.textColor = OTHER_TEXT_COLOR;
        typeSizeLabel.backgroundColor = [UIColor clearColor];
        typeSizeLabel.numberOfLines = 1;
        
        //赞数图
        goodIconImageView = [[UIImageView alloc]init];
        goodIconImageView.backgroundColor = [UIColor clearColor];
        goodIconImageView.image = [UIImage imageNamed:@"zan.png"];
        
        //赞数
        self.goodNumberLabel = [[UILabel alloc]init];
        self.goodNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        self.goodNumberLabel.textColor = OTHER_TEXT_COLOR;
        self.goodNumberLabel.backgroundColor = [UIColor clearColor];
        self.goodNumberLabel.numberOfLines = 1;
        self.goodNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //下载数图
        downloadIconImageView = [[UIImageView alloc]init];
        downloadIconImageView.backgroundColor = [UIColor clearColor];
        downloadIconImageView.image = [UIImage imageNamed:@"totle_down.png"];
        
        //下载数
        self.downloadNumberLabel = [[UILabel alloc]init];
        self.downloadNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        self.downloadNumberLabel.textColor = OTHER_TEXT_COLOR;
        self.downloadNumberLabel.backgroundColor = [UIColor clearColor];
        self.downloadNumberLabel.numberOfLines = 1;
        self.downloadNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //按钮
        self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.downloadButton setImage:downloadImg forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        //icon排行角标
        self.iconNumImageView = [[UIImageView alloc]init];
        self.iconNumImageView.backgroundColor = [UIColor clearColor];
        
        //价格
        self.priceLabel = [[PriceLabel alloc]init];
        self.priceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.priceLabel.textColor = OTHER_TEXT_COLOR;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.numberOfLines = 1;
        
        [self addSubview:custumSeperateLineImageView];
        [self addSubview:self.iconImageView];
        [self addSubview:detailLabel];
        [self addSubview:goodIconImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:downloadIconImageView];
        [self addSubview:typeSizeLabel];
        [self addSubview:self.goodNumberLabel];
        [self addSubview:self.downloadNumberLabel];
        [self addSubview:_downloadButton];
        [self addSubview:self.iconNumImageView];
        
        [self setLayoutSubviews];
        
        // cell selectStyle
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = CONTENT_BACKGROUND_COLOR;
        self.selectedBackgroundView = view;
    }
    
    return self;
}
- (void)setLayoutSubviews{
#define icon_size_list 60
#define other_icon_size_list 15
    
    CGFloat screenWidth = MainScreen_Width;
    
    detailLabel.frame = CGRectZero;
    self.iconImageView.frame = CGRectMake(15, 13, icon_size_list, icon_size_list);
    CGFloat nameLabelOriX = self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10;
    self.nameLabel.frame = CGRectMake(nameLabelOriX, 14, screenWidth-nameLabelOriX-68, 15);
    
//    typeSizeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4, self.nameLabel.frame.size.width, 15);
//        goodIconImageView.frame = CGRectMake(self.nameLabel.frame.origin.x, typeSizeLabel.frame.origin.y + typeSizeLabel.frame.size.height + 4, other_icon_size_list, other_icon_size_list);
    typeSizeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4, 60, 15);
    
    goodIconImageView.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4 + 15 + 6, other_icon_size_list, other_icon_size_list);
    self.goodNumberLabel.frame = CGRectMake(goodIconImageView.frame.origin.x + goodIconImageView.frame.size.width + 2, goodIconImageView.frame.origin.y + 2, 40, 10);
    downloadIconImageView.frame = CGRectMake(self.goodNumberLabel.frame.origin.x + self.goodNumberLabel.frame.size.width + 2, goodIconImageView.frame.origin.y, other_icon_size_list, other_icon_size_list);
    self.downloadNumberLabel.frame = CGRectMake(downloadIconImageView.frame.origin.x + downloadIconImageView.frame.size.width + 2, downloadIconImageView.frame.origin.y + 2, 40, 10);
    self.downloadButton.frame = CGRectMake(screenWidth-50, (PUBLICNOMALCELLHEIGHT-85)*0.5, 50, 85);
    custumSeperateLineImageView.frame = CGRectMake(8, PUBLICNOMALCELLHEIGHT-0.5, screenWidth, 0.5);

    
}

#pragma mark - Utility
-(void)initCellInfoDic:(NSDictionary *)dic
{
    infoDic = dic;
    self.appPrice = [dic objectForKey:@"appprice"];
}

- (void)setAppIconImageView:(UIImage *)image{
    self.iconImageView.image =image ;
}

- (void)setNameLabelText:(NSString *)nameStr{
    if (nameStr) {
        self.nameLabel.text = nameStr;
    }else{
        self.nameLabel.text = @"--";
    }
}

- (void)setGoodNumberLabelText:(NSString *)goodNumberStr{
    // 赞数
    if (goodNumberStr) {
        if ([goodNumberStr integerValue] > 10000) {
            self.goodNumberLabel.text = [NSString stringWithFormat:@"%.1f万",[goodNumberStr integerValue]/10000.0];
        }else
        {
            self.goodNumberLabel.text = goodNumberStr;
        }
        
    }else{
        self.goodNumberLabel.text = @"其他";
    }
}

- (void)setDownloadNumberLabelText:(NSString *)downloadNumberStr{
    // 下载数
    if (!downloadNumberStr) {
        self.downloadNumberLabel.text = @"0";
        return;
    }
    
    if ([downloadNumberStr integerValue] > 10000) {
        self.downloadNumberLabel.text = [NSString stringWithFormat:@"%.1f万",[downloadNumberStr integerValue]/10000.0];
    }else
    {
        self.downloadNumberLabel.text = downloadNumberStr;
    }
    
}

- (void)setLabelType:(NSString *)typeStr Size:(NSString *)sizeStr{
    // 设置类型和大小
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
    NSString *content = [NSString stringWithFormat:@"%@ | %@M",self.typeString,self.sizeString];
    typeSizeLabel.text = content;
    
    [typeSizeLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4, [self getContentWidth:content].width, [self getContentWidth:content].height)];
}

-(void)setDetailText:(NSString *)detailText{
    // 图片模式时简介
    if (!detailText) {
        detailLabel.text = @"-----------";
    }else{
        detailLabel.text = detailText;
        
    }
}

- (void)initDownloadButtonState{
    
    DOWNLOAD_STATE status = [[AppStatusManage getObject] appStatus:self.appID appVersion:self.appVersion];
    
    UIImage *stateImg = nil;
    
    [self.downloadButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    switch (status) {
        case STATE_DOWNLOAD:{
            stateImg = downloadImg;
            [self.downloadButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_UPDATE:{
            stateImg = updateImg;
            [self.downloadButton addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_INSTALL:{
            stateImg = installImg;
            [self.downloadButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case STATE_REINSTALL:{
            stateImg = reinstallImg;
            [self.downloadButton addTarget:self action:@selector(beginInstall:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case STATE_DOWNLONGING:{
            stateImg = downloadingImg;
            [self.downloadButton addTarget:self action:@selector(downloadingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    
    [self.downloadButton setImage:stateImg forState:UIControlStateNormal];
    [self.downloadButton setImage:stateImg forState:UIControlStateDisabled];
}

-(void)setAngleNumber:(NSInteger)number
{ // 1-10显示角标
    if (number > 9) {
        self.iconNumImageView.image = nil;
        self.iconNumImageView.frame = CGRectZero;
    }
    else
    {
        self.iconNumImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"listcut_%i",number]];
        self.iconNumImageView.frame = CGRectMake(_iconImageView.frame.origin.x, _iconImageView.frame.origin.y, 28, 28);
    }
}
- (void)setPrice{
    NSString *content = [NSString stringWithFormat:@" | ￥%@",[infoDic objectForKey:@"appprice"]];
    self.priceLabel.text = content;
    
    self.priceLabel.frame = CGRectMake(typeSizeLabel.frame.origin.x + typeSizeLabel.frame.size.width - 5, typeSizeLabel.frame.origin.y, [self getContentWidth:content].width, [self getContentWidth:content].height);
    [self.priceLabel setLineFrame];
    [self addSubview:self.priceLabel];

}

- (CGSize)getContentWidth:(NSString *)content{
    CGSize size = CGSizeMake(MainScreen_Width,15);
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize;
}
-(void)reloadRepairButtonState
{
    // 修复中状态
    BOOL repairingFlag = NO;
    
    //是否需要直接安装
    BOOL isToInstall = NO;
    
    // 下载中
    int downloadingItemCount = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    for (int i=0; i < downloadingItemCount; i++) {
        //
        NSDictionary *dic_ing = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
        NSString *appid_ing = [dic_ing objectForKey:DISTRI_APP_ID];
        NSString *plistStr_ing = [dic_ing objectForKey:DISTRI_PLIST_URL];
        
        // 是否同一个应用
        if (![_appID isEqualToString:appid_ing]){
            continue;
        }
        
        // 是否最新应用
        if ([[[FileUtil instance] plistURLNoArg:_plistURL] isEqualToString:[[FileUtil instance] plistURLNoArg:plistStr_ing]]) {
            repairingFlag = YES;
        }
    }
    
    // 已下载
    int downloadedItemCount = [[BppDistriPlistManager getManager] countOfDownloadedItem];
    for (int i=0; i < downloadedItemCount; i++) {
        NSDictionary *dic_ed = [[BppDistriPlistManager getManager] ItemInfoInDownloadedByIndex:i];
        NSString *appid_ed = [dic_ed objectForKey:DISTRI_APP_ID];
        NSString *plistStr_ed = [dic_ed objectForKey:DISTRI_PLIST_URL];
        
        // 是否同一应用
        if (![_appID isEqualToString:appid_ed]) {
            continue;
        }
        
        // 是否最新应用
        if ([[[FileUtil instance] plistURLNoArg:_plistURL] isEqualToString:[[FileUtil instance] plistURLNoArg:plistStr_ed]]) {
            isToInstall = YES;
        }
    }
    
    // 根据状态 更改界面
    [self.downloadButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    if (repairingFlag) {
        // 修复中(下载中、且版本一致)
        [self.downloadButton setImage:[UIImage imageNamed:@"repairing_btn.png"] forState:UIControlStateNormal];
        [self.downloadButton addTarget:self action:@selector(downloadingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (isToInstall){ // 修复和已下载一致，直接安装

        [self.downloadButton setImage:[UIImage imageNamed:@"repair_btn.png"] forState:UIControlStateNormal];
        [self.downloadButton addTarget:self action:@selector(repairInstallButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{ // 修复
        [self.downloadButton setImage:[UIImage imageNamed:@"repair_btn.png"] forState:UIControlStateNormal];
        [self.downloadButton addTarget:self action:@selector(repairButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Actions

-(void)repairButtonClick:(id)sender
{ // 修复列表-按钮点击事件
    
    BOOL downloadingFlag = YES; // 是否下载
//    BOOL installFlag  = NO; // 安装
    NSString *plist_ing = nil;
    NSString *plist_ed  = nil;
    
    // 下载中（版本不一致）
    int downloadingItemCount = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    for (int i=0; i < downloadingItemCount; i++) {
        //
        NSDictionary *dic_ing = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
        NSString *appid_ing = [dic_ing objectForKey:DISTRI_APP_ID];
        NSString *plistStr_ing = [dic_ing objectForKey:DISTRI_PLIST_URL];
        
        // 是否同一个应用
        if (![_appID isEqualToString:appid_ing]){
            continue;
        }
        
        // 是否最新应用
        if (![[[FileUtil instance] plistURLNoArg:_plistURL] isEqualToString:[[FileUtil instance] plistURLNoArg:plistStr_ing]]) {
            plist_ing = plistStr_ing; // 移除旧应用
            downloadingFlag = YES;
//            installFlag = NO;
            break;
        }
        else
        {
            downloadingFlag = NO;
//            installFlag = NO;
        }
    }
    
    // 已下载 (有没有,都要下载)
    int downloadedItemCount = [[BppDistriPlistManager getManager] countOfDownloadedItem];
    for (int i=0; i < downloadedItemCount; i++) {
        NSDictionary *dic_ed = [[BppDistriPlistManager getManager] ItemInfoInDownloadedByIndex:i];
        NSString *appid_ed = [dic_ed objectForKey:DISTRI_APP_ID];
        NSString *plistStr_ed = [dic_ed objectForKey:DISTRI_PLIST_URL];
        
        // 是否同一应用
        if (![_appID isEqualToString:appid_ed]) {
            continue;
        }
        
        // 是否最新应用
        if (![[[FileUtil instance] plistURLNoArg:_plistURL] isEqualToString:[[FileUtil instance] plistURLNoArg:plistStr_ed]]) {
            plist_ed = plistStr_ed; // 移除旧应用
            downloadingFlag = YES;
//            installFlag = NO;
            break;
        }
        else
        {
            downloadingFlag = NO;
//            installFlag = YES;
        }
        
    }
    
    if (plist_ing) {
        [[BppDistriPlistManager getManager] removePlistURL:plist_ing];
    }
    if (plist_ed) {
        [[BppDistriPlistManager getManager] removePlistURL:plist_ed];
    }
    
    // 安装/重新下载/继续下载
    if (downloadingFlag && _plistURL) {
        NSDictionary * AppInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.appID, DISTRI_APP_ID,
                                     self.appVersion, DISTRI_APP_VERSION,
                                     self.nameLabel.text, DISTRI_APP_NAME,
                                     self.downLoadSource,DISTRI_APP_FROM,
                                     self.iconURLString, DISTRI_APP_IMAGE_URL,
                                     self.appPrice,DISTRI_APP_PRICE,
                                     [infoDic objectForKey:@"appminosver"],@"appminosver",nil];
        [browserAppDelegate addDistriPlistURL:_plistURL  appInfo:AppInfoDic];
        
        // 更改按钮状态
        [self.downloadButton setImage:[UIImage imageNamed:@"repairing_btn.png"] forState:UIControlStateNormal];
        [self.downloadButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.downloadButton addTarget:self action:@selector(downloadingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
//    else if (installFlag) { // 安装
//        [[BppDistriPlistManager getManager] installPlistURL:_plistURL];
//    }
}

- (void)downloadingButtonClick:(id)sender
{ // 跳转到下载中页面（管理）
    [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_DOWNLOADING object:_plistURL];
}

- (void)repairInstallButtonClick:(UIButton *)sender{
    [[BppDistriPlistManager getManager] installPlistURL:_plistURL];
}


#pragma mark - 连续点击两次崩溃bug
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

#pragma mark - 下载或更新
- (void)beginDownload{
    
    if (self.plistURL) {
        
        NSDictionary * AppInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appID, DISTRI_APP_ID,
                                  self.appVersion, DISTRI_APP_VERSION,
                                  self.nameLabel.text, DISTRI_APP_NAME,
                                  self.downLoadSource,DISTRI_APP_FROM,
                                  self.iconURLString, DISTRI_APP_IMAGE_URL,
                                  self.appPrice,DISTRI_APP_PRICE,
                                  [infoDic objectForKey:@"appminosver"],@"appminosver",nil];
        
        [browserAppDelegate addDistriPlistURL:self.plistURL appInfo:AppInfo];
        
    }else{
        NSLog(@"plistURL is null");
    }
}

#pragma mark - 安装或重装
- (void)beginInstall:(id)sender{

    [self disableInstallBtnOneSecond:sender];// 禁用按钮1秒
    
    if( ![[BppDistriPlistManager getManager] ItemInfoInDownloadedByAttriName:DISTRI_PLIST_URL
                                                                       value:self.plistURL] ) {
        //需要下载
    }
    else
    { //直接安装
        [[BppDistriPlistManager getManager] installPlistURL:self.plistURL];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
