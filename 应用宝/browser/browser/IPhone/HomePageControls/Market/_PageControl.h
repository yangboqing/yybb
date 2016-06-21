//
//  _PageControl.h
//  browser
//
//  Created by niu_o0 on 14-7-11.
//
//

#import <UIKit/UIKit.h>

#define LayerTag        100
#define PageSize        CGSizeMake(5,5)
#define PageEllipse     8.0
#define PageSpacing     15


#define PageStateNormal     hllColor(255, 255, 255, 0.5).CGColor
#define PageStateHighlighted        hllColor(255, 255, 255, 1).CGColor

@class MyShapeLayer;
@interface _PageControl : UIView{
    @private
    UIBezierPath * layerPath;
    MyShapeLayer * _shapeLayer;
    CGFloat startX;
    NSMutableArray * _dataArray;
}

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
