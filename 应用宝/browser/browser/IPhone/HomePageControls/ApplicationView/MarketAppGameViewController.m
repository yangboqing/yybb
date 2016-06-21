//
//  MarketAppViewController.m
//  browser
//
//  Created by liguiyang on 14-9-24.
//
//

#import "MarketAppGameViewController.h"
#import "RotationView.h" // 轮播图
#import "DisplayCollectionViewController.h" // 八宫格
#import "SearchResult_DetailViewController.h" // 应用详情
#import "FindDetailViewController.h" // 活动详情
#import "DetailViewController.h" // 专题详情
#import "UIWebViewController.h" // 公告网页

#import "EGORefreshTableHeaderView.h" // 下拉刷新
#import "CollectionViewBack.h"

#import "PublicTableViewCell.h"
#import "TableViewLoadingCell.h"

#import "SearchResult_DetailViewController.h" // 应用详情
#import "MarketListViewController.h" // 下级列表
#import "AListViewController.h"
#import "AlertLabel.h"

#import "MarketServerManage.h"
#import "AppStatusManage.h"

typedef enum{
    cellTag_lunbo = 100, // 轮播
    cellTag_latest, // 最新
    cellTag_hot, // 最热
    cellTag_fengCe, // 封测网游
    cellTag_rankingList, // 排行榜
    cellTag_loading, // 加载cell
    cellTag_lastShow, // 最后的提示cell
}CellTag;

#define TAG_HOT 1001
#define TAG_LATEST 1002
#define TAG_FENGCE 1003
#define TAG_RANKINGLISTBTN 1004

#define KEY_DETAILSOURCE @"detailSource"
#define IDEN_REFRESH_APP @"pullRefreshAppIden"

@interface MarketAppGameViewController ()<UITableViewDataSource,UITableViewDelegate,MarketServerDelegate,DisplayCollectionViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *loopingArray; // 轮播图
    NSMutableArray *hotArray; // 最热
    NSMutableArray *latestArray; // 最新
    NSMutableArray *fengCeArray; // 封测网游
    NSMutableArray *rankingListArray; // 排行榜
    NSMutableArray *reportAppIdArray; // 上报曝光数据
    
    //
    RotationView *loopingView; // 轮播图UI
    DisplayCollectionViewController *hotVC; // 最热应用UI
    DisplayCollectionViewController *latestVC; // 最新应用UI
    DisplayCollectionViewController *fengCeVC; // 封测网游
    SearchResult_DetailViewController *appDetailViewController; // 应用详情
    
    CollectionViewBack *backView; // 状态界面
    EGORefreshTableHeaderView *egoRefreshView;
    AlertLabel *alertLabel; // 下拉刷新失败
    
    //
    BOOL couldUpwardPullRequest; // 是否可以上拉刷新
    BOOL scrollEndFlag; // 此变量和requestFailedFlag一块用
    BOOL rankingListRequestFailedFlag; // 请求失败
    BOOL hasExecOnce; // 防止 滑动急停 曝光两次
    
    int rankingPageCount;
    int failedCount; // 失败达到次数显示失败页：应用=2，游戏=3；
    BOOL refreshHeaderLoading;
    
    CellRequestStyle loadingCellStyle; // loading、Failed
    NSString *identifier; // 请求数据identifier
    NSString *identifier_NoCache; // 请求数据不缓存identifier
    BOOL firstRequestFlag; // 是否首次请求
    
    
    MarketType marketType;
    BOOL appTypeFlag;
    // image Name
    NSString *hotImgName;
    NSString *latestImgName;
    NSString *fengCeImgName;
    NSString *rankingImgName;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MarketAppGameViewController

-(id)initWithMarketType:(MarketType)mType
{
    self = [super init];
    if (self) {
        marketType = mType;
        appTypeFlag = (marketType==marketType_App)?YES:NO;
        if (mType==marketType_App) {
            hotImgName = @"hotApp.png";
            latestImgName = @"latestApp.png";
            rankingImgName = @"rankingApp.png";
        }
        else
        {
            hotImgName = @"hotGame.png";
            latestImgName = @"latestGame.png";
            fengCeImgName = @"fengceGame.png";
            rankingImgName = @"rankingGame.png";
        }
        identifier = [NSString stringWithFormat:@"MarketAG_%d",mType];
        identifier_NoCache = [NSString stringWithFormat:@"MarketAG_NoCache_%d",mType];
        //
        rankingListArray = [[NSMutableArray alloc] initWithCapacity:100];
        reportAppIdArray = [[NSMutableArray alloc] initWithCapacity:20];
        rankingPageCount = 1;
        couldUpwardPullRequest = YES;
        [[MarketServerManage getManager] addListener:self];
    }
    
    return self;
}

#pragma mark - Utility

