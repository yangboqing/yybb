//
//  DownLoadingTableViewCell.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import <UIKit/UIKit.h>

@class BPPProgressView;

#define INFINITE_TIME   999999999
#define WAIT_FOR_DOWN 11111

@interface DownLoadingTableViewCell : UITableViewCell{
    
    UIImageView *cellBGimageView;
    
    UIImageView *iconImageView; // 图标
    UILabel *volumeLabel; // 软件大小
    BPPProgressView *downProgressView; // 进度条
    UIButton *littleLoadingPauseBtn; // 下载、暂停、等待图标(Button)
    UILabel *timeLabel; // 时间Label
    UILabel *netErrorLabel; // 显示错误信息Label
    
    // Image
    UIImage *defaultImg;
    UIImage *littleLoadingImg;
    UIImage *littlePauseImg;
    UIImage *littleWaitingImg;
    UIImage *downGoImg;
    UIImage *downPauseImg;
}

@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *speedLabel;
@property (nonatomic , strong) UILabel *progressLabel;


@property (nonatomic , strong) UIButton *startOrPauseBtn;

@property (nonatomic , strong) NSMutableDictionary *progDic; // 下载进度
@property (nonatomic , strong) NSString *idenStr;
@property (nonatomic , strong) NSString *statusStr;
@property (nonatomic , strong) NSString *downingAppid;
@property (nonatomic , assign) BOOL cellEnable;

// 编辑状态
@property (nonatomic , strong) UIImageView *m_checkImageView;
@property (nonatomic , assign) BOOL m_checked;

// 图标
- (void)downLoadingIconImage:(UIImage *)img;
- (void)downLoadingName:(NSString *)nameStr;
- (void)downLoadingVolume:(CGFloat)volume;
- (void)downLoadingSpeed:(CGFloat)speedFloat;
- (void)downLoadingProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)downLoadingTime:(NSUInteger)time; // 剩余时间
- (void)setCellStatus:(NSInteger)index;// 设置Cell状态
- (void)downLoadComplete;//下载完成

- (void)setChecked:(BOOL)checked;//设置选中状态
- (void)setErrortext:(int)type;// 设置错误信息
@end
