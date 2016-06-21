//
//  UIWebViewController.h
//  browser
//
//  Created by liull on 14-7-7.
//
//

#import <UIKit/UIKit.h>



@protocol GiftWebViewControllerDelegate  <NSObject>

@optional
-(void)hideBootRemindView;

@end

@interface GiftWebViewController : UIViewController

@property (nonatomic, weak) id <GiftWebViewControllerDelegate>delegate;
@property(nonatomic) NSURL  * navigationUrl;
@property(nonatomic,assign)BOOL isKaipinUrl;//是否用于开屏图内链跳转

-(void)loadGiftPage;
-(void)setCustomNavTitle:(NSString *)title;

@end
