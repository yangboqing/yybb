//
//  HotWordCollectionViewCell.m
//  MyHelper
//
//  Created by liguiyang on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "HotWordCollectionViewCell.h"

@implementation HotWordCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.layer.borderWidth = 0.5;
        self.titleLabel.layer.borderColor = hllColor(201, 201, 201, 1.0).CGColor;
        self.titleLabel.textColor = hllColor(76.0, 76.0, 76.0, 1.0);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

@end
