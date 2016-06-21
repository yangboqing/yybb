//
//  SettingViewController_iphone.m
//  browser
//
//  Created by 王 毅 on 13-4-2.
//
//

#import "SettingViewController_iphone.h"
#import "CustomNavigationBar.h"

@interface SettingViewController_iphone (){
}

@end

@implementation SettingViewController_iphone
@synthesize settingTableViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.settingTableViewController = [[SettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.view addSubview:self.settingTableViewController.tableView];
        
        CGFloat topHeight = IOS7?64:0;
        CGFloat xHeight = IOS7?12:22;
        self.settingTableViewController.tableView.frame = CGRectMake(0, topHeight, self.view.frame.size.width, self.view.frame.size.height-topHeight-xHeight);
    }
    return self;
}

#pragma mark - Utility

-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // navigationBar
    UIImage * image = [UIImage imageNamed:@"nav_back.png"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    [button addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.leftBarButtonItem= backButton;
    
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] init];
    [navBar showNavigationTitleView:@"下载设置"];
    self.navigationItem.titleView = navBar;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

@end
