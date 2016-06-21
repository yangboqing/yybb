//
//  DownLoadManageViewController.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

typedef enum { // bottomEditView
    editView_show = 0,
    editView_hide,
    
    // 全选按钮
    editView_checkAll,
    editView_unCheckAll
}EditView_Type;

typedef enum {
    topClick_Downloading = 100,
    topClick_Downloaded,
    topClick_Update,
    topClick_None
}Top_ClickType;

#import "DownLoadManageViewController.h"
#import "UIImageEx.h"
#import "Reachability.h"
#import "BppDistriPlistManager.h"
#import "Reachability.h"
#import "SettingPlistConfig.h"
#import "ShowStorageView.h"
#import "AppStatusManage.h"
#import "MyNavigationController.h"
#define THEFONTCOLOR [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]
#define THEFONTSIZE 15.0f
#define CUTSIZEHEIGHT 65/2

@interface DownLoadManageViewController (){
    
    NSMutableArray * dataArray;//记录当前现在中的应用url
    Top_ClickType currentClick; // 记录当前显示的manageTopButton
    
    UIImageView *emptyCellBGImageView_ing;
    UIImageView *downingImageView;
    
    UIImageView *emptyCellBGImageView_over;
    UIImageView *downedImageView;
    
    Reachability  *hostReach;//监听网络变化
    dispatch_source_t timer;// 计时器
    
    ShowStorageView *showSpaceVeiw;//内存使用量弹出视图
    
    UIView *bottomEditView;//全选反选删除页面
    UIImageView *topEditLineView;
    UIButton *checkAllBtn;
    UIImageView *verticalEditLine;
    UIButton *deleteBtn;
    
    UILabel *messageLabel;//没有任务时提示语
    UILabel *loadedmessageLabel;
}

@end

@implementation DownLoadManageViewController

