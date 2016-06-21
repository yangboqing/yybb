//
//  SearchCustomCell.m
//  HotWordSearch
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "SearchAssociationCell.h"

@implementation SearchAssociationCell{
    UIImageView *cuttingLineView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 38);
        cuttingLineView = [[UIImageView alloc] init];
        SET_IMAGE(cuttingLineView.image, @"cuttingLine.png");
        
        UILabel *cusLabel = [[UILabel alloc] init]; // 为非ARC模式准备
        cusLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
        cusLabel.font = [UIFont systemFontOfSize:14.0f];
        cusLabel.backgroundColor = [UIColor clearColor];
        self.customLabel = cusLabel;
        
        [self addSubview:_customLabel];
        [self addSubview:cuttingLineView];
        
    }
    return self;
}

- (void)layoutSubviews{
    cuttingLineView.frame = CGRectMake(10, self.frame.size.height-0.5f, self.frame.size.width - 10, 0.5f);
    self.customLabel.frame = CGRectMake(20, 0, self.frame.size.width-32, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
