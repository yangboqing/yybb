//
//  NewFuntionView.h
//  browser
//
//  Created by caohechun on 15/1/6.
//
//

#import <UIKit/UIKit.h>
#define NEW_FUNCTION_HEIGHT 100
#define NEW_FUNCTION_HEIGHT_SAFEURL 116/2*PHONE_SCALE_PARAMETER
typedef enum{
    FUNCTION_TYPE_FREE = 0,
    FUNCTION_TYPE_ACTIVITY,
    FUNCTION_TYPE_GIFT,
    FUNCTION_TYPE_NECESSERY
}FUNCTION_TYPE;

typedef void(^clickFuntionBlock)(int tag);
@interface NewFuntionView : UIView
- (void)setFunctionButtonBlock:(clickFuntionBlock)block;
@end