-(RotationView*)getRotationView
{ // 获取轮播图实例
    RotationView *loopingPictureView = [[RotationView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, lunboHeight) andScrollTimer:4.0f];
    loopingPictureView.tag = (marketType==marketType_App)?1:2;
    NSString *sourceType = (marketType==marketType_App)?@"app":@"game";
    loopingPictureView.baoguangBlock = ^(NSInteger index){
        [[ReportManage instance] ReportAppBaoGuang:HOME_PAGE_LUNBO(sourceType,index) appids:nil];
    };
    
    return loopingPictureView;
}

-(DisplayCollectionViewController *)getGridViewController
{ // 获取最新、最热实例
    DisplayCollectionViewController *gridViewController = [[DisplayCollectionViewController alloc] initWithAppDisplayInformation:nil];
    gridViewController.view.frame = CGRectMake(0, 0, MainScreen_Width, gridViewController.view.frame.size.width);
    gridViewController.delegate = self;
    
    return gridViewController;
}

-(UIView *)getRankingListHeaderView
{
    // cuttingline、image、Button
    UIView *headView = [[UIView alloc] init];
    
//    UIView *separatorLineImgView = [[UIImageView alloc] init];
//    separatorLineImgView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1];
    
    UIImageView *leftTopImgView = [[UIImageView alloc] init];
    SET_IMAGE(leftTopImgView.image, rankingImgName)
    
    UIButton *rankingListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [LocalImageManager setImageName:@"all_btn.png" complete:^(UIImage *image) {
        [rankingListBtn setImage:image forState:UIControlStateNormal];
    }];
    rankingListBtn.tag = TAG_RANKINGLISTBTN;
    
//    [headView addSubview:separatorLineImgView];
    [headView addSubview:leftTopImgView];
    [headView addSubview:rankingListBtn];
    
//    separatorLineImgView.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 0.5);
    leftTopImgView.frame = CGRectMake(10, 18, 159, 16);
    rankingListBtn.frame = CGRectMake(self.view.frame.size.width-60, leftTopImgView.frame.origin.y-6, 60, 25);

    return headView;
}

