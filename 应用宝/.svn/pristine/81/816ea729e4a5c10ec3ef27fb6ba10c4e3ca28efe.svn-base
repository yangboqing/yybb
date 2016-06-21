//
//  DownLoadingTableViewController.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "DownLoadingTableViewController.h"
#import "DownLoadingTableViewCell.h"
#import "BppDownloadFile.h"
#import "BppDistriPlistManager.h"
#import "GetDevIPAddress.h"
#import "SettingPlistConfig.h"
#import "IphoneAppDelegate.h"
#import "AppStatusManage.h"
#import <objc/runtime.h>
#import "FileUtil.h"
#import "CollectionCells.h"


@interface DownLoadingTableViewController () <BppDistriPlistManagerDelegate,  UIAlertViewDelegate> {
    
    NSMutableArray *PauseCells;
    NSMutableDictionary *updataDict;
    NSMutableDictionary *saveSpeedDic;
//    DownLoadingTableViewCell *deletecell;
    DownLoadingTableViewCell *currentCell;//当前进行开始,暂停操作的按钮
}

@end

#define deleteDicAppID @"deleteDicAppID"
#define deleteDicPlist @"deleteDicPlist"

@implementation DownLoadingTableViewController
@synthesize delegate = _delegate;
@synthesize selectToDeleteArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor = WHITE_BACKGROUND_COLOR;
        PauseCells = [[NSMutableArray alloc]init];
        saveSpeedDic = [[NSMutableDictionary alloc]init];
        
        self.tableView.rowHeight = 69;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        updataDict = [NSMutableDictionary dictionary];
        
        editFlag = NO;
        hasEditFlag = NO;
        selectToDeleteArray = [NSMutableArray array];
        self.cellselectStyle = @"none";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BppDistriPlistManager getManager] countOfDownloadingItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DowningCell";
    
    DownLoadingTableViewCell *cell = (DownLoadingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DownLoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.startOrPauseBtn addTarget:self action:@selector(onStartOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSDictionary * dicCellItem = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:indexPath.row];
    
    cell.downingAppid = [dicCellItem objectForKey:DISTRI_APP_ID];
    cell.idenStr = [dicCellItem objectForKey:DISTRI_PLIST_URL];
    [cell downLoadingName: [dicCellItem objectForKey:DISTRI_APP_NAME]];
    [cell downLoadingIconImage:[[BppDistriPlistManager getManager] imageForPlistURL:cell.idenStr]];
    cell.statusStr = [NSString stringWithFormat:@"%d",[[dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] intValue]];
    
    cell.userInteractionEnabled = YES;
    
    //设置下载状态
    int status = [[dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_STATUS] intValue];
    [cell setCellStatus:status];
    if (status == DOWNLOAD_STATUS_RUN) {
        if ([saveSpeedDic objectForKey:cell.idenStr]) {
            cell.speedLabel.text = [saveSpeedDic objectForKey:cell.idenStr];
        }
    }
    
    
    //下载进度
    if ([dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_PROGRESS]) {
        if ([[dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_PROGRESS] floatValue] == -100) {
            [cell downLoadingProgress:[[cell.progDic objectForKey:@"progCount"] floatValue] animated:NO];
        }
        else
        {
            [cell downLoadingProgress:[[dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_PROGRESS] floatValue] animated:NO];
            [cell.progDic setObject:[dicCellItem objectForKey:DISTRI_APP_DOWNLOAD_PROGRESS] forKey:@"progCount"];
        }
    }else{
        [cell downLoadingProgress:0 animated:NO];
        [cell.progDic setObject:[NSNumber numberWithFloat:0] forKey:@"progCount"];
    }
    
    
    if ([dicCellItem objectForKey:DISTRI_IPA_TOTAL_LENGTH]) {
        [cell downLoadingVolume:[[dicCellItem objectForKey:DISTRI_IPA_TOTAL_LENGTH] floatValue]];
    }
    
    if ([self.cellselectStyle isEqualToString:@"allselect"]) {
        [cell setChecked:YES];
    }else if ([self.cellselectStyle isEqualToString:@"allunselect"])
    {
        [cell setChecked:NO];
    }else if ([self.cellselectStyle isEqualToString:@"none"])
    {
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.downingAppid,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
        if ([selectToDeleteArray containsObject:infoDic]) {
            [cell setChecked:YES];
        }else
        {
            [cell setChecked:NO];
        }
    }
    
//    deletecell = nil;
    return cell;
}

