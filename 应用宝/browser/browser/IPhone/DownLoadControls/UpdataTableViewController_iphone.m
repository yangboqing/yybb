//
//  UpdataTableViewController_iphone.m
//  browser
//
//  Created by 王 毅 on 13-4-2.
//
//

#import "UpdataTableViewController_iphone.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "GetDevIPAddress.h"
#import "BppDownloadToLocal.h"
#import "IphoneAppDelegate.h"
#import <objc/runtime.h>






@interface UpdataTableViewController_iphone (){
    NSMutableArray *savePauseCells;
    NSMutableDictionary *updataDict;
    
    BOOL isSingleTap; // 解决 点击"全部更新"时，列表中已下载软件 弹框提示安装的问题(判断按钮按钮)
    BOOL isAllUpdateClick; //解决 点击“全部更新”，页面跳转的问题(判断全部更新按钮)
}

@end

#define search_update_color [UIColor colorWithRed:34.0/255.0 green:192.0/255.0 blue:150.0/255.0 alpha:1]

#define search_install_color [UIColor colorWithRed:239.0/255.0 green:57.0/255.0 blue:50.0/255.0 alpha:1]

#define search_downloading_color [UIColor colorWithRed:226.0/255.0 green:149.0/255.0 blue:145.0/255.0 alpha:1]

#define updating_iphone_color [UIColor colorWithRed:226.0/255.0 green:149.0/255.0 blue:145.0/255.0 alpha:1]//（没图）

@implementation UpdataTableViewController_iphone
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = WHITE_BACKGROUND_COLOR;
        
        
        self.tableView.rowHeight = 68.5;
        
        
        savePauseCells = [[NSMutableArray alloc] init];
        updataDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    [[BppDistriPlistManager getManager] addListener:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataAfterScreen:)
                                                 name:RELOAD_UPDATA_AFTER_SCREEN
                                               object:nil];
    //注册KVO
    [[BppDistriPlistManager getManager] addObserver:self forKeyPath:@"updateItems" options:NSKeyValueObservingOptionNew context:nil];
    
    // 设定全部更新按钮状态
    [self isAllDownloading];
    isSingleTap = NO;
    
}

#define ID @"appId"
#define Version @"appVersion"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    @synchronized(self){
        
        NSMutableArray * dataArray = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (dataArray == nil) {
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            if (indexSet != nil) {
                NSUInteger indexCount = [indexSet count];
                NSUInteger buffer[indexCount];
                /*这个方法，得到Fills up to bufferSize indexes
                 一个数组，然后返回这个数组的起始位置，
                 eturns the number of indexes actually placed in the buffer;
                 把buffer计算出来，这里是无符号整型的数组，
                 这里面存放的就是需要reload的cell的范围，比如从30--40号cell要改变，这个数组中就是存放的30--40的整型数字，
                 */
                [indexSet getIndexes:buffer maxCount:indexCount inIndexRange:nil];
                
                NSMutableArray * indexPathArray = [NSMutableArray array];
                for (int i = 0; i < indexCount; i++)
                {
                    /*
                     把这些序号，存放到一数组中
                     */
                    NSUInteger indexPathIndices[2];
                    indexPathIndices[0] = 0;
                    indexPathIndices[1] = buffer[i];
                    NSIndexPath *newPath = [NSIndexPath indexPathWithIndexes:indexPathIndices length:2];
                    [indexPathArray addObject:newPath];
                }
                
                NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
                
                if ([kind integerValue] == NSKeyValueChangeRemoval)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        [self.tableView reloadData];
                    });
                    
                    
                }
                //获取通知检查更新列表数量
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_UPDATE_COUNT  object:nil];
                
                if ([[UpdateAppManager getManager] ItemCount] == 0) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(passBadgeCount_over)]) {
                        [self.delegate passBadgeCount_over];
                    }
                }
                
            }
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[UpdateAppManager getManager] ItemCount];
}