-(void)showRankingListView
{
    if (marketType == marketType_App) {
        AListViewController *listVC = [[AListViewController alloc] initWithRankingListType:rankingListType_App];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else
    {
        AListViewController *listVC = [[AListViewController alloc] initWithRankingListType:rankingListType_Game];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
}

-(void)showActivity:(NSDictionary *)dic image:(UIImage *)img source:(NSString *)source
{ // 活动详情
    FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
    findDetailVC.fromSource = source;
    findDetailVC.shareImage = img;
    [findDetailVC reloadActivityDetailVC:dic];
    [self.navigationController pushViewController:findDetailVC animated:YES];
}

- (void)showAppDetailViewController:(NSDictionary *)infoDataDic
{ // 应用详情
    [appDetailViewController hideDetailTableView];
    appDetailViewController.BG.hidden = NO;
    [appDetailViewController beginPrepareAppContent:[infoDataDic objectForKey:@"data"]];//设置数据
    [appDetailViewController setAppSoure:[infoDataDic objectForKey:KEY_DETAILSOURCE]];
    [self.navigationController pushViewController:appDetailViewController animated:YES];
    
    // 汇报
    [[ReportManage instance] ReportAppDetailClick:[infoDataDic objectForKey:KEY_DETAILSOURCE] appid:[[infoDataDic objectForKey:@"data"] objectForKey:@"appid"]];
}

-(void)showWebView:(NSString *)urlStr withTitle:(NSString *)title
{ // 网页公告
    UIWebViewController *webView = [[UIWebViewController alloc] init];
    [webView navigation:urlStr];
    webView.title = title;
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)showSpecialView:(NSDictionary *)dic
{
    DetailViewController *specialDetailVC = [[DetailViewController alloc] init];
    
    NSMutableDictionary *specialDic = [NSMutableDictionary dictionary];
    for (NSString *key in dic.allKeys) {
        if ([key isEqualToString:@"zt_id"]) {
            [specialDic setObject:[dic objectForKey:key] forKey:SPECIALID];
            continue;
        }
        [specialDic setObject:[dic objectForKey:key] forKey:key];
    }

        [specialDetailVC setDetailInfo:specialDic andStyle:_DETAIL_STYLE_TOPIC];
        [self.navigationController pushViewController:specialDetailVC animated:YES];
    
}

-(void)setRankingListData:(NSArray *)array
{
    // setData
    [rankingListArray addObjectsFromArray:array];
    
    // setParameter
    rankingPageCount++;
    couldUpwardPullRequest = (rankingListArray.count>100)?NO:YES;
    
    [self.tableView reloadData];
}

-(void)reloadRankingListLoadingCell:(CellRequestStyle)style
{
    loadingCellStyle = style;
    int section = appTypeFlag?4:5;
    int row = (rankingListArray.count<100)?rankingListArray.count:100;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)hideDownPullRefreshView
{
    refreshHeaderLoading = NO;
    [egoRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

-(void)showDownRefreshFailedLabel
{
    CGFloat originY = (IOS7)?44:0;
    [alertLabel startAnimationFromOriginY:originY];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor yellowColor];
    
    hotVC = [self getGridViewController]; // 最热
    latestVC = [self getGridViewController]; // 最新
    if (marketType==marketType_Game) {
        fengCeVC = [self getGridViewController]; // 封测
    }
    appDetailViewController = [[SearchResult_DetailViewController alloc] init];
    
    // 主界面
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // EGORefreshHeaderView
    egoRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    egoRefreshView.egoDelegate = self;
    [self.tableView addSubview:egoRefreshView];
    
    alertLabel = [[AlertLabel alloc] init];
    [self.view addSubview:alertLabel];
    
    // loading、failedView
    __weak id mySelf = self;
    backView = [[CollectionViewBack alloc] init];
    [backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(requestAll) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:backView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}
-(void)viewWillLayoutSubviews
{
    CGRect rect = self.view.bounds;
    CGFloat topHeight = IOS7?44:0;
    self.tableView.frame = rect;
    egoRefreshView.frame = CGRectMake(0, -rect.size.height+topHeight, rect.size.width, rect.size.height);
    backView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - UITableView dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return appTypeFlag?5:6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rankingSection = appTypeFlag?4:5;
    if (section == rankingSection) {
        int row = rankingListArray.count;
        return (row>100)?101:row+1;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //分隔条
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_Width, 10)];
    seperateView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    seperateView.layer.borderWidth = 0.5;
    seperateView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0].CGColor;
    return seperateView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||section == ((marketType == marketType_App)?4:5)) {
        return 0;
    }
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{ // 轮播
            static NSString *lunBoCellIden = @"appRotationViewIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lunBoCellIden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lunBoCellIden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = cellTag_lunbo;
                
                CGFloat topHeight = (IOS7)?44:0;
                loopingView = [self getRotationView];
                loopingView.frame = CGRectMake(0, topHeight, self.view.frame.size.width, lunboHeight);
                [cell.contentView addSubview:loopingView];
            }
            
            return cell;
        }
            break;
        case 1:{ // 最热
            static NSString *hotCellIden = @"appHotAppViewIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCellIden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotCellIden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = cellTag_hot;
                
                SET_IMAGE(hotVC.leftTopImgView.image, hotImgName);
                hotVC.collectionView.tag = TAG_HOT;
                
                [cell.contentView addSubview:hotVC.view];
            }
            
            return cell;
        }
            break;
        case 2:{ // 最新
            static NSString *latestCellIden = @"appLatestAppViewIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:latestCellIden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:latestCellIden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = cellTag_latest;
                
                SET_IMAGE(latestVC.leftTopImgView.image, latestImgName);
                latestVC.collectionView.tag = TAG_LATEST;
                
                [cell.contentView addSubview:latestVC.view];
            }
            
            return cell;
        }
            break;
        case 3:{ // listHeader_app or Fengce_game
            if (marketType == marketType_App) {
                static NSString *cellRankingHeaderIden = @"appRankingListHeaderIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRankingHeaderIden];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRankingHeaderIden];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView *rankingListHeadView = [self getRankingListHeaderView];
                    [cell.contentView addSubview:rankingListHeadView];
                    
                    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    allBtn.frame = [rankingListHeadView viewWithTag:TAG_RANKINGLISTBTN].frame;
                    [allBtn addTarget:self action:@selector(showRankingListView) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:allBtn];
                }
                
                return cell;
            }
            else
            {
                static NSString *cellFengCeIden = @"gameFengCeIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellFengCeIden];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellFengCeIden];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.tag = cellTag_fengCe;
                    
                    SET_IMAGE(fengCeVC.leftTopImgView.image, fengCeImgName);
                    fengCeVC.collectionView.tag = TAG_FENGCE;
                    
                    [cell.contentView addSubview:fengCeVC.view];
                }
                
                return cell;
            }
        }
            break;
        case 4:{ // rankingList_app or listHeader_game
            if (marketType == marketType_App) {
                if (indexPath.row < rankingListArray.count && indexPath.row < 100) {
                    static NSString *CellIdentifier = @"Cellhomelist";
                    
                    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell==nil) {
                        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.tag = cellTag_rankingList;
                    }
                    
                    NSDictionary *appInfor = rankingListArray[indexPath.row];
                    cell.downLoadSource = APP_WEEK_RANKING(indexPath.row);
                    [cell initCellInfoDic:appInfor];
                    [cell setAngleNumber:indexPath.row];
                    [cell setNameLabelText:[appInfor objectForKey:@"appname"]];
                    [cell setGoodNumberLabelText: [appInfor objectForKey:@"appreputation"]];
                    [cell setDownloadNumberLabelText:[appInfor objectForKey:@"appdowncount"]];
                    [cell setLabelType:[appInfor objectForKey:@"category"] Size:[appInfor objectForKey:@"appsize"]];
                    [cell setDetailText:[appInfor objectForKey:@"appintro"]];
                    cell.appVersion = [appInfor objectForKey:@"appversion"];
                    cell.iconURLString = [appInfor objectForKey:@"appiconurl"];
                    //按钮状态显示
                    cell.appID = [appInfor objectForKey:@"appid"];
                    cell.plistURL = [appInfor objectForKey:@"plist"];
                    
                    [cell initDownloadButtonState];
                    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:_StaticImage.icon_60x60];
                    
                    return cell;
                }
                else if (indexPath.row == 100)
                {
                    static NSString *lastCellIden = @"HomeListLastCellIdentifier";
                    UITableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:lastCellIden];
                    if (lastCell == nil) {
                        lastCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIden];
                        lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        lastCell.tag = cellTag_lastShow;
                        
                        CGFloat width_icon = 16;
                        CGFloat width_label = 250;
                        CGFloat oriX_icon = (MainScreen_Width-width_icon-width_label)*0.5;
                        
                        UIImageView *iconView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"lastCellImage", @"png")];
                        iconView.frame = CGRectMake(oriX_icon, 14, width_icon, width_icon);
                        [lastCell.contentView addSubview:iconView];
                        
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(oriX_icon+width_icon, 7, width_label, 30)];
                        textLabel.backgroundColor = [UIColor clearColor];
                        textLabel.textAlignment = NSTextAlignmentCenter;
                        textLabel.font = [UIFont systemFontOfSize:12.0f];
                        textLabel.text = @"已为您展现应用排行的前100 点击查看更多"; // : @"已为您展现游戏排行的前100 点击查看更多";
                        [lastCell addSubview:textLabel];
                    }
                    
                    return lastCell;
                }
                
                // loadingCell
                static NSString *loadingCellIden = @"AppLoadingCellIdentifier";
                TableViewLoadingCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:loadingCellIden];
                if (loadingCell == nil) {
                    loadingCell = [[TableViewLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellIden];
                    loadingCell.tag = cellTag_loading;
                }
                
                loadingCell.style = loadingCellStyle;
                return loadingCell;
            }
            else
            {
                static NSString *cellGameHeaderIden = @"GameRankingListHeaderIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGameHeaderIden];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGameHeaderIden];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIView *rankingListHeadView = [self getRankingListHeaderView];
                    [cell.contentView addSubview:rankingListHeadView];
                    
                    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    allBtn.frame = [rankingListHeadView viewWithTag:TAG_RANKINGLISTBTN].frame;
                    [allBtn addTarget:self action:@selector(showRankingListView) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:allBtn];
                    
                    
                }
                
                return cell;
            }
        }
            break;
        case 5:{ // rankingList_game
            if (indexPath.row < rankingListArray.count && indexPath.row < 100) {
                static NSString *cellGameIden = @"GameRankingListIdentifier";
                
                PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGameIden];
                if (cell==nil) {
                    cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGameIden];
                    cell.tag = cellTag_rankingList;
                }
                
                NSDictionary *appInfor = rankingListArray[indexPath.row];
                cell.downLoadSource = APP_WEEK_RANKING(indexPath.row);
                [cell initCellInfoDic:appInfor];
                [cell setAngleNumber:indexPath.row];
                [cell setNameLabelText:[appInfor objectForKey:@"appname"]];
                [cell setGoodNumberLabelText: [appInfor objectForKey:@"appreputation"]];
                [cell setDownloadNumberLabelText:[appInfor objectForKey:@"appdowncount"]];
                [cell setLabelType:[appInfor objectForKey:@"category"] Size:[appInfor objectForKey:@"appsize"]];
                [cell setDetailText:[appInfor objectForKey:@"appintro"]];
                cell.appVersion = [appInfor objectForKey:@"appversion"];
                cell.iconURLString = [appInfor objectForKey:@"appiconurl"];
                //按钮状态显示
                cell.appID = [appInfor objectForKey:@"appid"];
                cell.plistURL = [appInfor objectForKey:@"plist"];
                
                [cell initDownloadButtonState];
                [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:_StaticImage.icon_60x60];
                
                return cell;
            }
            else if (indexPath.row == 100)
            {
                static NSString *lastCellIden = @"HomeListLastCellIdentifier";
                UITableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:lastCellIden];
                if (lastCell == nil) {
                    lastCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIden];
                    lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    lastCell.tag = cellTag_lastShow;
                    
                    CGFloat width_icon = 16;
                    CGFloat width_label = 250;
                    CGFloat oriX_icon = (MainScreen_Width-width_icon-width_label)*0.5;
                    
                    UIImageView *iconView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"lastCellImage", @"png")];
                    iconView.frame = CGRectMake(oriX_icon, 14, width_icon, width_icon);
                    [lastCell.contentView addSubview:iconView];
                    
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(oriX_icon+width_icon, 7, width_label, 30)];
                    textLabel.backgroundColor = [UIColor clearColor];
                    textLabel.textAlignment = NSTextAlignmentCenter;
                    textLabel.font = [UIFont systemFontOfSize:12.0f];
                    textLabel.text = @"已为您展现游戏排行的前100 点击查看更多";
                    [lastCell addSubview:textLabel];
                }
                
                return lastCell;
            }
            
            // loadingCell
            static NSString *loadingCellIden = @"AppLoadingCellIdentifier";
            TableViewLoadingCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:loadingCellIden];
            if (loadingCell == nil) {
                loadingCell = [[TableViewLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellIden];
                loadingCell.tag = cellTag_loading;
            }
            
            loadingCell.style = loadingCellStyle;
            return loadingCell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UITableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    int section_list = appTypeFlag?4:5;
    if (indexPath.section == section_list) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == cellTag_rankingList) {
            NSDictionary *infoDic = @{@"data":rankingListArray[indexPath.row],KEY_DETAILSOURCE:((PublicTableViewCell*)cell).downLoadSource};
            [self showAppDetailViewController:infoDic];
        }
        else if (cell.tag == cellTag_lastShow)
        {
            [self showRankingListView];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0
    if (indexPath.section==0) {
        CGFloat topHeight = (IOS7)?44:0;
        return lunboHeight+topHeight;
    }
    
    int section_list_header = appTypeFlag?3:4;
    // 1、2 or 1、2、3
    if (indexPath.section<section_list_header) return 259*(MainScreen_Width/320)-(16*2+42)*(1-320/MainScreen_Width);
    // 3 or 4
    if (indexPath.section == section_list_header) return 35.0;
    
    // last section
    return (indexPath.row==rankingListArray.count || indexPath.row==100)?44+BOTTOM_HEIGHT:PUBLICNOMALCELLHEIGHT;
}

