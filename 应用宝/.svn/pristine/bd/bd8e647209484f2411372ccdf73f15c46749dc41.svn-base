//
//  HorizontalSlidingCell.h
//  Mymenu
//
//  Created by mingzhi on 14/11/22.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalSlidingView.h"
#import "CollectionCells.h"

typedef void(^ClickBlock)(NSString *appID ,NSIndexPath *index);

@interface HorizontalSlidingCell : UICollectionViewCell <HorizontalSlidingDelegate>
{
    ClickBlock _clickBlock;
}

@property (nonatomic, assign) MenuType type;
//属性
@property (nonatomic, retain) NSArray *dataArray;

//UI
@property (nonatomic, strong) HorizontalSlidingView * horizontalSlidingView;
@property (nonatomic, strong) UIImageView * bottomlineView;
- (void)setColor:(UIImage *)img andName:(NSString *)name;
- (void)setapBlock:(ClickBlock)block;

@end
