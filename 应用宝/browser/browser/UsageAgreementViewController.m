//
//  UsageAgreementViewController.m
//  browser
//
//  Created by liguiyang on 14-7-2.
//
//

#import "UsageAgreementViewController.h"
#import "CustomNavigationBar.h"

@interface UsageAgreementViewController ()<CustomNavigationBarDelegate>
{
    CustomNavigationBar *navBar;
    UITextView *contentView;
}
@end

@implementation UsageAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:246.0/255.0 alpha:1.0];
    }
    return self;
}

#pragma mark - CustomNavigationBarDelegate

-(void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utility

-(NSString *)getUsageAgreementContent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UsageAgreement" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // navigationBar
    navBar = [[CustomNavigationBar alloc] init];
    navBar.delegate = self;
    [navBar showBackButton:YES navigationTitle:@"使用协议" rightButtonType:rightButtonType_NONE];
    
    // mainView
    CGFloat cutHeight = (IOS7)?0:44.0f;
    CGRect rect = self.view.frame;
    rect.origin.x = 10.0f;
    rect.origin.y = 0.0f;
    rect.size.width = rect.size.width-20.0f;
    rect.size.height = rect.size.height - cutHeight;
    
    contentView = [[UITextView alloc] initWithFrame:rect];
    contentView.text = [self getUsageAgreementContent];
    contentView.font = [UIFont systemFontOfSize:15.0f];
    contentView.backgroundColor = self.view.backgroundColor;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.editable = NO;
    if (IOS7) {
        contentView.selectable = NO;
    }
    
    [self.view addSubview:contentView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