#pragma mark - DisplayCollectionViewDelegate
-(void)displayCollectionView:(UICollectionView *)collectionView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.section *4 + indexPath.row;
    switch (collectionView.tag) {
        case TAG_HOT:{
            NSString *hotSource = (marketType==marketType_App)?HOT_APP(index):HOT_GAME(index);
            NSDictionary *infoDic = @{@"data":hotArray[index],KEY_DETAILSOURCE:hotSource};
            [self showAppDetailViewController:infoDic];
        }
            break;
        case TAG_LATEST:{
            NSString *hotSource = (marketType==marketType_App)?NEW_APP(index):NEW_GAME(index);
            NSDictionary *infoDic = @{@"data":latestArray[index],KEY_DETAILSOURCE:hotSource};
            [self showAppDetailViewController:infoDic];
        }
            break;
        case TAG_FENGCE:{
            NSString *hotSource = FENGCE_GAME(index);
            NSDictionary *infoDic = @{@"data":fengCeArray[index],KEY_DETAILSOURCE:hotSource};
            [self showAppDetailViewController:infoDic];
        }
            break;
            
        default:
            break;
    }
}

-(void)displayCollectionView:(UICollectionView *)collectionView rightTopButtonClick:(id)sender
{
    MarketListType hotType = appTypeFlag?marketList_AppHotType:marketList_GameHotType;
    MarketListType latestType = appTypeFlag?marketList_AppLatestType:marketList_GameLatestType;
    
    if (collectionView.tag == TAG_HOT) {
        MarketListViewController *hotAppListVC = [[MarketListViewController alloc] initWithMarketListType:hotType];
        [self.navigationController pushViewController:hotAppListVC animated:YES];
    }
    else if (collectionView.tag == TAG_LATEST)
    {
        MarketListViewController *latestAppListVC = [[MarketListViewController alloc] initWithMarketListType:latestType];
        [self.navigationController pushViewController:latestAppListVC animated:YES];
    }
    else if (collectionView.tag == TAG_FENGCE)
    {
        MarketListViewController *latestAppListVC = [[MarketListViewController alloc] initWithMarketListType:marketList_GameFengCeType];
        [self.navigationController pushViewController:latestAppListVC animated:YES];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    refreshHeaderLoading = YES;
    [self performSelector:@selector(pullRequestAll) withObject:nil afterDelay:delayTime];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return refreshHeaderLoading;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [egoRefreshView egoRefreshScrollViewDidScroll:scrollView];
    //
    loopingView.offsetY = scrollView.contentOffset.y;
    CGFloat offset = scrollView.contentSize.height - loopingView.offsetY;
    CGFloat refreshHeight = MainScreen_Height - 20-20+49;
//    NSLog(@"offset: %f",offset);
    if (couldUpwardPullRequest && refreshHeight > offset) {
        scrollEndFlag = NO;
        couldUpwardPullRequest = NO;
        [self requestRankingList];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [egoRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
    //
    hasExecOnce = NO;
    if (!decelerate) {
        hasExecOnce = YES;
        [self reportBaoGuang]; // 曝光
        
        //展示排行榜失败cell
        scrollEndFlag = YES;
        if (rankingListRequestFailedFlag) {
            rankingListRequestFailedFlag = NO;
            couldUpwardPullRequest = YES;
            [self reloadRankingListLoadingCell:CellRequestStyleFailed];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!hasExecOnce) {
        [self reportBaoGuang]; // 曝光度
        
        //展示排行榜失败cell
        scrollEndFlag = YES;
        if (rankingListRequestFailedFlag) {
            rankingListRequestFailedFlag = NO;
            couldUpwardPullRequest = YES;
            [self reloadRankingListLoadingCell:CellRequestStyleFailed];
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(_tableView.contentInset.top+65)) {
        *targetContentOffset = scrollView.contentOffset;
    }
}


#pragma mark - Check Data
- (BOOL)checkListData:(NSDictionary *)dic
{
    if (![dic getNSArrayObjectForKey:@"data"]) return NO;
    
    NSArray *tmpArray = [dic getNSArrayObjectForKey:@"data"];
    for (int i = 0; i < [tmpArray count]; i++) {
        
        NSDictionary *tmpDic = [tmpArray objectAtIndex:i];
        if(!IS_NSDICTIONARY(tmpDic))
            return NO;
        
        if (!([tmpDic getNSStringObjectForKey:@"appdowncount" ] &&
              [tmpDic getNSStringObjectForKey:@"appintro" ] &&
              [tmpDic getNSStringObjectForKey:@"appname" ] &&
              [tmpDic getNSStringObjectForKey:@"appreputation" ] &&
              [tmpDic getNSStringObjectForKey:@"appsize" ] &&
              [tmpDic getNSStringObjectForKey:@"appupdatetime" ] &&
              [tmpDic getNSStringObjectForKey:@"appversion" ] &&
              [tmpDic getNSStringObjectForKey:@"category" ] &&
              [tmpDic getNSStringObjectForKey:@"ipadetailinfor" ] &&
              [tmpDic getNSStringObjectForKey:@"plist" ] &&
              [tmpDic getNSStringObjectForKey:@"share_url" ] &&
              [tmpDic getNSStringObjectForKey:@"appiconurl" ] &&
              [tmpDic getNSStringObjectForKey:@"appid" ])) {
            
            return NO;
        }
    }
    return YES;
}

#pragma mark - public Request

-(void)requestAll
{
    // prepare
    firstRequestFlag = YES;
    backView.status = Loading;
    failedCount = 0;
    
    // send request message
    if (marketType == marketType_App) {
        [self requestLoopingPictures];
        [self requestHotApp];
        [self requestLatestApp];
    }
    else
    {
        [self requestLoopingPictures];
        [self requestHotGameData];
        [self requestLatestGameData];
        [self requestFengceGameData];
    }
    
}

-(void)requestRankingList
{
    [self reloadRankingListLoadingCell:CellRequestStyleLoading];
    //
    if (marketType == marketType_App) {
        [self requestRankingListApp];
    }
    else
    {
        [self requestRankingListGameData];
    }
}

-(void)pullRequestAll
{
    [self hideDownPullRefreshView];
    failedCount = 0; // 展示失败页面标记
    
    if (marketType == marketType_App) {
        [[MarketServerManage getManager] requestLoopPlay:LOOPPALY_APP userData:identifier_NoCache];
        [[MarketServerManage getManager] requestHotAppColumn:identifier_NoCache];
        [[MarketServerManage getManager] requestNewAppColumn:identifier_NoCache];
    }
    else
    {
        [[MarketServerManage getManager] requestLoopPlay:LOOPPALY_GAME userData:identifier_NoCache];
        [[MarketServerManage getManager] requestHotGameColumn:identifier_NoCache];
        [[MarketServerManage getManager] requestNewGameColumn:identifier_NoCache];
        [[MarketServerManage getManager] requestFengCeBetaGameColumn:identifier_NoCache];
    }
}

-(void)reportBaoGuang
{
    // 清空数据
    [reportAppIdArray removeAllObjects];
    
    // 填充数据
    for (UITableViewCell *cell in _tableView.visibleCells) {
        if (cell.tag==cellTag_hot) {
            int itemCount = (hotArray.count>=8)?8:hotArray.count;
            for (int i=0;i<itemCount;i++) {
                [reportAppIdArray addObject:[hotArray[i] objectForKey:@"appid"]];
            }
        }
        else if (cell.tag == cellTag_latest){
            int itemCount = (latestArray.count>=8)?8:latestArray.count;
            for (int i=0 ;i<itemCount ;i++) {
                [reportAppIdArray addObject:[latestArray[i] objectForKey:@"appid"]];
            }
        }
        else if (cell.tag == cellTag_fengCe){
//            int
        }
        else if (cell.tag == cellTag_rankingList)
        {
            [reportAppIdArray addObject:((PublicTableViewCell*)cell).appID];
        }
    }
    
    // 上报数据
    [[ReportManage instance] ReportAppBaoGuang:HOME_PAGE_APP appids:reportAppIdArray];
}

#pragma mark - looping(应用、游戏轮播图)
-(void)requestLoopingPictures
{ // 轮播图
    NSString *loopType = (marketType==marketType_App)?LOOPPALY_APP:LOOPPALY_GAME;
    [[MarketServerManage getManager] getLoopPlayData:loopType userData:identifier];
}

- (void)loopPlayRequestSucess:(NSDictionary*)dataDic loopPlayType:(NSString*)type userData:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    
    NSString *loopingType = (marketType==marketType_App)?LOOPPALY_APP:LOOPPALY_GAME;
    if ([type isEqualToString:loopingType]) {
        /*
         
         关于轮播图：
         返回数据中的lunbo_type (int) 的返回值解释
         1:普通 ----应用详情
         2:免流轮播图(type=jingxuan时会用到)  --- 免流轮播专区列表
         3:公告 --- 公告页
         4:活动
         5:外链（网址）
         */
        
        if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
            loopingArray = [[dataDic objectForKey:@"data"] mutableCopy];
        }
        
        [loopingView setLunbo_data:loopingArray];
        
        __weak typeof(self) mySelf = self;
        __weak NSArray *tmpLoopingPicArr = loopingArray;
        NSString *sourceName = (marketType==marketType_App)?@"app":@"game";
        
        [loopingView setClickWithBlock:^(NSInteger index) {
//            NSLog(@"`````%d",index);
            
            NSDictionary *tmpDic = tmpLoopingPicArr[index];
            int tmpIndex = [[tmpDic objectForKey:@"lunbo_type"] intValue];
            
            switch (tmpIndex) {
                case 1:{ // 应用详情
                    NSDictionary * appInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpLoopingPicArr[index], @"data",
                                              HOME_PAGE_LUNBO(sourceName,index), KEY_DETAILSOURCE, nil];
                    [mySelf showAppDetailViewController:appInfoDic];
                }
                    break;
                case 2:{ // 暂无
                }
                    break;
                case 3:{ // 公告
                    [mySelf showWebView:[tmpDic objectForKey:@"lunbo_url"] withTitle:[tmpDic objectForKey:@"lunbo_intro"]];
                }
                    break;
                case 4:{ // 活动
                    [mySelf showActivity:tmpDic image:nil source:HOME_PAGE_LUNBO(sourceName,index)];
                }
                    break;
                case 5:{ // 外联（本身网页打开）
                    [mySelf showWebView:[tmpDic objectForKey:@"lunbo_url"] withTitle:[tmpDic objectForKey:@"lunbo_intro"]];
                }
                    break;
                case 6:{ // 外链（safari打开）
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[tmpDic objectForKey:@"lunbo_url"]]];
                }
                    break;
                case 7:{ // 专题
                    [mySelf showSpecialView:tmpDic];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    
}

- (void)loopPlayRequestFail:(NSString*)type userData:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    
}

#pragma mark - HotApp(最热应用)
-(void)requestHotApp
{
    [[MarketServerManage getManager] getHotAppColumn:identifier];
}

- (void)hotAppColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self hotAppColumnRequestFail:userData];
        return;
    }
    
    if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
        hotArray = [[dataDic objectForKey:@"data"] mutableCopy];
        [hotVC setAppDisplayInformationValue:hotArray];
    }
    
    // 隐藏loading
    firstRequestFlag = NO;
    backView.status = Hidden;
}

