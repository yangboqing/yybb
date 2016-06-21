//
//  SerachHistoryRecordTableVIewController.m
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
        
        self.tableView.rowHeight = 39;
        
        self.recordList = [[SearchManager getObject] getSearchResultArray];
        if (!self.recordList) {
            self.recordList = [[[NSMutableArray alloc]init]autorelease];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
        cell = [[[SearchHistoryRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.deleteButton addTarget:self action:@selector(DeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [cell setHistroyRecord:[[FileUtil instance] urlEncode:[self.recordList objectAtIndex:indexPath.row]]];


    
    return cell;
}

- (void)DeleteButtonClick:(UIButton *)sender{
    
    SearchHistoryRecordTableViewCell *cell = (SearchHistoryRecordTableViewCell *)sender.tag;
    NSUInteger index = [self getIndexFromArray:cell.recordLabel.text];
    
    [[SearchManager getObject] deleteSearchHistoryRecord:index];
    
    //删除界面
    NSArray *indexPaths = [ NSArray arrayWithObject: [NSIndexPath indexPathForRow:index  inSection:0] ];
    
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationLeft];
    
}


- (NSUInteger)getIndexFromArray:(NSString*)str{
    
    NSMutableArray *array = [[SearchManager getObject] getSearchResultArray];
    NSString *string = [[FileUtil instance] urlCode:str];
    NSUInteger index = [array indexOfObject:string];
    return index;
    
}

- (void)rushList{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchHistoryRecordTableViewCell *cell = nil;
    cell =(SearchHistoryRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getHistoryRecordString:)]) {
        [self.delegate getHistoryRecordString:cell.recordLabel.text];
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


- (void)dealloc{
    
    [self.recordList release];
    self.recordList = nil;
    [super dealloc];
}


@end