#pragma mark -  tableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78*MULTIPLE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownLoadingTableViewCell *cell = nil;
    cell =(DownLoadingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.cellselectStyle = @"none";
    
    if (cell.editing)
	{
        if (!cell.m_checked) {
//            NSLog(@"添加一项  %i",indexPath.row);
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.downingAppid,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
            [cell setChecked:YES];
            [selectToDeleteArray addObject:infoDic];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_CHECKEDITVIEW object:nil];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DownLoadingTableViewCell *cell = nil;
    cell =(DownLoadingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.cellselectStyle = @"none";
    
    if (cell.editing)
	{
        if (cell.m_checked) {
//            NSLog(@"取消一项  %i",indexPath.row);
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cell.downingAppid,deleteDicAppID,cell.idenStr,deleteDicPlist, nil];
            
            [cell setChecked:NO];
            [selectToDeleteArray removeObject:infoDic];
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
    // 全部禁用（开始下载、编辑按钮）
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingChangeTopButtonState:)]) {
        [self.delegate downloadingChangeTopButtonState:topButtonType_AllDisable];
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
//        }
//        else
//        {
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        
//    }
    self.editing = NO;
    
    // 全部可用（开始下载、编辑按钮）
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingChangeTopButtonState:)]) {
        
        // 下载中是否有下载项
        int itemCount = [[BppDistriPlistManager getManager] countOfDownloadingItem];
        TopButton_StateType topBtnState = topButtonType_AllDisable;
        if (itemCount > 0) {
            topBtnState = topButtonType_AllEnable;
        }
        
        [self.delegate downloadingChangeTopButtonState:topBtnState];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DownLoadingTableViewCell *cell = (DownLoadingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self deleteDownloadingCell:cell];
}

#pragma mark - BppDistriPlistManagerDelegate
- (void) onDidPlistMgrAddDownloadItem:(NSString*)distriPlist{ // 添加了一个下载条目
    
    //添加了一条下载条目, 汇报日志
    {
        NSDictionary * itemInfo = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlist];
        if(itemInfo) {
            NSString * appid = [itemInfo objectForKey:DISTRI_APP_ID];
            NSString * dlfrom = [itemInfo objectForKey:DISTRI_APP_FROM];
            [[ReportManage instance] ReportAppClickDownload:dlfrom appid:appid];
        }
    }
    
    //取消编辑状态
    [self setTableViewEdit:NO];
    
    //回调使外层刷新下载中和已下载的个数
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
        [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlist];
    NSString *appID= nil;
    appID = [dic objectForKey:DISTRI_APP_ID];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_APP_DOWNLOADING  object:appID];
    
    
    if ([updataDict objectForKey:distriPlist]) {
        [updataDict removeObjectForKey:distriPlist];
    }else{
        {
            //将新添加的名字和url告诉外层
            NSString * nameStr  = nil;
            nameStr = @"";
            if ([dic objectForKey:DISTRI_APP_NAME] != nil) {
                nameStr = [dic objectForKey:DISTRI_APP_NAME];
            }
            if ([dic objectForKey:@"appName"] != nil) {
                nameStr = [dic objectForKey:@"appName"];
            }
            
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:nameStr];
            [array addObject:distriPlist];
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_NEW_DOWNLOAD_ITEM  object:array];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADCOUNT  object:nil];
}

- (void) onDidPlistMgrDownloadIconComplete:(NSString*)distriPlist icon:(UIImage*)image{
    //取得可见的CELL
    for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
        
        if ( [ cell.idenStr isEqualToString:distriPlist] ) {
            [cell downLoadingIconImage:image];
            break;
        }
    }
}

