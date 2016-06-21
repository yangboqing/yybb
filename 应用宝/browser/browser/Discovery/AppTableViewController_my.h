//
//  AppTableViewController.h
//  browser
//
//  Created by liguiyang on 14-6-10.
//
//

#import <UIKit/UIKit.h>

@interface AppTableViewController_my : UICollectionViewController

@property (nonatomic, strong) NSArray *dataAry;

-(void)reloadAppTableView:(NSArray *)appArray withFromSource:(NSString *)fromSource;
@end
