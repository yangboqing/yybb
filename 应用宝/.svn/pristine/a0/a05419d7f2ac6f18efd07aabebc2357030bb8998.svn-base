//
//  LoginViewController.h
//  browser
//
//  Created by 王毅 on 15/1/6.
//
//绑定APPID的登录界面

#import <UIKit/UIKit.h>
#import "FileUtil.h"
#import "LoginLabelView.h"
#import "CustomNavigationBar.h"
#import "LoginSucessViewController.h"
#import "MyNavigationController.h"
#import "LoginServerManage.h"
#import "FreeAccountViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,CustomNavigationBarDelegate,LoginServerDelegate>{
    CustomNavigationBar *navBar;
    LoginServerManage *loginServer;
    
    
}
@property (nonatomic , strong) UITextField *LoginTitle;
@property (nonatomic , strong) UITextField *passWord;
@property (nonatomic , strong) UIButton *loginBtn;
- (void)beginLogin;
@end
