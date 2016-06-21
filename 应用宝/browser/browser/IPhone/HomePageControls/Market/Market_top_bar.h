//
//  Market_top_bar.h
//  browser
//
//  Created by niu_o0 on 14-5-19.
//
//

#import <UIKit/UIKit.h>

@interface Top_button : UIButton

@property (nonatomic, strong) UIImageView * vImageView;

@end

#define TOP_BUTTON_TAG 50
//2.7版
#define NO_SELECTED hllColor(81, 81, 81, 1)

#define SELECTED hllColor(222, 53, 46, 1)
//新春版
//#define NO_SELECTED hllColor(244, 188, 184, 1)
//
//#define SELECTED hllColor(255, 255, 255, 1)
typedef void(^Top_bar_click)(NSInteger index);

@interface Market_top_bar : UIView{
    Top_bar_click click;
    @public
    NSUInteger _selectButtonTag;
}

- (void)setMarket_top_barClickWithBlock:(Top_bar_click)_click;

//- (void)setMarket_top_barWillScroll:(UIScrollView *)_scrollView;

- (void)setMarket_top_barDidScroll:(UIScrollView *)_scrollView;

//- (void)setMarket_top_barDidEndScroll:(UIScrollView *)_scrollView;

- (void)setMarket_top_barClickWithIndex:(NSUInteger) index;

@end
