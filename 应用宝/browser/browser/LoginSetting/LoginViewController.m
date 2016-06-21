//
//  LoginViewController.m
//  browser
//
//  Created by 王毅 on 15/1/6.
//
//

#import "LoginViewController.h"
#import "StatementViewController.h"
#import "MyNavigationController.h"

#define LOGIN_DEFAULT_STRING @"请输入您的Apple ID"
#define PASSWORD_DEFAULT_STRING @"请输入您的密码"
#define EMPTY_TEXT_COLOR [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
#define MAX_LENGTH 30
#define LOGIN_TEXT @"loginSaveText"
#define PASSWORD_TEXT @"passwordSaveText"

#define SIDE_WIDTH 15*IPHONE6_XISHU

@interface LoginViewController(){
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    
    UIImageView *line;
    
    UIImageView *bgImageView;
    NSMutableDictionary *uploadTextDic;
    
    
    UIButton *selectBtn;
    UILabel *xieyiLabel;
    UILabel *selectLabel;
    
    NSArray *infoDataArray;
    
    
    UIView *firstInfoView;
    UIView *secondInfoView;
    UIView *thirdInfoView;
    
    
    UILabel *getFreeAccountLabel;
    
    BOOL isSelect;
    StatementViewController *statementViewController;
    
}

@end


@implementation LoginViewController

