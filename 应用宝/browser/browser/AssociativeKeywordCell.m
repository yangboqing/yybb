//
//  AssociativeKeywordCell.m
//  MyHelper
//
//  Created by liguiyang on 14-12-31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "AssociativeKeywordCell.h"

@interface AssociativeKeywordCell ()
{
    CGFloat originX;
    CGFloat colorValue;
    UILabel *sepLabel; // 分割线
}

@end

@implementation AssociativeKeywordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        originX = 20;
        colorValue = 199.0/255.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.iconImgView = [[LayerImageView alloc] init];
        self.iconImgView.radius = 5.0;
        self.titleLabel = [[UILabel alloc] init];
        
        sepLabel = [[UILabel alloc] init];
        sepLabel.backgroundColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1.0];
        
        [self addSubview:_iconImgView];
        [self addSubview:_titleLabel];
        [self addSubview:sepLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    self.iconImgView.frame = CGRectMake(originX, 10, 24, 24);
    self.titleLabel.frame = CGRectMake(originX+24+10, 0, frame.size.width-originX-24-10-20, frame.size.height);
    sepLabel.frame = CGRectMake(originX, frame.size.height-0.5, frame.size.width-originX, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