- (id)init
{
    self = [super init];
    if (self) {
        dataArray = [[NSMutableArray alloc] init];
        
        // 下载中列表
        _downLoadingTableViewController = [[DownLoadingTableViewController alloc]initWithStyle:UITableViewStylePlain];
        _downLoadingTableViewController.view.hidden = NO;
        _downLoadingTableViewController.delegate = self;
        [self.view addSubview:_downLoadingTableViewController.view];
        
        // 下载中无数据时显示UI
        emptyCellBGImageView_ing = [[UIImageView alloc]init];
        emptyCellBGImageView_ing.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        emptyCellBGImageView_ing.hidden = YES;
        [self.view addSubview:emptyCellBGImageView_ing];
        
        downingImageView = [[UIImageView alloc]init];
        SET_IMAGE(downingImageView.image, @"downdePageNotData.png")
        [emptyCellBGImageView_ing addSubview:downingImageView];
        
        messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = THEFONTCOLOR;
        messageLabel.font = [UIFont systemFontOfSize:THEFONTSIZE];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"当前没有下载任务";
        [downingImageView addSubview:messageLabel];
        
        // 已下载列表
        _downOverTableViewController = [[DownOverTableViewController alloc]initWithStyle:UITableViewStylePlain];
        _downOverTableViewController.view.hidden = YES;
        _downOverTableViewController.delegate = self;
        [self.view addSubview:_downOverTableViewController.view];
        
        // 已下载无数据时显示UI
        emptyCellBGImageView_over = [[UIImageView alloc]init];
        emptyCellBGImageView_over.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        emptyCellBGImageView_over.hidden = YES;
        [self.view addSubview:emptyCellBGImageView_over];
        
        downedImageView = [[UIImageView alloc]init];
        SET_IMAGE(downedImageView.image, @"downdePageNotData.png");
        [emptyCellBGImageView_over addSubview:downedImageView];
        
        loadedmessageLabel = [[UILabel alloc] init];
        loadedmessageLabel.backgroundColor = [UIColor clearColor];
        loadedmessageLabel.textColor = THEFONTCOLOR;
        loadedmessageLabel.font = [UIFont systemFontOfSize:THEFONTSIZE];
        loadedmessageLabel.textAlignment = NSTextAlignmentCenter;
        loadedmessageLabel.numberOfLines = 0;
        
        loadedmessageLabel.text = @"当前没有可安装应用请您先下载应用";
        [downedImageView addSubview:loadedmessageLabel];
        
        
        // 顶部导航
        topView = [[DownLoadManageTopView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_Width, 44)];
        topView.topViewDelegate = self;
//        self.navigationItem.titleView = topView;
        
        // 导航栏底部提示UI
        _headImageView = [[HeadImageView alloc]init];
        [self.view addSubview:_headImageView];
        
        [_headImageView.allStartPauseBtn addTarget:self action:@selector(allStartPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _headImageView.allStartPauseBtn.tag = 2;
        [_headImageView changeButtonTitleWithType:allStart_Type];
        
        _headImageView.allUpdatBtn.tag = 3;
        [_headImageView.allUpdatBtn addTarget:self action:@selector(allUpdataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _headImageView.editBtn.tag = 1;
        [_headImageView.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headImageView changeButtonTitleWithType:edit_Type];
        
        // 底部弹出UI
        bottomEditView = [[UIView alloc] init];
        bottomEditView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:249.0/255.0 blue:247.0/255.0 alpha:1];
        
        topEditLineView = [[UIImageView alloc] init];
        topEditLineView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        
        checkAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkAllBtn.backgroundColor = [UIColor clearColor];
        [self changeCheckAllButtonTitle:editView_checkAll];
        checkAllBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        checkAllBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [checkAllBtn setTitleColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1] forState:UIControlStateNormal];
        [checkAllBtn addTarget:self action:@selector(checkAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        verticalEditLine = [[UIImageView alloc] init];
        verticalEditLine.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [deleteBtn setTitleColor:[UIColor colorWithRed:230.0/255.0 green:113.0/255.0 blue:106.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomEditView addSubview:topEditLineView];
        [bottomEditView addSubview:checkAllBtn];
        [bottomEditView addSubview:verticalEditLine];
        [bottomEditView addSubview:deleteBtn];
        [self.view addSubview:bottomEditView];
        
        // 显示可用空间UI
        showSpaceVeiw = [[ShowStorageView alloc] init];
        showSpaceVeiw.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
        [self.view addSubview:showSpaceVeiw];
        
        //
        if ([[[FileUtil instance] GetCurrntNet] isEqualToString:@"3g"])
        {
            [self downloadStatus];//获取当前正在下载的列表
        }
        
        //添加网络变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [hostReach startNotifier];
    }
    
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;//初始化当前选中为正在下载列表
    return self;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //新春版
//    if(IOS7){
//        [self.navigationController.navigationBar setBarTintColor:NEWYEAR_RED];
//    }
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    MyNavigationController *nav = (MyNavigationController *)self.navigationController;
    [nav cancelSlidingGesture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MyNavigationController *nav = (MyNavigationController *)self.navigationController;
    [nav addSlidingGesture];
}
- (void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickLookInfoBtn:)
												 name:@"clickLookInfoBtn"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDownloadingTableView:)
												 name:RELOADDOWNLOADINGTABLEVIEW
                                               object:nil];
    //当已下载表视图删除应用时调用,更新topView显示的应用数量
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadAllDownloadView)
                                                name:UPDATE_DOWNLOAD_TOPVIEW_COUNT
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCheckEditButtonTitle)
                                                 name:CHANGE_CHECKEDITVIEW
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disableUpdataBtn:)
                                                 name:IS_DISABLE_UPDATE_BUTTON
                                               object:nil];
    
    //用于更新剩余空间
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateStorageView)
                                                name:RELOADDOWNLOADCOUNT
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateStorageView)
                                                name:APPLICATIONS_CHANGED_NOTIFICATION
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateStorageView)
                                                name:CHANGEBUTTONSTATETODOWN
                                              object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - DownManageTopViewDelegate
