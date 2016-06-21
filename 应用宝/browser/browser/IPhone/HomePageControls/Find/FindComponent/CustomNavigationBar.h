//
//  CustomNavigationBar.h
//  browser
//
//  Created by liguiyang on 14-5-27.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    rightButtonType_NONE = 200,
    rightButtonType_ONE,
}RightButtonType;

@protocol CustomNavigationBarDelegate <NSObject>
-(void)popCurrentViewController;
@end

@interface CustomNavigationBar : UIView
{
    CGFloat originX_title;
    CGFloat width_title;
    CGFloat originX_PraiseBtn;
    CGFloat originX_RightTopBtn;
    CGSize backItemSize;
}
@property (nonatomic, strong) UIButton *backButton; // 返回按钮
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIButton *praiseButton; // 赞
@property (nonatomic, strong) UIButton *shareButton; // 分享
@property (nonatomic, strong) UIButton *rightTopButton; // rightBarButton
@property (nonatomic, weak) id <CustomNavigationBarDelegate>delegate;

// 整个NavigationBar，自定义backButton
-(void)showBackButton:(BOOL)showFlag navigationTitle:(NSString *)title rightButtonType:(RightButtonType)btnType;

// 赋值给navigation的titleView,BackButton是navigation的leftBarButtonItem
-(void)showNavigationTitleView:(NSString *)title;
-(void)praiseAndShareButtonSelectEnable:(BOOL)flag; // 赞、分享按钮是否可点击()

@end
