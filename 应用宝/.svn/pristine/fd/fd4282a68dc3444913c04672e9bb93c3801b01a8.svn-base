//
//  SearchInformationCell.m
//  MyHelper
//
//  Created by zhaolu  on 15-3-4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "SearchInformationCell.h"

@implementation SearchInformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _foreLabel = [[UILabel alloc]initWithFrame:CGRectMake(17*MainScreen_Width/375, 0, 100, 43*MainScreen_Width/375)];
        _foreLabel.backgroundColor = [UIColor clearColor];
        _foreLabel.textAlignment = NSTextAlignmentLeft;
        _foreLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_foreLabel];
        
        _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainScreen_Width-17*MainScreen_Width/375-150, 0, 150, 43*MainScreen_Width/375)];
        _backLabel.backgroundColor = [UIColor clearColor];
        _backLabel.textAlignment = NSTextAlignmentRight;
        _backLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_backLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(17*MainScreen_Width/375, 43*MainScreen_Width/375-1, MainScreen_Width-17*MainScreen_Width/375, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:1];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}
-(void)setForeText:(NSString *)foreText AndBackText:(NSString *)backText AndIsTitleCell:(BOOL)isTitleCell
{
    _foreLabel.text = foreText;
    _backLabel.text = backText;
    if (isTitleCell) {
        self.backgroundColor = [UIColor colorWithRed:247.f/255 green:247.f/255 blue:247.f/255 alpha:1];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
