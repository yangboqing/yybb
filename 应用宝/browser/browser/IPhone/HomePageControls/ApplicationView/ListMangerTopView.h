//
//  ListMangerTopView.h
//  browser
//
//  Created by mingzhi on 14-5-15.
//
//

#import <UIKit/UIKit.h>


#define CLICK_WEEK_BUTTON 111
#define CLICK_MONTH_BUTTON 222
#define CLICK_TOTAL_BUTTON 333


@interface ListMangerTopView : UIView
{
@public
    NSUInteger _selectButtonTag;
}
@property (nonatomic , retain) UIView *line;
@property (nonatomic , retain) UIButton *backButton;
@property (nonatomic , retain) UIButton *weekBtn;
@property (nonatomic , retain) UIButton *monthBtn;
@property (nonatomic , retain) UIButton *totalBtn;

- (void)myAnimation:(NSInteger)before;
- (void)myAnimation:(float)dur anIndex:(NSUInteger)index;
- (void)setBtnEnable:(BOOL)enable;

- (void)setList_top_barDidScroll:(UIScrollView *)_scrollView;
@end