- (id)init{
    
    self = [super init];
    if (self) {
        
        uploadTextDic = [NSMutableDictionary dictionary];
        infoDataArray = [NSArray arrayWithObjects:@"安装应用将永久不会出现异常闪退情况",@"使用自己的Apple ID进行应用内购买",@"使用自己的Apple ID登录Game Center", nil];
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = hllColor(242, 242, 242, 1);
    self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitCurrentPage:) name:QUIT_BINDING_PAGE object:nil];
    
    
    loginServer = [LoginServerManage new];
    loginServer.delegate = self;
    
    NSString *account = LOGIN_DEFAULT_STRING;
    NSString *password = PASSWORD_DEFAULT_STRING;
    
    BOOL isLogin = NO;
    
    NSDictionary *dic = [[FileUtil instance] getAccountPasswordInfo];
    if (dic && [dic objectForKey:SAVE_ACCOUNT] && [dic objectForKey:SAVE_PASSWORD]) {
        account = [dic objectForKey:SAVE_ACCOUNT];
        password = [dic objectForKey:SAVE_PASSWORD];
        isLogin = YES;
    }

    
    navBar = [[CustomNavigationBar alloc] init];
    navBar.frame = self.navigationController.navigationBar.bounds;
    navBar.delegate = self;
    [navBar showBackButton:YES navigationTitle:@"Apple ID绑定" rightButtonType:rightButtonType_NONE];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    statementViewController = [[StatementViewController alloc]init];
    
    
    bgImageView = [UIImageView new];
    bgImageView.image = [UIImage imageNamed:@"login-box"];
    bgImageView.backgroundColor = CLEAR_COLOR;
    bgImageView.userInteractionEnabled = YES;
    
    
    topLabel = [UILabel new];
    topLabel.font = [UIFont systemFontOfSize:13.0f];
    topLabel.text = @"登陆后,即可使用您的Apple ID下载App";
    topLabel.textColor = GRAY_TEXT_COLOR;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    

    bottomLabel = [UILabel new];
    bottomLabel.font = [UIFont systemFontOfSize:17.0f];
    bottomLabel.text = @"绑定Apple ID的优点";
    bottomLabel.textColor = hllColor(81, 81, 81, 1);
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    line = [UIImageView new];
    line.backgroundColor = hllColor(193, 193, 193, 1);
    

    //登录输入框
    _LoginTitle = [UITextField new];
    _LoginTitle.tag = 1;
    _LoginTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _LoginTitle.backgroundColor = [UIColor clearColor];
    _LoginTitle.delegate = self;
    _LoginTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
    _LoginTitle.text = account;
    _LoginTitle.font = [UIFont systemFontOfSize:16.0f];
    _LoginTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _LoginTitle.textColor = EMPTY_TEXT_COLOR;
    _LoginTitle.keyboardType = UIKeyboardTypeDefault;
    _LoginTitle.returnKeyType = UIReturnKeyNext;
    _LoginTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    
    //密码输入框
    _passWord = [UITextField new];
    _passWord.tag = 2;
    _passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWord.backgroundColor = [UIColor clearColor];
    _passWord.delegate = self;
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.font = [UIFont systemFontOfSize:16.0f];
    _passWord.text = password;
    _passWord.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _passWord.textColor = EMPTY_TEXT_COLOR;
    _passWord.keyboardType = UIKeyboardTypeDefault;
    _passWord.returnKeyType = UIReturnKeyDone;
    _passWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (isLogin == YES) {
        _passWord.secureTextEntry=YES;
    }
    
    
    getFreeAccountLabel = [UILabel new];
    getFreeAccountLabel.backgroundColor = CLEAR_COLOR;
    getFreeAccountLabel.text = @"获取免费账号";
    getFreeAccountLabel.textAlignment = NSTextAlignmentRight;
    getFreeAccountLabel.textColor = MY_BLUE_COLOR;
    getFreeAccountLabel.font = [UIFont systemFontOfSize:14.0f];
    getFreeAccountLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *freeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getFreeAccount)];
    [getFreeAccountLabel addGestureRecognizer:freeTap];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:WILL_GIVE_ACCOUNT] isEqualToString:@"off"]) {
        getFreeAccountLabel.hidden = YES;
    }
    
    
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor clearColor];
//    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn-login"] forState:UIControlStateNormal];
//    [_loginBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = MY_YELLOW_COLOR;
    [_loginBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
 
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = CLEAR_COLOR;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"check-box-checked"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    xieyiLabel = [UILabel new];
    xieyiLabel.font = [UIFont systemFontOfSize:14.0f];
    xieyiLabel.text = @"我已阅读并同意";
    xieyiLabel.textColor = hllColor(162, 162, 162, 1);
    xieyiLabel.backgroundColor = [UIColor clearColor];
    xieyiLabel.textAlignment = NSTextAlignmentLeft;
    
    
    selectLabel = [UILabel new];
    selectLabel.font = [UIFont systemFontOfSize:14.0f];
    selectLabel.text = @"免责声明";
    selectLabel.textColor = MY_BLUE_COLOR;
    selectLabel.backgroundColor = [UIColor clearColor];
    selectLabel.textAlignment = NSTextAlignmentLeft;
    selectLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showStatement)];
    [selectLabel addGestureRecognizer:tap];
    
    
    firstInfoView = [self creatBottomInfoView:0];
    secondInfoView = [self creatBottomInfoView:1];
    thirdInfoView = [self creatBottomInfoView:2];
    
    [self.view addSubview:firstInfoView];
    [self.view addSubview:secondInfoView];
    [self.view addSubview:thirdInfoView];
    
    
    [self.view addSubview:topLabel];
    

    [bgImageView addSubview:_LoginTitle];
    [bgImageView addSubview:_passWord];
    [self.view addSubview:bgImageView];
    
    [self.view addSubview:line];
    [self.view addSubview:bottomLabel];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:selectBtn];
    [self.view addSubview:xieyiLabel];
    [self.view addSubview:selectLabel];
    [self.view addSubview:getFreeAccountLabel];
    
    [self makeFrame];
}
- (void)makeFrame{
    
    topLabel.frame = CGRectMake(SIDE_WIDTH, 64, self.view.frame.size.width - SIDE_WIDTH*2, 40*IPHONE6_XISHU);
    bgImageView.frame = CGRectMake(0, topLabel.frame.origin.y + topLabel.frame.size.height - 6 , MainScreen_Width, (179/2)*IPHONE6_XISHU);
    _LoginTitle.frame = CGRectMake(37*IPHONE6_XISHU, 0, MainScreen_Width, bgImageView.frame.size.height/2 - 1);
    _passWord.frame = CGRectMake(_LoginTitle.frame.origin.x, bgImageView.frame.size.height/2 +1, _LoginTitle.frame.size.width, _LoginTitle.frame.size.height);
    
    getFreeAccountLabel.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y + bgImageView.frame.size.height + 8*IPHONE6_XISHU, bgImageView.frame.size.width - 20, 20*IPHONE6_XISHU);
    
    
    _loginBtn.frame = CGRectMake(0, getFreeAccountLabel.frame.origin.y + getFreeAccountLabel.frame.size.height + 12*IPHONE6_XISHU, MainScreen_Width, 40*IPHONE6_XISHU);
    selectBtn.frame = CGRectMake(SIDE_WIDTH, _loginBtn.frame.origin.y + _loginBtn.frame.size.height + 15*IPHONE6_XISHU, 16*IPHONE6_XISHU, 16*IPHONE6_XISHU);
    xieyiLabel.frame = CGRectMake(selectBtn.frame.origin.x + selectBtn.frame.size.width + 4*IPHONE6_XISHU, selectBtn.frame.origin.y, 100, selectBtn.frame.size.height);
    selectLabel.frame = CGRectMake(xieyiLabel.frame.origin.x + xieyiLabel.frame.size.width, xieyiLabel.frame.origin.y, 56, xieyiLabel.frame.size.height);
    line.frame = CGRectMake(10*IPHONE6_XISHU, selectBtn.frame.origin.y + selectBtn.frame.size.height + 20, self.view.frame.size.width - 20*IPHONE6_XISHU, 1);
    bottomLabel.frame = CGRectMake(0, line.frame.origin.y + line.frame.size.height + 20*IPHONE6_XISHU, self.view.frame.size.width, 20);
    firstInfoView.frame = CGRectMake(SIDE_WIDTH*2, bottomLabel.frame.origin.y + bottomLabel.frame.size.height + 17, 250, 16);
    firstInfoView.center = CGPointMake(MainScreen_Width/2, firstInfoView.center.y);
    secondInfoView.frame = CGRectMake(firstInfoView.frame.origin.x, firstInfoView.frame.origin.y + firstInfoView.frame.size.height + 9*IPHONE6_XISHU, firstInfoView.frame.size.width, firstInfoView.frame.size.height);
    thirdInfoView.frame = CGRectMake(firstInfoView.frame.origin.x, secondInfoView.frame.origin.y + secondInfoView.frame.size.height + 9*IPHONE6_XISHU, firstInfoView.frame.size.width, firstInfoView.frame.size.height);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:navBar];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [navBar removeFromSuperview];
}
#pragma mark - CustomNavigationBarDelegate