- (void)hotAppColumnRequestFail:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    failedCount++;
    
    // 下拉刷新失败
    if (failedCount==2 && [userData isEqualToString:identifier_NoCache]) {
        [self showDownRefreshFailedLabel];
        return;
    }
    
    // 初次清楚 及 上拉刷新
    if (firstRequestFlag && failedCount==2) {
        backView.status = Failed;
    }
}

#pragma mark - latestApp(最新应用)

-(void)requestLatestApp
{
    [[MarketServerManage getManager] getNewAppColumn:identifier];
}

- (void)newAppColumnRequestSucess:(NSDictionary*)dataDic userData:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self newAppColumnRequestFail:userData];
        return;
    }
    
    if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
        latestArray = [[dataDic objectForKey:@"data"] mutableCopy];
        [latestVC setAppDisplayInformationValue:latestArray];
    }
    
    // 隐藏loading
    firstRequestFlag = NO;
    backView.status = Hidden;
}

-(void)newAppColumnRequestFail:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    failedCount++;
    
    // 下拉刷新失败
    if (failedCount==2 && [userData isEqualToString:identifier_NoCache]) {
        [self showDownRefreshFailedLabel];
        return;
    }
    
    // 初级加载 及 上拉刷新失败
    if (firstRequestFlag && failedCount == 2) {
        backView.status = Failed;
    }
}

