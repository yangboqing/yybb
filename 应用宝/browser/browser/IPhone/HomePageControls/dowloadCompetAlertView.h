//
//  dowloadCompetAlertView.h
//  browser
//
//  Created by 王毅 on 13-11-11.
//
//

#import <UIKit/UIKit.h>

#define ALREADY_ADD @"已添加"
#define DOWN_COMPET @"下载完成"

//点击了下载、或者有应用下载完成后，在屏幕下方弹出的黑色提示条
@protocol downAlertViewDelegate <NSObject>

- (void)downAlertClickItselfStaut:(NSString *)str;

@end

@interface dowloadCompetAlertView : UIView

@property (nonatomic , weak) id<downAlertViewDelegate>delegate;
@property (nonatomic, retain) NSString *appid;
- (void)setAppNameLabelFrame:(NSString *)appNameStr fixedText:(NSString *)striing;
- (void)setDownloadFailMessage:(NSString *)msn;

@end
