//
//  WallPaperCell.h
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import <UIKit/UIKit.h>
#import "GifView.h"
#import "LayerImageView.h"

static NSString *cellReuseIden = @"WallPaperReuseIdentifier";
static NSString *cellLoadingIden = @"WallPaperLoadingIdentifier";

typedef enum {
    WallPaperCellStyleDefault = 0,
    WallPaperCellStyleRequestLoading,
    WallPaperCellStyleRequestFailed
}WallPaperCellStyle;

@interface WallPaperCell : UICollectionViewCell
{
    // WallPaperDefaultStyleCell
    
    // WallPaperRequestStyleCell
    GifView *loadingView;
    UILabel *loadingLabel;
    
    CGFloat width_ing;
}

@property (nonatomic, assign) WallPaperCellStyle style;

@property (nonatomic, strong) LayerImageView *imgView;

@end