- (void)updataAfterScreen:(NSNotification *)note{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
-(void)isAllDownloading
{ // 设置全部更新的按钮的状态
    BOOL isEnable = NO;
    
    for (NSInteger i=0; i<[[UpdateAppManager getManager] ItemCount]; i++){

        NSDictionary *updateItemDic = [[UpdateAppManager getManager] getItemByIndex:i];
        NSDictionary *dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL
                                        value:[updateItemDic objectForKey:UPDATE_APP_DISTRI_PLIST]];
        if(!dic){
            isEnable = YES;
            break;
        }
    }
    
    [self setAllUpdateButtonEnable:isEnable];
}
-(void)setAllUpdateButtonEnable:(BOOL)isEnable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isAllUpdateButtonEnable:)]) {
        [self.delegate isAllUpdateButtonEnable:isEnable];
    }
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
    return [[UpdateAppManager getManager] ItemCount];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UpdataCell";
    
    UpdataTableViewCell_iphone *cell = (UpdataTableViewCell_iphone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UpdataTableViewCell_iphone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.upDataBtn addTarget:self action:@selector(installUpdataClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    NSDictionary * dicCellItem = [[UpdateAppManager getManager] getItemByIndex:indexPath.row];
    cell.idenStr = [dicCellItem objectForKey:UPDATE_APP_DISTRI_PLIST];
    cell.updataAppid = [dicCellItem objectForKey:UPDATE_APP_ID];
    cell.updataAppVersion = [dicCellItem objectForKey:UPDATE_APP_VERSION];
    NSString * urlString = [dicCellItem objectForKey:UPDATE_ICON_URL];
    
    NSURL * url = [NSURL URLWithString:urlString];
    cell.iconImageUrl = urlString;
    [(UIImageView *)cell.iconImageView ky_setImageWithURL:url];

    [cell upDataCellName:[dicCellItem objectForKey:UPDATE_APP_NAME]];
    [cell upDataCellVersion:[dicCellItem objectForKey:UPDATE_APP_VERSION]
                     volume:[[dicCellItem objectForKey:UPDATE_APP_SIZE] intValue]];
    
    // 下载中active_iphone
    NSDictionary * _dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:cell.idenStr];
    if (_dic != nil) {
        if ([[_dic objectForKey:DISTRI_APP_DOWNLOAD_STATUS] intValue] == 3) {
            [cell.upDataBtn setImage:LOADIMAGE(@"search_install", @"png") forState:UIControlStateNormal];
            [cell.upDataBtn setTitle:@"安装" forState:UIControlStateNormal];
            [cell.upDataBtn setTitleColor:search_install_color forState:UIControlStateNormal];
        }
        else
        {
            [cell.upDataBtn setImage:LOADIMAGE(@"search_downloading", @"png") forState:UIControlStateNormal];
            [cell.upDataBtn setTitle:@"下载中" forState:UIControlStateNormal];
            [cell.upDataBtn setTitleColor:search_downloading_color forState:UIControlStateNormal];
        }
    }
    else
    {
        [cell.upDataBtn setImage:LOADIMAGE(@"search_update", @"png") forState:UIControlStateNormal];
        [cell.upDataBtn setTitle:@"更新" forState:UIControlStateNormal];
        [cell.upDataBtn setTitleColor:search_update_color forState:UIControlStateNormal];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"忽略";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //ios6有时会触发本方法?
    //    if (IOS7) {
    //        UpdataTableViewCell_iphone *cell = (UpdataTableViewCell_iphone *)[tableView cellForRowAtIndexPath:indexPath];
    //        cell.upDataBtn.hidden = YES;
    //    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UpdataTableViewCell_iphone *cell = (UpdataTableViewCell_iphone *)[tableView cellForRowAtIndexPath:indexPath];
    //    cell.upDataBtn.hidden = NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}

- (void)installUpdataClick:(UIButton *)sender{
    
    isAllUpdateClick = NO;
    UpdataTableViewCell_iphone *cell = (__bridge UpdataTableViewCell_iphone *)(void*)sender.tag;
    
    NSString *netStr = [[FileUtil instance] GetCurrntNet];
    
    NSDictionary * dic = [[UpdateAppManager getManager] getItemByPlist:cell.idenStr];
    NSString *appid = [dic objectForKey:UPDATE_APP_ID];
    NSString *appName = [dic objectForKey:UPDATE_APP_NAME];
    NSString *appVer = [dic objectForKey:UPDATE_APP_VERSION];
    
    
    if (![[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL])
    {
        if ([netStr isEqualToString:@"wifi"])
        {
            [[BppDownloadToLocal getObject] downLoadPlistFile:cell.idenStr];
            
        }
        else if ([netStr isEqualToString:@"3g"])
        {
            if ([[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES)
            {
                
                UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:@"快用"
                                                                    message:ON_WIFI_DOWN_TIP
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"知道了",nil];
                [netAlert show];
            }
            else
            {
                [[BppDownloadToLocal getObject] downLoadPlistFile:cell.idenStr];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[GetDevIPAddress getObject] reportUpdataAppID:appid AppName:appName AppVersion:appVer];
                    
                });
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        if ([netStr isEqualToString:@"3g"]){
            
            if ([[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES) {

                UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:@"快用" message:ON_WIFI_DOWN_TIP delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [netAlert show];
            }
            else
            {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(delayAfterClickUpdataBtnWithAppName:)]) {
                    
                    [cell.upDataBtn setImage:LOADIMAGE(@"search_downloading", @"png") forState:UIControlStateNormal];
                    [cell.upDataBtn setTitle:@"下载中" forState:UIControlStateNormal];
                    [cell.upDataBtn setTitleColor:search_downloading_color forState:UIControlStateNormal];
                    
                    [self.delegate delayAfterClickUpdataBtnWithAppName:cell.nameLabel.text];
                    [self performSelectorOnMainThread:@selector(addToDowning:) withObject:cell waitUntilDone:NO];
                }
            }
        }else if ([netStr isEqualToString:@"wifi"]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(delayAfterClickUpdataBtnWithAppName:)]) {
                
                //[self.delegate delayAfterClickUpdataBtnWithAppName:cell.nameLabel.text];
                
                [self performSelectorOnMainThread:@selector(addToDowning:) withObject:cell waitUntilDone:NO];

            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)addToDowning:(id)cell{
    UpdataTableViewCell_iphone *_cell  = (UpdataTableViewCell_iphone *)cell;
    NSDictionary * _dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:_cell.idenStr];
    if (_dic != nil && [[_dic objectForKey:DISTRI_APP_DOWNLOAD_STATUS] intValue] == DOWNLOAD_STATUS_SUCCESS) {
        [_cell.upDataBtn setImage:LOADIMAGE(@"search_install", @"png") forState:UIControlStateNormal];
        [_cell.upDataBtn setTitle:@"安装" forState:UIControlStateNormal];
        [_cell.upDataBtn setTitleColor:search_install_color forState:UIControlStateNormal];
        isSingleTap = YES; // 单独点击安装按钮
    }
    else{
        [_cell.upDataBtn setImage:LOADIMAGE(@"search_downloading", @"png") forState:UIControlStateNormal];
        [_cell.upDataBtn setTitle:@"下载中" forState:UIControlStateNormal];
        [_cell.upDataBtn setTitleColor:search_downloading_color forState:UIControlStateNormal];
    }
    
    if (!_dic) {
        NSIndexPath *tmpIndex = [self.tableView indexPathForCell:cell];
        _dic = [NSDictionary dictionaryWithObjectsAndKeys:
                _cell.updataAppid,DISTRI_APP_ID,
                _cell.nameLabel.text,DISTRI_APP_NAME,
                _cell.updataAppVersion,DISTRI_APP_VERSION,
                _cell.iconImageUrl,DISTRI_APP_IMAGE_URL,
                APP_UPDATE(_cell.updataAppid, tmpIndex.row), @"dlfrom",
                nil];
    }
    
    
    if ([[[FileUtil instance] GetCurrntNet] isEqualToString:@"wifi"]) {
        [self addUrlToDownload:_cell.idenStr infoDic:_dic];
    }else{
        [self addUrlToDownload:_cell.idenStr infoDic:_dic];
    }
    //获取通知检查更新列表数量
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_UPDATE_COUNT  object:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSDictionary *dic = objc_getAssociatedObject(alertView, "info");
    objc_setAssociatedObject(alertView, "info", nil, OBJC_ASSOCIATION_RETAIN);
    
    NSInteger tag = [[dic objectForKey:@"tag"] intValue];
    if(tag == 444) {
        if(buttonIndex == 0) {
            NSString * distriPlist = [dic objectForKey:@"userdata"];
            [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
        }
    }
}

- (void)updataAllByOpenURL{
    
    for (int i=0; i < [[UpdateAppManager getManager] ItemCount]; i++){
        
        NSDictionary * item = [[UpdateAppManager getManager] getItemByIndex:i];
        
        //发布plist
        NSString *distriPlist = [item objectForKey: UPDATE_APP_DISTRI_PLIST];
        
        [[BppDownloadToLocal getObject] downLoadPlistFile:distriPlist];
        
        [updataDict setObject:distriPlist forKey:distriPlist];
    }
    
    //获取通知检查更新列表数量
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_UPDATE_COUNT  object:nil];
}

- (void)updataAll{
    
    /*
     appIconUrl = "http://pic.wanmeiyueyu.com/Data/APPINFOR/16/78/com.sina.weibo/BigIcon_1402502400.jpg";
     appId = "com.sina.weibo";
     appName = "\U5fae\U535a";
     appSize = 34770836;
     appVersion = "4.4.0";
     plist = "itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/16/78/com.sina.weibo/dizigui_zhouyi_com.sina.weibo_1402502400_4.4.0_s.plist?dlfrom=iphonebrowser-update_4";
     */
    
    isSingleTap = NO;
    isAllUpdateClick = YES;
    
    for (int i=0; i<[[UpdateAppManager getManager] ItemCount]; i++) {
        NSDictionary * dic = [[UpdateAppManager getManager] getItemByIndex:i];

        NSString * distriPlistURL = [dic objectForKey:UPDATE_APP_DISTRI_PLIST];
        
        NSDictionary *tmpinfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:UPDATE_APP_ID],     DISTRI_APP_ID,
                                    [dic objectForKey:UPDATE_APP_VERSION],  DISTRI_APP_VERSION,
                                    [dic objectForKey:UPDATE_APP_NAME],     DISTRI_APP_NAME,
                                    APP_UPDATE([dic objectForKey:UPDATE_APP_ID], 0), DISTRI_APP_FROM,
                                    [dic objectForKey:UPDATE_ICON_URL],  DISTRI_APP_IMAGE_URL,
                                    distriPlistURL,  DISTRI_PLIST_URL, nil];
        //添加到下载中
        [self addUrlToDownload:distriPlistURL infoDic:tmpinfoDic];
        
        [updataDict setObject:distriPlistURL forKey:distriPlistURL];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allUpdataNotifi"  object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passUpdataDic"  object:updataDict];
    //获取通知检查更新列表数量
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_UPDATE_COUNT  object:nil];
    
    [self setAllUpdateButtonEnable:NO];
}

