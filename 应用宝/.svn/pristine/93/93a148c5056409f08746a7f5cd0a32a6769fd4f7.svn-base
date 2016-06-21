//
//  FindCell.m
//  KY20Version
//
//  Created by liguiyang on 14-5-19.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "FindCell.h"

@implementation ImageLayerView

-(id)init
{
    self = [super init];
    if (self) {
        CAShapeLayer *imgLayer = [[CAShapeLayer alloc] init];
        imgLayer.fillColor = [UIColor whiteColor].CGColor;
        imgLayer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:imgLayer];
        self.imageLayer = imgLayer;
    }
    
    return self;
}
- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.imageLayer.borderWidth = 0.5;
    self.imageLayer.borderColor = hllColor(120, 120, 120, 0.3).CGColor;
    self.imageLayer.cornerRadius = radius;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageLayer.frame = self.layer.bounds;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.radius]];
    self.imageLayer.path = path.CGPath;
}

@end

@implementation FindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        normalColor = [UIColor blackColor];
        clickColor  = hllColor(165, 165, 165, 1.0);
        UIFont *font = [UIFont systemFontOfSize:12];
        
        ImageLayerView *thumb = [[ImageLayerView alloc] init];
        thumb.backgroundColor = [UIColor clearColor];
        thumb.radius = 0.0f;
        
        separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = hllColor(212, 212, 212, 1.0);
        
        UILabel *titLabel = [[UILabel alloc] init];
        titLabel.numberOfLines = 0;
        titLabel.font = [UIFont systemFontOfSize:15.0f];
        
        UILabel *timeLabel  = [[UILabel alloc] init];
        timeLabel.textColor = clickColor;
        timeLabel.font = font;

        
        [self addSubview:thumb];
        [self addSubview:titLabel];
        [self addSubview:timeLabel];
        [self addSubview:separatorLine];
        
        self.thumbnailView = thumb;
        self.titleLabel = titLabel;
        self.timeLabel  = timeLabel;
        
        // setting
        UIView *selectBgView = [[UIView alloc] init];
        selectBgView.backgroundColor = CONTENT_BACKGROUND_COLOR;
        self.selectedBackgroundView = selectBgView;
    }
    return self;
}

-(void)setClickState:(Click_State)clickState
{
    if (clickState == Click_NO) {
        self.titleLabel.textColor = normalColor;
    }
    else
    {
        self.titleLabel.textColor = clickColor;
    }
}

#pragma mark - Utility

-(void)setCustomFrame
{
    // space
    CGFloat horizontalOneSpace = 10;
    CGFloat horizontalTwoSpace = 8;
    // frame size
    CGFloat thumbnailWidth = 125;
    CGFloat thumbnailHeight = 70;
    
    CGFloat timeWidth = 70;
    CGFloat timeHeight = 16;
    
    CGFloat origionalX_titleLabel = horizontalOneSpace+thumbnailWidth+horizontalTwoSpace;
    CGFloat titleWidth = MainScreen_Width-origionalX_titleLabel-5;
    CGFloat titleHeight = 34;
    
    CGSize size = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(titleWidth, 36)];
    titleHeight = size.height;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
    self.thumbnailView.frame = CGRectMake(horizontalOneSpace, 11, thumbnailWidth, thumbnailHeight);
    self.titleLabel.frame = CGRectMake(origionalX_titleLabel, 11, titleWidth, titleHeight);
    self.timeLabel.frame = CGRectMake(_titleLabel.frame.origin.x,_thumbnailView.frame.origin.y+_thumbnailView.frame.size.height-16, timeWidth, timeHeight);
    separatorLine.frame = CGRectMake(horizontalOneSpace, self.frame.size.height-0.5, MainScreen_Width-horizontalOneSpace, 0.5);
    
}
@end
