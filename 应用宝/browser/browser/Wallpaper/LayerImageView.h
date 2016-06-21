//
//  LayerImageView.h
//  browser
//
//  Created by liguiyang on 14-8-25.
//
// 设置icon圆角

#import <UIKit/UIKit.h>

@interface LayerImageView : UIImageView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) CAShapeLayer *imageLayer;

@end
