//
//  FindListViewController.m
//  KY20Version
//
//  Created by liguiyang on 14-5-19.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "FindListViewController.h"
#import "FindDetailViewController.h" // 发现详情页
#import "RotationView.h" // 轮播图
#import "DetailViewController.h"
#import "CustomNavigationBar.h"
// 加载、失败页
#import "CollectionViewBack.h"
#import "GifView.h"
#import "FindCell.h"
#import "TableViewLoadingCell.h"
#import "AlertLabel.h"

#import "SearchManager.h"
#import "MarketServerManage.h" // 请求类
#import "EGORefreshTableHeaderView.h"
#import "UIWebViewController.h"
#import "SearchResult_DetailViewController.h"
#import "LocalImageManager.h"

#define HEIGHT_CELL 92
#define HEIGHT_BOTTOM 47
#define TAG_CELL_LUNBO 123
#define TAG_CELL_CONTENT 124
#define TAG_CELL_NULL 125


@interface FindListViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MarketServerDelegate,EGORefreshTableHeaderDelegate,SearchManagerDelegate>
{
    // data
    NSArray *loopingPicturesArr; // 轮播图
    NSMutableArray *infoArray; // 活动数据
    NSMutableArray *infoStateArray; //活动点击状态数组（与infoArray对应)
    NSMutableArray *exposureArray; // 曝光数组
    
    // UI
    UILabel *loopingLine;
    RotationView *loopingView; // 轮播图
    SearchResult_DetailViewController *appDetailVC;
    
    // loading、failed
    CollectionViewBack * _backView;
    UIView *footerView;
    
    NSInteger pageNumber;
    BOOL hasNextData; // 是否有下页数据
    BOOL couldPullRefreshFlag; // 是否请求中
    BOOL hasReportFlag; // 是否已上报数据
    BOOL scrollEndFlag; // 是否滚动停止
    BOOL hasReceivedDataFlag; // 已经返回数据
    
    // 下拉刷新
    EGORefreshTableHeaderView * _refreshHeader;
    BOOL isLoading;
    AlertLabel *alertLabel;
    
    UIImage *default_findImage;
    CellRequestStyle lastCellStyle;
    FindColumnType findColumnType;
    NSString *reqIdentifier;
    NSString *reqNoCacheIdentifier;
}

@property (nonatomic, strong) UITableView *findTableView;;
@property (nonatomic, strong) NSMutableArray *activityArray; //本地存储的活动id

@end

@implementation FindListViewController

-(instancetype)initWithFindColumnType:(FindColumnType)columnType
{
    self = [super init];
    if (self) {
        // 请求数据初始化
        findColumnType = columnType;
        reqIdentifier = [NSString stringWithFormat:@"%dTypeReq",columnType];
        reqNoCacheIdentifier = [NSString stringWithFormat:@"%dTypeNoCacheReq",columnType];
        
        infoArray = [NSMutableArray array];
        infoStateArray = [NSMutableArray array];
        exposureArray = [NSMutableArray array];
        [[MarketServerManage getManager] addListener:self];
        
        // 合并类移植
        self.view.backgroundColor = [UIColor grayColor];
        default_findImage = [UIImage imageNamed:@"default_find.png"];
    }
    
    return self;
}

#pragma mark - initialization

-(void)initLoopingPictures
{ // 轮播图
    CGFloat topHeight = IOS7?64:0;
    loopingView = [[RotationView alloc] initWithFrame:CGRectMake(0, topHeight, MainScreen_Width, lunboHeight) andScrollTimer:4.0];
    loopingView.tag = 3;
    loopingView.baoguangBlock = ^(NSInteger index){
        [[ReportManage instance] ReportAppBaoGuang:HOME_PAGE_LUNBO(@"discovery", index) appids:nil];
    };
}

-(void)initAppDetailVC
{
    appDetailVC = [[SearchResult_DetailViewController alloc] init];
}

#pragma mark - RequestData

-(void)initilizationRequest
{
    pageNumber = 1;
    _backView.status = Loading;
    
    // requestData
    if (findColumnType==findColumn_choiceType){
        [self requestLoopingPicture]; // 轮播图
        [self requestActivitiesData];
    }
    else
    {
        [self requestActivitiesData];
    }
}

