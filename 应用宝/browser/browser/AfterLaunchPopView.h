//
//  AfterLaunchPopView.h
//  
//
//  Created by mingzhi on 14-4-10.
//  Copyright (c) 2014年 ___mingzhi___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AfterLaunchPopView : UIView
{
    UIImageView *imageView;
    NSString *imageURL;
    
    int waitTime;
    
    NSString *imageDataPath;
    NSString *imagePlistPath;
    NSMutableDictionary *plistDic;
    
    NSString *deviceStr;
    
}
@property (nonatomic,retain)NSString *imageDataPath;
- (id)initWithFrame:(CGRect)frame andRemoveAfterDelay:(int)time;
- (void)showWithDic:(NSDictionary *)dic;
- (void)hide;
- (void)deleteTheImage;
@end
