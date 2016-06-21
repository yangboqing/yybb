//
//  LayerImageView.m
//  browser
//
//  Created by liguiyang on 14-8-25.
//
//

#import "LayerImageView.h"

@implementation LayerImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *imgLayer = [[CAShapeLayer alloc] init];
        imgLayer.fillColor = [UIColor whiteColor].CGColor;
        imgLayer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:imgLayer];
        self.imageLayer = imgLayer;
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.imageLayer.borderWidth = 0.5;
    self.imageLayer.borderColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.2].CGColor;
    self.imageLayer.cornerRadius = radius;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageLayer.frame = self.layer.bounds;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.radius]];
    self.imageLayer.path = path.CGPath;
}

@end