- (void) onDidPlistMgrDownloadIPAProgress:(NSString*)distriPlist attr:(NSDictionary*)dicAttr{
    // IPA下载进度（此回调将频繁触发）
    if (distriPlist != nil) {
        
        for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
            
            if ( [ cell.idenStr isEqualToString:distriPlist] ) {
                
                //只有RUN状态的Cell才能有进度信息
                if ( [cell.statusStr intValue] != DOWNLOAD_STATUS_RUN) {
                    break;
                }
                
                CGFloat curProgress = [[dicAttr objectForKey:BPPDownloadProgressKey] floatValue];
                if (curProgress < 0) {
                    //如果进度变小，则继续用大进度
                    [cell downLoadingProgress:[[cell.progDic objectForKey:@"progCount"] floatValue] animated:YES];
                }else{
                    //显示通知的进度
                    [cell downLoadingProgress:[[dicAttr objectForKey:BPPDownloadProgressKey] floatValue] animated:YES];
                    
                    //保存CELL自己的进度
                    [cell.progDic setObject:[dicAttr objectForKey:BPPDownloadProgressKey] forKey:@"progCount"];
                }
                
                //NSLog(@"name:%@ speed:%.2f", cell.nameLabel.text, [[dicAttr objectForKey:BPPDownloadSpeedKey] floatValue]);
                [cell downLoadingSpeed:[[dicAttr objectForKey:BPPDownloadSpeedKey] floatValue]];
                [saveSpeedDic setValue:[NSString stringWithFormat:@"%.2fKB/s",[[dicAttr objectForKey:BPPDownloadSpeedKey] floatValue]] forKey:cell.idenStr];

                [cell downLoadingTime:[[dicAttr objectForKey:BPPDownloadRemainTimeKey]  intValue]];
                [cell downLoadingVolume:[[dicAttr objectForKey:BPPDownloadTotalLengthKey]  floatValue]];
                
                break;
            }
        }
    }
}

- (void) onDidPlistMgrDownloadIPAComplete:(NSString*)distriPlist index:(NSUInteger)index{
    // IPA下载完毕
    NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlist];
    
    
    //把该CELL的进度设置为0
    for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
        if ( [ cell.idenStr isEqualToString:distriPlist] ){
            [cell downLoadingProgress:0.0 animated:NO];
            break;
        }
    }
    [saveSpeedDic removeObjectForKey:distriPlist];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADCOUNT  object:nil];
    
    //刷新更新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_UPDATA_AFTER_SCREEN object:nil];
    
    BOOL _isQuickInstall = [[SettingPlistConfig getObject] getPlistObject:QUICK_INSTALL];
    if (_isQuickInstall == YES ) {

            [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
        

    }else{
        {
            NSMutableArray *array = [NSMutableArray array];
            NSString * nameStr = [dic objectForKey:DISTRI_APP_NAME];
            [array addObject:nameStr];
            [array addObject:distriPlist];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADCOMPLETE  object:array];
        }
    }
    
    if ([[BppDistriPlistManager getManager] countOfDownloadingItem] == 0) { // 下载中的数组归0
        if (self.tableView.hidden == NO) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
                [self.delegate downloadingTableViewChanged:downLoadingType_showEmpty];
            }
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
            [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
        }
    }
    
    dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:distriPlist];
    NSString *appName = [dic objectForKey:DISTRI_APP_NAME];
    [self setupLocalNotifications:appName];
}

