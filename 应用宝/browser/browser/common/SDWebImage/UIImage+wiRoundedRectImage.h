//
//  UIImage+wiRoundedRectImage.h
//  MyHelper
//
//  Created by mingzhi on 15/1/30.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wiRoundedRectImage)
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end
