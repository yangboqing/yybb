//
//  DownLoadingTableViewCell.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "DownLoadingTableViewCell.h"
#import "UIImageEx.h"
#import "BPPProgressView.h"
#import "BppDistriPlistManager.h"
#import "BppDownloadFile.h"
#import "CollectionCells.h"
#define EDITOFFSET 40

@interface DownLoadingTableViewCell (){
    UIImageView *bottomLineImageView;
    float volumeFloat;
    float speedlableFloat;
}

@end

@implementation DownLoadingTableViewCell
@synthesize startOrPauseBtn = _startOrPauseBtn;
@synthesize idenStr = _idenStr;
@synthesize statusStr = _statusStr;
@synthesize progDic = _progDic;
@synthesize downingAppid = _downingAppid;
@synthesize speedLabel;
@synthesize m_checked;
@synthesize m_checkImageView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.progDic = [NSMutableDictionary dictionary];
        self.cellEnable = YES;
        
        littlePauseImg = [UIImage imageNamed:@"pauseDown_iphone.png"];
        littleLoadingImg = [UIImage imageNamed:@"startDown_iphone.png"];
        littleWaitingImg = [UIImage imageNamed:@"loadingIcon.png"];
        downGoImg = [UIImage imageNamed:@"newjixu@2x.png"];
        downPauseImg = [UIImage imageNamed:@"newzanting@2x.png"];
        defaultImg = _StaticImage.icon_60x60;
        
        [self setErrortext: 0];
        
        // cell背景及底部line
        cellBGimageView = [[UIImageView alloc]init];
        SET_IMAGE(cellBGimageView.image, @"cell_bg_notline.png");
        
        cellBGimageView.userInteractionEnabled = YES;
        
        bottomLineImageView = [[UIImageView alloc]init];
        bottomLineImageView.backgroundColor = SEPERATE_LINE_COLOR;
        
        [self addSubview:cellBGimageView];
        [self addSubview:bottomLineImageView];
        
        //
        iconImageView = [[UIImageView alloc]init];
        iconImageView.image = defaultImg;
        iconImageView.layer.borderWidth = .5;
        iconImageView.layer.borderColor = hllColor(50, 50, 50, 0.2).CGColor;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        nameLabel.textColor=namelableColor;
        nameLabel.text = @"";
        self.nameLabel = nameLabel;

//        volumeLabel = [[UILabel alloc]init];
//        volumeLabel.textAlignment = NSTextAlignmentRight;
//        volumeLabel.backgroundColor = [UIColor clearColor];
//        volumeLabel.textColor = GRAY_TEXT_COLOR;
//        volumeLabel.font = [UIFont systemFontOfSize:12.0f];
//        volumeLabel.text = @"";
        
        downProgressView = [[BPPProgressView alloc] init];
        UIImage * image = nil;
        image = [UIImage imageNamed:@"progressBG.png"];
        image = [image stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];
        downProgressView.trackImage = image;
        image = [UIImage imageNamed:@"progressBG02.png"];
        image = [image stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];
        downProgressView.progressImage = image;
        
        littleLoadingPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        littleLoadingPauseBtn.tag = (NSUInteger)self;
        
        speedLabel = [[UILabel alloc]init];
        speedLabel.backgroundColor = [UIColor clearColor];
        speedLabel.textAlignment=NSTextAlignmentRight;
        speedLabel.font = [UIFont systemFontOfSize:12.0f];
        speedLabel.textColor = GRAY_TEXT_COLOR;
        speedLabel.text = @"0.0M(0.0KB/s)";
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.textColor = GRAY_TEXT_COLOR;
        timeLabel.text = @"";
        
        netErrorLabel = [[UILabel alloc]init];
        netErrorLabel.backgroundColor = [UIColor clearColor];
        netErrorLabel.textAlignment = NSTextAlignmentRight;

        netErrorLabel.font = [UIFont systemFontOfSize:10.0f];
        netErrorLabel.textColor = GRAY_TEXT_COLOR;

        netErrorLabel.hidden = YES;
        
        self.startOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startOrPauseBtn.tag = (NSUInteger)self;
        
        self.startOrPauseBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.startOrPauseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.startOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.startOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        
        
        //        _progressLabel
        _progressLabel = [[UILabel alloc]init];
        _progressLabel.backgroundColor =[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
//        _progressLabel.backgroundColor=[UIColor blackColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:10.0f];
        _progressLabel.textColor = GRAY_TEXT_COLOR;
        _progressLabel.text = @"0%";

        
        [cellBGimageView addSubview:downProgressView];
        [cellBGimageView addSubview:littleLoadingPauseBtn];
        [cellBGimageView addSubview:self.startOrPauseBtn];
        [cellBGimageView addSubview:iconImageView];
        [cellBGimageView addSubview:self.nameLabel];
//        [cellBGimageView addSubview:volumeLabel];
        [cellBGimageView addSubview:speedLabel];
        [cellBGimageView addSubview:timeLabel];
        [cellBGimageView addSubview:_progressLabel];
        [cellBGimageView addSubview:netErrorLabel];

    }
    
    return self;
}

