//
//  BlackCoverBackgroundView.h
//  browser
//
//  Created by caohechun on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
@interface BlackCoverBackgroundView : UIView
{
    float alphaValue;
    float showDuration;
    float fadeDuration;
}
- (void)show;
- (void)showWithoutAnimation;
- (void)fade;
- (void)setViewAlpha:(float)value;
- (void)setAnimationShowDuration:(float)duration;//默认0.5
- (void)setAnimationFadeDuration:(float)duration;//默认0.3
- (void)fade_withoutAnimation;
@end
