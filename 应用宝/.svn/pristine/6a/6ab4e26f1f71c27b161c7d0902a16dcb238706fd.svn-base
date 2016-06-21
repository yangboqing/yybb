//
//  SerachHistoryRecordTableVIewController.h
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import <UIKit/UIKit.h>
#import "SearchHistoryRecordTableViewCell.h"
#import "SearchManager.h"

@protocol SearchHistoryRecordDelegate <NSObject>

- (void)getHistoryRecordString:(NSString *)string;

@end


@interface SearchHistoryRecordTableViewController : UITableViewController
@property (nonatomic , assign) id<SearchHistoryRecordDelegate>delegate;
- (void)rushList;
@end
