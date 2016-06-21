//
//  FreeAccountViewController.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "FreeAccountViewController.h"


#define SIDE_WIDTH 15*IPHONE6_XISHU
@interface FreeAccountViewController (){
    UILabel *topLabel;
    
    UIImageView *line;
    
    UIView *bgImageView;
    
    UILabel *accNameLabel;
    UILabel *accInfoLabel;
    UILabel *pwdNameLabel;
    UILabel *pwdInfoLabel;
    
    UIButton *copyBtn;
    
    
    NSArray *infoDataArray;

    UIImageView *bottomImageView;
    
    UIImageView *qiaomenImageView;
    
    UILabel *getAccountInfoLabel;

    CustomNavigationBar *navBar;
    
    UILabel *goActive;
    LoginServerManage *loginManage;
    UIScrollView *baseView;
}

@end

@implementation FreeAccountViewController

- (id)init{
    
    self = [super init];
    if (self) {
        
        infoDataArray = [NSArray arrayWithObjects:@"1.点击复制ID和密码",@"2.粘贴到弹出框的用户名里",@"3.剪切下密码字段,再粘贴到密码输入框里面", nil];
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = hllColor(242, 242, 242, 1);
    self.view.userInteractionEnabled = YES;
    
    baseView = [[UIScrollView alloc] init];

    baseView.bounces = MainScreen_Height>1000?NO:YES;
    baseView.backgroundColor = hllColor(242, 242, 242, 1);
    [self.view addSubview:baseView];

    NSString *responseStr = [[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO];
    responseStr = [DESUtils decryptUseDES:responseStr key:APPLE_ACCOUNT_KEY];
    
    NSDictionary *infoMap = [[FileUtil instance] analysisJSONToDictionary:responseStr];
    
    loginManage = [LoginServerManage new];
    loginManage.delegate = self;
    
    
    topLabel = [UILabel new];
    topLabel.font = [UIFont systemFontOfSize:13.0f];
    topLabel.text = @"绑定自己的Apple ID,下载的应用更稳定";
    topLabel.textColor = GRAY_TEXT_COLOR;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [baseView addSubview:topLabel];

    bgImageView = [UIView new];
    bgImageView.layer.borderWidth = 1;
    bgImageView.clipsToBounds = YES;
    bgImageView.layer.borderColor = hllColor(221, 221, 221, 1).CGColor;
    bgImageView.backgroundColor = WHITE_BACKGROUND_COLOR;
    [baseView addSubview:bgImageView];
    
    
    accNameLabel = [UILabel new];
    accNameLabel.backgroundColor = CLEAR_COLOR;
    accNameLabel.text = @"Apple ID";
    accNameLabel.textAlignment = NSTextAlignmentLeft;
    accNameLabel.textColor = hllColor(50, 50, 50, 1);
    accNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [bgImageView addSubview:accNameLabel];
    
    accInfoLabel = [UILabel new];
    accInfoLabel.backgroundColor = CLEAR_COLOR;
    accInfoLabel.text = [infoMap objectForKey:@"name"]?[infoMap objectForKey:@"name"]:@"";
    accInfoLabel.textAlignment = NSTextAlignmentRight;
    accInfoLabel.textColor = hllColor(150, 150, 150, 1);
    accInfoLabel.font = [UIFont systemFontOfSize:14.0f];
    [bgImageView addSubview:accInfoLabel];
    
    line = [UIImageView new];
    line.backgroundColor = hllColor(221, 221, 221, 1);
    [bgImageView addSubview:line];
    
    pwdNameLabel = [UILabel new];
    pwdNameLabel.backgroundColor = CLEAR_COLOR;
    pwdNameLabel.text = @"密码";
    pwdNameLabel.textAlignment = NSTextAlignmentLeft;
    pwdNameLabel.textColor = hllColor(50, 50, 50, 1);
    pwdNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [bgImageView addSubview:pwdNameLabel];
    
    pwdInfoLabel = [UILabel new];
    pwdInfoLabel.backgroundColor = CLEAR_COLOR;
    pwdInfoLabel.text = [infoMap objectForKey:@"pwd"]?[infoMap objectForKey:@"pwd"]:@"";
    pwdInfoLabel.textAlignment = NSTextAlignmentRight;
    pwdInfoLabel.textColor = hllColor(150, 150, 150, 1);
    pwdInfoLabel.font = [UIFont systemFontOfSize:14.0f];
    [bgImageView addSubview:pwdInfoLabel];
    
    
    getAccountInfoLabel = [UILabel new];
    getAccountInfoLabel.backgroundColor = CLEAR_COLOR;
    getAccountInfoLabel.text = @"账号详情";
    getAccountInfoLabel.textAlignment = NSTextAlignmentRight;
    getAccountInfoLabel.textColor = MY_BLUE_COLOR;
    getAccountInfoLabel.font = [UIFont systemFontOfSize:14.0f];
    getAccountInfoLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *freeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getFreeAccountInfo)];
    [getAccountInfoLabel addGestureRecognizer:freeTap];
    [baseView addSubview:getAccountInfoLabel];
    
    
    copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.clipsToBounds = YES;
    copyBtn.backgroundColor = MY_YELLOW_COLOR;
    [copyBtn setTitle:@"复制ID和密码" forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(clickCopy:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:copyBtn];
    

    bottomImageView = [UIImageView new];
    bottomImageView.image = [UIImage imageNamed:@"qiaomenzi"];
    bottomImageView.backgroundColor = CLEAR_COLOR;
    [baseView addSubview:bottomImageView];
    


    qiaomenImageView = [UIImageView new];
    qiaomenImageView.image = [UIImage imageNamed:@"acount_copy"];
    qiaomenImageView.backgroundColor = CLEAR_COLOR;
    [baseView addSubview:qiaomenImageView];
    
    
    navBar = [[CustomNavigationBar alloc] init];
    [navBar showBackButton:YES navigationTitle:@"Apple ID绑定" rightButtonType:rightButtonType_ONE];
    navBar.delegate = self;
    [navBar.rightTopButton setTitle:@"注销" forState:UIControlStateNormal];
    //新春版
    [navBar.rightTopButton setTitleColor:MY_BLUE_COLOR forState:UIControlStateNormal];
    [navBar.rightTopButton addTarget:self action:@selector(uploadFeedback) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    goActive = [UILabel new];
    goActive.text = @"一步激活";
    goActive.font = [UIFont systemFontOfSize:14.0f];
    goActive.textColor = MY_BLUE_COLOR;
    goActive.userInteractionEnabled  = YES;
    goActive.textAlignment  = NSTextAlignmentRight;
    UITapGestureRecognizer *active = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yibujihuo)];
    [goActive addGestureRecognizer:active];
    [baseView addSubview:goActive];
    
    [self makeFrame];

}