#pragma mark - RankingListApp(应用排行榜)

-(void)requestRankingListApp
{
    [[MarketServerManage getManager] getAppRankingListColumn:WEEK_RANKING_LIST pageCount:rankingPageCount userData:identifier];
}

- (void)appRankingListColumnRequestSucess:(NSDictionary*)dataDic rankingList:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self appRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
        return;
    }
    
    //
    [self setRankingListData:[dataDic objectForKey:@"data"]];
    
}

- (void)appRankingListColumnRequestFail:(NSString*)rankingList pageCount:(int)pageCount userData:(id)userData;
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    rankingListRequestFailedFlag = YES;
    if (scrollEndFlag) {
        scrollEndFlag = NO;
        couldUpwardPullRequest = YES;
        [self reloadRankingListLoadingCell:CellRequestStyleFailed];
    }
}

#pragma mark - HotGame(最热游戏)

-(void)requestHotGameData
{
    [[MarketServerManage getManager] getHotGameColumn:identifier];
}

-(void)hotGameColumnRequestSucess:(NSDictionary *)dataDic userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self hotGameColumnRequestFail:userData];
        return;
    }
    
    if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
        hotArray = [[dataDic objectForKey:@"data"] mutableCopy];
        [hotVC setAppDisplayInformationValue:hotArray];
    }
    
    // 隐藏loading
    firstRequestFlag = NO;
    backView.status = Hidden;
}

