//
//  AppTestDetailViewController.m
//  browser
//
//  Created by caohechun on 14-4-21.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppTestDetailViewController.h"

@interface AppTestDetailViewController ()
{
    UILabel *titleLabel;
    UIButton *backButton;
}
@end

@implementation AppTestDetailViewController
- (void)dealloc{

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = CONTENT_BACKGROUND_COLOR;
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"评    测"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.userInteractionEnabled = YES;
    [self.view addSubview:titleLabel];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LocalImageManager setImageName:@"back_iphone_white.png" complete:^(UIImage *image) {
        [backButton setImage:image forState:UIControlStateNormal];
    }];
    backButton.backgroundColor = TOP_RED_COLOR;
    [backButton addTarget:self action:@selector(backToTestPage) forControlEvents:UIControlEventTouchUpInside];
    
    [titleLabel addSubview:backButton];
    titleLabel.frame = CGRectMake(0, 0, MainScreen_Width, 40);
    backButton.frame = CGRectMake(12, (40-24)/2, 45, 24);
    
    _testDetail = [[UIWebView alloc]initWithFrame:CGRectMake(0, backButton.frame.origin.y + backButton.frame.size.height + 8, 308, MainScreen_Height - 20  - 40 - 49)];
    _testDetail.scalesPageToFit = NO;
    _testDetail.delegate = self;
    [self.view addSubview:_testDetail];
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

    
    
    _testDetail.hidden = NO;
}
- (void)viewWillLayoutSubviews{
    
}
- (void)backToTestPage{

    self.view.frame = CGRectMake(-self.view.frame.size.width, 0, 308, MainScreen_Height - 20 - 20 - 40 - 40 - 40);
    _testDetail.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
