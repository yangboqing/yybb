//
//  AppTestTableViewController.h
//  browser
//
//  Created by caohechun on 14-4-17.
//
//

#import <UIKit/UIKit.h>
#import "SearchManager.h"
//用于显示评测活动详情的代理
@protocol TestDetailDelegate <NSObject>

- (void)showTestDetail:(NSDictionary *)dic withImage:(UIImage *)image;

@end


@interface AppTestTableViewController : UITableViewController<SearchManagerDelegate>
@property (nonatomic, weak)id<TestDetailDelegate>testDetailDelegate;
- (void)setTestDetail:(NSDictionary *)dataDic;
@end
