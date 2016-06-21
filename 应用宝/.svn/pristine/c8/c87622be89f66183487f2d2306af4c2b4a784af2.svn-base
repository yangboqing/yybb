//
//  FlashQuitRepairView.h
//  browser
//
//  Created by 王 毅 on 13-2-1.
//
//

#import <UIKit/UIKit.h>
#import "HeadImageView.h"
@class PopViewController;
@protocol lessonDelegate <NSObject>

- (void)openLesson;
- (void)closeLesson;

@end

@interface FlashQuitRepairView : UIView{
    UIImageView *repairBgImgView;//闪退弹框修复背景
    UILabel *repairInfoLabel; // 修复信息
    UILabel *infoTipLabel; // 修复提示信息
    UIImageView *shortLineView;
    UIImageView *repairInfoTipView;//闪退弹框注意图标
    
    // loading
    UIActivityIndicatorView *activityIndicator;
    
    // button cutting line
    UIImageView *horizontalLineView;
    UIImageView *verticalLineView;
    UILabel *titleLabel;
    
    NSInteger repairStateFlag; // 0:ready repair 1:repairing 2:success 3:fail
}
@property (nonatomic , strong) UIButton *repairBtn;
@property (nonatomic , strong) UIButton *repairCloseBtn;//闪退弹框修复的关闭按钮
@property (nonatomic , strong) UILabel *repairLabel;// 修复ing & 修复ed
@property (nonatomic , strong) UIButton *lessonButton;//查看教程按钮;
@property (nonatomic , weak)id<lessonDelegate>lessonDelegate;
- (void)isShowReadyOrIng:(int)index;
- (void)startRepairingAnimation;
-(void)showRepairingResult:(NSInteger)result;
@end
