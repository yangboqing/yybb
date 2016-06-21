//
//  AssociateSearchTableViewController.h
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchAssociationTableViewDelegate <NSObject>

-(void)aSearchAssociationTermHasBeenSelected:(NSString *)searchTerm;

@end

@interface SearchAssociationTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *searchWords;
@property (nonatomic, weak) id <SearchAssociationTableViewDelegate>delegate;

-(id)initWithShowData:(NSArray *)searchWords;
-(void)reloadSearchTableViewWithData:(NSArray *)resultData;
@end