- (void)makeFrame{
    CGRect rect = self.view.frame;
    rect.size.height = rect.size.height - 49;
    baseView.frame = rect;
    
    topLabel.frame = CGRectMake(SIDE_WIDTH, 0, baseView.frame.size.width - SIDE_WIDTH*2, 40*IPHONE6_XISHU);
    bgImageView.frame = CGRectMake( -1, topLabel.frame.origin.y + topLabel.frame.size.height - 6 , MainScreen_Width + 2, (179/2)*IPHONE6_XISHU);
    
    accNameLabel.frame = CGRectMake(SIDE_WIDTH, 0, 80, bgImageView.frame.size.height/2 - 1);
    accInfoLabel.frame = CGRectMake(37*IPHONE6_XISHU, 0, bgImageView.frame.size.width - 37*IPHONE6_XISHU - 10 - 10, accNameLabel.frame.size.height);
    
    line.frame = CGRectMake(0, accNameLabel.frame.origin.y + accNameLabel.frame.size.height, bgImageView.frame.size.width, 1);
    
    
    pwdNameLabel.frame = CGRectMake(accNameLabel.frame.origin.x, accNameLabel.frame.origin.y + accNameLabel.frame.size.height + 1, accNameLabel.frame.size.width, accNameLabel.frame.size.height);
    pwdInfoLabel.frame = CGRectMake(accInfoLabel.frame.origin.x, bgImageView.frame.size.height/2 +1, accInfoLabel.frame.size.width, accInfoLabel.frame.size.height);
    
    getAccountInfoLabel.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y + bgImageView.frame.size.height + 8*IPHONE6_XISHU, bgImageView.frame.size.width - 20, 20*IPHONE6_XISHU);
    copyBtn.frame = CGRectMake(0, getAccountInfoLabel.frame.origin.y + getAccountInfoLabel.frame.size.height + 12*IPHONE6_XISHU, MainScreen_Width, 40*IPHONE6_XISHU);
    
    bottomImageView.frame = CGRectMake(SIDE_WIDTH, copyBtn.frame.origin.y + copyBtn.frame.size.height + 15*IPHONE6_XISHU, baseView.frame.size.width - SIDE_WIDTH*2, ((baseView.frame.size.width - (SIDE_WIDTH*2))/335)*113);
    
    qiaomenImageView.frame = CGRectMake((baseView.frame.size.width - 299)/2, bottomImageView.frame.origin.y + bottomImageView.frame.size.height+12*IPHONE6_XISHU, 299, 165/2);
//    goActive.frame =CGRectMake(bgImageView.frame.origin.x, qiaomenImageView.frame.origin.y + qiaomenImageView.frame.size.height + 5, bgImageView.frame.size.width, 17*IPHONE6_XISHU);

    baseView.contentSize = CGSizeMake(self.view.frame.size.width, goActive.frame.origin.y + goActive.frame.size.height + 20);
    
}


-(void)popCurrentViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)uploadFeedback{
    NSDictionary *dic = [[FileUtil instance] getAccountPasswordInfo];
    if (dic && [dic objectForKey:SAVE_ACCOUNT] && [dic objectForKey:SAVE_PASSWORD]) {
        NSString *account = [dic objectForKey:SAVE_ACCOUNT];
        NSString *password = [dic objectForKey:SAVE_PASSWORD];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[account stringByAppendingString:password]];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNTPASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APPLEID_ACCOUNT_INFO];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //移除导航的右滑返回手势
    MyNavigationController *nav = (MyNavigationController *)(self.navigationController);
    [nav cancelSlidingGesture];
    
}
- (void)clickCopy:(UIButton *)sender{
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@ %@",accInfoLabel.text,pwdInfoLabel.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"复制成功" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)yibujihuo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yibujihuochangjiaocheng" object:nil];
}

- (void)getFreeAccountInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ACCOUNT_LIST object:nil];
    
}

@end
