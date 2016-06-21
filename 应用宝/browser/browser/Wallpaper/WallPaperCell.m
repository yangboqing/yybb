//
//  WallPaperCell.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperCell.h"

@implementation WallPaperCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        width_ing = 85;
        // display UI
        LayerImageView *layerImgView = [[LayerImageView alloc] init];
        [self.contentView addSubview:layerImgView];
        self.imgView = layerImgView;
        
        // loading/failed UI
        loadingView = [[GifView alloc] init];
        [loadingView startGif];
        [self.contentView addSubview:loadingView];
        
        loadingLabel = [[UILabel alloc] init];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.font = [UIFont systemFontOfSize:11];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.textColor = CONTENT_COLOR;
        [self.contentView addSubview:loadingLabel];
    }
    return self;
}

-(void)setStyle:(WallPaperCellStyle)style
{
    switch (style) {
        case WallPaperCellStyleDefault:{
            self.imgView.frame = self.bounds;
        }
            break;
            
        case WallPaperCellStyleRequestLoading:{
            [loadingView startGif];
            loadingLabel.text = @"";
//            loadingLabel.text = FRASHLOAD_ING;
            CGFloat originY = (MainScreen_Width-110)*0.5;
            loadingView.frame = CGRectMake(originY, 17, 110, 10);
//            loadingLabel.frame = CGRectMake(originY+25, 7, width_ing, 30);
        }
            break;
            
        case WallPaperCellStyleRequestFailed:{
            [loadingView stopGif];
            loadingLabel.text = FRASHLOAD_FAILD;
            loadingLabel.frame = CGRectMake(0, 7, self.frame.size.width, 30);
        }
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews
{
    self.imgView.frame = self.bounds;
}

#pragma mark - Utility


@end
