//
//  SearchInformationCell.h
//  MyHelper
//
//  Created by zhaolu  on 15-3-4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInformationCell : UITableViewCell
{
    UILabel *_foreLabel;
    UILabel *_backLabel;
    UIView *_lineView;
}
-(void)setForeText:(NSString *)foreText AndBackText:(NSString *)backText AndIsTitleCell:(BOOL)isTitleCell;
@end
