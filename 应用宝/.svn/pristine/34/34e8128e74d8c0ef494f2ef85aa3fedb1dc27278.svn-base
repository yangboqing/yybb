//
//  DownLoadFreeFlowViewController.m
//  browser
//
//  Created by liguiyang on 14-5-26.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "DownLoadFreeFlowViewController.h"
#import "SearchResult_DetailViewController.h"
#import "SearchResultCell.h"

#import "MarketServerManage.h"
#import "SettingPlistConfig.h"
#import "BppDistriPlistManager.h"
#import "CustomNavigationBar.h"

#import "AppStatusManage.h"
#import "CollectionViewBack.h"

static NSString *cellRefreshIdentifier = @"RefreshCellIdentifier";

@interface DownLoadFreeFlowViewController ()<MarketServerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BppDistriPlistManagerDelegate>
{
    NSMutableArray *resultArray; //
    
    // 详情页
    SearchResult_DetailViewController *freeDetailVC;
    
    CollectionViewBack * _backView;
    
    // loading cell components
    UILabel *cellLoadingLabel;
    UIActivityIndicatorView *cellLoadingActivity;
    int loadingCellFlag;
    //
    int requestCount;
    BOOL hasNextData;
    BOOL isRequesting;
    UIImage *defaultListImage;
    UIImage *defaultViewImage;
    UIView  *footView;
}

@property (nonatomic, strong) UITableView    *tableView;
@end

@implementation DownLoadFreeFlowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)dealloc{
    [[MarketServerManage getManager] removeListener:self];
    
    [[BppDistriPlistManager getManager] removeListener:self];
    
}


#pragma mark - initizlization