- (void)addUrlToDownload:(NSString *)distriPlistURL infoDic:(NSDictionary*)infoDic{
    
    NSDictionary * _dic = [[UpdateAppManager getManager] getItemByPlist:distriPlistURL];
    NSString *appID = [_dic objectForKey:@"appId"];
    NSString *appName = [_dic objectForKey:@"appName"];
    NSString *appVer = [_dic objectForKey:@"appVersion"];
    
    NSString *PlistUrl = nil;
    
    DOWNLOAD_STATUS status = [[BppDistriPlistManager getManager]getPlistURLStatus:distriPlistURL];
    
    if (status == STATUS_ALREADY_IN_DOWNLOADING_LIST) {
        
        for (int i = 0; i < [[BppDistriPlistManager getManager] countOfDownloadingItem]; i ++) {
            
            NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
            
            if ([appID isEqualToString:[dic objectForKey:DISTRI_APP_ID]]) {
                if ([[FileUtil instance] hasNewVersion:appID oldVersion:[dic objectForKey:DISTRI_APP_ID]] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_DOWNLAODING_BECAUSE_UPDATE  object:dic];
                    [[GetDevIPAddress getObject] reportUpdataAppID:appID AppName:appName AppVersion:appVer];
                }else{
                    PlistUrl = [dic objectForKey:DISTRI_PLIST_URL];
                    
                    NSString * netType = [[FileUtil instance] GetCurrntNet];
                    if ([netType isEqualToString:@"wifi"]) {
                    
                        [[NSNotificationCenter defaultCenter] postNotificationName:START_DOWNLOADING_FOR_UPDATE  object:PlistUrl];

                    }else if ([netType isEqualToString:@"3g"] && [[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == NO){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:START_DOWNLOADING_FOR_UPDATE  object:PlistUrl];
                    }

                    if (!isAllUpdateClick) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ALREADY_JOIN_DOWNING_LIST  object:PlistUrl];
                    }
                }
                
            }
            
        }
        
    }else if (status == STATUS_ALREADY_IN_DOWNLOADED_LIST){
        for (NSMutableDictionary *dic in [BppDistriPlistManager getManager].distriAlReadyDownloadedPlists) {
            if ([[dic objectForKey:DISTRI_APP_ID] isEqualToString:appID]) {
                if ([[FileUtil instance] hasNewVersion:appVer oldVersion:[dic objectForKey:DISTRI_APP_VERSION]] == NO) {
                    
                    if (isSingleTap) {
                        
                        NSString * distriPlist = distriPlistURL;
                        
                        if( [[BppDistriPlistManager getManager] getIPASize:distriPlist]/1024/1024 > 50 //大于50M
                           && ![[[FileUtil instance] GetCurrntNet] isEqualToString:@"wifi"] //非WIFI
                           && [[UIDevice currentDevice].systemVersion integerValue] < 8) { //小于IOS8
                            
                            UIAlertView *netAlert = [[UIAlertView alloc]initWithTitle:nil
                                                                              message:NO_WIFI_50M_CANNOT_INSTALL_TIP
                                                                             delegate:self
                                                                    cancelButtonTitle:nil
                                                                    otherButtonTitles:@"是",
                                                     @"否", nil];
                            netAlert.delegate = self;
                            NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:444], @"tag",  distriPlist, @"userdata", nil];
                            objc_setAssociatedObject(netAlert, "info", info, OBJC_ASSOCIATION_RETAIN);
                            [netAlert show];
                            
                        }else{
                            [[BppDistriPlistManager getManager] installPlistURL:distriPlist];
                        }
                        
                    }
                    isSingleTap = NO;
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_DOWNLOAD_BECAUSE_UPDATE  object:appID];
                    [self addToPauseArray:distriPlistURL infoDic:infoDic];

                    [browserAppDelegate addDistriPlistURL:distriPlistURL appInfo:infoDic];
                    [[GetDevIPAddress getObject] reportUpdataAppID:appID AppName:appName AppVersion:appVer];
                    [[NSNotificationCenter defaultCenter] postNotificationName:PASS_UPDATE_TO_DOWNLOADING  object:savePauseCells];
                }
                break;
            }
            
        }

        
    }else if (status == STATUS_NONE){
        [browserAppDelegate addDistriPlistURL:distriPlistURL appInfo:infoDic];
        [[GetDevIPAddress getObject] reportUpdataAppID:appID AppName:appName AppVersion:appVer];
        

    }
        
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADINGTABLEVIEW  object:nil];
}

