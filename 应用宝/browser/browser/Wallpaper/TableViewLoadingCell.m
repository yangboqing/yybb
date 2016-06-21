//
//  TableViewLoadingCell.m
//  browser
//
//  Created by liguiyang on 14-8-20.
//
//

#import "TableViewLoadingCell.h"

@implementation TableViewLoadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setStyle:(CellRequestStyle)style
{
    if (style==CellRequestStyleLoading) {
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
