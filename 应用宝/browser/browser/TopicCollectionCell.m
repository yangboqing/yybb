//
//  TopicCollectionCell.m
//  Mymenu
//
//  Created by mingzhi on 14/11/22.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import "TopicCollectionCell.h"

@implementation TopicCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        
        _backImageView = [UIImageView new];
        _backImageView.image = [UIImage imageNamed:@"jingxuan_topic"];
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_backImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = TitleFont;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:@"买买买——剁掉我的手"];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        _titleLabel.backgroundColor = hllColor(0, 0, 0, 0.7);
//        [self.contentView addSubview:_titleLabel];
        
        UIColor *color = hllColor(19, 126, 174, 1);
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setBackgroundColor:[UIColor clearColor]];
        [titleBtn setTitle:@"专题" forState:UIControlStateNormal];
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        [titleBtn setTitleColor:color forState:UIControlStateNormal];
        titleBtn.layer.borderWidth = 0.5;
        titleBtn.layer.borderColor = color.CGColor;
        titleBtn.layer.cornerRadius = 3;
//        [self.contentView addSubview:titleBtn];
        
        _bottomlineView = [UIImageView new];
        _bottomlineView.backgroundColor = BottomColor;
        [self.contentView addSubview:_bottomlineView];
        
        mengheiImage = [UIImageView new];
        mengheiImage.image = [UIImage imageNamed:@"choice_menghei"];
        mengheiImage.userInteractionEnabled = NO;
//        [self.contentView addSubview:mengheiImage];
        
        _horizontalSlidingView = [HorizontalSlidingView new];
        _horizontalSlidingView.backgroundColor = [UIColor clearColor];
        _horizontalSlidingView.userInteractionEnabled = NO;
        [_horizontalSlidingView setTitleViewHidden:YES];
//        [self.contentView addSubview:_horizontalSlidingView];
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    _backImageView.frame = CGRectMake(0, 0, frame.size.width, 492.2/2*MULTIPLE);
//    _backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    //_titleLabel.frame = CGRectMake(26/2, 0, 390/2, 82/2);
    titleBtn.frame = CGRectMake(_titleLabel.frame.origin.x+6, _titleLabel.frame.origin.y+(_titleLabel.frame.size.height-15)/2+1, 25, 15);
    _bottomlineView.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    _horizontalSlidingView.frame = CGRectMake(0, 40*MULTIPLE-10, frame.size.width, frame.size.height-40*MULTIPLE);
    mengheiImage.frame = _backImageView.frame;

}
- (void)setCellData:(NSDictionary *)specialDic
{
    if (specialDic) {
        //设置属性
        _topicID = [specialDic objectForKey:SPECIAL_ID];
        _device = [specialDic objectForKey:DEVICE];
        _platform = [specialDic objectForKey:PLATFORM];
        _creatime = [specialDic objectForKey:CREAT_TIME];
        _introduce = [specialDic objectForKey:INTRODUCE];
        
        //设置显示
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:[specialDic objectForKey:BANNER]] placeholderImage:[UIImage imageNamed:@"jingxuan_topic"]];
        _titleLabel.text = [NSString stringWithFormat:@"        %@  ",[specialDic objectForKey:TITLE]];
        
        [_horizontalSlidingView setDataArr:[specialDic objectForKey:@"display_appinfo"]];
        
        
        CGSize theStringSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(MainScreen_Width-26, 82/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size;
        _titleLabel.frame = CGRectMake(26/2, 0, theStringSize.width, 82/2);
        
        CAShapeLayer *styleLayer = [CAShapeLayer layer];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:_titleLabel.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
        styleLayer.path = shadowPath.CGPath;
        _titleLabel.layer.mask = styleLayer;
    }
}

@end
