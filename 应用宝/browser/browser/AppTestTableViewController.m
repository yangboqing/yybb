//
//  AppTestTableViewController.m
//  browser
//
//  Created by caohechun on 14-4-17.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppTestTableViewController.h"
#import "AppTestTableViewCell.h"
#import "SearchManager.h"
#import "AppTestDetailViewController.h"
#import "FindDetailViewController.h"
#import "SDImageCache.h"
@interface AppTestTableViewController ()
{
    int sectionNumber;
    NSDictionary * testDataDic;

}
@end

@implementation AppTestTableViewController
- (void)dealloc{

}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    testDataDic =  [[NSDictionary alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setTestDetail:(NSDictionary *)dataDic{
    testDataDic = dataDic;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UILabel *sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreen_Width, 30)];
    sectionTitle.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    sectionTitle.textAlignment = NSTextAlignmentLeft;
    sectionTitle.font = [UIFont systemFontOfSize:15];
    sectionTitle.backgroundColor = CONTENT_BACKGROUND_COLOR;
    sectionTitle.text  = @"  活动";
    

    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, MainScreen_Width, 30);
    bgView.backgroundColor  = [UIColor clearColor];
    [bgView addSubview:sectionTitle];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height - 0.5, MainScreen_Width, 0.5)];
    lineView.backgroundColor =  [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    [bgView addSubview:lineView];
    
//    return [bgView autorelease];
    if (section == 0) {
        if ([[testDataDic objectForKey:@"huodong"] count] != 0) {
            return sectionTitle;
        }else{
            sectionTitle.text = @"  评测";
            return bgView ;
        }
    }
    if (section ==1) {
        sectionTitle.text = @"  评测";
        return bgView ;
    }
    return nil;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    int num = ([[testDataDic objectForKey:@"huodong"] count]?1:0) + ([[testDataDic objectForKey:@"pingce"] count]?1:0);
//    NSLog(@"section数量 = %d",num);
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[testDataDic objectForKey:@"huodong"]count] !=0) {
            return  [[testDataDic objectForKey:@"huodong"] count];
        }else{
            return  [[testDataDic objectForKey:@"pingce"] count];
        }
    }
    return  [[testDataDic objectForKey:@"pingce"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"test";
    AppTestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AppTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSDictionary * dic = nil;
    if (indexPath.section ==0) {
        if ([[testDataDic objectForKey:@"huodong"] count] !=0) {
            dic  = [testDataDic objectForKey:@"huodong"][indexPath.row];

        }else{
            dic  = [testDataDic objectForKey:@"pingce"][indexPath.row];
        }
        [cell setTestCellDetail:dic];
        
    }
    if (indexPath.section ==1) {
        dic =  [testDataDic objectForKey:@"pingce"][indexPath.row];
        [cell setTestCellDetail:dic];

    }
    cell.detailURLString = [dic objectForKey:@"content_url"];

    [cell->preView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic_url"] ]];
    
    return cell;
    
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppTestTableViewCell *cell = (AppTestTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic  = [(AppTestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] getTestCellDetail];
    if([[dic objectForKey:@"content_url_open_type"] integerValue] == 2){
        NSURL * url = [NSURL URLWithString:[dic objectForKey:@"content_url"]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [self.testDetailDelegate showTestDetail:dic withImage:[cell getTestImage]];
    }
    
}



@end
