//
//  ArgumentViewController.h
//  browser
//
//  Created by liguiyang on 14-7-9.
//
//

#import <UIKit/UIKit.h>

@protocol ArgumentViewDelegate <NSObject>

-(void)argumentViewChangeHeight:(CGFloat)height;

@end


@interface ArgumentViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) id <ArgumentViewDelegate>delegate;

-(void)loadArgumentString:(NSString *)string baseUrl:(NSURL *)url;
-(void)stopLoadingAndClearCache;
-(void)banWebViewSliding:(BOOL)flag;

@end
