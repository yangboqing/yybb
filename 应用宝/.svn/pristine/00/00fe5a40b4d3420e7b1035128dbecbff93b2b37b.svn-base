//
//  DownOverTableViewController.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "DownOverTableViewController.h"
#import "GetDevIPAddress.h"
#import "IphoneAppDelegate.h"
#import "AppStatusManage.h"
#import <objc/runtime.h>
#import "FileUtil.h"
#import "CollectionCells.h"

@interface DownOverTableViewController (){
    NSMutableDictionary *installDic;
    UILabel *installedLabel;
    UILabel *reinstalledLabel;
    CGFloat fontSize;
    CGFloat headerHeight;
//    DownOverTableViewCell *deletecell;
    dispatch_source_t timer;
    
    //
    UIImage *installImg;
    UIImage *reinstallImg;
    
    //
    BOOL editFlag;
    BOOL hasEditFlag;
}

@end

#define deleteDicAppID @"deleteDicAppID"
#define deleteDicPlist @"deleteDicPlist"

@implementation DownOverTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = WHITE_BACKGROUND_COLOR;

        installDic = [[NSMutableDictionary alloc]init];
        self.installArray = [NSMutableArray array];
        self.reinstallArray = [NSMutableArray array];
        self.tableView.rowHeight = 78*MULTIPLE;
        headerHeight = 31;
        fontSize = 12;
        self.cellselectStyle = @"none";
        installImg = [UIImage imageNamed:@"state_install_smalls.png"];
        reinstallImg = [UIImage imageNamed:@"state_reinstall_small.png"];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return [self.installArray count];
