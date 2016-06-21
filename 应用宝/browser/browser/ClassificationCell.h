//
//  ClassificationCell.h
//  MyHelper
//
//  Created by 李环宇 on 14-12-18.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCells.h"
@interface ClassificationCell : UICollectionViewCell
{
    CGFloat OriX;
}
@property (nonatomic, retain) UIImageView *backImage;
@property (nonatomic, retain) UILabel *nameLabel;//标题
@property (nonatomic, retain) UILabel *numberLabel;//种类
@property (nonatomic, retain) UIImageView *underImage;
@property (nonatomic, retain) UIImageView *verticalImage;

- (void)setLayoutLeft:(BOOL)left;

@end
