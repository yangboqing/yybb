//
//  UIWebViewController.h
//  browser
//
//  Created by liull on 14-7-7.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    webView_AnnouncementType = 300,
    webView_BootRemindType
}WebType;

@protocol UIWebViewControllerDelegate  <NSObject>

@optional
-(void)hideBootRemindView;

@end

@interface UIWebViewController : UIViewController

@property (nonatomic, weak) id <UIWebViewControllerDelegate>delegate;

-(id)initWithWebType:(WebType)webType;

-(void)navigation:(NSString*)url;
-(void)setCustomNavTitle:(NSString *)title;

@end