//    }
//    return [self.reinstallArray count];
    
    return [self.installArray count];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownedCell";
    
    DownOverTableViewCell *cell = (DownOverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DownOverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.installBtn addTarget:self action:@selector(onDownloadedInstallClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSMutableArray *tmpArray = indexPath.section>0?self.reinstallArray:self.installArray;
    NSDictionary * dicCellItem = tmpArray[indexPath.row];
    cell.idenStr = [dicCellItem objectForKey:DISTRI_PLIST_URL];
    [cell downOverCellIconImage:[[BppDistriPlistManager getManager] imageForPlistURL:cell.idenStr]];
    [cell downOverCellName:[dicCellItem objectForKey:DISTRI_APP_NAME]];
    [cell downOverCellVersion:[dicCellItem objectForKey:DISTRI_APP_VERSION] volume:[[dicCellItem objectForKey:DISTRI_IPA_TOTAL_LENGTH] intValue]];
    cell.appID = [dicCellItem objectForKey:DISTRI_APP_ID];
    
//    if ( indexPath.section == 1) {
//        [cell setIphoneButtonImage:reinstallImg];
//    } else {
//        [cell setIphoneButtonImage:installImg];
//    }
    
    [cell setIphoneButtonImage:installImg];

    
    if ([self.cellselectStyle isEqualToString:@"allselect"]) {
        [cell setChecked:YES];
    }else if ([self.cellselectStyle isEqualToString:@"allunselect"])
    {
        [cell setChecked:NO];
    }else if ([self.cellselectStyle isEqualToString:@"none"])
    {
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.appID,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
        if ([_selectToDeleteArray containsObject:infoDic]) {
            [cell setChecked:YES];
        }else
        {
            [cell setChecked:NO];
        }
    }
//    deletecell = nil;
    return cell;
}

#pragma mark - UITableView delegate

//- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return headerHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, headerHeight-0.5, self.view.frame.size.width, 0.5)];
//    line.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
//    view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
//    if (section == 1) {
//        reinstalledLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*PHONE_SCALE_PARAMETER, 0, self.view.frame.size.width, headerHeight)];
//        reinstalledLabel.text = [NSString stringWithFormat:@"已安装 ( %d )",[self.reinstallArray count]];
//        reinstalledLabel.textAlignment = NSTextAlignmentLeft;
//        reinstalledLabel.font = [UIFont systemFontOfSize:fontSize];
//        reinstalledLabel.textColor = [UIColor blackColor];
//        reinstalledLabel.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
//        [reinstalledLabel addSubview:line];
//        [view addSubview:reinstalledLabel];
//        return view;
//    }else{
//        installedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*PHONE_SCALE_PARAMETER, 0, self.view.frame.size.width, headerHeight)];
//        installedLabel.text = [NSString stringWithFormat:@"未安装 ( %d )",[self.installArray count]];
//        installedLabel.textAlignment = NSTextAlignmentLeft;
//        installedLabel.font = [UIFont systemFontOfSize:fontSize];
//        installedLabel.textColor = [UIColor blackColor];
//        installedLabel.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
//        [installedLabel addSubview:line];
//        [view addSubview:installedLabel];
//        return view;
//    }
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownOverTableViewCell *cell = nil;
    cell =(DownOverTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.cellselectStyle = @"none";
    
    if (cell.editing)
	{
        if (!cell.m_checked) {
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.appID,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
            
            [cell setChecked:YES];
            [self.selectToDeleteArray addObject:infoDic];
        }
		
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_CHECKEDITVIEW object:nil];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{//取消一项
    
    DownOverTableViewCell *cell = nil;
    cell =(DownOverTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.cellselectStyle = @"none";
    
    if (cell.editing)
	{
        if (cell.m_checked) {
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.appID,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
            
            [cell setChecked:NO];
            [self.selectToDeleteArray removeObject:infoDic];
        }
		
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_CHECKEDITVIEW object:nil];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editFlag) {
        hasEditFlag = YES;
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    
    hasEditFlag = NO;
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downOverChangeTopButtonState:)]) {
        [self.delegate downOverChangeTopButtonState:topEditButton_Disable];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice]systemVersion] floatValue] < 8.0)) {
//        if (deletecell) {
//            NSIndexPath *tmpIntex = [tableView indexPathForCell:deletecell];
//            if (tmpIntex.row != indexPath.row) {
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            
//        }
//        else
//        {
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//
//    }
    self.editing = NO;
    
    // 解禁按钮
    if (self.delegate && [self.delegate respondsToSelector:@selector(downOverChangeTopButtonState:)]) {
        [self.delegate downOverChangeTopButtonState:topEditButton_Enable];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DownOverTableViewCell *cell = (DownOverTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self deleteDownOverCell:cell];
}

#pragma mark - BppDistriPlistManagerDelegate

- (void) onDidPlistMgrDownloadIPAComplete:(NSString*)distriPlist index:(NSUInteger)index{//listener来实现
    
    [self refreshMobileAppList:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
        [self.delegate downOverTableViewChanged:downOverType_refresh];
    }
    
//    // 应用修复列表改变对应cell按钮状态
//    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_REPAIRCELL_STATE object:distriPlist];
    
    //更新badge
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:nil];
}

- (void) onDidPlistMgrInAlreayDownloadDeleteSameAppid:(NSString *)appid DiffenertVersion:(NSString *)version{
    [self refreshMobileAppList:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSDictionary *dic = objc_getAssociatedObject(alertView, "info");
    objc_setAssociatedObject(alertView, "info", nil, OBJC_ASSOCIATION_RETAIN);
    
    NSInteger tag = [[dic objectForKey:@"tag"] intValue];
    if (tag == 222) {
        if (buttonIndex == 0) {
            
            [self deleteSelectedRows];
            
            if ( [self.installArray count]+[self.reinstallArray count]==0 ) {
                
                [self clearAllAppAndReloadDataSource];
                
                if ([[BppDistriPlistManager getManager] countOfDownloadedItem] == 0) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
                        [self.delegate downOverTableViewChanged:downOverType_showEmpty];
                    }
                }
            }
            
        }
    }
}

#pragma mark - 外露接口

-(void)setTableViewEdit:(BOOL)edit
{
    editFlag = edit;
    hasEditFlag = NO;
    [self.tableView setEditing:edit animated:YES];
}

