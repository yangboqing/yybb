//
//  WallPaperTopView.h
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    latest_ClickType = 0, // 最新
    classify_ClickType // 分类
}WPTop_ClickType;

#define TAG_LATESTBTN 1000
#define TAG_CLASSIFYBTN 1001

@interface WallPaperTopView : UIView
{
    UIImage *verticalImg;
    UIImageView *verticalImageLine;
    UILabel *bottomLabelLine;
    //
    CGRect leftRect;
    CGRect rightRect;
    NSAttributedString *latestTitle_select;
    NSAttributedString *latestTitle_unselect;
    NSAttributedString *classifyTitle_select;
    NSAttributedString *classifyTitle_unselect;
}

@property (nonatomic, strong) UIButton *latestBtn;
@property (nonatomic, strong) UIButton *classifyBtn;

@end
