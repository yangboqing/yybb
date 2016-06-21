//
//  PromptBoxView.h
//  browser
//
//  Created by admin on 13-9-25.
//
//

#import <UIKit/UIKit.h>
//无新版本时弹出的界面
@interface PromptBoxView : UIView

{
    UILabel * _label; // titleString
    UIImageView *horizontalLineView;
}

@property (retain, nonatomic) UIImageView * BGImageView;
@property (retain, nonatomic) NSMutableString * labelString;
@property (retain, nonatomic) UIButton *confirmBtn;
@end