-(BOOL)tableViewEditStyleDone
{
    return hasEditFlag;
}

- (void)clearAllAppAndReloadDataSource{
    [self.installArray removeAllObjects];
    [self.reinstallArray removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)clickdeleteSelectedRows:(id)sender{
    
    UIAlertView *netAlert = [[UIAlertView alloc]initWithTitle:@"是否要删除选中应用" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", @"否", nil];
    netAlert.delegate = self;
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:222], @"tag", nil];
    objc_setAssociatedObject(netAlert, "info", info, OBJC_ASSOCIATION_RETAIN);
    
    //netAlert
    [netAlert show];
}

- (void)selectAllCells:(BOOL)flag
{
    self.cellselectStyle = flag?@"allselect":@"allunselect";
    
    if (flag) {
        
        for (int i = 0; i<[self.installArray count]; i++) {
            
            NSDictionary * dicCellItem = [self.installArray objectAtIndex:i];
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dicCellItem objectForKey:DISTRI_APP_ID],deleteDicAppID,[dicCellItem objectForKey:DISTRI_PLIST_URL],deleteDicPlist, nil];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            DownOverTableViewCell *cell =(DownOverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            if (![_selectToDeleteArray containsObject:infoDic]) {
//                NSLog(@"section0添加一项  %i",indexPath.row);
                [cell setChecked:YES];
                [self.selectToDeleteArray addObject:infoDic];
            }
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
//        for (int i = 0; i<[self.reinstallArray count]; i++) {
//            
//            NSDictionary * dicCellItem = [self.reinstallArray objectAtIndex:i];
//            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dicCellItem objectForKey:DISTRI_APP_ID],deleteDicAppID,[dicCellItem objectForKey:DISTRI_PLIST_URL],deleteDicPlist, nil];
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//            DownOverTableViewCell *cell =(DownOverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//            
//            if (![_selectToDeleteArray containsObject:infoDic]) {
////                NSLog(@"section1添加一项  %i",indexPath.row);
//                [cell setChecked:YES];
//                [self.selectToDeleteArray addObject:infoDic];
//            }
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }
    }else
    {
        for (int i = 0; i<[self.installArray count]; i++) {
            
            NSDictionary * dicCellItem = [self.installArray objectAtIndex:i];
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dicCellItem objectForKey:DISTRI_APP_ID],deleteDicAppID,[dicCellItem objectForKey:DISTRI_PLIST_URL],deleteDicPlist, nil];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            DownOverTableViewCell *cell =(DownOverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

            if ([_selectToDeleteArray containsObject:infoDic]) {
//                NSLog(@"section0取消一项  %i",indexPath.row);
                [cell setChecked:NO];
                [self.selectToDeleteArray removeObject:infoDic];
            }
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        
//        for (int i = 0; i<[self.reinstallArray count]; i++) {
//            
//            NSDictionary * dicCellItem = [self.reinstallArray objectAtIndex:i];
//            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dicCellItem objectForKey:DISTRI_APP_ID],deleteDicAppID,[dicCellItem objectForKey:DISTRI_PLIST_URL],deleteDicPlist, nil];
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//            DownOverTableViewCell *cell =(DownOverTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//            
//            if ([_selectToDeleteArray containsObject:infoDic]) {
////                NSLog(@"section1取消一项  %i",indexPath.row);
//                [cell setChecked:NO];
//                [self.selectToDeleteArray removeObject:infoDic];
//            }
//            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
//        }
    }
}

#pragma mark - Utility
- (void)onDownloadedInstallClick:(UIButton *)sender{
    
    // 禁用按钮按钮1秒钟
    [self disableInstallButtonOneSecond:sender];
    
    // 安装
    DownOverTableViewCell *cell = (__bridge DownOverTableViewCell *)(void*)sender.tag;
    NSString * distriPlist = cell.idenStr;
    
    //已绑定账号且未显示过教程才弹框
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNTPASSWORD]&&![[NSUserDefaults standardUserDefaults] objectForKey:COPY_ACCOUNT_INFOR]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:COPY_ACCOUNT_INFOR];
        [[NSNotificationCenter defaultCenter] postNotificationName:COPY_ACCOUNT_INFOR object:distriPlist];
        
        return;
    }

    [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
}

