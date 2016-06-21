//
//  ClassificationCell.m
//  MyHelper
//
//  Created by 李环宇 on 14-12-18.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "ClassificationCell.h"

@implementation ClassificationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth = 0.5f;
//        self.layer.backgroundColor=[[UIColor clearColor] CGColor];
//        self.layer.borderColor = [hllColor(212,212,212,1.0) CGColor];
        OriX = 0.0;
        self.backImage = [[UIImageView alloc] init];
        self.backImage.backgroundColor =hllColor(200,200,200,0.5);
        self.backImage.layer.cornerRadius = 10;
        self.backImage.layer.masksToBounds = YES;
        [self addSubview:self.backImage];
        
        self.underImage = [[UIImageView alloc] init];
        self.underImage.backgroundColor =hllColor(212,212,212,1.0);
        [self addSubview:self.underImage];
        
        self.verticalImage = [[UIImageView alloc] init];
        self.verticalImage.backgroundColor =hllColor(212,212,212,1.0);
        [self addSubview:self.verticalImage];
        
//        [self.backImage sd]
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor =hllColor(50,50,50,1);
        self.nameLabel.font = [UIFont systemFontOfSize:16.0f*MULTIPLE];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.textColor =hllColor(150,150,150,1);
        self.numberLabel.font = [UIFont systemFontOfSize:12.0f];
        self.numberLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:self.nameLabel];
        [self addSubview:self.numberLabel];
    }
    return self;
}

- (void)setLayoutLeft:(BOOL)left
{
    OriX = left?0.0:13*MULTIPLE;
    [self layoutCustomView];
}

- (void)layoutSubviews{
 
    [super layoutSubviews];
    [self layoutCustomView];
}

- (void)layoutCustomView
{
    CGFloat oriY = (self.bounds.size.height - 50*MULTIPLE)*0.5-0.5;
    self.backImage.frame=CGRectMake(OriX, oriY, 50*MULTIPLE, 50*MULTIPLE);
    self.underImage.frame=CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
    self.verticalImage.frame=CGRectMake(self.bounds.size.width-0.5, 0, 0.5, self.bounds.size.height);
    self.nameLabel.frame=CGRectMake(self.backImage.frame.origin.x+self.backImage.frame.size.width+10, 16*MULTIPLE, 90*MULTIPLE, 24*MULTIPLE);
    self.numberLabel.frame=CGRectMake(self.backImage.frame.origin.x+self.backImage.frame.size.width+10, 39*MULTIPLE, 90*MULTIPLE, 24*MULTIPLE);
}

@end
