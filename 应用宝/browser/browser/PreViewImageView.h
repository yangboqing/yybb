//
//  PreViewImageView.h
//  browser
//
//  Created by caohechun on 14-5-9.
//
//

#import <UIKit/UIKit.h>
#import "AppDetailView.h"

#define IMAGES_SCROLLVIEW_HEIGHT 330//纯截图
#define IMAGES_SCROLLVIEW_WEIGHT 220
#define IMAGES_SCROLLVIEW_WEIGHT_IPHONE5 186
#define PREVIEW_SCROLLVIEW_WEIGTH 220//截图带装饰边框
#define PREVIEW_SCROLLVIEW_HEIGHT 330
@interface PreViewImageView : UIImageView

- (void)setPicture:(UIImage *)image;
- (void)resetBackgroundImgForIphone4;//重置背景为4尺寸
- (void)resetBackgroundImgForIphone5;//重置背景为5尺寸
@end
