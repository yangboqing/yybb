//
//  LoadingCollectionCell.m
//  MyHelper
//
//  Created by zhaolu  on 15-1-4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "LoadingCollectionCell.h"

@implementation LoadingCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        loadingView = [[GifView alloc] init];
        [loadingView startGif];
        
        loadingLabel = [[UILabel alloc] init];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.font = [UIFont systemFontOfSize:11];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.textColor = CONTENT_COLOR;
        
        [self addSubview:loadingView];
        [self addSubview:loadingLabel];
    }
    return self;
}

-(void)setStyle:(CollectionCellRequestStyle)style
{
    if (style==CollectionCellRequestStyleLoading) {
        [loadingView startGif];
        loadingLabel.text = @"";
//        loadingLabel.text = FRASHLOAD_ING;
        
        CGFloat oriX = (MainScreen_Width-110)*0.5;
        loadingView.frame = CGRectMake(oriX, 17, 110, 10);
//        loadingLabel.frame = CGRectMake(oriX+20+5, 7, 85, 30);
    }
    else
    {
        [loadingView stopGif];
        loadingLabel.text = FRASHLOAD_FAILD;
        loadingLabel.frame = CGRectMake(0, 7, self.frame.size.width, 30);
    }
}

@end
