//
//  MoreCell.h
//  browser
//
//  Created by liguiyang on 14-6-19.
//
//

#import <UIKit/UIKit.h>

typedef enum LineType{
    topLine = 0,
    bottomLine
    
}LineType;

@interface MoreCell : UITableViewCell
{
    UIImageView *topLineView;
    UIImageView *cuttingLineView;
}

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *contentLabel;

-(void)showHorizontalLine:(LineType)lineType;
-(void)hideCuttingLine:(BOOL)flag;

@end
