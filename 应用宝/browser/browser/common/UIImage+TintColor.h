//
//  UIImage+TintColor.h
//  140822NavColorTest
//
//  Created by caohechun on 14-8-25.
//  Copyright (c) 2014年 caohechun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
@end
