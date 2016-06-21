//
//  UIWebViewController.m
//  browser
//
//  Created by liull on 14-7-7.
//
//

#import "UIWebViewController.h"
#import "UIView+ALQuickFrame.h"
#import "IphoneAppDelegate.h"
#import "CollectionViewBack.h"


@interface UIWebViewController () <UIWebViewDelegate>
{
    CollectionViewBack * _backView;
    UILabel *titleLabel;
    WebType webViewType;
}
@property(nonatomic) UIWebView  * webView;
@property(nonatomic) UIScrollView  * scrollView;

@property(nonatomic) NSURL  * navigationUrl;
@end

@implementation UIWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithWebType:(WebType)webType
{
    self = [super init];
    if (self) {
        webViewType = webType;
    }
    
    return self;
}

#pragma mark - Utility

-(UIView *)getCustomNavigationWithTitle:(NSString *)title
{
    UIColor *fontColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    UIColor *backColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = backColor;
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = backColor;
    titleLabel.textColor = fontColor;
    titleLabel.text = title;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        
    }];
    
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1];
    
    CGFloat StartY = IOS7 ? 20 :0;
    CGFloat topHeight = (IOS7)?64:44;
    
    backView.frame = CGRectMake(0, 0, MainScreen_Width, topHeight);
    btn.frame = CGRectMake(15 , StartY+5, 34, 34);
    titleLabel.frame = CGRectMake(0, StartY, backView.frame.size.width, 44);
    imageView.frame = CGRectMake(0, StartY + 44-0.5, backView.frame.size.width, 0.5);
    
    [backView addSubview:titleLabel];
    [backView addSubview:btn];
    [backView addSubview:imageView];
    
    return backView;
}

-(void)setCustomNavTitle:(NSString *)title
{
    titleLabel.text = title;
}

-(void)navigation:(NSString*)url {
    
    self.navigationUrl = [NSURL URLWithString:url];
    if( self.navigationUrl.absoluteString.length <= 0 ) {
        [_backView setStatus:Failed];
        return ;
    }
    
    [_backView setStatus:Loading];
    [self.webView loadRequest:[NSURLRequest requestWithURL: self.navigationUrl]];
}



- (void)back{

   [self.navigationController popViewControllerAnimated:YES];

}

-(void)backAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBootRemindView)]) {
        [self.delegate hideBootRemindView];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    addNavgationBarBackButton(self, back);
    
    CGFloat topHeight = (IOS7)?64:44;
    UIEdgeInsets inset = (webViewType==webView_BootRemindType)?UIEdgeInsetsMake(topHeight, 0, 0, 0):UIEdgeInsetsZero;
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleWidth;
    self.scrollView.contentInset = inset;
    [self.view addSubview:self.scrollView];
    
    // webView
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.webView.delegate = self;
    [self.scrollView addSubview:self.webView];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"webView"];
    
    
    if(self.navigationUrl.absoluteString.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL: self.navigationUrl ]];
    }
    
    _backView = [[CollectionViewBack alloc] init];
    [self.view addSubview:_backView];
    __weak typeof(self) mySelf = self;
    [_backView setClickActionWithBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [mySelf.webView loadRequest:[NSURLRequest requestWithURL: mySelf.navigationUrl]];
        });
    }];

    if( self.navigationUrl.absoluteString.length <= 0 ) {
        [_backView setStatus:Failed];
    }else {
        [_backView setStatus:Loading];
    }
    
    // navigationBar(最顶层)
    if (webViewType==webView_BootRemindType) {
        [self.view addSubview:[self getCustomNavigationWithTitle:nil]];
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat bottomHeight = (webViewType==webView_BootRemindType)?0:BOTTOM_HEIGHT;
    
    CGFloat height =MAX(self.webView.scrollView.contentSize.height, self.view.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height+bottomHeight); // 避免底部导航遮挡网页
    [self.webView setHeight:height];
    
    
    _backView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //获取当前页面的title
    //    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    self.navigationController.navigationItem.title = title;
    
    [_backView setStatus:Hidden];
    
    FeLogDebug(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [_backView setStatus:Failed];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/27/68/com.kuaiyong.browser/dizigui_zhouyi_com.kuaiyong.browser_1404057600_1.5.1.0.plist
    if([request.URL.scheme isEqualToString:@"itms-services"]) {
        
        if (webViewType == webView_BootRemindType) { // 启动提醒
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        else
        {
            [browserAppDelegate downloadIPAByPlistURL:request.URL.absoluteString];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if( [(__bridge NSString*)context isEqualToString:@"webView"] ) {

        FeLogDebug(@"webView contentSize change!");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self viewWillLayoutSubviews];
        });
    }
    
}

- (void)dealloc{
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
