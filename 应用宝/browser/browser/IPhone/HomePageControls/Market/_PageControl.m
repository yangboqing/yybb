//
//  _PageControl.m
//  browser
//
//  Created by niu_o0 on 14-7-11.
//
//

#import "_PageControl.h"

@interface MyShapeLayer : CAShapeLayer
@property (nonatomic, assign) NSInteger tag;
@end
@implementation MyShapeLayer
@end



@implementation _PageControl


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        layerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageSize.width, PageSize.height) cornerRadius:PageSize.width];
        _shapeLayer = [MyShapeLayer new];
        _shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _shapeLayer.fillColor = PageStateHighlighted;
        _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageSize.width, PageSize.height) cornerRadius:PageSize.height].CGPath;
        [self.layer addSublayer:_shapeLayer];
        
        _dataArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    startX = numberOfPages*(PageSize.width+PageSpacing);
    startX = (self.bounds.size.width-startX)/2;
    
    _shapeLayer.frame = CGRectMake(startX, (self.bounds.size.height-PageSize.height)/2, PageSize.width, PageSize.height);
    
    for (int i=0; i<_numberOfPages; i++) {
        MyShapeLayer * layer = [MyShapeLayer new];
        layer.path = layerPath.CGPath;
        layer.tag = LayerTag+i;
        layer.fillColor = PageStateNormal;
        layer.frame = CGRectMake(startX+(i*(PageSize.width+PageSpacing)), (self.bounds.size.height-PageSize.height)/2, PageSize.width, PageSize.height);
        [_dataArray addObject:layer];

        [self.layer insertSublayer:layer below:_shapeLayer];
    }
}

static float lastScroll = 0.0;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat dur = scrollView.contentOffset.x/scrollView.bounds.size.width;

    NSInteger index = startX+PageSize.width/2+dur*(PageSpacing+PageSize.width);
    _shapeLayer.position =CGPointMake(index , self.bounds.size.height/2);

     NSInteger idx = 1;
    
    for (MyShapeLayer * layer in _dataArray) {
        layer.fillColor = PageStateNormal;
        if (CGRectIntersectsRect(layer.frame, _shapeLayer.frame)){

            layer.fillColor = PageStateHighlighted;
            
            if ((NSInteger)_shapeLayer.position.x >= (NSInteger)layer.position.x-idx && (NSInteger)_shapeLayer.position.x <= (NSInteger)layer.position.x+idx) {
                
                _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageEllipse, PageSize.height) cornerRadius:PageSize.height].CGPath;
            }else{
                NSInteger idx = _shapeLayer.position.x-layer.position.x;
                if (idx >= 0 && idx <= 3){
                    
                    if (fabsf(scrollView.contentOffset.x - lastScroll) > 20.0) {
                        lastScroll = scrollView.contentOffset.x;
                        [CATransaction begin];
                        [CATransaction setDisableActions:YES];
                        _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageEllipse-idx, PageSize.height) cornerRadius:PageSize.height].CGPath;
                        [CATransaction commit];
                    }
                    
                }else{
                    _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageSize.width, PageSize.height) cornerRadius:PageSize.height].CGPath;
                }
            }
        }
        
    }
}

- (MyShapeLayer *)layerWithPage:(NSInteger)page{
    if (self.layer.sublayers.count > page) {
        for (id obj in self.layer.sublayers) {
            if ([obj isKindOfClass:[MyShapeLayer class]]){
                if (((MyShapeLayer *)obj).tag-LayerTag == page) return obj;
            }
            
        }
    }
    return nil;
}

- (void)setCurrentPage:(NSUInteger)currentPage{
    _currentPage = currentPage;
    MyShapeLayer * __layer = [_dataArray objectAtIndex:currentPage];
    __layer.fillColor = [UIColor whiteColor].CGColor;
    _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, PageEllipse, PageSize.height) cornerRadius:PageSize.height].CGPath;
    _shapeLayer.position = __layer.position;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
