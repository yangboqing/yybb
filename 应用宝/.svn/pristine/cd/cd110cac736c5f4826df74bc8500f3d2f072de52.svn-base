//
//  YulanPageView.h
//  browser
//
//  Created by 王毅 on 14-9-1.
//
//

#import <UIKit/UIKit.h>

#define CLICK_YULAN_TEXT @"点击屏幕即可预览"
#define NET_TROBLEM_TEXT @"网络问题"
#define BIZHI_SETTING_TEXT @"设置中..."
#define BIZHI_SAVING_TEXT @"保存中..."
#define BIZHI_SETTING_COMPLTE_TEXT @"设置成功"
#define BIZHI_SAVE_COMPLTE_TEXT @"保存成功"

@protocol YulanPageDelegate <NSObject>
@optional
- (void)clickFirstYulanPage:(NSInteger)index;

@end


@interface YulanPageView : UIView{
    UIImageView *backGroundImageView;
    UIImageView *YulanTubiao;
    UIImageView *tubiaoBackgroundImageView;
    UIImageView *notWebImageVIew;
    UIImageView *bizhiSetSuccessImageView;
    UILabel *imageVIewLabel;
    UIImageView *bizhiSettingBaseView;
    UIImageView *bizhiSettingTurnView;
    BOOL choiceLabelY;
    UIActivityIndicatorView *_activityIndicator;
    
}
@property (nonatomic ,weak)id<YulanPageDelegate>delegate;
//0:只显示一次的预览引导图 1：没网  2：设置中  3：设置成功  4：保存成功
- (void)isShowWhatImageVIew:(NSInteger)showState isSave:(BOOL)isSave;
@end
