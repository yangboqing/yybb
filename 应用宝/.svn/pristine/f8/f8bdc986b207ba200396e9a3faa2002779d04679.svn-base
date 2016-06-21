//
//  Find_top_bar.h
//  browser
//
//  Created by mahongzhi on 14-10-15.
//
//

#import <UIKit/UIKit.h>

@interface FindTop_button : UIButton

@property (nonatomic,strong) UIImageView * vImageView1;

@end

#define TOP_BUTTON_TAG 50

#define NO_SELECTED hllColor(0.0, 0.0, 0.0, 0.5)

#define SELECTED hllColor(0.0, 0.0, 0.0, 1)

typedef void(^Top_bar_click)(NSInteger index);

@interface Find_top_bar : UIView{
   Top_bar_click click;
    @public
    NSUInteger _selectButtonTag;
    float startContentOffsetX;
    float willEndContentOffsetX;
}

- (void)setFind_top_barClickWithBlock:(Top_bar_click)_click;

- (void)setFind_top_barDidScroll:(UIScrollView *)_scrollView;
- (void)setFind_top_starScroll:(UIScrollView *)_scrollView;
- (void)setFind_top_endScroll:(UIScrollView *)_scrollView;
- (void)setFind_top_didEndScroll:(UIScrollView *)_scrollView;

- (void)setFind_top_barClickWithIndex:(NSUInteger) index;

@end
