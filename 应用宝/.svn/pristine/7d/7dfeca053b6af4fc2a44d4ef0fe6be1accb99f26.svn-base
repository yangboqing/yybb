//
//  SearchRecordCell.m
//  MyHelper
//
//  Created by liguiyang on 14-12-31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "SearchRecordCell.h"

@interface SearchRecordCell()
{
    CGFloat originX;
    CGFloat colorValue;
    UILabel *sepLabel;
}

@end

@implementation SearchRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //
        originX = 20;
        colorValue = 199.0/255.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.titleLabel = [[UILabel alloc] init];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageNamed:@"close_search.png"] forState:UIControlStateNormal];
        
        sepLabel = [[UILabel alloc] init];
        sepLabel.backgroundColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1.0];
        
        [self addSubview:_titleLabel];
        [self addSubview:_closeBtn];
        [self addSubview:sepLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.titleLabel.frame = CGRectMake(originX, 0, frame.size.width-originX-30, frame.size.height);
    self.closeBtn.frame = CGRectMake(frame.size.width-50, (frame.size.height-38)*0.5, 50, 38);
    sepLabel.frame = CGRectMake(originX, frame.size.height-0.5, frame.size.width-originX, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
