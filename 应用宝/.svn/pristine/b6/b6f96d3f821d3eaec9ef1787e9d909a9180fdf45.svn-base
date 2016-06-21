//
//  TableViewLoadingCell.h
//  browser
//
//  Created by liguiyang on 14-8-20.
//
//

#import <UIKit/UIKit.h>
#import "GifView.h"

typedef enum {
    CellRequestStyleLoading = 0,
    CellRequestStyleFailed
}CellRequestStyle;

@interface TableViewLoadingCell : UITableViewCell
{
    GifView *loadingView;
    UILabel *loadingLabel;
}

@property (nonatomic, assign) CellRequestStyle style;
@property (nonatomic, strong) NSString *identifier;

@end
