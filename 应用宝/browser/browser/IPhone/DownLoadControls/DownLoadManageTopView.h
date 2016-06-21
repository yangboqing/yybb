//
//  DownLoadManageTopView.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  应用管理顶部视图

#import <UIKit/UIKit.h>


@protocol DownLoadManageTopViewDelegate <NSObject>
@optional

- (void)downloadManageTopButtonClick:(NSString*)pageName;

@end

@interface DownLoadManageTopView : UIView

@property (nonatomic , weak) id<DownLoadManageTopViewDelegate>topViewDelegate;
@property (nonatomic , strong) UIButton *downingBtn;
@property (nonatomic , strong) UIButton *downedBtn;
@property (nonatomic , strong) UIButton *updateBtn;

- (void)refreshManageTopButton; // 刷新应用数显示（下载中、已下载、更新）
- (void)touchTopButton:(NSString*)pageName;
@end
