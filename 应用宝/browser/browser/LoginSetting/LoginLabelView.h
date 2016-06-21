//
//  LoginLabelView.h
//  browser
//
//  Created by 王毅 on 15/1/12.
//
//绑定APPID登录界面下面的有点详细内容

#import <UIKit/UIKit.h>

@interface LoginLabelView : UIView{
    UIImageView *headImageView;
    UILabel *titleLabel;
}
- (void)setTitleLabelText:(NSString*)text;
@end
