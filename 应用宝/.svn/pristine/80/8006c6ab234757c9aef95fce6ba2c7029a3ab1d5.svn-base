//
//  AppRelevantTableViewController.h
//  browser
//
//  Created by caohechun on 14-4-17.
//
//

#import <UIKit/UIKit.h>
#import "SearchResultCell.h"
#import "SearchManager.h"
@protocol relevantDelegate<NSObject>
- (void)loadAnotherApp_relevent:(id)data;
- (void)loadAnotherApp_source_relevant:(id)data;
- (void)showOrHideRotation_relevant:(id)data;
@end
@interface AppRelevantTableViewController : UITableViewController<SearchManagerDelegate>
@property (nonatomic,weak)id<relevantDelegate>relevantDelegate;
- (void)setRelevantData:(NSArray *)array;
@end