-(void)popCurrentViewController
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IS_QUIT_BINDING_PAGE object:nil];
    
    //my 新增
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)showStatement{
    [self.navigationController pushViewController:statementViewController animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        [_passWord resignFirstResponder];
        if ([_LoginTitle.text isEqualToString:LOGIN_DEFAULT_STRING]) {
            textField.text = @"";
        }
    }else{
        [_LoginTitle resignFirstResponder];
        if ([_passWord.text isEqualToString:PASSWORD_DEFAULT_STRING]) {
            textField.text = @"";
        }
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""] || textField.text.length < 1){//|| ![textField.text isEqualToString:[TEXTFILED_DEFAULT_STRING ]]) {
        textField.textColor = EMPTY_TEXT_COLOR;
        if (textField.tag == 1) {
            _LoginTitle.text = LOGIN_DEFAULT_STRING;
        }else{
            _passWord.secureTextEntry=NO;
            _passWord.text = PASSWORD_DEFAULT_STRING;
            
        }
        
    }else{
        textField.textColor = [UIColor blackColor];
        if (textField.tag == 1) {
            [uploadTextDic setObject:textField.text forKey:LOGIN_TEXT];
        }else{
            [uploadTextDic setObject:textField.text forKey:PASSWORD_TEXT];
            _passWord.secureTextEntry=YES;
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 2) {
        _passWord.secureTextEntry=YES;
    }
    
//    if (textField.text.length > MAX_LENGTH) {
//        textField.text = [textField.text substringToIndex:MAX_LENGTH];
//    }
    textField.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAllResponder];
    if (textField.tag == 1) {
        [_passWord becomeFirstResponder];
    }
    
    return YES;
}
- (void)getFreeAccount{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"loginloading"];
    [loginServer requestGetFreeAccountInfo];
}