-(void)hotGameColumnRequestFail:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    failedCount++;
    
    // 下拉刷新失败
    if (failedCount==3 && [userData isEqualToString:identifier_NoCache]) {
        [self showDownRefreshFailedLabel];
        return;
    }
    
    // 上拉刷新 及 初次加载
    if (firstRequestFlag && failedCount==3) {
        backView.status = Failed;
    }
}

#pragma mark - LatestGame(最新游戏)

-(void)requestLatestGameData
{
    [[MarketServerManage getManager] getNewGameColumn:identifier];
}

-(void)newGameColumnRequestSucess:(NSDictionary *)dataDic userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self newGameColumnRequestFail:userData];
        return;
    }
    
    if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
        latestArray = [[dataDic objectForKey:@"data"] mutableCopy];
    }
    
    [latestVC setAppDisplayInformationValue:latestArray];
    
    // 隐藏loading
    firstRequestFlag = NO;
    backView.status = Hidden;
}

-(void)newGameColumnRequestFail:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    failedCount++;
    
    // 下拉刷新失败
    if (failedCount==3 && [userData isEqualToString:identifier_NoCache]) {
        [self showDownRefreshFailedLabel];
        return;
    }
    
    // 上拉刷新 及 初次加载
    if (firstRequestFlag && failedCount == 3) {
        backView.status = Failed;
    }
}

