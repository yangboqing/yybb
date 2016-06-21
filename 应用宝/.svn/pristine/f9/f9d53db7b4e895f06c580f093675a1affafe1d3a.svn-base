//
//  WYWebView.h
//  browser
//
//  Created by 王 毅 on 13-2-20.
//
//

#import <UIKit/UIKit.h>
@class WYWebView;

@protocol WYWebViewProgressDelegate <NSObject>
@optional
- (void) webView:(WYWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end
@interface WYWebView : UIWebView
@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@property (nonatomic, weak)  id<WYWebViewProgressDelegate> progressDelegate;
@end