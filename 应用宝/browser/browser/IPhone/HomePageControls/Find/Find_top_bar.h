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

#define NO_SELECTED hllColor(81, 81, 81, 1)

#define SELECTED hllColor(222, 53, 46, 1)

//新春版
//#define NO_SELECTED hllColor(244, 188, 184, 1)
//
//#define SELECTED hllColor(255, 255, 255, 1)

typedef void(^Top_bar_click)(NSInteger index);

@interface Find_top_bar : UIView{
   Top_bar_click click;
    @public
    NSUInteger _selectButtonTag;
}

- (void)setFind_top_barClickWithBlock:(Top_bar_click)_click;

- (void)setFind_top_barDidScroll:(UIScrollView *)_scrollView;

- (void)setFind_top_barClickWithIndex:(NSUInteger) index;

@end