- (void)addToPauseArray:(NSString *)PlistUrl infoDic:(NSDictionary*)infoDic{

    if ([[[FileUtil instance] GetCurrntNet] isEqualToString:@"3g"]
        && [[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES)
    {
        [savePauseCells addObject:PlistUrl];
    }
}

- (BOOL)isHaveDownload:(UpdataTableViewCell_iphone *)cell{
    @synchronized(self) {
        
        for (NSMutableDictionary *dic in [BppDistriPlistManager getManager].distriAlReadyDownloadedPlists) {
            
            if ([cell.updataAppid isEqualToString:[dic objectForKey:@"updataAppId"]]) {
                if ([[FileUtil instance] hasNewVersion:cell.updataAppid oldVersion:[dic objectForKey:@"updataVersion"]] == NO) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}

#pragma mark - listener回调方法
//用来判断新添加到下载列表的app是否在更新列表中,如在则变更按钮为下载中
- (void) onDidPlistMgrAddDownloadItem:(NSString*)distriPlist{
    [self.tableView reloadData];
    [self isAllDownloading];
    
}

- (void)dealloc{
    [[BppDistriPlistManager getManager] removeListener:self];
    //移除KVO
    [[BppDistriPlistManager getManager] removeObserver:self forKeyPath:@"updateItems"];
}

@end
