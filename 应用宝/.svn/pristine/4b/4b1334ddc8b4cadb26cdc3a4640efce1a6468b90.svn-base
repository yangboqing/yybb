//
//  AppTableViewController.h
//  browser
//
//  Created by liguiyang on 14-6-10.
//
//

#import <UIKit/UIKit.h>

@protocol AppTableViewDelegate <NSObject>

-(void)appTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AppTableViewController : UITableViewController

@property (nonatomic, weak) id <AppTableViewDelegate>delegate;
-(void)reloadAppTableView:(NSArray *)appArray withFromSource:(NSString *)fromSource;
@end