-(void)deleteDownOverCell:(DownOverTableViewCell *)cell
{
//    deletecell = cell;
//    删除数据
    //在已下载拆分为已安装和未安装后,原有的删除数据源方法需要更改
    [[BppDistriPlistManager getManager] removePlistURL:cell.idenStr];
    
    NSString *tempAppid = nil;
    //除需要在downloaded.plist中删除外,还需要在self.installedApps或self.notInstalledApps中删除
    do {
        for (NSMutableDictionary *dic in self.installArray) {
            if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:cell.idenStr]) {
                tempAppid = [dic objectForKey:DISTRI_APP_ID];
                //removeAppInstall

                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:tempAppid];

                
                [self.installArray removeObject:dic];
                break;
            }
        }
        
        for (NSMutableDictionary *dic in self.reinstallArray) {
            if ( [[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:cell.idenStr] ) {
                
                tempAppid = [dic objectForKey:DISTRI_APP_ID];
                //removeAppReinstall

                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:tempAppid];

                
                [self.reinstallArray removeObject:dic];
                break;
            }
        }
        
    } while (0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //删除界面
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:Nil];
    });
    
    [self.tableView reloadData];
    
    [[GetDevIPAddress getObject] deleteInstallReportData:cell.appID];
    
    if ([[BppDistriPlistManager getManager] countOfDownloadedItem] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
            [self.delegate downOverTableViewChanged:downOverType_showEmpty];
        }
    }
}

-(void)disableInstallButtonOneSecond:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), 0, 0);
    dispatch_source_set_event_handler(timer, ^{
        btn.enabled = YES;
        dispatch_source_cancel(timer);
    });
    
    dispatch_resume(timer);
}

- (void)deleteSelectedRows
{
    self.cellselectStyle = @"allunselect";
    //删除测试
    if ([_selectToDeleteArray count]) {
        
        for (NSDictionary *tmpDic in _selectToDeleteArray) {
            
            NSString *tmpAppID = [tmpDic objectForKey:deleteDicAppID];
            NSString *tmpPlist = [tmpDic objectForKey:deleteDicPlist];
            
            [[BppDistriPlistManager getManager] removePlistURL:tmpPlist];
            //NSLog(@"-=-=-=-   indexpathRow  %i   %@",tmpindexPath.row,tmpcell.idenStr);
            
            NSString *tempAppid = nil;
            
            //除需要在downloaded.plist中删除外,还需要在self.installedApps或self.notInstalledApps中删除
            for (NSMutableDictionary *dic in self.installArray) {
                if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:tmpPlist]) {
                    tempAppid = [dic objectForKey:DISTRI_APP_ID];
                    //removeAppInstall
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:tempAppid];
                    [self.installArray removeObject:dic];
                    break;
                }
            }
            for (NSMutableDictionary *dic in self.reinstallArray) {
                if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:tmpPlist]) {
                    tempAppid = [dic objectForKey:DISTRI_APP_ID];
                    //removeAppReinstall
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:tempAppid];
                    [self.reinstallArray removeObject:dic];
                    break;
                }
            }
            
            
            [[GetDevIPAddress getObject] deleteInstallReportData:tmpAppID];
            
            if ([[BppDistriPlistManager getManager] countOfDownloadedItem] == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
                    [self.delegate downOverTableViewChanged:downOverType_showEmpty];
                }
            }
            
        }
        //发送变化通知
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:Nil];
        [self.selectToDeleteArray removeAllObjects];
        
        [self.tableView reloadData];
    }
}