-(void)downRefreshRquest
{
    switch (findColumnType) {
        case findColumn_choiceType:{ // 精选
            [[MarketServerManage getManager] requestLoopPlay:LOOPPALY_DISCOVERY userData:reqNoCacheIdentifier];
            [[MarketServerManage getManager] requestDiscoverList:1 type:DISCOVER_ALL_LIST userData:reqNoCacheIdentifier];
        }
            break;
        case findColumn_evaluateType:{ // 测评
            [[MarketServerManage getManager] requestDiscoverList:1 type:DISCOVER_TESTEVALUATION_LIST  userData:reqNoCacheIdentifier];
        }
            break;
        case findColumn_informationType:{ // 资讯
            [[MarketServerManage getManager] requestFound:DISCOVER_INFORMATION_LIST page:1 isUseCache:NO userData:reqNoCacheIdentifier];
        }
            break;
        case findColumn_applePieType:{ // 苹果派
            [[MarketServerManage getManager] requestFound:DISCOVER_APPPIE_LIST page:1 isUseCache:NO userData:reqNoCacheIdentifier];
        }
            break;
            
        default:
            break;
    }
    
    //
    [self hideRefreshLoading];
}

-(void)requestLoopingPicture
{
    [[MarketServerManage getManager] getLoopPlayData:LOOPPALY_DISCOVERY userData:nil];
}

-(void)requestActivitiesData
{
    switch (findColumnType) {
        case findColumn_choiceType:{ // 精选
            [[MarketServerManage getManager] getDiscoverList:pageNumber type:DISCOVER_ALL_LIST userData:reqIdentifier];
        }
            break;
        case findColumn_evaluateType:{ // 测评
            [[MarketServerManage getManager] getDiscoverList:pageNumber type:DISCOVER_TESTEVALUATION_LIST userData:reqIdentifier];
        }
            break;
        case findColumn_informationType:{ // 资讯
            [[MarketServerManage getManager] requestFound:DISCOVER_INFORMATION_LIST page:pageNumber isUseCache:YES userData:reqIdentifier];
        }
            break;
        case findColumn_applePieType:{ // 苹果派
            [[MarketServerManage getManager] requestFound:DISCOVER_APPPIE_LIST page:pageNumber isUseCache:YES userData:reqIdentifier];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 曝光度

-(void)reportAppBaoGuang
{// 汇报曝光度
    
    [exposureArray removeAllObjects];
    
    UITableViewCell *cell;
    for (cell in self.findTableView.visibleCells) {
        if (cell.tag == TAG_CELL_CONTENT) {
            NSString *acId = ((FindCell*)cell).identifier;
            [exposureArray addObject:acId];
        }
    }
    
    [[ReportManage instance]ReportAppBaoGuang:PRIVILEGE_ACTIVITY(-1) appids:exposureArray];
    NSLog(@"REPROT APPID: %@",exposureArray);
}

#pragma mark - pullRefresh Animaiton
-(void)pullRefresh
{
    // 请求数据
    [self showLastCellStyle:CellRequestStyleLoading];
    [self requestActivitiesData];
    
}

#pragma mark - Utility

-(void)pushDetailViewController:(UIViewController*)VC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(findNavControllerPushViewController:)]) {
        [self.delegate findNavControllerPushViewController:VC];
    }
}

-(void)showloopingPictureDetailView:(NSInteger)index
{ // loopingPicture block call;
    if (loopingPicturesArr != nil) {
        [self showDetailInformation:loopingPicturesArr[index] withSource:HOME_PAGE_LUNBO(@"discovery", index) shareImage:nil];
    }
}

-(void)showDetailInformation:(NSDictionary *)infoDic withSource:(NSString *)fromSource shareImage:(UIImage *)img
{
    FindDetailViewController * findDetailViewController = [[FindDetailViewController alloc] init];
    findDetailViewController.fromSource = fromSource;
    findDetailViewController.shareImage = img;
    findDetailViewController.content = [infoDic objectForKey:@"content"];
    [findDetailViewController reloadActivityDetailVC:infoDic];
    [self pushDetailViewController:findDetailViewController];
}

