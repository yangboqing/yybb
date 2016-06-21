//
//  UIWebViewController.m
//  browser
//
//  Created by liull on 14-7-7.
//
//

#import "GiftWebViewController.h"
#import "UIView+ALQuickFrame.h"
#import "IphoneAppDelegate.h"
#import "CollectionViewBack.h"


@interface GiftWebViewController () <UIWebViewDelegate>
{
    CollectionViewBack * _backView;
    UILabel *titleLabel;
    UIButton *closeButton;
}
@property(nonatomic) UIWebView  * webView;
@property(nonatomic) UIScrollView  * scrollView;


@end

@implementation GiftWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        static float fontSize = 16;

//        UIColor *fontColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
//        UIColor *backColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        //2.7
//        titleLabel.textColor = fontColor;
        //新春版
//        titleLabel.textColor = [UIColor whiteColor];

        titleLabel.text = @"礼包";
        titleLabel.frame = CGRectMake(0, 0, MainScreen_Width, 44);
        
        
        closeButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(MainScreen_Width - (fontSize*2 + 10) - 10, (44 - fontSize)/2, (fontSize*2 + 10), fontSize);
        closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        //2.7
        [closeButton setTitleColor:TOP_RED_COLOR forState:UIControlStateNormal];
        //新春版
//        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        

        
        
    }
    return self;
}



#pragma mark - Utility


-(void)setCustomNavTitle:(NSString *)title
{
    titleLabel.text = title;
}

-(void)loadGiftPage {
    
    if( !self.navigationUrl || self.navigationUrl.absoluteString.length <= 0 ) {
        [_backView setStatus:Failed];
        return ;
    }
    
    [_backView setStatus:Loading];
    [self.webView loadRequest:[NSURLRequest requestWithURL: self.navigationUrl]];
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.webView loadHTMLString:@"" baseURL:nil]; // 解决进入下级网页后 点击关闭按钮返回主页，再进入此页一直转菊花的问题
}

- (void)showPreviousPage{
    
    NSString *curUrl = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    if ([curUrl isEqualToString:self.navigationUrl.absoluteString] || ![self.webView canGoBack]) {
        [self back];
    }
    else
    {
        [self.webView goBack];
    }
    
}

-(void)backAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBootRemindView)]) {
        [self.delegate hideBootRemindView];
    }
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isKaipinUrl) {
        [self.navigationController.navigationBar addSubview:titleLabel];
        [self.navigationController.navigationBar addSubview:closeButton];
    }

    

//    titleLabel.userInteractionEnabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [closeButton removeFromSuperview];
    [titleLabel removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    addNavgationBarBackButton(self, showPreviousPage);
    
    CGFloat topHeight = (IOS7)?64:44;
    UIEdgeInsets inset = UIEdgeInsetsZero;
    
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
//    if (webViewType==webView_BootRemindType) {
//        [self.view addSubview:[self getCustomNavigationWithTitle:nil]];
//    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat bottomHeight = BOTTOM_HEIGHT;
    
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

@end
