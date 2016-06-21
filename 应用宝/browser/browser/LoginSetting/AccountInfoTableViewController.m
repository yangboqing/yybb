//
//  AccountInfoTableViewController.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "AccountInfoTableViewController.h"
#import "AccountInfoTableViewCell.h"

@interface AccountInfoTableViewController (){
    NSMutableArray *cellArray;
}

@end

@implementation AccountInfoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellArray = [NSMutableArray arrayWithObjects:@"Apple ID",@"密码",@"邮箱密码", nil];
    
    
    [self getAccountInfoData];
    
    
    
    self.tableView.backgroundColor = CLEAR_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 37;
    self.tableView.sectionFooterHeight = 0;
}

- (void)getAccountInfoData{
    NSString *responseStr = [[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO];
    responseStr = [DESUtils decryptUseDES:responseStr key:APPLE_ACCOUNT_KEY];
    
    if (responseStr) {
        self.infoMap = [[FileUtil instance] analysisJSONToDictionary:responseStr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }
    
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"密保问题";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"accountInfo";
    
    AccountInfoTableViewCell *cell = (AccountInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AccountInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section == 0) {
        
        cell.rightInfo.font = [UIFont systemFontOfSize:14.0f];
        
        cell.leftName.text = [cellArray objectAtIndex:indexPath.row];
        [cell setBackGroundImage:indexPath.row];
        [cell showLine:YES];
        if (indexPath.row == 0) {
            cell.rightInfo.text = [self.infoMap objectForKey:@"name"]?[self.infoMap objectForKey:@"name"]:@"";
            [cell showLine:YES];
        }else if (indexPath.row == 1){
            cell.rightInfo.text = [self.infoMap objectForKey:@"pwd"]?[self.infoMap objectForKey:@"pwd"]:@"";
            [cell showLine:YES];
        }else if (indexPath.row == 2){
            cell.rightInfo.text = [self.infoMap objectForKey:@"epwd"]?[self.infoMap objectForKey:@"epwd"]:@"";
            [cell showLine:NO];
        }
        
    }else{
        cell.rightInfo.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.row == 0) {
            cell.leftName.text = [NSString stringWithFormat:@"问题%d",(int)indexPath.section];
            [cell setBackGroundImage:0];
            if (indexPath.section == 1) {
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"q1"]?[self.infoMap objectForKey:@"q1"]:@""];
            }else if (indexPath.section ==2){
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"q2"]?[self.infoMap objectForKey:@"q2"]:@""];
            }else if (indexPath.section == 3){
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"q3"]?[self.infoMap objectForKey:@"q3"]:@""];
            }
        }else if (indexPath.row == 1){
            [cell setBackGroundImage:2];
            [cell showLine:NO];
            cell.leftName.text = [NSString stringWithFormat:@"答案%d",(int)indexPath.section];
            if (indexPath.section == 1) {
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"a1"]?[self.infoMap objectForKey:@"a1"]:@""];
            }else if (indexPath.section ==2){
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"a2"]?[self.infoMap objectForKey:@"a2"]:@""];
            }else if (indexPath.section == 3){
                cell.rightInfo.text = [FileUtil  replaceUnicode:[self.infoMap objectForKey:@"a3"]?[self.infoMap objectForKey:@"a3"]:@""];
            }
        }
    }
    
    return cell;
}




@end
