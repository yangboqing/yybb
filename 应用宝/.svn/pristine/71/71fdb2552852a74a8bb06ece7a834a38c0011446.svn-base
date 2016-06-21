//
//  FeedbackViewController.m
//  browser
//
//  Created by liguiyang on 14-7-1.
//
//

#import "MoreFeedbackViewController.h"
#import "CustomNavigationBar.h"
#import "AdvisePageView.h" // 反馈页面

#define TAG_FEEDBACK_BUTTON 1200

@interface MoreFeedbackViewController ()<CustomNavigationBarDelegate>
{
    CustomNavigationBar *navBar;
    AdvisePageView *advisePageView;
}
@end

@implementation MoreFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Utility

-(void)uploadFeedback
{
    [advisePageView resignAllResponder];
    [advisePageView uploadAdvise:nil];
}

-(void)setCustomFrame
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    advisePageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
}

#pragma mark - CustomNavigationBarDelegate

-(void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // navigationBar
    navBar = [[CustomNavigationBar alloc] init];
    [navBar showBackButton:YES navigationTitle:@"意见反馈" rightButtonType:rightButtonType_ONE];
    navBar.delegate = self;
    [navBar.rightTopButton setTitle:@"提交" forState:UIControlStateNormal];
    //新春版
    [navBar.rightTopButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
    [navBar.rightTopButton addTarget:self action:@selector(uploadFeedback) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = navBar;
    
    //反馈页面
    advisePageView = [[AdvisePageView alloc]init];
    [self.view addSubview:advisePageView];
    
    [self setCustomFrame];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:navBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [advisePageView.contentTextView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [advisePageView resignAllResponder];
    [navBar removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    advisePageView = nil;
}

@end
