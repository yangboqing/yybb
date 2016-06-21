//
//  SingleCellectionViewCell.h
//  KY20Version
//
//  Created by liguiyang on 14-5-22.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerImageView.h"

#define WIDTH_ICON (60*(MainScreen_Width/320))
#define HEIGHT_LABEL (32*(MainScreen_Width/320))

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface myUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end


@interface SingleCellectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) LayerImageView *imageView;
@property (nonatomic, strong) myUILabel *nameLabel;


@end