- (void)downloadManageTopButtonClick:(NSString*)pageName{
    
    if (([pageName isEqualToString:@"downing"] && currentClick==topClick_Downloading) || ([pageName isEqualToString:@"downed"] && currentClick==topClick_Downloaded) || ([pageName isEqualToString:@"update"] && currentClick==topClick_Update)) {
        return;
    }
    
    // 设置 TableView
    [_downLoadingTableViewController setTableViewEdit:NO];
    [_downOverTableViewController setTableViewEdit:NO];
    
    // 设置 HeadImageView、BottomEditView
    [_headImageView changeButtonTitleWithType:edit_Type];
    [self showBottomEditView:editView_hide];
    
    // 显示响应页面
    if ([pageName isEqualToString:@"downing"]){
        currentClick = topClick_Downloading;
        [self showDownloadingView];
    }
    else if ([pageName isEqualToString:@"downed"]){
        currentClick = topClick_Downloaded;
        [self showDownOverView];
    }
    else if ([pageName isEqualToString:@"update"]){
        currentClick = topClick_Update;
        [self showUpdateView];
    }
    
    
    //My newAdd
//    //解决下载中已下载列表不显示的问题
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //更新发现、已下载、界面按钮状态
//        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MOBILE_APP_LIST object:nil];
//    });
    [self downloadingTableViewChanged:downLoadingType_refresh];
    [self downOverTableViewChanged:downOverType_refresh];

    
}

#pragma mark - DownLoadingTableViewDelegate

-(void)downloadingTableViewChanged:(DownLoading_Type)type
{


    switch (type) {
        case downLoadingType_showEmpty:{
            emptyCellBGImageView_ing.hidden = NO;
            _downLoadingTableViewController.tableView.hidden = YES;
            
            // 刷新 ManageTopView
            [topView refreshManageTopButton];
            
            // 设置 HeadImageView
            [_headImageView changeButtonTitleWithType:allStart_Type];
            [_headImageView changeButtonTitleWithType:edit_Type];
            _headImageView.allStartPauseBtn.enabled = NO;
            _headImageView.editBtn.enabled = NO;
            
            // 设置 BottomEditView
            [self showBottomEditView:editView_hide];
            
        }
            break;
        case downLoadingType_refresh:{
            if ([[BppDistriPlistManager getManager] countOfDownloadingItem] > 0) {
                emptyCellBGImageView_ing.hidden = YES;
                _downLoadingTableViewController.tableView.hidden = NO;
                _headImageView.editBtn.enabled = YES;
                _headImageView.allStartPauseBtn.enabled = YES;
            }else{
                emptyCellBGImageView_ing.hidden = NO;
                _downLoadingTableViewController.tableView.hidden = YES;
                _headImageView.editBtn.enabled = NO;
                _headImageView.allStartPauseBtn.enabled  = NO;
            }
            [_headImageView changeButtonTitleWithType:edit_Type];

            // 刷新 ManageTopView
            [topView refreshManageTopButton];
            
            // 设置 HeadImageView
            NSInteger itemsOfPause = [_downLoadingTableViewController numberOfPauseItems];
            if (itemsOfPause > 0) {
                [_headImageView changeButtonTitleWithType:allStart_Type];
            }
            else
            {
                [_headImageView changeButtonTitleWithType:allPause_Type];
            }
            
        }
            
            
            break;
            
        default:
            break;
    }
}

-(void)downloadingChangeTopButtonState:(TopButton_StateType)type
{
    
    if (_downLoadingTableViewController.tableView.hidden) {
        
        [topView refreshManageTopButton];
        return;
    }
    switch (type) {
        case topButtonType_AllEnable:{
            _headImageView.allStartPauseBtn.enabled = YES;
            _headImageView.editBtn.enabled = YES;
        }
            break;
        case topButtonType_AllDisable:{
            _headImageView.allStartPauseBtn.enabled = NO;
            _headImageView.editBtn.enabled = NO;
        }
            break;
        case TopButtonType_AllStart:{
            [_headImageView changeButtonTitleWithType:allStart_Type];
        }
            break;
        case TopButtonType_AllPause:{
            [_headImageView changeButtonTitleWithType:allPause_Type];
        }
            
        default:
            break;
    }
}

#pragma mark - DownOverTableViewDelegate

