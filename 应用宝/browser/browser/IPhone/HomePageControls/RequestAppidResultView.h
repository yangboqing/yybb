//
//  RequestAppidResultView.h
//  browser
//
//  Created by caohechun on 15/3/18.
//
//

#import <UIKit/UIKit.h>
@protocol AppidResultDeletate<NSObject>
- (void)handleAppidResult:(int)type;
@end
@interface RequestAppidResultView : UIView
typedef enum {
    SUCCESS = 1,
    APPID_ERROR,
    NET_ERROR,
}ResuletType;

@property (nonatomic,assign) id<AppidResultDeletate>appidResultDelegate;
- (void)showRequestAppidResultViewWithType:(ResuletType)result;

@end
