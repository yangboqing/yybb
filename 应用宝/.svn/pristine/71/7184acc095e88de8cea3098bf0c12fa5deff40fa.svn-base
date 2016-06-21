//
//  SearchHistoryRecordTableViewController.m
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import "SearchHistoryRecordTableViewController.h"

@interface SearchHistoryRecordTableViewController ()
@property (nonatomic , retain) NSMutableArray *recordList;
@end

@implementation SearchHistoryRecordTableViewController
@synthesize recordList = _recordList;
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.recordList = [[SearchManager getObject] getSearchResultArray];
        if (!self.recordList) {
            self.recordList = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    self.recordList = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!self.recordList) {
        return 0;
    };
    if (self.recordList.count < 20) {
        return self.recordList.count;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recordList";
    
    SearchHistoryRecordTableViewCell *cell = (SearchHistoryRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchHistoryRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.deleteButton addTarget:self action:@selector(DeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [cell setHistroyRecord:[[FileUtil instance] urlDecode:[self.recordList objectAtIndex:indexPath.row]]];


    
    return cell;
}

#pragma mark - Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchHistoryRecordTableViewCell *cell = nil;
    cell =(SearchHistoryRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getHistoryRecordString:)]) {
        [self.delegate getHistoryRecordString:cell.recordLabel.text];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

#pragma mark - Utility

- (void)DeleteButtonClick:(UIButton *)sender{
    
    SearchHistoryRecordTableViewCell *cell = (__bridge SearchHistoryRecordTableViewCell *)(void *)(sender.tag);
    NSUInteger index = [self getIndexFromArray:cell.recordLabel.text];
    
    [[SearchManager getObject] deleteSearchHistoryRecord:index];
    
    //删除界面
    [self rushList];
//    NSArray *indexPaths = [ NSArray arrayWithObject: [NSIndexPath indexPathForRow:index  inSection:0] ];
//    
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationLeft];
    
}


- (NSUInteger)getIndexFromArray:(NSString*)str{
    
    NSMutableArray *array = [[SearchManager getObject] getSearchResultArray];
    NSString *string = [[FileUtil instance] urlEncode:str];
    NSUInteger index = [array indexOfObject:string];
    return index;
    
}

- (void)rushList{
    self.recordList = [[SearchManager getObject] getSearchResultArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