- (void)deleteItemFromBranchArray:(NSString *)plistUrl{ //从分支数组里删除app
    NSUInteger index;
    do {
        for (NSMutableDictionary *dic in self.installArray) {
            if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:plistUrl]) {
                index = [self.installArray indexOfObject:dic];
                [self.installArray removeObjectAtIndex:index];
                break;
            }
            
        }
        for (NSMutableDictionary *dic in self.reinstallArray) {
            if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:plistUrl]) {
                index = [self.reinstallArray indexOfObject:dic];
                [self.reinstallArray removeObjectAtIndex:index];
                break;
            }
            
        }
        
    } while (0);
    
}

#pragma mark - Notification methods


- (void)deleteDownedBecauseUpdata:(NSNotification *)note{
    NSString * appID = note.object;
    
    NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoInDownloadedByAttriName:DISTRI_APP_ID value:appID];
    NSString *plist = [dic objectForKey:DISTRI_PLIST_URL];
    
    //删除数据
    [[BppDistriPlistManager getManager] removePlistURL:plist];
    [self deleteItemFromBranchArray:plist];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    if ([[BppDistriPlistManager getManager] countOfDownloadedItem] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
            [self.delegate downOverTableViewChanged:downOverType_showEmpty];
        }
    }
}

- (void)deleteAppAfterInstall:(NSNotification *)note{
    NSMutableArray *array = note.object;
    NSString *appid = [array objectAtIndex:0];
    NSString *plistUrl = [array lastObject];
    
    //从已下载列表删除
    [[BppDistriPlistManager getManager] removePlistURL:plistUrl];
    for (NSMutableDictionary *dic in self.installArray) {
        if ([[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:plistUrl]) {
            [self.installArray removeObject:dic];
            break;
        }
    }
    
    for (NSMutableDictionary *dic in self.reinstallArray) {
        if ( [[dic objectForKey:DISTRI_PLIST_URL]isEqualToString:plistUrl] ) {
            [self.reinstallArray removeObject:dic];
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:appid];
    
        [[GetDevIPAddress getObject] deleteInstallReportData:appid];

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[BppDistriPlistManager getManager] countOfDownloadedItem] == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downOverTableViewChanged:)]) {
                [self.delegate downOverTableViewChanged:downOverType_showEmpty];
            }
        }
    });
    
    [self.tableView reloadData];
}

- (void)refreshMobileAppList:(NSNotification *)note{
    
    [self.installArray removeAllObjects];
    [self.reinstallArray removeAllObjects];
    
//    NSArray *mobileArray = [[AppStatusManage getObject] getAppList:FALSE];
    
    NSMutableArray * localArray = [[BppDistriPlistManager getManager].distriAlReadyDownloadedPlists  mutableCopy];
    
//    NSIndexSet * indexes = [localArray  indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//        
//        NSString * localAppid = [obj objectForKey:DISTRI_APP_ID];
//        NSString * localAppVersion = [obj objectForKey:DISTRI_APP_VERSION];
//        
//        for (NSDictionary *dic in mobileArray) {
//            NSString * appid = [dic objectForKey:DESK_APPID];
//            NSString * appVersion = [dic objectForKey:DESK_APPVER];
//            
//            if ([appid isEqualToString:localAppid]
//                && [appVersion isEqualToString:localAppVersion]) {
//                
//                [self.reinstallArray addObject:obj];
//                return TRUE;
//            }
//        }
//
//        return FALSE;
//    }];
//    
//    [localArray removeObjectsAtIndexes:indexes];
    self.installArray = localArray;
    
    
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BppDistriPlistManager getManager] addListener:self];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deleteDownedBecauseUpdata:)
//												 name:DELETE_DOWNLOAD_BECAUSE_UPDATE
//                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deleteAppAfterInstall:)
//                                                 name:DELETE_APP_AFTER_INSTALL
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMobileAppList:)
                                                 name:REFRESH_MOBILE_APP_LIST
                                               object:nil];
    
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    self.selectToDeleteArray = deleteArray;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    [[BppDistriPlistManager getManager] removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
