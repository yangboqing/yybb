//
//  AssociateSearchTableViewController.m
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "SearchAssociationTableViewController.h"
#import "SearchAssociationCell.h"

@interface SearchAssociationTableViewController ()

@end

@implementation SearchAssociationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithShowData:(NSArray *)searchWords
{
    self = [super init];
    if (self) {
        self.searchWords = [NSArray arrayWithArray:searchWords];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Utility
-(void)reloadSearchTableViewWithData:(NSArray *)resultData
{
    self.searchWords = resultData;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchWords.count < 10) {
        return _searchWords.count;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchAssociationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchAssociationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.customLabel.text = _searchWords[indexPath.row];

    
    return cell;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchWords == nil) {
        return ;
    }
    if (![_searchWords[indexPath.row] isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(aSearchAssociationTermHasBeenSelected:)]) {
            [self.delegate aSearchAssociationTermHasBeenSelected:_searchWords[indexPath.row]];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{// 此处不能完全限制住cell的高度，如需修改请到自定义的cell中修改
    return 38;
}

@end
