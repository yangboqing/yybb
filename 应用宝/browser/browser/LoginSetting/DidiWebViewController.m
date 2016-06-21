//
//  DidiWebViewController.m
//  browser
//
//  Created by 王毅 on 15/1/28.
//
//

#import "DidiWebViewController.h"
#import "CustomNavigationBar.h"

@interface DidiWebViewController()<UIWebViewDelegate>{
    UIImageView *topBgImageView;
    UIButton *backBtn;
    UIButton *closeBtn;
    UILabel *titleLabel;
    
    UIWebView*webView;
    
    
}

@end


@implementation DidiWebViewController

- (void)viewDidLoad{
    
    self.view.backgroundColor = WHITE_COLOR;
    self.view.userInteractionEnabled = YES;
    
    topBgImageView = [UIImageView new];
    topBgImageView.backgroundColor = NEWYEAR_RED;
    topBgImageView.userInteractionEnabled = YES;
    
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    
    titleLabel = [UILabel new];
    titleLabel.text = @"打车礼券";
    titleLabel.textColor = WHITE_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DIDI_URL]]];
    
    
    [topBgImageView addSubview:closeBtn];
    [topBgImageView addSubview:backBtn];
    [topBgImageView addSubview:titleLabel];
    
    
    [self.view addSubview:topBgImageView];
    [self.view addSubview:webView];
    
    
}
- (void)backWeb:(UIButton *)sender{
    
    if ([webView canGoBack]) {
        [webView goBack];
    }
    
}

//- (void)closeWeb:(UIButton *)sender{
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_CLOSE_DIDI_WEB object:@"close"];
//    
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    topBgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    
    backBtn.frame = CGRectMake(5, 25, 34, 34);
    closeBtn.frame = CGRectMake(self.view.frame.size.width - 5 - 40, 25, 40, 34);
    titleLabel.frame = CGRectMake((self.view.frame.size.width - 100*IPHONE6_XISHU)/2, 20, 100*IPHONE6_XISHU, 44);
    

    webView.frame = CGRectMake(0, topBgImageView.frame.size.height, self.view.frame.size.width, MainScreeFrame.size.height - topBgImageView.frame.size.height);
    
}



@end
