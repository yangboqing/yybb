//
//  LoginWindowView.h
//  browser
//
//  Created by 王毅 on 15/1/6.
//
//首次点击安装时弹出的提示绑定APPID的界面

#import <UIKit/UIKit.h>

@protocol LoginWindowDelegate <NSObject>

- (void)hiddenself;

@end

@interface LoginWindowView : UIView{
    UIImageView *showView;
}
@property(nonatomic , assign) id<LoginWindowDelegate>delegate;
@end