#pragma mark - FengCeGame(封测网游)

-(void)requestFengceGameData
{
    [[MarketServerManage getManager] getFengCeBetaGameColumn:identifier];
}

-(void)FengCeBetaGameColumnRequestSucess:(NSDictionary *)dataDic userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self FengCeBetaGameColumnRequestFail:userData];
        return;
    }
    
    if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
        fengCeArray = [[dataDic objectForKey:@"data"] mutableCopy];
    }
    
    [fengCeVC setAppDisplayInformationValue:fengCeArray];
    
    // 隐藏loading
    firstRequestFlag = NO;
    backView.status = Hidden;
}

-(void)FengCeBetaGameColumnRequestFail:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    failedCount++;
    
    // 下拉刷新失败
    if (failedCount==3 && [userData isEqualToString:identifier_NoCache]) {
        [self showDownRefreshFailedLabel];
        return;
    }
    
    // 上拉刷新 及 初次加载
    if (firstRequestFlag && failedCount == 3) {
        backView.status = Failed;
    }
}

#pragma mark - RankingListGame(游戏排行榜)
-(void)requestRankingListGameData
{
    [[MarketServerManage getManager] getGameRankingListColumn:WEEK_RANKING_LIST pageCount:rankingPageCount userData:identifier];
}

-(void)gameRankingListColumnRequestSucess:(NSDictionary *)dataDic rankingList:(NSString *)rankingList pageCount:(int)pageCount userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    if (![self checkListData:dataDic]) {
        [self gameRankingListColumnRequestFail:rankingList pageCount:pageCount userData:userData];
        return;
    }
    
    //
    [self setRankingListData:[dataDic objectForKey:@"data"]];
}

-(void)gameRankingListColumnRequestFail:(NSString *)rankingList pageCount:(int)pageCount userData:(id)userData
{
    if (![userData isEqualToString:identifier] && ![userData isEqualToString:identifier_NoCache]) return;
    //
    rankingListRequestFailedFlag = YES;
    if (scrollEndFlag) {
        scrollEndFlag = NO;
        couldUpwardPullRequest = YES;
        [self reloadRankingListLoadingCell:CellRequestStyleFailed];
    }
}
@end
