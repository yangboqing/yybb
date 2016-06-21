//
//  SimilarNavigationView.h
//  MyHelper
//
//  Created by mingzhi on 14/12/31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    funcLeftBtn_tag = 0,
    funcRightBtn_tag,
    funcThirdBtn_tag,
    funcFourBtn_tag,
    funcForthBtn_tag,
    leftBtn_tag ,
    rightBtn_tag
}SimilarNavigationBtnType;

typedef enum{
    new_tag = 120,
    top_tag,
    good_tag,
    four_tag,
}NavAppGameType;

typedef void(^NavigationViewBtnclickBlock)(SimilarNavigationBtnType sender);

@interface SimilarNavigationView : UIView
{
    //UI
    @public
    UIToolbar *toolbar;
    @package
    UIImageView *cuttingLineView;
    
    UILabel *titleLabel;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UISegmentedControl *segmentedControl;
    //功能
    NavigationViewBtnclickBlock navigationViewBtnclickBlock;
    CGFloat changeStartX;
}
- (void)setTitle:(NSString *)title AndBtnTitleNameArray:(NSArray *)btnNameArray;
- (void)setBtnImage:(NSArray *)imageArray;
- (void)setnavigationViewBtnclickBlock:(NavigationViewBtnclickBlock)block;
- (void)btnImage:(NavAppGameType)type;
- (void)initAppGameBtn;
- (void)initFindBtn;
@end