-(void)downOverTableViewChanged:(DownOver_Type)type
{
    if (currentClick != topClick_Downloaded) {
        
        return;
    }
    
    switch (type) {
        case downOverType_showEmpty:{
            emptyCellBGImageView_over.hidden = NO;
            _downOverTableViewController.tableView.hidden = YES;
            
            // 设置 ManageTopView
            [topView refreshManageTopButton];
            
            // 设置HeadImageView
            [_headImageView changeButtonTitleWithType:edit_Type];
            _headImageView.editBtn.enabled = NO;
            
            // 设置bottomEditView
            [self showBottomEditView:editView_hide];
        }
            break;
        case downOverType_refresh:{
            if ([[BppDistriPlistManager getManager] countOfDownloadedItem] > 0) {
                emptyCellBGImageView_over.hidden = YES;
                _downOverTableViewController.tableView.hidden = NO;
            }else{
                emptyCellBGImageView_over.hidden = NO;
                _downOverTableViewController.tableView.hidden = YES;
            }

            [_downOverTableViewController.tableView reloadData];
            
            // 设置manageTopView
            [topView refreshManageTopButton];
            
            // 设置 HeadImageView
            _headImageView.editBtn.enabled = YES;
            
        }
            break;
            
        default:
            break;
    }
}

-(void)downOverChangeTopButtonState:(TopEditButton_State)state
{
    switch (state) {
        case topEditButton_Enable:{
            _headImageView.editBtn.enabled = YES;
        }
            break;
            
        case topEditButton_Disable:{
            _headImageView.editBtn.enabled = NO;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 外露接口

- (void)showDownloadPage:(NSString *)pageName{
    currentClick = topClick_None;
    [topView touchTopButton:pageName];
    if ([pageName isEqualToString:@"update"]) {
        self.navigationItem.title = @"更新";
        UIButton *switchToDown = [UIButton buttonWithType:UIButtonTypeCustom];
        switchToDown.frame = CGRectMake(0, 0, 30, 30);
        [switchToDown setImage:[UIImage imageNamed:@"switchToDown@2x.png"] forState:UIControlStateNormal];
        [switchToDown addTarget:self action:@selector(switchToDown) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switchToDown];
    }else{
        self.navigationItem.titleView = topView;

    }
}

#pragma mark - Actions (5 methods)

- (void)switchToDown{
    DownLoadManageViewController *down = [[DownLoadManageViewController alloc] init];
    [down showDownloadPage:@"downing"];
    [self.navigationController pushViewController:down animated:YES];
}
- (void)allStartPauseBtnClick:(UIButton *)sender{
    
    if (_downLoadingTableViewController.editing) {
        return;
    }
    
    UIButton *tmpBtn = (UIButton *)sender;
    if (tmpBtn.tag == allPause_Type) {
        BOOL successFalg = [self allPauseClick];
        if (successFalg) { // 全部暂停执行成功，更改按钮文字
            [_headImageView changeButtonTitleWithType:allStart_Type];
        }
    }
    else
    {
        BOOL successFlag = [self allStartClick];
        if (successFlag) {
            [_headImageView changeButtonTitleWithType:allPause_Type];
        }
    }
    
    [self allStartPauseBtnDisableMoment];
}


- (void)editBtnClick:(UIButton *)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    if (tmpBtn.tag == edit_Type) {
        
        // 设置 downloading/downover Tableview为编辑模式
        BOOL editDone = NO;
        switch (currentClick) {
            case topClick_Downloading:{ // 下载中
                [_downLoadingTableViewController setTableViewEdit:YES];
                editDone = [_downLoadingTableViewController tableViewEditStyleDone];
            }
                break;
            case topClick_Downloaded:{ // 已下载
                [_downOverTableViewController setTableViewEdit:YES];
                editDone = [_downOverTableViewController tableViewEditStyleDone];
            }
                break;
                
            default:
                break;
        }
        
        // 改变按钮状态、显示BottomEditView
        if (editDone) {
            [_headImageView changeButtonTitleWithType:editCancel_Type];
            _headImageView.allStartPauseBtn.enabled = NO;
            [self showBottomEditView:editView_show];
        }
    }
    else
    {
        // 改变按钮状态、隐藏BottomEditView
        [_headImageView changeButtonTitleWithType:edit_Type];
        _headImageView.allStartPauseBtn.enabled = YES;
        [self showBottomEditView:editView_hide];
        
        // 设置downloading/downed TableView编辑模式
        switch (currentClick) {
            case topClick_Downloading:{
                [_downLoadingTableViewController setTableViewEdit:NO];
            }
                break;
            case topClick_Downloaded:{
                [_downOverTableViewController setTableViewEdit:NO];
            }
                break;
                
            default:
                break;
        }
        
        // 清理数据
        [_downLoadingTableViewController.selectToDeleteArray removeAllObjects];
        [_downOverTableViewController.selectToDeleteArray removeAllObjects];
    }
}

- (void)checkAllBtnClick:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    BOOL selectFlag;
    if ([tmpBtn.titleLabel.text isEqualToString:@"全选"]) {
        selectFlag = YES;
        [self changeCheckAllButtonTitle:editView_unCheckAll];
    }else{
        selectFlag = NO;
        [self changeCheckAllButtonTitle:editView_checkAll];
    }
    
    // 设置cell选中状态
    if (currentClick == topClick_Downloading) { // 正在下载
        [_downLoadingTableViewController selectAllCells:selectFlag];
    }
    else
    {
        [_downOverTableViewController selectAllCells:selectFlag];
    }
}

- (void)deleteBtnClick:(id)sender
{
    switch (currentClick) {
        case topClick_Downloading:{ // 删除下载中选中的cell
            if (_downLoadingTableViewController.selectToDeleteArray.count>0) {
                [self deleteCheckedDownloadingItems];
            }
        }
            break;
        case topClick_Downloaded:{
            if (_downOverTableViewController.selectToDeleteArray.count>0) {
                [_downOverTableViewController clickdeleteSelectedRows:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 全部开始/暂停Actions

- (BOOL)allStartClick{
    
    BOOL startFlag = YES;
    NSString *netStr = [[FileUtil instance] GetCurrntNet];
    
    if ([netStr isEqualToString:@"3g"]){
        
        if ( [[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL] ) {
            if ([[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES){
                
                startFlag = NO;
                UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:nil message:ON_WIFI_DOWN_TIP delegate:self cancelButtonTitle:@"流量够用" otherButtonTitles:@"取消下载", nil];
                netAlert.tag = NO_WIFI_DOWN_TAG;
                [netAlert show];
            }else{
                startFlag = YES;
                [_downLoadingTableViewController clickAllStartBtn];
            }
        }
        
    }else if ([netStr isEqualToString:@"wifi"]){
        startFlag = YES;
        [_downLoadingTableViewController clickAllStartBtn];
    }else{
        startFlag = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络异常，请检查网络"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"知道了"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return startFlag;
}

- (BOOL)allPauseClick{
    BOOL pauseFlag = YES;
    
    [_downLoadingTableViewController clickAllPauseBtn];
    
    return pauseFlag;
}

-(void)allStartPauseBtnDisableMoment
{
    _headImageView.allStartPauseBtn.enabled = NO;
    //
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC),0, 0);
    dispatch_source_set_event_handler(timer, ^{
        _headImageView.allStartPauseBtn.enabled = YES;
        dispatch_source_cancel(timer);
    });
    
    dispatch_resume(timer);
}

#pragma mark  - 全选/反选、删除

-(void)changeCheckAllButtonTitle:(EditView_Type)checkType
{
    switch (checkType) {
        case editView_checkAll:{
            [checkAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
            break;
        case editView_unCheckAll:{
            [checkAllBtn setTitle:@"反选" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteCheckedDownloadingItems{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否要删除选中应用" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
    alert.tag = 66;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 66) {
        if (buttonIndex == 0) {
            
            [_downLoadingTableViewController deleteSelectedRows];
            [self showDownloadingView];
            // 通知其他界面更改状态
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOADDOWNLOADCOUNT  object:nil];
        }
    }
    if (alertView.tag == NO_WIFI_DOWN_TAG) {
        if (buttonIndex == 0) {
            [_downLoadingTableViewController clickAllStartBtn];
            [_headImageView changeButtonTitleWithType:allPause_Type];
            [self allStartPauseBtnDisableMoment];
        }

    }
}

#pragma mark - NSNotification Methods

- (void)updateStorageView
{ // 更新存储空间数据
    [self reloadAllDownloadView];
    [showSpaceVeiw setProgressView];
}

- (void)reloadDownloadingTableView:(NSNotification *)note{
    [_downLoadingTableViewController.tableView reloadData];
}

- (void)clickLookInfoBtn:(NSNotification *)note{
    
    NSString *distriPlist = nil;
     NSString *vc = nil;
    
    distriPlist = [note.object objectAtIndex:0];
    vc = [note.object objectAtIndex:1];
    
    [topView touchTopButton:vc];
    if ([vc isEqualToString:@"downing"]) {
        
        [self showDownloadingView];
        
        //在 下载中 的索引
        NSInteger index = [[BppDistriPlistManager getManager] indexItemInDownloadingByAttriValue:DISTRI_PLIST_URL
                                                                                           value:distriPlist];
        NSIndexPath * _curIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_downLoadingTableViewController.tableView selectRowAtIndexPath:_curIndexPath
                                                               animated:YES
                                                         scrollPosition:UITableViewScrollPositionMiddle];
        
    }else if ([vc isEqualToString:@"downover"]){
        [self showDownOverView];
    }
}

- (void)reloadAllDownloadView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [topView refreshManageTopButton];
        [_downOverTableViewController.tableView reloadData];
        [_downLoadingTableViewController.tableView reloadData];
//        [_updataViewController reloadTable];
    });
}

- (void)changeCheckEditButtonTitle
{
    if (!_downLoadingTableViewController.view.hidden) {
        
        if (_downLoadingTableViewController.selectToDeleteArray.count < [[BppDistriPlistManager getManager] countOfDownloadingItem]) {
            [self changeCheckAllButtonTitle:editView_checkAll];
        }else
        {
            [self changeCheckAllButtonTitle:editView_unCheckAll];
        }
        
    }else if (!_downOverTableViewController.view.hidden)
    {
        if (_downOverTableViewController.selectToDeleteArray.count < _downOverTableViewController.installArray.count + _downOverTableViewController.reinstallArray.count) {
            [self changeCheckAllButtonTitle:editView_checkAll];
        }else
        {
            [self changeCheckAllButtonTitle:editView_unCheckAll];
        }
    }
}

- (void)disableUpdataBtn:(NSNotification *)bl{
    _headImageView.allUpdatBtn.enabled = [bl.object boolValue];
}

#pragma mark - Utility

-(void)showDownloadingView
{
    // 公共
    _headImageView.allStartPauseBtn.hidden = NO;
    _headImageView.editBtn.hidden = NO;
    _headImageView.allUpdatBtn.hidden = YES;
    [_headImageView hideLessonTipView:YES];
    
    emptyCellBGImageView_over.hidden = YES;
    _downOverTableViewController.view.hidden = YES;
    
    showSpaceVeiw.hidden = NO;
    
    // 区分
    NSInteger items = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    if (items > 0) {
        
        emptyCellBGImageView_ing.hidden = YES;
        _downLoadingTableViewController.tableView.hidden = NO;
        
        // 设置 HeadImageView
        int pauseItems = [_downLoadingTableViewController numberOfPauseItems];
        if (pauseItems == 0) {
            [_headImageView changeButtonTitleWithType:allPause_Type];
        }
        else
        {
            [_headImageView changeButtonTitleWithType:allStart_Type];
        }
        _headImageView.allStartPauseBtn.enabled = YES;
        _headImageView.editBtn.enabled = YES;
    }
    else
    {
        emptyCellBGImageView_ing.hidden = NO;
        _downLoadingTableViewController.tableView.hidden = YES;
        
        // 设置 HeadImageView
        [_headImageView changeButtonTitleWithType:allStart_Type];
        [_headImageView changeButtonTitleWithType:edit_Type];
        _headImageView.allStartPauseBtn.enabled = NO;
        _headImageView.editBtn.enabled = NO;
        
        // 设置 BottomEditView
        [self showBottomEditView:editView_hide];
        
    }
    
    // 设置屏幕常亮
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES ];
}

-(void)showDownOverView
{
    // 公共
    _headImageView.allStartPauseBtn.hidden = YES;
    _headImageView.editBtn.hidden = NO;
    _headImageView.allUpdatBtn.hidden = YES;
    [_headImageView hideLessonTipView:NO];
    
    
    emptyCellBGImageView_ing.hidden = YES;
    _downLoadingTableViewController.view.hidden = YES;
    
    showSpaceVeiw.hidden = NO;
    
    // 区分
    NSInteger items = [[BppDistriPlistManager getManager] countOfDownloadedItem];
    
    if (items > 0) {
        // 显示
        emptyCellBGImageView_over.hidden = YES;
        _downOverTableViewController.tableView.hidden = NO;
        [_downOverTableViewController.tableView reloadData];
        
        // 设置HeadImageView
        _headImageView.editBtn.enabled = YES;
    }
    else
    {
        // 显示
        emptyCellBGImageView_over.hidden = NO;
        _downOverTableViewController.tableView.hidden = YES;
        
        // 设置HeadImageView
        [_headImageView changeButtonTitleWithType:edit_Type];
        _headImageView.editBtn.enabled = NO;
        
        // 设置bottomEditView控件
        [self showBottomEditView:editView_hide];
    }
    
    // 取消常亮
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}

-(void)showUpdateView
{
    // 设置 HeadImageView
    _headImageView.allStartPauseBtn.hidden = YES;
    _headImageView.editBtn.hidden = YES;
    _headImageView.allUpdatBtn.hidden = NO;
    [_headImageView hideLessonTipView:NO];

    
    // 设置 TableView
    emptyCellBGImageView_ing.hidden = YES;
    emptyCellBGImageView_over.hidden = YES;
    _downLoadingTableViewController.view.hidden = YES;
    _downOverTableViewController.view.hidden = YES;
    
    // 设置Bottom部分
    showSpaceVeiw.hidden = YES;
    
    // refresh
}

-(void)showBottomEditView:(EditView_Type)type
{ // bottomEditView 是否显示
    switch (type) {
        case editView_show:{ // 显示bottomEditView
            [self changeCheckAllButtonTitle:editView_checkAll];
            
            if (!isPopDeleteShowView) {
                isPopDeleteShowView = YES;
                
                [UIView beginAnimations:@"showBottomEditView" context:nil];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:bottomEditView cache:YES];
                CGRect rect = bottomEditView.frame;
                rect.origin.y = rect.origin.y - CUTSIZEHEIGHT-BOTTOM_HEIGHT;
                bottomEditView.frame = rect;
                [UIView commitAnimations];
            }
            
        }
            break;
        case editView_hide:{ // 隐藏bottomEditView
            [self changeCheckAllButtonTitle:editView_unCheckAll];
            
            if (isPopDeleteShowView) {
                isPopDeleteShowView = NO;
                
                [UIView beginAnimations:@"hideBottomEditView" context:nil];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:bottomEditView cache:YES];
                CGRect rect = bottomEditView.frame;
                rect.origin.y = rect.origin.y + CUTSIZEHEIGHT+BOTTOM_HEIGHT;
                bottomEditView.frame = rect;
                [UIView commitAnimations];
                
                [_downLoadingTableViewController.selectToDeleteArray removeAllObjects];
                [_downOverTableViewController.selectToDeleteArray removeAllObjects];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self.view bringSubviewToFront:bottomEditView];
    
    _downLoadingTableViewController.cellselectStyle = @"none";
    _downOverTableViewController.cellselectStyle = @"none";
}

- (void)downloadStatus
{ // 获取当前正在下载的列表（ 等待中或者下载中）不包含停止下载的----用于开机继续下载
    [dataArray removeAllObjects];
    
    NSInteger count = [[BppDistriPlistManager getManager] countOfDownloadingItem];
    for (int i=0; i<count; i++)
    {
        NSDictionary * dic =  [[BppDistriPlistManager getManager] ItemInfoInDownloadingByIndex:i];
        NSInteger status = [[dic objectForKey:DISTRI_APP_DOWNLOAD_STATUS] integerValue];
        
        if (status == DOWNLOAD_STATUS_RUN || status == DOWNLOAD_STATUS_WAIT) {
            [dataArray addObject:[dic objectForKey:DISTRI_PLIST_URL]];
        }
    }
}

- (void)startDown
{ //开始下载所有没有暂停的，等待中的
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i=0; i<dataArray.count; i++) {
            [_downLoadingTableViewController clickPlistStartBtn:[dataArray objectAtIndex:i]];
        }
    });
}

- (void)reachabilityChanged:(NSNotification *)note { //实时监听网络变化,改变下载状态
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable)
    {
        [self downloadStatus];
        [self allPauseClick];
    }
    else if (status == 1)//3g
    {
        [self downloadStatus];
        
        [self allPauseClick];
    }
    else if (status == 2)//wifi
    {
        if (dataArray.count)
        {
            [self startDown];
        }
    }
}

#pragma mark - viewDidLayoutSubviews

- (void)viewDidLayoutSubviews{
    
#define DOWNWIDTH [UIScreen mainScreen].bounds.size.width
#define DOWNHEIGHT [UIScreen mainScreen].bounds.size.height-BOTTOM_HEIGHT
    
    CGFloat TMPFL = 0;
    CGFloat tabledeleteHeight = 0;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] < 7.0) {
        tabledeleteHeight = 68;
    }else
    {
        TMPFL = 64;
    }
    
    _headImageView.frame = CGRectMake(0, TMPFL, DOWNWIDTH+49, 36);
    _downLoadingTableViewController.view.frame = CGRectMake(0, _headImageView.frame.origin.y+_headImageView.frame.size.height, self.view.frame.size.width, DOWNHEIGHT-(_headImageView.frame.origin.y+_headImageView.frame.size.height)-CUTSIZEHEIGHT-tabledeleteHeight);
    _downOverTableViewController.view.frame = _downLoadingTableViewController.view.frame;
    
    if (!isPopDeleteShowView) {
        bottomEditView.frame = CGRectMake((self.view.frame.size.width - self.view.frame.size.width)/2, _downLoadingTableViewController.view.frame.origin.y+_downLoadingTableViewController.view.frame.size.height+CUTSIZEHEIGHT+BOTTOM_HEIGHT, self.view.frame.size.width, CUTSIZEHEIGHT);
        topEditLineView.frame = CGRectMake(0, 0, bottomEditView.frame.size.width, 1);
        checkAllBtn.frame = CGRectMake(0, 0, (MainScreen_Width-1)/2, bottomEditView.frame.size.height);
        verticalEditLine.frame = CGRectMake((MainScreen_Width-1)/2, (CUTSIZEHEIGHT - 22)/2, 1, 22);
        deleteBtn.frame = CGRectMake((MainScreen_Width-1)/2 + 1, 0, (MainScreen_Width-1)/2, bottomEditView.frame.size.height);
        
        showSpaceVeiw.frame = CGRectMake(bottomEditView.frame.origin.x, bottomEditView.frame.origin.y-CUTSIZEHEIGHT-BOTTOM_HEIGHT, self.view.frame.size.width, CUTSIZEHEIGHT);
    }
    
    emptyCellBGImageView_ing.frame = _downLoadingTableViewController.view.frame;
    downingImageView.frame = CGRectMake((emptyCellBGImageView_ing.frame.size.width - 190)/2, (emptyCellBGImageView_ing.frame.size.height - 120)/2, 190, 120);
    messageLabel.frame = CGRectMake(0, 10, downingImageView.frame.size.width, downingImageView.frame.size.height);
    
    emptyCellBGImageView_over.frame = _downOverTableViewController.view.frame;
    downedImageView.frame = CGRectMake((emptyCellBGImageView_over.frame.size.width - 190)/2, (emptyCellBGImageView_over.frame.size.height - 120)/2, 190, 120);
    CGFloat StartX = 27.5;
    loadedmessageLabel.frame = CGRectMake(StartX, 20, downedImageView.frame.size.width-StartX*2, downedImageView.frame.size.height);
    
}

@end