-(void)showWebPageInSafari:(NSString *)urlStr
{
    NSURL *url =  [NSURL URLWithString:urlStr];
    if (url.absoluteString.length > 0) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)setTableViewListData:(NSArray *)array userData:(NSString *)userData
{ // 将请求回的数据添加到数据中，将其对应的是否点击过的状态也保存到数据中
    if (array == nil) {
        return ;
    }
    
    // 下拉刷新
    if ([userData isEqualToString:reqNoCacheIdentifier]) {
        [infoArray removeAllObjects];
        pageNumber = 1;
    }
    
    for ( int i= 0; i<array.count; i++) {
        [infoArray addObject:array[i]];
    }
    [self refreshAcvitityStateArray];
    
    // 界面
    [self.findTableView reloadData];
    
    // 下次请求页数+1
    pageNumber++;
}

-(BOOL)isClickedActivityId:(NSString *)acId
{
    __block BOOL clickedFlag = NO;
    [_activityArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:acId]) {
            clickedFlag = YES;
            *stop = YES;
        }
    }];
    
    return clickedFlag;
}

-(void)refreshAcvitityStateArray
{ // 刷新与列表数据对应的状态数据（是否点击过）
    [infoStateArray removeAllObjects];
    
    [infoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self isClickedActivityId:[obj objectForKey:@"id"]]) {
            [infoStateArray addObject:@"y"];
        }
        else
        {
            [infoStateArray addObject:@"n"];
        }
    }];
}

-(void)refreshStoredActivityArray
{
    self.activityArray = [[SearchManager getObject] getActivityIDs];
}

-(void)showLastCellStyle:(CellRequestStyle)style
{
    [self reloadLastCellStyle:style];
}

-(void)showDownRefreshFailedAlertLabel
{
    CGFloat originY = (IOS7)?64:0;
    [alertLabel startAnimationFromOriginY:originY];
}

-(void)executeFailedCode:(NSString *)userData
{
    if (![userData isEqualToString:reqIdentifier] && ![userData isEqualToString:reqNoCacheIdentifier]) return;
    
    if (pageNumber != 1) {
        // 上/下拉刷新失败
        hasReceivedDataFlag = YES;
        if (scrollEndFlag) {
            scrollEndFlag = NO;
            
            couldPullRefreshFlag = YES;
            [self showLastCellStyle:CellRequestStyleFailed];
        }
        
        // 下拉刷新
        if ([userData isEqualToString:reqNoCacheIdentifier]) {
            [self showDownRefreshFailedAlertLabel];
        }
    }
    else
    {
        _backView.status = Failed;
    }
}

-(BOOL)checkDataEndFlag:(NSDictionary *)dataDic
{
    BOOL endFlag = NO;
    if (IS_NSDICTIONARY([dataDic objectForKey:@"flag"])) {
        NSString *flagStr = [[dataDic objectForKey:@"flag"] getNSStringObjectForKey:@"dataend"];
        if (flagStr) {
            endFlag = YES;
        }
    }
    
    return endFlag;
}