#pragma mark - 外露接口

- (void)downLoadingIconImage:(UIImage *)img{
    
    iconImageView.image = img?img:defaultImg;
}

- (void)downLoadingName:(NSString *)nameStr{ // 设置标题
    
    NSAssert(nameStr!=nil, @"nameStr!=nil");
    
    if (nameStr != nil && ![nameStr isEqualToString:@""]) {
        self.nameLabel.text = nameStr;
    }
    
}

- (void)downLoadingVolume:(CGFloat)volume{ // 设置大小
    
//    volumeLabel.text = [NSString stringWithFormat:@"%.1fM",(CGFloat)volume/1024.0/1024.0];

    volumeFloat=volume;
//    NSLog(@"----%@",str);
    [self initspeedLable];
}

- (void)downLoadingSpeed:(CGFloat)speedFloat{ // 下载速度label显示
    [self setCellStatus:DOWNLOAD_STATUS_RUN];
//    speedLabel.text = [NSString stringWithFormat:@"(%.1fKB/s)",speedFloat];
    NSString*str = [NSString stringWithFormat:@"(%.1fKB/s)",speedFloat];

    speedlableFloat=speedFloat;
//    NSLog(@"====%f",str);
    [self initspeedLable];
}
- (void)initspeedLable{
    if (volumeFloat>0&&speedlableFloat>0) {
        NSString*str=[NSString stringWithFormat:@"%.1fM(%.1fKB/s)",(CGFloat)volumeFloat/1024.0/1024.0,speedlableFloat];
//        NSLog(@"----------------%@",str);
        speedLabel.text=str;
    }
}
- (void)downLoadingProgress:(CGFloat)progress animated:(BOOL)animated{ // 下载速度进度条
    [downProgressView setProgress:progress animated:animated];
    CGFloat width = progress * downProgressView.bounds.size.width;
    
    int a=progress*100;
    if (downProgressView.frame.origin.x>0) {
        
    
    _progressLabel.frame = CGRectMake(downProgressView.frame.origin.x+width-5, downProgressView.frame.origin.y-3.5, 30, 8);
    _progressLabel.text=[NSString stringWithFormat:@"%d%%",a];
    }
}


- (void)downLoadingTime:(NSUInteger)time{
    
//    timeLabel.hidden = NO;
    NSString *timeStr = nil;
    timeStr = [self secondToTimeZone:time];
    if (time == 0 || [timeStr isEqualToString:@"noTime"]) {
        timeLabel.text = @"0秒";
    }else if (time == INFINITE_TIME){
        timeLabel.text = @"正在预估...";
    }else if (time == WAIT_FOR_DOWN){
        timeLabel.text = @"等待下载";
    }else{
        timeLabel.text = timeStr;
    }
}

- (NSString *)secondToTimeZone:(NSUInteger)second{
    
    NSInteger hour=0, minite=0;
    hour = second/60/60;
    minite = (second - hour*60*60)/60;
    second = second - hour*60*60 - minite*60;
    
    if (hour>0) {
        return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,minite,second];
    }else if (minite>0){
        return [NSString stringWithFormat:@"%.2d:%.2d",minite,second];
    }else if (second>0){
        return [NSString stringWithFormat:@"%.2d秒",second];
    }else{
        return @"noTime";
    }
    
}

