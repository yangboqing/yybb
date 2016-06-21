//
//  HeadImageView.h
//  browser
//
//  Created by admin on 13-9-3.
//
//  闪退修复帮助提醒 长条

typedef enum {
    allStart_Type = 0,
    allPause_Type,
    edit_Type,
    editCancel_Type,
}HeadImage_ButtonType;

#import <UIKit/UIKit.h>
#import "UITouchLabel.h"

@interface HeadImageView : UIImageView<UITouchLabelDelegate>
{
    // 修复教程提示
    UITouchLabel *lessonTipLabel;
    UIButton *closeBtn;
    BOOL isCloseBtnClick;
    
    // 按钮状态 Image
    UIImage *allStartImg;
    UIImage *allPauseImg;
    UIImage *editImg;
    UIImage *editCancelImg;
    UIImage *allUpdateImg;
}

// 开始/暂停、更新、编辑按钮
@property (strong, nonatomic) UIButton *allStartPauseBtn;
@property (strong, nonatomic) UIButton *allUpdatBtn;
@property (strong, nonatomic) UIButton *editBtn;

// 是否显示修复教程提示
-(void)hideLessonTipView:(BOOL)flag;
-(void)changeButtonTitleWithType:(HeadImage_ButtonType)type;

@end