-(BOOL)checkData:(NSDictionary *)dataDic
{
    BOOL typeFlag = NO;
    if (IS_NSDICTIONARY(dataDic)) {
        
        NSArray *tmpArr = [dataDic getNSArrayObjectForKey:@"data"];
        if (tmpArr) {
            for (id obj in tmpArr) {
                if (IS_NSDICTIONARY(obj)) {
                    if ([obj getNSStringObjectForKey:@"title"] &&
                        [obj getNSStringObjectForKey:@"pic_url"] &&
                        [obj getNSStringObjectForKey:@"date"] &&
                        [obj getNSStringObjectForKey:@"content"] &&
                        [obj getNSStringObjectForKey:@"content_url_open_type"] &&
                        [obj getNSStringObjectForKey:@"id"])
                    {
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

-(void)reloadLastCellStyle:(CellRequestStyle)style
{
    if (hasNextData) {
        lastCellStyle = style;
        int lastIndex = infoArray.count+1;
        [self.findTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)setCustomFrame
{
    CGFloat topHeight = (IOS7)?64:0;
    CGFloat offset = (IOS7)?0:64;
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rect = CGRectMake(0, 0, frame.size.width,frame.size.height-offset);
    
    self.findTableView.frame = rect;
    _refreshHeader.frame = CGRectMake(0, -_findTableView.bounds.size.height+topHeight, _findTableView.bounds.size.width, _findTableView.bounds.size.height);
    _backView.frame = rect;
}

#pragma mark - lunbo action
//外链
- (void)GOActive:(NSString *)URL andTitle:(NSString *)titleName
{
    UIWebViewController *webView = [[UIWebViewController alloc] init];
    webView.title = titleName;
    [webView navigation:URL];
    [self pushDetailViewController:webView];
}

// app detail

-(void)showAppDetailVC:(NSDictionary *)dic LunboIndex:(NSInteger)index
{
    [appDetailVC setAppSoure:HOME_PAGE_LUNBO(@"discovery",index)];
    appDetailVC.view.hidden = NO;
    [appDetailVC hideDetailTableView];
    appDetailVC.BG.hidden = NO;
    [appDetailVC beginPrepareAppContent:dic];
    [self pushDetailViewController:appDetailVC];
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
    [self pushDetailViewController:specialDetailVC];
    
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hasNextData?infoArray.count+2:infoArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // 轮播图 或 空Cell
        
        if (findColumnType == findColumn_choiceType) {
            static NSString *loopingIden = @"cellLoopingIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loopingIden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loopingIden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = TAG_CELL_LUNBO;
                [self initLoopingPictures];
                
                CGFloat topHeight = IOS7?64:0;
                loopingLine = [[UILabel alloc] init];
                loopingLine.frame = CGRectMake(10, topHeight+lunboHeight, self.view.frame.size.width-10, 0.5);
                loopingLine.backgroundColor = hllColor(212, 212, 212, 1.0);
                
                [cell addSubview:loopingLine];
                [cell addSubview:loopingView];
            }
            
            return cell;
        }
        else
        { // 空cell
            static NSString *nullIden = @"NULLIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nullIden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nullIden];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = TAG_CELL_NULL;
            }
            
            return cell;
        }
    }
    else if(indexPath.row <= infoArray.count)
    { // 内容cell
        static NSString *CellIdentifier = @"ChoiceCellIden";
        FindCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[FindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.tag = TAG_CELL_CONTENT;
        }
        
        // set value
        NSDictionary *infoDic = infoArray[indexPath.row-1];
        cell.titleLabel.text = [infoDic objectForKey:@"title"];
        cell.timeLabel.text  = [infoDic objectForKey:@"date"];
        cell.identifier = [infoDic objectForKey:@"id"];
        
        // 缩略图
        NSString *picUrl = [infoDic objectForKey:@"pic_url"];
        [cell.thumbnailView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:default_findImage];
        
        // 颜色样式
        if ([infoStateArray[indexPath.row-1] isEqualToString:@"y"]) {
            [cell setClickState:Click_YES];
        }
        else
        {
            [cell setClickState:Click_NO];
        }
        
        //
        [cell setCustomFrame];
        
        return cell;
    }
    
    // lastCell
    static NSString *cellLoadingIden = @"LoadingCellIdentifier";
    TableViewLoadingCell *cell_loading = [tableView dequeueReusableCellWithIdentifier:cellLoadingIden];
    if (cell_loading == nil) {
        cell_loading = [[TableViewLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadingIden];
        cell_loading.tag = TAG_CELL_NULL;
        cell_loading.identifier = nil;
    }
    
    [cell_loading setStyle:lastCellStyle];
    
    return cell_loading;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat topHeight = IOS7?64:0;
    
    if (findColumnType == findColumn_choiceType) { // 精选
        if (indexPath.row == 0) {
            return lunboHeight+topHeight+0.5;
        }
        else if (indexPath.row <= infoArray.count)
        {
            return HEIGHT_CELL;
        }
        
        return 44;
    }
    
    // 评测、资讯、苹果派
    if (indexPath.row==0) {
        return topHeight;
    }
    else if (indexPath.row <= infoArray.count) {
        return HEIGHT_CELL;
    }
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row>0 && indexPath.row <= infoArray.count) {
        
        NSDictionary *dic = infoArray[indexPath.row-1];
        NSString *picUrlKey = [dic objectForKey:@"pic_url"];
        NSString *source = PRIVILEGE_ACTIVITY(indexPath.row-1);
        
        // 打开方式
        NSInteger openType = [[dic objectForKey:@"content_url_open_type"] integerValue];
        if (openType == 1) {
            [self showDetailInformation:dic withSource:source shareImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:picUrlKey]];
        }
        else if (openType == 2)
        {
            [self showWebPageInSafari:[dic objectForKey:@"content"]];
            
            // 刷新列表选中界面
            [[SearchManager getObject] storeActivityId:[dic objectForKey:@"id"]];
            [self refreshStoredActivityArray];
            [self refreshAcvitityStateArray];
            [self.findTableView reloadData];
        }
        
        // 汇报点击
        [[ReportManage instance] ReportAppDetailClick:source appid:[dic objectForKey:@"id"]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return BOTTOM_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footerView;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    loopingView.offsetY = scrollView.contentOffset.y;
    [_refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    
    // 上拉刷新
    CGFloat refreshHeight = self.view.frame.size.height+49; // 底部导航条的高度
    if (couldPullRefreshFlag && hasNextData && scrollView.contentSize.height-scrollView.contentOffset.y < refreshHeight) {
        
        couldPullRefreshFlag = NO;
        scrollEndFlag = NO;
        hasReceivedDataFlag = NO;
        
        [self pullRefresh];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    
    hasReportFlag = NO;
    if (!decelerate) {
        hasReportFlag = YES;
        // 曝光量
        [self reportAppBaoGuang];
        
        // 展示失败cell
        scrollEndFlag = YES;
        if (hasReceivedDataFlag) {
            hasReceivedDataFlag = NO;
            couldPullRefreshFlag = YES;
            
            [self showLastCellStyle:CellRequestStyleFailed];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!hasReportFlag) {
        hasReportFlag = YES;
        // 曝光量
        [self reportAppBaoGuang];
        
        // 展示失败cell
        scrollEndFlag = YES;
        if (hasReceivedDataFlag) {
            hasReceivedDataFlag = NO;
            couldPullRefreshFlag = YES;
            
            [self showLastCellStyle:CellRequestStyleFailed];
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(_findTableView.contentInset.top+65)) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - 下拉刷新

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    isLoading = YES;
    [self performSelector:@selector(downRefreshRquest) withObject:nil afterDelay:delayTime];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return isLoading;
}

- (void)hideRefreshLoading{
    isLoading = NO;
    [_refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:_findTableView];
}

#pragma mark - MarketServerDelegate（轮播_精选、评测、资讯、苹果派）

-(void)loopPlayRequestSucess:(NSDictionary *)dataDic loopPlayType:(NSString *)type userData:(id)userData
{ // 轮播图
    
    if (findColumnType!=findColumn_choiceType) return; // 非精选返回
    
    if ([type isEqualToString:LOOPPALY_DISCOVERY]) {
        
        if (IS_NSARRAY([dataDic objectForKey:@"data"])) {
            
            loopingPicturesArr = [dataDic objectForKey:@"data"];
            [loopingView setLunbo_data:loopingPicturesArr];
            
            __weak NSArray *tmpLoopingPicArr = loopingPicturesArr;
            __weak FindListViewController *tmpSelf = self;
            [loopingView setClickWithBlock:^(NSInteger index) {
                
                NSDictionary *tmpDic = tmpLoopingPicArr[index];
                int tmpIndex = [[tmpDic objectForKey:@"lunbo_type"] intValue];
                NSString *appId = @"";
                switch (tmpIndex) {
                    case 1:{ // 应用详情
                        [tmpSelf showAppDetailVC:tmpDic LunboIndex:index];
                        appId = [tmpDic objectForKey:@"appid"];
                    }
                        break;
                    case 2:{ //暂无
                    }
                        break;
                    case 3:{ // 公告
                        [tmpSelf GOActive:[tmpDic objectForKey:@"lunbo_url"] andTitle:[tmpDic objectForKey:@"lunbo_intro"]];
                        appId = [tmpDic objectForKey:@"huodong_id"];
                    }
                        break;
                    case 4:{ // 活动
                        [tmpSelf showloopingPictureDetailView:index];
                        appId = [tmpDic objectForKey:@"huodong_id"];
                    }
                        break;
                    case 5:{ // 外联（快用打开）
                        [tmpSelf GOActive:[tmpDic objectForKey:@"lunbo_url"] andTitle:[tmpDic objectForKey:@"lunbo_intro"]];
                        appId = [tmpDic objectForKey:@"huodong_id"];
                    }
                        break;
                    case 6:{ // 外链（safari打开）
                        [tmpSelf showWebPageInSafari:[tmpDic objectForKey:@"lunbo_url"]];
                        appId = [tmpDic objectForKey:@"huodong_id"];
                    }
                        break;
                    case 7:{ // 专题
                        [tmpSelf showSpecialView:tmpDic];
                        appId = [tmpDic objectForKey:@"zt_id"];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                // 点击量汇报
                [[ReportManage instance] ReportAppDetailClick:HOME_PAGE_LUNBO(@"discovery", index) appid:appId];
            }];
            
        }
    }
}

-(void)loopPlayRequestFail:(NSString *)type userData:(id)userData
{
    if ([type isEqualToString:@"discovery"]) {
        NSLog(@"loopPlayRequestFail: %@",userData);
    }
}

- (void)discoverListRequestSucess:(NSDictionary*)dataDic pageCount:(int)pageCount type:(NSString*)type userData:(id)userData;
{ // 精选、评测
    
    if (![userData isEqualToString:reqIdentifier] && ![userData isEqualToString:reqNoCacheIdentifier]) return;
    
    // 是否有下一页 标识
    if ([self checkDataEndFlag:dataDic]) {
        if ([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]) {
            hasNextData = YES;
            couldPullRefreshFlag = YES;
        }
        else
        {
            hasNextData = NO;
            couldPullRefreshFlag = NO;
        }
    }
    else
    {
        hasNextData = NO;
        
    }
    
    // 验证数据类型
    if ([self checkData:dataDic]) {
        [self setTableViewListData:[dataDic objectForKey:@"data"] userData:userData];
    }
    
    // 初次请求成功
    if (pageNumber == 2) {
        _backView.status = Hidden;;
    }
}

- (void)discoverListRequestFail:(int)pageCount type:(NSString*)type userData:(id)userData;
{ // 精选失败
    [self executeFailedCode:userData];
}

-(void)FoundRequestSucess:(NSDictionary *)dataDic type:(NSString *)type pageCount:(int)pageCount userData:(id)userData isUseCache:(BOOL)isUseCache
{ // 成功：资讯、苹果派
    
    if (![userData isEqualToString:reqIdentifier] && ![userData isEqualToString:reqNoCacheIdentifier]) return;
    
    // 是否有下一页 标识
    if ([self checkDataEndFlag:dataDic]) {
        if ([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"y"]) {
            hasNextData = YES;
            couldPullRefreshFlag = YES;
        }
        else
        {
            hasNextData = NO;
            couldPullRefreshFlag = NO;
        }
    }
    else
    {
        hasNextData = NO;
    }
    
    // 验证数据类型
    if ([self checkData:dataDic]) {
        [self setTableViewListData:[dataDic objectForKey:@"data"] userData:userData];
    }
    
    // 初次请求成功
    if (pageNumber == 2) {
        _backView.status = Hidden;;
    }
}

-(void)FoundRequestFail:(NSString *)type pageCount:(int)pageCount userData:(id)userData isUseCache:(BOOL)isUseCache
{ // 失败：资讯、苹果派
    [self executeFailedCode:userData];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 初始化主界面
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.findTableView = tableView;
    
    _refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    _refreshHeader.egoDelegate = self;
    _refreshHeader.inset = self.findTableView.contentInset;
    [self.findTableView addSubview:_refreshHeader];
    
    alertLabel = [[AlertLabel alloc] init];
    [self.view addSubview:alertLabel];
    
    _backView = [CollectionViewBack new];
    __weak typeof(self) mySelf = self;
    [_backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(initilizationRequest) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:_backView];
    
    // setFrame
    [self setCustomFrame];
    
    // tableview footer
    footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    [self initAppDetailVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 刷新存储的活动id(被点击过的)
    [self refreshStoredActivityArray];
    [self refreshAcvitityStateArray];
    [self.findTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[MarketServerManage getManager] removeListener:self];
}

@end