- (void)setCellStatus:(NSInteger)status {
    
    self.statusStr = [NSString stringWithFormat:@"%d",status];
    
    if (status == DOWNLOAD_STATUS_RUN) {
        //run
        netErrorLabel.hidden = YES;
//        speedLabel.hidden = NO;
//        timeLabel.hidden = NO;
    
        [littleLoadingPauseBtn setImage:littleLoadingImg forState:UIControlStateNormal];
//        [self.startOrPauseBtn setImage:downPauseImg forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];

        
    }else if (status == DOWNLOAD_STATUS_ERROR){
        //error
        netErrorLabel.hidden = NO;
//        speedLabel.hidden = YES;
//        timeLabel.hidden = YES;
        
        [littleLoadingPauseBtn setImage:littlePauseImg forState:UIControlStateNormal];
//        [self.startOrPauseBtn setImage:downGoImg forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"继续" forState:UIControlStateNormal];


    }else if (status == DOWNLOAD_STATUS_SUCCESS){
        //success
        netErrorLabel.hidden = YES;
//        speedLabel.hidden = YES;
//        timeLabel.hidden = YES;
    
        
    }else if (status == DOWNLOAD_STATUS_WAIT){
        //wait
        netErrorLabel.hidden = YES;
//        speedLabel.hidden = NO;
        //speedLabel.text = @"等待中...";
//        timeLabel.hidden = YES;

    
//        self.speedLabel.text = @"等待中...";
        [littleLoadingPauseBtn setImage:littleWaitingImg forState:UIControlStateNormal];
//        [self.startOrPauseBtn setImage:downPauseImg forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];


    }else if (status == DOWNLOAD_STATUS_STOP) {
        //pause
        netErrorLabel.hidden = YES;
//        speedLabel.hidden = NO;
//        timeLabel.hidden = YES;
//        timeLabel.text=@"已暂停";
       speedLabel.text=@"已暂停";
//        self.speedLabel.text = @"暂停下载";
        [littleLoadingPauseBtn setImage:littlePauseImg forState:UIControlStateNormal];
//        [self.startOrPauseBtn setImage:downGoImg forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"继续" forState:UIControlStateNormal];

        self.statusStr = [NSString stringWithFormat:@"%d",status];

        
    }else if (status == DOWNLOAD_STATUS_MD5_CHECK) {
        //md5 check
        
        self.speedLabel.text = @"文件校验中...";
//        [self.startOrPauseBtn setImage:downPauseImg forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];

        //MD5检测属于RUN状态
        self.statusStr = [NSString stringWithFormat:@"%d",DOWNLOAD_STATUS_RUN];
    }
}

- (void)downLoadComplete{
//    speedLabel.hidden = YES;
//    timeLabel.hidden = YES;
}

- (void) setErrortext:(int)errortext {
    
    if (errortext == DownloadErrorNet) {
        netErrorLabel.text = @"网络连接错误,请检查网络";
    }else if (errortext == DownloadErrorNoFreeSpace) {
        netErrorLabel.text = @"系统磁盘空间不足";
    }else if (errortext == DownloadErrorFileException) {
        netErrorLabel.text = @"文件校验异常";
    }else if (errortext == DownloadErrorFileLocalWriteException) {
        netErrorLabel.text = @"文件写入异常";
    }else if (errortext == DownloadErrorFileLengthException) {
        netErrorLabel.text = @"文件不完整";
    }else if (errortext == DownloadErrorDownloadTypeToGetAppInfo) {
        netErrorLabel.text = @"获取App信息失败";
    }
}

#pragma mark - 自定义多选
- (void)setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
        if (alpha) {
            cellBGimageView.center = CGPointMake(self.center.x+EDITOFFSET, cellBGimageView.center.y);
        }else
        {
            cellBGimageView.center = CGPointMake(self.center.x, cellBGimageView.center.y);
        }
        
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}


