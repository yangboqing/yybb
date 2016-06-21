//
//  SettingTableViewController.m
//  browser
//
//  Created by caohechun on 14-2-19.
//
//

#import "SettingTableViewController.h"
#import "TableViewCell.h"
#import "FileUtil.h"
#define StringSize 8
#define ONSTRING @"关闭后下载后即安装,下载不稳定"
#define OFFSTRING @"开启后下载稳定,不能自动安装"

#define IS_ACTIVED [[FileUtil instance] checkAuIsCanLogin]

@interface SettingTableViewController()

{
    NSMutableArray * dataArray;
    
    NSMutableArray *headArray;
    NSMutableArray *footArray;
    NSMutableArray *contentArray;
    NSMutableArray *mutableSetTmpArray;
    
}
@property (nonatomic, retain) NSString * patch;

@end
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

@synthesize patch = _patch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    }
    return self;
}

- (void)dealloc
{
    self.patch = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mutableSetTmpArray = [[NSMutableArray alloc]init];

    headArray = [NSMutableArray arrayWithObjects:@"下载",@"安装",nil];

//    footArray = [NSMutableArray arrayWithObjects:@"关闭下载后即安装,下载不稳定", nil];
    contentArray = [[NSMutableArray alloc]init];
//    [contentArray addObject:[NSDictionary dictionaryWithObject:@[@"下载到设备再安装"] forKey:@"安装模式"]];
    
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:@[@"下载完成提示安装"] forKey:@"下载"];
    [contentArray addObject:tmpDic];
    [mutableSetTmpArray addObject:tmpDic];
    
    [contentArray addObject:[NSDictionary dictionaryWithObject:@[@"安装成功后自动删除安装包"] forKey:@"安装"]];
    [mutableSetTmpArray addObject:[NSDictionary dictionaryWithObject:@[@"安装成功后自动删除安装包"] forKey:@"安装"]];

    //将下载到设备再安装写死
    [[SettingPlistConfig getObject] changePlistObject:SWITCH_YES key:DOWNLOAD_TO_LOCAL];
    
//    if(![[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL])
//    {
//        [self tableviewShrinkWithString:SWITCH_NO];
//    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
    return headArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[contentArray[section] objectForKey:headArray[section]]count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return headArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        if (INT_SYSTEMVERSION>= 7) {
//            return 30;
//        }
//        return 20;
//    }
//    return 0;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        
//        return footArray[0];
//        
//    }
//    return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell显示的文字
    NSString *contentString  = [contentArray[indexPath.section] objectForKey:headArray[indexPath.section]][indexPath.row];
//    if ([contentString isEqualToString:@"下载到设备再安装"]) {
//        //
//        static NSString *idenDownInstall = @"downToDeviceInstall";
//        SwitchTableViewCell_iphone *cell = [tableView dequeueReusableCellWithIdentifier:idenDownInstall];
//        if (cell == nil) {
//            cell = [[SwitchTableViewCell_iphone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenDownInstall];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        cell.settingSwitch.on = [[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL];
//        cell.settingSwitch.tag = 100;
//        [cell cellLabelText:contentString];
//        
//        [cell.settingSwitch addTarget:self action:@selector(swtichChange:) forControlEvents:UIControlEventValueChanged];
//        return cell;
//    }else
    if ([contentString isEqualToString:@"下载完成提示安装"]) {
        //
        static NSString *idenDownInstallTip = @"downDoneInstallTip";
        SwitchTableViewCell_iphone *cell = [tableView dequeueReusableCellWithIdentifier:idenDownInstallTip];
        if (cell == nil) {
            cell = [[SwitchTableViewCell_iphone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenDownInstallTip];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.settingSwitch.on = [[SettingPlistConfig getObject] getPlistObject:QUICK_INSTALL];
        cell.settingSwitch.tag = 101;
        [cell cellLabelText:contentString];
        
        [cell.settingSwitch addTarget:self action:@selector(swtichChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else if ([contentString isEqualToString:@"安装成功后自动删除安装包"]) {
        //
        static NSString *idenInstallDownDel = @"installDoneDelPacket";
        SwitchTableViewCell_iphone *cell = [tableView dequeueReusableCellWithIdentifier:idenInstallDownDel];
        if (cell == nil) {
            cell = [[SwitchTableViewCell_iphone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenInstallDownDel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.settingSwitch.on = [[SettingPlistConfig getObject] getPlistObject:DELETE_PACK_AFTER_INSTALLING];

        cell.settingSwitch.tag = 102;
        [cell cellLabelText:contentString];
        
        [cell.settingSwitch addTarget:self action:@selector(swtichChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    
    return nil;
}

- (void)tableviewShrinkWithString:(NSString *)switchString
{
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    if (([switchString isEqualToString:SWITCH_NO] && headArray.count == 5))
    {
        [self.tableView beginUpdates];
        [contentArray removeObjectsAtIndexes:indexSet];
        [headArray removeObjectsAtIndexes:indexSet];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    }
    else if (([switchString isEqualToString:SWITCH_YES] && headArray.count == 3))//2
    {
        [self.tableView beginUpdates];
        [contentArray insertObjects:mutableSetTmpArray atIndexes:indexSet];
        [headArray insertObjects:@[@"下载",@"安装"] atIndexes:indexSet];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void) swtichChange:(UISwitch *)aSwitch{
    
    int index = aSwitch.tag;
    
    NSString *swtichStr = nil;
    
    if (aSwitch.isOn == YES) {
        swtichStr = SWITCH_YES;
    }else{
        swtichStr = SWITCH_NO;
    }
    
    
    switch (index) {
//        case 100:{
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            SwitchTableViewCell_iphone * myCell = (SwitchTableViewCell_iphone *)[self.tableView cellForRowAtIndexPath:indexPath];
//            if (aSwitch.isOn) {
//                myCell.myLabel.text = ONSTRING;
//            }else{
//                myCell.myLabel.text = OFFSTRING;
//            }
//            [[SettingPlistConfig getObject] changePlistObject:swtichStr key:DOWNLOAD_TO_LOCAL];
//            break;
//        }
        case 101:
            [[SettingPlistConfig getObject] changePlistObject:swtichStr key:QUICK_INSTALL];
            break;
        case 102:
            [[SettingPlistConfig getObject] changePlistObject:swtichStr key:DELETE_PACK_AFTER_INSTALLING];
            break;
        default:
            break;
    }
    
    
    [aSwitch setOn:aSwitch.isOn animated:YES];
    [self.tableView reloadData];
    
}

@end