- (void) onDidPlistMgrStatusChange:(NSString*)distriPlist dicAttr:(NSDictionary *)attr {
    
    NSInteger status = [[attr objectForKey:@"status"] integerValue];
    
    if (![[BppDistriPlistManager getManager] countOfDownloadingItem]) {
        return;
    }
    for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
        
        if ( [ cell.idenStr isEqualToString:distriPlist] ) {
            [cell setCellStatus:status];
            // 进一步对错误状态处理，标示出错原因
            if (status == DOWNLOAD_STATUS_ERROR) {
                int errorCode = [[attr objectForKey: BPPDownloadErrorReasonUserInfoKey] integerValue];
                [cell setErrortext:errorCode];
            }
            break;
        }
    }
    
    if ([self numberOfPauseItems] > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingChangeTopButtonState:)]) {
            [self.delegate downloadingChangeTopButtonState:TopButtonType_AllStart];
        }
    }
    else if([[BppDistriPlistManager getManager] countOfDownloadingItem]>0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingChangeTopButtonState:)]) {
            [self.delegate downloadingChangeTopButtonState:TopButtonType_AllPause];
        }
    }
    
}

- (void)onDidPlistMgrDownloadAUIPAError:(NSString *)appid{
    
    NSString *errorAppid = appid;
    
    for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
        if ( [ cell.downingAppid isEqualToString:errorAppid] ) {
            [cell setErrortext:DownloadErrorDownloadTypeToGetAppInfo];
            [cell setCellStatus:DOWNLOAD_STATUS_ERROR];
            NSString *name = cell.nameLabel.text;
            
            if(name&&appid){
                [[NSNotificationCenter defaultCenter] postNotificationName:AU_DOWNLOAD_FAIL object:@{@"name":name,@"appid":appid}];
            }
            break;
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

- (NSInteger)numberOfPauseItems{ // 暂停下载的应用的个数
    
    NSInteger pauseCount = 0;
    NSInteger count = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    
    for (int i=0; i<count; i++) {
        NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
        NSInteger status = [[dic objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue];
        if (status == DOWNLOAD_STATUS_STOP) {
            pauseCount ++;
        }
    }
    
    return pauseCount;
}

- (void)clickAllStartBtn{
    [[BppDistriPlistManager getManager] startAllPlistURL];
    [self.tableView reloadData];
}

- (void)clickAllPauseBtn{
    [[BppDistriPlistManager getManager] stopAllPlistURL];
    [self.tableView reloadData];

}

- (void)clickPlistStartBtn:(NSString *)_urlString
{
    [[BppDistriPlistManager getManager] startPlistURL:_urlString];
    [self.tableView reloadData];
}

- (void)deleteSpeedDic{
    [saveSpeedDic removeAllObjects];
}

- (void)deleteSelectedRows
{
    self.cellselectStyle = @"allunselect";
    //删除测试
    if ([selectToDeleteArray count]) {
        
        for (NSDictionary *tmpDic in selectToDeleteArray) {
            
            NSString *tmpAppID = [tmpDic objectForKey:deleteDicAppID];
            NSString *tmpPlist = [tmpDic objectForKey:deleteDicPlist];
            
            //NSLog(@"删除的  %@",tmpPlist);
            
            if ([saveSpeedDic objectForKey:tmpPlist]) {
                [saveSpeedDic removeObjectForKey:tmpPlist];
            }
            
            NSInteger index = [[BppDistriPlistManager getManager] removePlistURL:tmpPlist];
            if (index == NSNotFound){
                //NSLog(@"%@ 删除失败", tmpPlist);
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:tmpAppID];

        }
        
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADCOUNT object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DOWNLOAD_TOPVIEW_COUNT object:Nil];
        [selectToDeleteArray removeAllObjects];
        
        [self setTableViewEdit:NO];

    }
}

- (void)selectAllCells:(BOOL)flag
{
    self.cellselectStyle = flag?@"allselect":@"allunselect";
    
    for (int i = 0; i<[[BppDistriPlistManager getManager] countOfDownloadingItem]; i++) {
        
        NSDictionary * dicCellItem = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dicCellItem objectForKey:DISTRI_APP_ID],deleteDicAppID,[dicCellItem objectForKey:DISTRI_PLIST_URL],deleteDicPlist, nil];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DownLoadingTableViewCell *cell =(DownLoadingTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if(flag) {
            if (![selectToDeleteArray containsObject:infoDic]) {
//                NSLog(@"添加一项  %i %@",indexPath.row,infoDic);
                [cell setChecked:YES];
                [selectToDeleteArray addObject:infoDic];
            }
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else{
            
            if ([selectToDeleteArray containsObject:infoDic]) {
//                NSLog(@"取消一项  %i",indexPath.row);
                [cell setChecked:NO];
                [selectToDeleteArray removeObject:infoDic];
            }
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

#pragma mark - Utility

- (void)onStartOrPause:(UIButton*)sender{
    
    NSString *netStr = [[FileUtil instance] GetCurrntNet];
    if (!netStr) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络异常，请检查网络" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    DownLoadingTableViewCell *cell =  (__bridge DownLoadingTableViewCell *)(void*)sender.tag;
    
    if ([cell.statusStr intValue] == DOWNLOAD_STATUS_RUN) {
        //运行状态-->暂停
        
        [[BppDistriPlistManager getManager] stopPlistURL:cell.idenStr];
        [cell setCellStatus:DOWNLOAD_STATUS_STOP];

    }else if ([cell.statusStr intValue] == DOWNLOAD_STATUS_STOP ||
              [cell.statusStr intValue] == DOWNLOAD_STATUS_ERROR){
        
        //        NSDictionary * itemInfo = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByAttriName:DISTRI_PLIST_URL value:cell.idenStr];
        //        NSNumber * bFreeFlow = [itemInfo objectForKey:DISTRI_FREE_FLOW];
        //        if( ![bFreeFlow boolValue] ) {
        //非3G 免流，才可能弹出“禁止非WIFI下载”
        if ([[[FileUtil instance] GetCurrntNet] isEqualToString:@"3g"] && [[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES) {
            
            //当前操作按钮
            currentCell = cell;
            
            UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:nil message:ON_WIFI_DOWN_TIP delegate:self cancelButtonTitle:@"流量够用" otherButtonTitles:@"取消下载", nil];
            netAlert.tag = NO_WIFI_DOWN_TAG;
            [netAlert show];
            
            return ;
        }
        //        }
        
        //暂停,错误-->开始
        [[BppDistriPlistManager getManager] startPlistURL:cell.idenStr];
        [cell setCellStatus:DOWNLOAD_STATUS_RUN];
        
    }else if ([cell.statusStr intValue] == DOWNLOAD_STATUS_WAIT){
        //等待-->暂停
        [[BppDistriPlistManager getManager] stopPlistURL:cell.idenStr];
        [cell setCellStatus: DOWNLOAD_STATUS_STOP];
    }
    
    //用于更新全部开始或暂停状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
        [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(downingCellTimerMethods:) userInfo:cell repeats:NO];
}

-(void)deleteDownloadingCell:(DownLoadingTableViewCell *)cell
{
//    deletecell = cell;
    [cell downLoadingProgress:0.0 animated:NO];
    [saveSpeedDic removeObjectForKey:cell.idenStr];
    [[BppDistriPlistManager getManager] removePlistURL:cell.idenStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //removeAppDownloading
    

    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBUTTONSTATETODOWN object:cell.downingAppid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADCOUNT object:nil];
    
    if ([[BppDistriPlistManager getManager] countOfDownloadingItem] == 0) {
        if (self.tableView.hidden == NO) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
                [self.delegate downloadingTableViewChanged:downLoadingType_showEmpty];
            }
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
            [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
        }
    }
}

- (void)downingCellTimerMethods:(NSTimer *)timer{ // 防止频繁点击
    DownLoadingTableViewCell *cell = nil;
    cell = timer.userInfo;
    cell.cellEnable = YES;
}

- (void)setupLocalNotifications:(NSString *)appName {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:1];
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ 已经下载完成",appName];//@"Time to get up!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"downing", @"downing", @"downed", @"downed", nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - NSNotification methods
- (void)deleteDowningBecauseUpdata:(NSNotification *)note{
    
    NSMutableDictionary *noteDic = note.object;
    
    NSString * appID = [noteDic objectForKey:DISTRI_APP_ID];
    NSString * distriPlistURL = [noteDic objectForKey:DISTRI_PLIST_URL];
    
    NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_APP_ID
                                                                           value:appID];
    NSString *plist = [dic objectForKey:DISTRI_PLIST_URL];
    
    
    for (DownLoadingTableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.idenStr isEqualToString:distriPlistURL]) {
            [cell downLoadingProgress:0.0 animated:NO];
            [saveSpeedDic removeObjectForKey:cell.idenStr];
        }
    }
    
    
    
    //删除数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BppDistriPlistManager getManager] removePlistURL:plist];
        sleep(1.0);
        [browserAppDelegate addDistriPlistURL:distriPlistURL appInfo:noteDic];
        sleep(1.0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    if ([[BppDistriPlistManager getManager] countOfDownloadingItem] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
            [self.delegate downloadingTableViewChanged:downLoadingType_showEmpty];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
            [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
        }
    }
}

- (void)StartDowningForUpdata:(NSNotification *)note{
    NSString *plistUrl = note.object;
    
    @synchronized(self) {
        
        NSInteger count = [[BppDistriPlistManager getManager] countOfDownloadingItem];
        
        for (NSInteger i =0; i<count ; i++) {
            
            NSDictionary *dic = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
            if ([[dic objectForKey:DISTRI_PLIST_URL ] isEqualToString:plistUrl]) {
                
                NSInteger status = [[dic objectForKey:DISTRI_APP_DOWNLOAD_STATUS] intValue];
                if ( status == DOWNLOAD_STATUS_STOP || status == DOWNLOAD_STATUS_ERROR){
                    
                    [[BppDistriPlistManager getManager] startPlistURL:plistUrl];
                    [self.tableView reloadData];
                }
            }
        }
    }
    
}
- (void)deleteDowningBecauseFail:(NSNotification *)noti{
    
    
    NSString * appID = noti.object;
    if (!appID) {
        return;
    }
    
    NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_APP_ID
                                                                           value:appID];
    NSString *plist = [dic objectForKey:DISTRI_PLIST_URL];
    
    if (!plist) {
        return;
    }
    //删除数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"plist = %@",plist);
        sleep(1);
        [[BppDistriPlistManager getManager] removePlistURL:plist];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_APP_DOWNLOADING object:nil];
            
            if (![[BppDistriPlistManager getManager] countOfDownloadingItem]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
                    [self.delegate downloadingTableViewChanged:downLoadingType_showEmpty];
                }
            }else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
                    [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
                }
            }
        });
    });
    

}
- (void)passUpdataDic:(NSNotification *)note{
    updataDict = note.object;
}