- (void)setEditing:(BOOL)editting animated:(BOOL)animated
{
    
    if (IOS7) {
        self.startOrPauseBtn.enabled = !editting;
        self.startOrPauseBtn.userInteractionEnabled = !editting;
        if (editting) {
            self.startOrPauseBtn.titleLabel.alpha = 0.5;
        }else
        {
            self.startOrPauseBtn.titleLabel.alpha = 1;
        }
    }else
    {
        self.startOrPauseBtn.hidden = editting;
    }
    
    if (self.editingStyle == UITableViewCellEditingStyleDelete) {
        if (!IOS7) {
            
            [super setEditing:editting animated:animated];
        }
        return;
    }
    
	if (self.editing == editting)
	{
		return;
	}
	
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.backgroundView = [[UIView alloc] init];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] init];
            SET_IMAGE(m_checkImageView.image, @"Unselected.png");
            m_checkImageView.frame = CGRectMake(0, 0, 22, 22);
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}

- (void)setChecked:(BOOL)checked
{
	if (checked)
	{
//		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
        SET_IMAGE(m_checkImageView.image, @"Selected.png");
	}
	else
	{
//		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
        SET_IMAGE(m_checkImageView.image, @"Unselected.png");
	}
	m_checked = checked;
    
    self.backgroundView.backgroundColor = self.backgroundColor;
}

#pragma mark - Life Cycle

- (void) layoutSubviews {
    if (!IOS7) {
        [super layoutSubviews];
    }
    
    cellBGimageView.frame = self.bounds;
    
    if (self.editingStyle != UITableViewCellEditingStyleDelete) {
        if (self.editing) {
            m_checkImageView.center = CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5);
            cellBGimageView.center = CGPointMake(self.center.x+EDITOFFSET, cellBGimageView.center.y);
            
        }else
        {
            m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                                  CGRectGetHeight(self.bounds) * 0.5);
            cellBGimageView.center = CGPointMake(self.center.x, cellBGimageView.center.y);
        }
    }
    
    iconImageView.frame = CGRectMake(13*MULTIPLE, 13*MULTIPLE, 52*MULTIPLE, 52*MULTIPLE);
    iconImageView.layer.cornerRadius = 10;
    iconImageView.layer.masksToBounds = YES;

    CGFloat nameOri_X = iconImageView.frame.origin.x + iconImageView.frame.size.width + 13;
    self.nameLabel.frame = CGRectMake(nameOri_X, (13.5+4)*MULTIPLE, 375/2*(MainScreen_Width/320.0), 13);
    downProgressView.frame = CGRectMake(nameOri_X, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + (7+16+5)*MULTIPLE, 355/2*(MainScreen_Width/320), 2);
    //    littleLoadingPauseBtn.frame = CGRectMake(nameOri_X, downProgressView.frame.origin.y + downProgressView.frame.size.height + 7, 12, 12);
    //    70.15
    speedLabel.frame = CGRectMake(downProgressView.frame.origin.x + downProgressView.frame.size.width - 110, (13 +18+6)*MULTIPLE, 110, 11);
    self.startOrPauseBtn.frame = CGRectMake(self.frame.size.width - 64*MULTIPLE, 26*MULTIPLE, 53*MULTIPLE, 28*MULTIPLE);
//    volumeLabel.frame = CGRectMake(downProgressView.frame.origin.x + downProgressView.frame.size.width - 65-70, (13 +18+6)*MULTIPLE, 65, 11);
    timeLabel.frame = CGRectMake(nameOri_X,(13 +18+6)*MULTIPLE, 65, 11);
    netErrorLabel.frame = CGRectMake(downProgressView.frame.origin.x,downProgressView.frame.origin.y+5*MULTIPLE , 355/2*(MainScreen_Width/320), 10);
    
    bottomLineImageView.frame = CGRectMake(8, self.bounds.size.height - 0.5, self.bounds.size.width - 8, 0.5);
}

- (void)dealloc{
    self.idenStr = nil;
    self.statusStr = nil;
    self.progDic = nil;
    self.downingAppid = nil;
    
    self.nameLabel = nil;
    m_checkImageView = nil;
}


@end
