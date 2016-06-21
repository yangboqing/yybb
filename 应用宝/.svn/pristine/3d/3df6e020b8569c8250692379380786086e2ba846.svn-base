//
//  LoadingCollectionCell.h
//  MyHelper
//
//  Created by zhaolu  on 15-1-4.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifView.h"
typedef enum {
    CollectionCellRequestStyleLoading = 0,
    CollectionCellRequestStyleFailed
}CollectionCellRequestStyle;

@interface LoadingCollectionCell : UICollectionViewCell
{
    GifView *loadingView;
    UILabel *loadingLabel;
}
@property (nonatomic, assign) CollectionCellRequestStyle style;
@property (nonatomic, strong) NSString *identifier;
@end
