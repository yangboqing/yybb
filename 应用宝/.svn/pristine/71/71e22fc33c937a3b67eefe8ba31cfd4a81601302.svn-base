//
//  HomeToolCell.h
//  MyHelper
//
//  Created by liguiyang on 15-3-4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPPProgressView.h"

typedef enum {
    positionType_head,
    positionType_headRight,
    positionType_headLeft,
    positionType_sideRight,
    positionType_sideRightUp,
    positionType_sideRightDown,
    positionType_sideLeft,
    positionType_sideLeftUp,
    positionType_sideLeftDown
}PositionType;

// 显示图标cell
@interface HomeToolCell : UICollectionViewCell
{
    UILabel *headLabel;
    UILabel *footLabel;
    UILabel *sideLabel;
}

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIImageView *lightImgView;

- (void)setHeadLabelPosition:(PositionType)type;
- (void)setSideLabelPosition:(PositionType)type;

@end

// 显示内存cell
@interface HomeMemoryCell : UICollectionViewCell
{
    UIImageView *usedImgView;
    UIImageView *freeImgView;
    BPPProgressView *progressView;
    
    CGFloat usedLabelWidth;
    CGFloat freeLabelWidth;
}
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *memoryLabel;
@property (nonatomic, strong) UILabel *usedMemoryLabel;
@property (nonatomic, strong) UILabel *freeMemoryLabel;

- (void)setProgressValue:(CGFloat)value;

@end

// 显示设备型号cell
@interface HomeHeadCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UIButton *shopBtn;

@end