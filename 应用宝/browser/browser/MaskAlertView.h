//
//  MaskAlertView.h
//  MyHelper
//
//  Created by liguiyang on 15-1-8.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    AlertViewloading = 0,
    AlertViewUpdate
} AlertViewType;
@protocol MaskAlertViewDelegate <NSObject>

- (void)maskAlertViewConfirmButtonClick:(NSDictionary *)updateDic;
@end

@interface MaskAlertView : UIView

@property (nonatomic, weak) id <MaskAlertViewDelegate>delegate;

- (void)setMaskAlertViewType:(AlertViewType)alertType updateInfo:(NSDictionary *)infoDic;

@end
