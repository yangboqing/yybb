//
//  LoginSucessViewController.m
//  browser
//
//  Created by 王毅 on 15/1/6.
//
//

#import "LoginSucessViewController.h"

@interface LoginSucessViewController(){
    UILabel *topLabel;
    UILabel *accountLabel;
    UILabel *bottomLabel;
    
}

@end

@implementation LoginSucessViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = hllColor(242, 242, 242, 1);
    self.view.userInteractionEnabled = YES;
    

    navBar = [[CustomNavigationBar alloc] init];
    [navBar showBackButton:YES navigationTitle:@"Apple ID绑定" rightButtonType:rightButtonType_ONE];
    navBar.delegate = self;
    [navBar.rightTopButton setTitle:@"注销" forState:UIControlStateNormal];
    //新春版
    [navBar.rightTopButton setTitleColor:MY_BLUE_COLOR forState:UIControlStateNormal];
    [navBar.rightTopButton addTarget:self action:@selector(showBlackView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    

    topLabel = [UILabel new];
    topLabel.font = [UIFont systemFontOfSize:13.0f];
    topLabel.text = @"当前绑定的Apple ID为:";
    topLabel.textColor = GRAY_TEXT_COLOR;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    
    
    NSDictionary *dic = [[FileUtil instance] getAccountPasswordInfo];
    accountLabel = [UILabel new];
    accountLabel.font = [UIFont systemFontOfSize:14.0f];
    accountLabel.text = [dic objectForKey:SAVE_ACCOUNT]?[dic objectForKey:SAVE_ACCOUNT]:@"";
    accountLabel.textColor = BLACK_COLOR;
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.clipsToBounds = YES;
    accountLabel.userInteractionEnabled = YES;
    
    
    
    bottomLabel = [UILabel new];
    bottomLabel.textColor = BLACK_COLOR;
    bottomLabel.backgroundColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    bottomLabel.layer.borderColor = hllColor(200, 200, 200, 1).CGColor;
    bottomLabel.layer.borderWidth = 0.5f;


    [self.view addSubview:topLabel];
    [self.view addSubview:bottomLabel];
    [self.view addSubview:accountLabel];


    
    [self makeFrame];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCurrentViewController) name:CLICK_CANCELLATION object:nil];
    
}

- (void)makeFrame{

    
    topLabel.frame = CGRectMake(15, 64, self.view.frame.size.width-30, 40*IPHONE6_XISHU);
    bottomLabel.frame = CGRectMake( - 1, topLabel.frame.origin.y + topLabel.frame.size.height - 6, self.view.frame.size.width + 2,40*IPHONE6_XISHU);
    accountLabel.frame = CGRectMake(20, topLabel.frame.origin.y + topLabel.frame.size.height, self.view.frame.size.width, 40*IPHONE6_XISHU);
}

//- (void)clickToDidi:(UIButton *)sender{
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_CLOSE_DIDI_WEB object:@"open"];
//    
//}


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
#pragma mark - CustomNavigationBarDelegate

-(void)popCurrentViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showBlackView{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLICK_ACCOUNT object:nil];
}

@end
