//
//  WallPaperClassifyCell.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperClassifyCell.h"

@implementation WallPaperClassifyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LayerImageView *iconView = [[LayerImageView alloc] init];
        iconView.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        
        [self addSubview:iconView];
        [iconView addSubview:nameLabel];
        self.iconView = iconView;
        self.classifyNameLabel = nameLabel;
    }
    return self;
}

-(void)layoutSubviews
{ // 156*320
    self.iconView.frame = self.bounds;
    self.classifyNameLabel.frame = CGRectMake(0, _iconView.frame.size.height-21, _iconView.frame.size.width, 21);
}

@end
