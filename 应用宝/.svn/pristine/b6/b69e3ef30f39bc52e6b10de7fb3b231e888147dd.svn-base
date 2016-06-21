//
//  ArgumentViewController.m
//  browser
//
//  Created by liguiyang on 14-7-9.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "ArgumentViewController.h"

@interface ArgumentViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation ArgumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.frame];
        webview.backgroundColor = [UIColor whiteColor];
        webview.scrollView.backgroundColor = [UIColor whiteColor];
        webview.delegate = self;
        webview.scrollView.delegate = self;
        webview.scrollView.bounces = NO;
        [self.view addSubview:webview];
        self.webView = webview;
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"comment"];
    }
    return self;
}

#pragma mark - Utility

-(void)loadArgumentString:(NSString *)string baseUrl:(NSURL *)url;
{
    [self.webView loadHTMLString:string baseURL:url];
}

-(void)stopLoadingAndClearCache
{
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [self.webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSHTTPCookie *cookie;
    for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

-(void)banWebViewSliding:(BOOL)flag
{
    self.webView.scrollView.scrollEnabled = !flag;
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(argumentViewChangeHeight:)]) {
        [self.delegate argumentViewChangeHeight:webView.scrollView.contentSize.height];
    }
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(__bridge NSString *)context isEqualToString:@"comment"] && [keyPath isEqualToString:@"contentSize"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(argumentViewChangeHeight:)]) {
            [self.delegate argumentViewChangeHeight:_webView.scrollView.contentSize.height];
        }
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:@"comment"];
    
    self.webView.delegate = nil;
    self.webView = nil;
}

@end