- (void)passUpdataToDowning:(NSNotification *)note{
    NSArray * array = note.object;
    if (array.count) {
        for (NSString * str in array) {
            [PauseCells addObject:str];
        }
    }
}
#pragma mark - 非wifi下载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == NO_WIFI_DOWN_TAG&&buttonIndex == 0) {
        
        //***参考onStartOrPause:方法内代码改写
        
        if (currentCell) {
            //暂停,错误-->开始
            [[BppDistriPlistManager getManager] startPlistURL:currentCell.idenStr];
            [currentCell setCellStatus:DOWNLOAD_STATUS_RUN];
            //用于更新全部开始或暂停状态
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadingTableViewChanged:)]) {
                [self.delegate downloadingTableViewChanged:downLoadingType_refresh];
            }
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(downingCellTimerMethods:) userInfo:currentCell repeats:NO];
            
            currentCell = nil;
        }
        

    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BppDistriPlistManager getManager] addListener:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteDowningBecauseUpdata:)
												 name:DELETE_DOWNLAODING_BECAUSE_UPDATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StartDowningForUpdata:)
												 name:START_DOWNLOADING_FOR_UPDATE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passUpdataToDowning:)
                                                 name:PASS_UPDATE_TO_DOWNLOADING
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passUpdataDic:)
                                                 name:@"passUpdataDic"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteDowningBecauseFail:)
                                                 name:DELETE_APP_BECAUSE_DOWNLOAD_FAIL
                                               object:nil];
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
