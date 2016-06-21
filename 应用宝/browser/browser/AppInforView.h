//
//  AppInforView.h
//  browser
//
//  Created by caohechun on 14-4-2.
//
//

#import <UIKit/UIKit.h>
//app 详情页的表视图的headView,用于显示app基本信息
@class DownloadBtn;
@interface AppInforView : UIView{
    @public
    UIImageView * iconImageView;

}
@property(nonatomic,retain) UIButton *appStateButton;
@property(nonatomic,retain) NSString *appID;
- (void)initAppInforWithData:(NSDictionary *)dataDic;//设置常规信息
- (void)setIconImage:(UIImage *)iconImage;//设置图标
- (void)resetPraiseCount:(NSString *)count;//重新设置推荐数量
- (NSString *)getPraiseCount;//获取推荐数量
- (void)initDownloadButtonState;//更新按钮状态
@end
