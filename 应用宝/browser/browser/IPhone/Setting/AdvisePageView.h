//
//  AdvisePageView.h
//  browser
//
//  Created by 王 毅 on 13-4-12.
//
//

#import <UIKit/UIKit.h>
#import "FileUtil.h"

#define TEXTVIEW_TEXT    @"savetextview"
#define TEXTFIELD_TEXT   @"savetextfield"

@protocol AdvisePageViewDelegate <NSObject>
@optional
//键盘高度
- (void)keyboardHeight:(CGFloat)height;
- (void)chanelFocus;
@end

@interface AdvisePageView : UIView<UITextViewDelegate,UITextFieldDelegate>{
    // 记录输入的字数UILabel
    UILabel *numericlabel;
    //反馈者联系方式的textfield
    UITextField *mobileTextField;
    //上传信息的字典
    NSMutableDictionary *uploadTextDic;
    //提交等待界面的背景
    UIImageView *uploadImageView;
    //提交等待界面的笑脸图
    UIImageView *uploadSubImageView;
    //提交等待界面的文字
    UILabel *uploadLabel;
    //textview的背景图
    UIImageView *textViewBGImageView;
    //textfield背景图
    UIImageView *textFieldBGImageView;
    //关闭按钮 iPad
    UIButton *closeButton;
    
    //菊花
     UIActivityIndicatorView *activityIndicator;
    UIImageView *bgTransparentView;
    
    BOOL firstEnable;
    BOOL isSucceed;
    
    BOOL isCanClickUpdataButton;
    BOOL isTextField; // 判断是否是点击的mobileTextField
    
    
    UIScrollView *scrollView;
    UIImageView *bgImgView;
}
@property (nonatomic , weak) id<AdvisePageViewDelegate>delegate;
@property (nonatomic, strong) UITextView *contentTextView; //问题反馈正文的textview

- (void)resignAllResponder;
- (void)uploadAdvise:(UIButton *)sender; // 提交action
@end