-(void)initMainView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    
    [self.view addSubview:tableView];

    self.tableView = tableView;
    
    // set frame
    [self setViewFrame];
    
    _backView = [CollectionViewBack new];
    __weak typeof(self) m = self;
    [_backView setClickActionWithBlock:^{
        [m performSelector:@selector(searchListFailedViewHasBeenTap) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:_backView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    rect.size.height = rect.size.height+20;
    _backView.frame = rect;
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Request data/show loading/show failed

-(void)searchListFailedViewHasBeenTap
{// 点击搜索失败页面 重新搜索
    [self requestFreeFlowData];
}

-(void)requestFreeFlowData
{
    // request
    [[MarketServerManage getManager] getChinaUnicomFreeFlowList:requestCount userData:nil];
    
    // showLoading
    if (requestCount == 1) {
        _backView.status = Loading;
    }
    
    isRequesting = YES;
}

#pragma mark - Utility

-(NSString *)getPlistUrlByPlistDic:(NSDictionary *)plistDic;
{
    NSString *netOperatorState = [[FileUtil instance] checkChinaMobileNetState];
    NSString *plistKey = @"kuaiyong";
    
    if ([netOperatorState isEqualToString:@"中国联通3G"] || [netOperatorState isEqualToString:@"中国联通4G"]) {
        plistKey = @"chinaunicom";
    }
    else if ([netOperatorState isEqualToString:@"中国移动3G"] || [netOperatorState isEqualToString:@"中国移动4G"])
    {
        plistKey = @"chinamobile";
    }
    else if ([netOperatorState isEqualToString:@"中国电信3G"] || [netOperatorState isEqualToString:@"中国电信4G"])
    {
        plistKey = @"chinatelecom";
    }
    
    return [plistDic objectForKey:plistKey];
}

-(NSDictionary *)restoreAppInfoDictionary:(NSDictionary *)appInfo
{
    NSMutableDictionary *tmpDic = [appInfo mutableCopy];
    [tmpDic setObject:[self getPlistUrlByPlistDic:[appInfo objectForKey:@"plist"]] forKey:@"plist"];
    
    return tmpDic;
}

-(void)showFreeDetailView:(NSDictionary *)infoDic atIndex:(NSInteger)row
{
    freeDetailVC.view.hidden = NO;
    freeDetailVC.detailType = @"FreeFlow";
    [freeDetailVC hideDetailTableView];
    freeDetailVC.BG.hidden = NO;
    [freeDetailVC setAppSoure:CHINAUNICOM_FREE_FLOW(row)];
    freeDetailVC.mianliuPList = [self getPlistUrlByPlistDic:[infoDic objectForKey:@"plist"]];
    [freeDetailVC beginPrepareAppContent:infoDic];

    [self.navigationController pushViewController:freeDetailVC animated:YES];
}

- (void)updateDownloadButtonState{
    // 更新下载按钮状态
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

//-(void)showRefreshLoadingCell
//{
//    cellLoadingLabel.frame = CGRectMake(100, 2, 80, 30);
//    cellLoadingLabel.text = @"努力加载中";
//    
//    cellLoadingActivity.frame = CGRectMake(175, 2, 30, 30);
//    cellLoadingActivity.hidden = NO;
//    [cellLoadingActivity startAnimating];
//}
//- (void)showRefreshFailedCell
//{
//    cellLoadingLabel.frame = CGRectMake(10, 2, 300, 30);
//    cellLoadingLabel.text = @"网络有点堵塞，试试再次上拉";
//    
//    [cellLoadingActivity stopAnimating];
//    cellLoadingActivity.hidden = YES;
//}

-(void)reloadTableByAppending:(NSArray *)array
{
    //
    requestCount++;
    loadingCellFlag = 0;
    isRequesting = NO;
    //
    for (NSDictionary *dic in array) {
        [resultArray addObject:dic];
    }
    
    [self.tableView reloadData];
}

-(void)setViewFrame
{
    // freeFlowView
    self.tableView.frame = self.view.bounds;
    
}

-(void)backChoiceVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 曝光度

-(void)reportAppBaoGuang
{
    NSArray *ids = [self getVisibleCellAppIds];
    [[ReportManage instance] ReportAppBaoGuang:CHINAUNICOM_FREE_FLOW(-1) appids:ids];
}

-(NSArray *)getVisibleCellAppIds
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (SearchResultCell *cell in self.tableView.visibleCells) {
        [array addObject:cell.appID];
    }
    
    return array;
}

-(BOOL)checkPlistDic:(NSDictionary *)plistDic
{
    
    BOOL plistFlag = NO;
    if (plistDic) {
        if (IS_NSSTRING([plistDic objectForKey:@"kuaiyong"]) &&
            IS_NSSTRING([plistDic objectForKey:@"chinaunicom"]) &&
            IS_NSSTRING([plistDic objectForKey:@"chinamobile"]) &&
            IS_NSSTRING([plistDic objectForKey:@"chinatelecom"])) {
            plistFlag = YES;
        }
    }
    
    return plistFlag;
}

-(BOOL)checkData:(NSDictionary *)dataDic
{
    BOOL typeFlag = NO;
    if (IS_NSDICTIONARY(dataDic)) {
        NSArray *appArr = [dataDic getNSArrayObjectForKey:@"data"];
        
        if (appArr) {
            for (id obj in appArr) {
                if (IS_NSDICTIONARY(obj)) {
                    if ([obj getNSStringObjectForKey:@"appdowncount"] &&
                        [obj getNSStringObjectForKey:@"appiconurl"] &&
                        [obj getNSStringObjectForKey:@"appid"] &&
                        [obj getNSStringObjectForKey:@"appintro"] &&
                        [obj getNSStringObjectForKey:@"appname"] &&
                        [obj getNSStringObjectForKey:@"appreputation"] &&
                        [obj getNSStringObjectForKey:@"appsize"] &&
                        [obj getNSStringObjectForKey:@"appupdatetime"] &&
                        [obj getNSStringObjectForKey:@"appversion"] &&
                        [obj getNSStringObjectForKey:@"category"] &&
                        [obj getNSStringObjectForKey:@"ipadetailinfor"] &&
                        [obj getNSStringObjectForKey:@"ipadetailinfor"] &&
                        [self checkPlistDic:[obj getNSDictionaryObjectForKey:@"plist"]]) {
                        typeFlag = YES;
                    }
                    else
                    {
                        typeFlag = NO;
                        break;
                    }
                }
            }
        }
    }
    
    return typeFlag;
}

#pragma mark - MarketServerManageDelegate
//栏目-联通免流列表请求成功
- (void)ChinaUnicomFreeFlowListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount userData:(id)userData;
{
    if (IS_NSDICTIONARY([dataDic objectForKey:@"flag"])) {
        NSString *flagStr = [[dataDic objectForKey:@"flag"] objectForKey:@"dataend"];
        if (flagStr && [flagStr isEqualToString:@"y"]) {
            hasNextData = YES;
        }
        else
        {
            hasNextData = NO;
        }
    }
    else
    {
        hasNextData = NO;
    }
    
    if (requestCount == 1) {
        _backView.status = Hidden;
    }
    
    // 数据校验
    if ([self checkData:dataDic]) {
        NSArray *resultArr = [dataDic objectForKey:@"data"];
        [self reloadTableByAppending:resultArr];
    }
    else
    {
        _backView.status = Failed;
    }
    
    
    
}

//栏目-联通免流列表请求失败
- (void)ChinaUnicomFreeFlowListRequestFail:(int)pageCount userData:(id)userData;
{
    isRequesting = NO;
    //
    if (requestCount != 1) {
        //[self showRefreshFailedCell];
        [_tableView reloadData];
    }
    else
    {
        _backView.status = Failed;
    }
    
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArray.count+loadingCellFlag;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < resultArray.count) {
        static NSString *CellIdentifier = @"downloadFreeFlowCell";
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        

        NSMutableDictionary *appInfor = resultArray[indexPath.row];
        cell.source = CHINAUNICOM_FREE_FLOW(indexPath.row);
        cell.identifier = [appInfor objectForKey:@"appiconurl"];
        cell.iconURLString = [appInfor objectForKey:@"appiconurl"];
        [cell initCellwithInfor:[self restoreAppInfoDictionary:appInfor]];
        
        //cell 内实现下载按钮状态改变
        [cell initDownloadButtonState];
        
        //图片显示
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:defaultListImage];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // refreshCell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRefreshIdentifier];
    static RefreshView * _refresh = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRefreshIdentifier];
        _refresh = [RefreshView new];
        _refresh.frame = cell.bounds;
        [cell.contentView addSubview:_refresh];
    }
    
    isRequesting?[_refresh startGif]:[_refresh stopGif];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = resultArray[indexPath.row];
    [self showFreeDetailView:dic atIndex:indexPath.row];
    // 点击汇报
    [[ReportManage instance] ReportAppDetailClick:CHINAUNICOM_FREE_FLOW(indexPath.row) appid:[dic objectForKey:@"appid"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < resultArray.count) {

        return 80;
        
    }
    
    return 38;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (footView == nil) {
        footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor clearColor];
    }
    
    return footView;
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (hasNextData && !isRequesting) {
        if (loadingCellFlag==0 && scrollView.contentSize.height-scrollView.contentOffset.y-455 < 0) {
            loadingCellFlag = 1;
            isRequesting = YES;
            [self.tableView reloadData];
            //[self showRefreshLoadingCell];
            [self requestFreeFlowData];
            NSLog(@"offset.y: %f, contentSize.height: %f, defference: %f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.contentSize.height-scrollView.contentOffset.y);
        }
        else if (loadingCellFlag==1 && scrollView.contentSize.height-scrollView.contentOffset.y-440 < 0)
        {
            [self requestFreeFlowData];
            NSLog(@"offset.y: %f, contentSize.height: %f, defference: %f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.contentSize.height-scrollView.contentOffset.y);
        }
        
    }
    
}

static bool _deceler = false;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _deceler = true;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && _deceler==false) {
        [self reportAppBaoGuang];
    }
    
    _deceler = false;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reportAppBaoGuang];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数据
    [[MarketServerManage getManager] addListener:self];
    
    defaultListImage = _StaticImage.icon_60x60;
    defaultViewImage = [UIImage imageNamed:@"PictureMode_default.png"];
    resultArray = [[NSMutableArray alloc] init];
    
    // NavigationBar
//    UIImage * image = LOADIMAGE(@"nav_back", @"png");
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
    [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    }];
    [button addTarget:self action:@selector(backChoiceVC) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.leftBarButtonItem= backButton;
    
    CustomNavigationBar *navTitleBar = [[CustomNavigationBar alloc] init];
    [navTitleBar showNavigationTitleView:@"联通3G免流量"];
    self.navigationItem.titleView = navTitleBar;
    
    // 主界面创建
    [self initMainView];
    
    freeDetailVC = [[SearchResult_DetailViewController alloc] init];
    
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //用于更新下载按钮状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadButtonState) name:RELOADDOWNLOADCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadButtonState) name:CHANGEBUTTONSTATETODOWN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadButtonState) name:APPLICATIONS_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadButtonState) name:REFRESH_MOBILE_APP_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDownloadButtonState)
                                                 name:ADD_APP_DOWNLOADING
                                               object:nil];
    
    [[BppDistriPlistManager getManager] addListener:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestCount = 1; // 请求数据
        [self requestFreeFlowData];
    });
    
    // 更新cell.plistUrl值(应用下载地址)
    [self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
