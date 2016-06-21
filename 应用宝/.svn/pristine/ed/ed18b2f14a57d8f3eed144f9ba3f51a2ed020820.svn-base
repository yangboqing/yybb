//
//  SingleCellectionViewCell.m
//  KY20Version
//
//  Created by liguiyang on 14-5-22.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "SingleCellectionViewCell.h"

@implementation myUILabel
@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}


@end

@implementation SingleCellectionViewCell

- (id)initWithFrame:(CGRect)frame
{ //frame = {(0,0),(60,100)}
    self = [super initWithFrame:frame];
    if (self) {
        
        LayerImageView *imgView = [[LayerImageView alloc] init];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.radius = 12.0f;
        
        myUILabel *label = [[myUILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [label setVerticalAlignment:VerticalAlignmentTop];
        label.numberOfLines = 0;
        
        [self addSubview:imgView];
        [self addSubview:label];
        self.imageView = imgView;
        self.nameLabel = label;
        
        // set frame
        [self setCustomFrame];
        
    }
    return self;
}

#pragma mark - Utility
-(void)setCustomFrame
{
    self.imageView.frame = CGRectMake(0, 0, WIDTH_ICON, WIDTH_ICON);
    self.nameLabel.frame = CGRectMake(0, WIDTH_ICON+7, WIDTH_ICON, HEIGHT_LABEL);
}

@end