- (void)requestGetFreeAccountSucess:(NSString*)account password:(NSString *)password{
    _LoginTitle.text = account;
    _passWord.text = password;
}

- (void)clickSelect:(UIButton *)sender{
    if (isSelect) {
        _loginBtn.enabled = YES;
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"check-box-checked"] forState:UIControlStateNormal];
    }else{
        _loginBtn.enabled = NO;
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"check-box-normal"] forState:UIControlStateNormal];
    }
    isSelect = !isSelect;
}
- (void)clickLogin:(UIButton*)sender{
    
    [self beginLogin];
    
}

- (void)beginLogin{
    NSString * netType = [[FileUtil instance] GetCurrntNet];
    if (netType == nil) {
        [[FileUtil instance] showAlertView:nil message:@"没有连接到网络，请检查网络后再次提交"  delegate:self];
        
        return;
    }
    
    
    if (_LoginTitle.text.length < 2 || [_LoginTitle.text isEqualToString:LOGIN_DEFAULT_STRING]) {
        [[FileUtil instance] showAlertView:@"账号长度不正确" message:nil delegate:self];
        return;
    }else if (_passWord.text.length <2 || [_passWord.text isEqualToString:PASSWORD_DEFAULT_STRING]){
        [[FileUtil instance] showAlertView:@"请输入您的密码" message:nil delegate:self];
        return;
    }
    [self resignAllResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"loginloading"];
    [loginServer requestLoginFromServer:_LoginTitle.text password:_passWord.text userData:self];

}

- (LoginLabelView*)creatBottomInfoView:(int)index{
    LoginLabelView *view = [LoginLabelView new];
    view.backgroundColor = CLEAR_COLOR;
    [view setTitleLabelText:[infoDataArray objectAtIndex:index]];
    
    return view;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //移除导航的右滑返回手势
    MyNavigationController *nav = (MyNavigationController *)(self.navigationController);
    [nav cancelSlidingGesture];
    
}
- (void)resignAllResponder{
    [_LoginTitle resignFirstResponder];
    [_passWord resignFirstResponder];
    
}

#pragma mark -
#pragma mark LoginServerDelegate
- (void)requestLoginFromServerSucess:(NSString*)account password:(NSString*)password dataDic:(NSDictionary*)dataDic userData:(id)userData{
//保存apple id 和密码,不管是自己的还是请求免费的
    [[FileUtil instance] saveAccountPasswordInfo:account pwd:password];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"loginsucess"];
//APPLEID_ACCOUNT_INFO,保存请求回来的免费的账号信息
    if ([[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO]) {
        FreeAccountViewController*loginSucessViewController = [[FreeAccountViewController alloc]init];
        [self.navigationController pushViewController:loginSucessViewController animated:YES];
    }else{
        LoginSucessViewController *loginSucessViewController = [[LoginSucessViewController alloc] init];
        [self.navigationController pushViewController:loginSucessViewController animated:YES];
    }
    
    

//    NSDictionary *map = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNTPASSWORD];
    
}
- (void)requestLoginFromServerFail:(NSString*)account password:(NSString*)password userData:(id)userData{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"loginfail"];
}

- (void)dealloc{
    loginServer.delegate = nil;
    _LoginTitle.delegate = nil;
    _passWord.delegate = nil;
}

- (void)quitCurrentPage:(NSNotification*)note{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
