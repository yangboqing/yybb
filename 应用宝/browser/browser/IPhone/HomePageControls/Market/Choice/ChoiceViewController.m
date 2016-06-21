//
//  ChoiceViewController.m
//  browser
//
//  Created by niu_o0 on 14-5-19.
//
//

#import "ChoiceViewController.h"
#import "MoreViewController.h"
#import "MarketServerManage.h"
#import "SearchManager.h"
#import "SearchResult_DetailViewController.h"
#import "FindDetailViewController.h"
#import "DetailViewController.h"
#import "DownloadStatus.h"
#import "EGORefreshTableHeaderView.h"
#import "UIWebViewController.h"
#import "RepairAppViewController.h"
#import "AlertLabel.h"
#import "NewFuntionView.h"
#import "CategoryListViewController.h"
#import "GiftWebViewController.h"
#import "NewAddFreeListViewController.h"
#import "ReportManage.h"
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#define LOAD(a) [UIImage imageNamed:a]

#define Repeat_downloads       0

#define IDEN_PULLREFRESH_JINGXUAN @"pullRefreshJingXuanIdens"
#define CHOICE_LOOP_HEIGHT 130*PHONE_SCALE_PARAMETER


@interface ChoiceItem : NSObject

@property (nonatomic, strong) NSArray * content;
@property (nonatomic, strong) UIImage * titleImage;
@property (nonatomic, assign) _CHOICE _choice;

@end

@implementation ChoiceItem

@end

@interface ChoiceViewController () <MarketServerDelegate,SearchManagerDelegate, EGORefreshTableHeaderDelegate>{
    CollectionViewLayout * layout;
    MoreViewController * _moreViewController;
    BOOL _moreCell;
    MarketServerManage * _server;
    EGORefreshTableHeaderView * _refreshHeader;
    SearchResult_DetailViewController * _detail;   //应用详情页
    DetailViewController * _detailViewController;  //专题  详情页
    BOOL no_data;
    NSUInteger _failCount;
    NSArray * rotationArray;
    UIWebViewController * _webViewController;
    CollectionViewBack * _backView;
    AlertLabel *alertLabel; // 下拉刷新失败
    NewFuntionView *newFunctionView;
    CategoryListViewController *freeList;
    GiftWebViewController *giftWeb;
    float newAddFunctionButton_height;
    GiftWebViewController *kaipingWeb;
//    NewAddFreeListViewController *newAddFreeList;
}

@end

@implementation ChoiceViewController


- (CGSize) collectionViewItemSize:(_CHOICE)_choice{
    CGSize size = CGSizeZero;
    switch (_choice) {
        case TOPIC:
            size = CGSizeMake((292/2)*(MainScreen_Width/320), (148/2)*(MainScreen_Width/320));
            break;
        case RECOMMEND:
            size = CGSizeMake(_tableView.bounds.size.width, 176/2);
            break;
//去掉活动
//        case ACTIVITY:
//            size = CGSizeMake(_tableView.bounds.size.width, 93);
//            break;
        default:
            size = CGSizeMake((121/2)*(MainScreen_Width/320), (196/2)*(MainScreen_Width/320));
            break;
    }
    return size;
}

//collction的头部图片集合
- (NSArray *)headImage{
    return @[LOAD(@"cut_03.png"),  LOAD(@"cut_16.png"), LOAD(@"cut_11.png"), LOAD(@"cut_34.png")];//去掉活动 LOAD(@"cut_19.png")
}

- (void)dealloc{
    [_server removeListener:self];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _refreshHeader.egoDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        no_data = YES;
        _failCount = 0;
        _server = [MarketServerManage new];
        [_server addListener:self];
        
        _dataArray = [NSMutableArray new];
        _countDic = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a ni

 
//点击本地推送通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickLocalPush:)
												 name:LOCAL_PUSH_DETAIL
                                               object:nil];
//点击远程通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickRemotePush:)
                                                 name:REMOTE_PUSH
                                               object:nil];
    //点击开屏图
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickKaiping:)
                                                 name:CLICK_KAIPING
                                               object:nil];
    
    [[self headImage] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ChoiceItem * item = [ChoiceItem new];
        item.titleImage = obj;
        item._choice = idx;
        [_dataArray addObject:item];
    }];
    
    
    
    IphoneAppDelegate *appDelegate = (IphoneAppDelegate *)[UIApplication sharedApplication].delegate;
    newAddFunctionButton_height= appDelegate.isSafeURL?NEW_FUNCTION_HEIGHT_SAFEURL:NEW_FUNCTION_HEIGHT;
    
    
    layout = [CollectionViewLayout new];
    //scrollView滚动的方向--垂直
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _tableView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //内部缩小的尺寸-上左下右
    _tableView.contentInset = UIEdgeInsetsMake(newAddFunctionButton_height + CHOICE_LOOP_HEIGHT+ (IOS7 ? 44 : 0), 0, 0, 0);
    
    
   //2.7需要对轮播图片的大小进行处理,兼容新老格式:600*330,640*260

    _rotationView = [[RotationView alloc] initWithFrame:CGRectMake(0, -CHOICE_LOOP_HEIGHT - newAddFunctionButton_height, MainScreen_Width, CHOICE_LOOP_HEIGHT) andScrollTimer:4.0];
    _rotationView.tag = 0;
    
    //_rotationView.hidden = YES;
    
    [_tableView addSubview:_rotationView];
    

    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.shouldGroupAccessibilityChildren = YES;
    
    //collection注册各cell
    [_tableView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_NORMOL];
    [_tableView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_TOPIC];
    //去掉活动
//    [_tableView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_ACTIVITY];
    [_tableView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_RECOMMEND];
    [_tableView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_REQUESTMORE];
    
    //collection头部左侧图片和右侧"全部"按钮
    [_tableView registerClass:[CollectionViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    //下拉刷新
    _refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    _refreshHeader.egoDelegate = self;
    _refreshHeader.inset = _tableView.contentInset;
    [_tableView addSubview:_refreshHeader];
    
    
    _moreViewController = [MoreViewController new];
    _detail = [SearchResult_DetailViewController new];
    _detailViewController = [DetailViewController defaults];
    _webViewController = [UIWebViewController new];
//    _webViewController.view.hidden = YES;
//    [self.view addSubview:_webViewController.view];
    
     ChoiceViewController * __weak mySelf = self;
    EGORefreshTableHeaderView * __weak __refresh = _refreshHeader;
    SearchResult_DetailViewController * __weak __detail = _detail;
    UIWebViewController * __weak __web = _webViewController;
    DetailViewController *__weak __detailViewController = _detailViewController;
    [_rotationView setClickWithBlock:^(NSInteger index) {
        NSDictionary * dic = [[mySelf rotationArray] objectAtIndex:index];
        NSInteger idx = [[dic objectForKey:@"lunbo_type"] integerValue];
//        NSLog(@"idx is %d",idx);
        [__refresh egoRefreshScrollViewDataSourceDidFinishedLoading:nil];
        if (idx == 1){
            [__detail setAppSoure:HOME_PAGE_LUNBO(@"jingxuan", index)];
            [__detail beginPrepareAppContent:[[mySelf rotationArray] objectAtIndex:index]];
            [mySelf.navgationController pushViewController:__detail animated:YES];
        }else if (idx == 3 || idx == 5){
            __web.title = [dic objectForKey:@"lunbo_intro"];
            [__web navigation:[dic objectForKey:@"lunbo_url"]];
            [mySelf.navgationController pushViewController:__web animated:YES];
        } else if (idx == 4){
            FindDetailViewController * __active = [FindDetailViewController new];
            [__active reloadActivityDetailVC:dic];
            [mySelf.navgationController pushViewController:__active animated:YES];
        }

         else if (idx == 6){
            NSURL * url = [NSURL URLWithString:[dic objectForKey:@"lunbo_url"]];
            [[UIApplication sharedApplication] openURL:url];
        }else if (idx == 7){ // 专题
            NSMutableDictionary *specialDic = [NSMutableDictionary dictionary];
            for (NSString *key in dic.allKeys) {
                if ([key isEqualToString:@"zt_id"]) {
                    [specialDic setObject:[dic objectForKey:key] forKey:SPECIALID];
                    continue;
                }
                [specialDic setObject:[dic objectForKey:key] forKey:key];
            }

            [__detailViewController setDetailInfo:specialDic andStyle:_DETAIL_STYLE_TOPIC];
            [mySelf.navgationController pushViewController:__detailViewController animated:YES];
            
        }
        
        
    }];
    
    _rotationView.baoguangBlock = ^(NSInteger index){
        [[ReportManage instance] ReportAppBaoGuang:HOME_PAGE_LUNBO(@"jingxuan", index) appids:nil];
    };
    
    
    //新增功能按钮

    [self setNewAddFunction];
    
    
    
    // 下拉刷新失败Label
    alertLabel = [[AlertLabel alloc] init];
    [self.view addSubview:alertLabel];
    
    //加载中
    _backView = [CollectionViewBack new];
    [_tableView addSubview:_backView];
    [_backView setClickActionWithBlock:^{
        [mySelf failCount:0];
        [mySelf performSelector:@selector(request) withObject:nil afterDelay:delayTime];
    }];
    
    [self setBackView];
    [self request];
    
    

}

- (void)failCount:(NSInteger)index{
    _failCount = index;
}

- (NSArray *)rotationArray{
    return rotationArray;
}

- (void)request{
    
    if (isRequest) {
        [self didRequestData];
        return;
    }
    
    [_server getLoopPlayData:LOOPPALY_JINGXUAN userData:nil];
    
    [_server getHomePageGoodgameAndGoodapp:nil];
    
    //[_server getHomePageGoodgameAndGoodapp:nil];
    
    [_server gethomePageSpecial:nil];
    
    [_server getHomePageActivity:nil];

    //请求礼包
    [_server requestPackageWebUrl:nil];
    
}

-(void)pullRefreshRquest
{
    if (isRequest) {
        [self didRequestData];
        return;
    }
    
    [_server requestLoopPlay:LOOPPALY_JINGXUAN userData:IDEN_PULLREFRESH_JINGXUAN];
    [_server requestHomepageGoodgameAndGoodapp:IDEN_PULLREFRESH_JINGXUAN];
    [_server requestHomepageSpecial:IDEN_PULLREFRESH_JINGXUAN];
//    去掉活动
//    [_server requestHomePageActivity:IDEN_PULLREFRESH_JINGXUAN];
}

- (void)setBackView{
    if (no_data) {
        if (_failCount >= 3) {
            [_backView setStatus:Failed];
        }else{
            [_backView setStatus:Loading];
        }
        _tableView.scrollEnabled = NO;
    }else{
        _backView.status = Hidden;
        _tableView.scrollEnabled = YES;
        if (isLoading) [self didRequestData];
    }
}

-(void)showDownRefreshFailedLabel
{
    CGFloat originY = (IOS7)?44:0;
    [alertLabel startAnimationFromOriginY:originY];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    _tableView.frame = rect;
    CGFloat startY = IOS7 ? 44 : 0;
    _refreshHeader.frame = CGRectMake(0, -rect.size.height-_tableView.contentInset.top+startY, _tableView.bounds.size.width, _tableView.bounds.size.height);
    _backView.frame = _tableView.bounds;
    _webViewController.view.frame = rect;
}
#pragma mark - 设置新增按钮功能区
- (void)setNewAddFunction{
    ChoiceViewController * __weak mySelf = self;
    newFunctionView = [[NewFuntionView alloc]init];

    newFunctionView.frame = CGRectMake(0, _rotationView.frame.origin.y + _rotationView.frame.size.height, _rotationView.frame.size.width, newAddFunctionButton_height);
    
    giftWeb = [[GiftWebViewController alloc]init];
    GiftWebViewController *__weak __giftWeb = giftWeb;
//    newAddFreeList = [[NewAddFreeListViewController alloc]init];
//    MoreViewController * __weak __moreViewController = _moreViewController;
//    NewAddFreeListViewController *__weak __newAddFreeList = newAddFreeList;
    
    [newFunctionView setFunctionButtonBlock:^(int tag) {
        if (tag == FUNCTION_TYPE_FREE) {//免费,包括应用和游戏
            NewAddFreeListViewController *__newAddFreeList = [[NewAddFreeListViewController alloc] init];
            [mySelf.navgationController pushViewController:__newAddFreeList animated:YES];
        }else if (tag == FUNCTION_TYPE_ACTIVITY){//活动
            MoreViewController *  __moreViewController = [[MoreViewController alloc] init];
            [__moreViewController setChoiceView:ACTIVITY];
            [mySelf.navgationController pushViewController:__moreViewController animated:YES];
        }else if (tag == FUNCTION_TYPE_NECESSERY){//必备
            MoreViewController *  __moreViewController = [[MoreViewController alloc] init];
            [__moreViewController setChoiceView:NECESSARY];
            [mySelf.navgationController pushViewController:__moreViewController animated:YES];
        }else if (tag == FUNCTION_TYPE_GIFT){
            mySelf.navgationController.navigationItem.title = @"礼包";
            [__giftWeb loadGiftPage];
            [mySelf.navgationController pushViewController:__giftWeb animated:YES];
        }
        //汇报点击日志
        [[ReportManage instance] reportEnterPage:tag];
        
    }];
    [_tableView addSubview:newFunctionView];
}

#pragma mark - 本地推送
- (void)clickLocalPush:(NSNotification *)noti{
    if (!noti.object) {
        return;
    }
    NSString *type = [noti.object objectForKey:@"push_type"];
    NSString  *ID = [noti.object objectForKey:@"push_type_info"];
    if ([type isEqualToString:LOCAL_PUSH_APP]) {
        //应用详情
        [_detail setAppSoure:@"localPush"];
        [_detail beginPrepareAppContent:@{@"appid": ID}];
        [_navgationController pushViewController:_detail animated:YES];
    }else if ([type isEqualToString:LOCAL_PUSH_HUODONG]){
        //活动详情
        FindDetailViewController * _activeViewController = [FindDetailViewController new];
        [_activeViewController reloadActivityDetailVC:@{@"huodong_id": ID}];
        [_navgationController pushViewController:_activeViewController animated:YES];
    }else if ([type isEqualToString:LOCAL_PUSH_SPECIAL]){
        //专题详情
        [_detailViewController setDetailInfo:@{SPECIALID: ID} andStyle:_DETAIL_STYLE_TOPIC];
        [_navgationController pushViewController:_detailViewController animated:YES];
    }
    
}

- (void)clickRemotePush:(NSNotification *)noti{
    if (!noti.object) {
        return;
    }
    [_navgationController popToRootViewControllerAnimated:NO];

    NSString *type = [noti.object objectForKey:@"push_type"];
    NSString  *ID = [noti.object objectForKey:@"push_detail"];
    if([type isEqualToString:REMOTE_PUSH_APP]&&ID){
        //应用详情
        [_detail setAppSoure:REMOTE_PUSH];
        [_detail beginPrepareAppContent:@{@"appid": ID}];
        [_navgationController pushViewController:_detail animated:YES];
        
        [[ReportManage instance] reportRemoteNotificationClickedWithType:type andContentid:ID];
    }
}

- (void)clickKaiping:(NSNotification *)noti{
    if (!noti.object) {
        return;
    }
    [_navgationController popToRootViewControllerAnimated:NO];
    
    NSString *type = [noti.object objectForKey:@"kaiping_type"];
    NSString  *ID = [noti.object objectForKey:@"kaiping_detail"];
    
    if([type isEqualToString:@"toAppDetail"]&&ID){
        //应用详情
        [_detail setAppSoure:CLICK_KAIPING];
        [_detail beginPrepareAppContent:@{@"appid": ID}];
        [_navgationController pushViewController:_detail animated:YES];
    }else if ([type isEqualToString:@"toWebUrl"]&&ID){
        //url
        kaipingWeb = [[GiftWebViewController alloc] init];
        kaipingWeb.navigationUrl  = [NSURL URLWithString:ID];
        kaipingWeb.isKaipinUrl = YES;
        [kaipingWeb loadGiftPage];
        [_navgationController pushViewController:kaipingWeb animated:YES];
    }
}
#pragma mark - 轮播图


- (void)loopPlayRequestSucess:(NSDictionary *)dataDic loopPlayType:(NSString *)type userData:(id)userData{
    if (![type isEqualToString:LOOPPALY_JINGXUAN]) return;
    
    NSArray * obj = [dataDic objectForKey:@"data"];
    
    if (IS_NSARRAY(obj) && obj.count > 0 )
    rotationArray = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
    [_rotationView setLunbo_data:rotationArray];
}

- (void)loopPlayRequestFail:(NSString *)type userData:(id)userData{
    if (![type isEqualToString:LOOPPALY_JINGXUAN]) return;
    
    static int count = 0;
    
    if (count >= Repeat_downloads) {
        count = 0;
        return;
    }
    
    [_server getLoopPlayData:type userData:nil];
    
    count ++;
}

#pragma mark - 游戏 应用



- (BOOL)checkGoodgameAndApp:(NSDictionary *)dic{
    
    NSDictionary * _dic = [dic getNSDictionaryObjectForKey:@"data"];
    if (!_dic) return NO;
    NSArray * app = [_dic getNSArrayObjectForKey:@"app"];
    if (!app) return NO;
    NSArray * game = [_dic getNSArrayObjectForKey:@"game"];
    if (!game) return NO;
    
    return [_StaticImage check:app] && [_StaticImage check:game];
    
}

- (void)homepageGoodgameAndGoodappRequestSucess:(NSDictionary *)dataDic userData:(id)userData{
    
    if (![self checkGoodgameAndApp:dataDic]) {
        [self homepageGoodgameAndGoodappRequestFail:userData];
        return;
    }
    
    
    no_data = NO;
    
    if (self->isLoading) [self didRequestData];
    [self setBackView];
    NSDictionary * dic = [dataDic objectForKey:@"data"];
    
    if (![dic isKindOfClass:[NSDictionary class]]) return;
    
    ChoiceItem * item = [_dataArray objectAtIndex:APP];
    if ([[dic objectForKey:@"app"] isKindOfClass:[NSArray class]]){
        if ([[dic objectForKey:@"app"] count]) {
            item.content = [dic objectForKey:@"app"];
        }
    }

    item = [_dataArray objectAtIndex:GAME];
    if ([[dic objectForKey:@"game"] isKindOfClass:[NSArray class]]){
        if ([[dic objectForKey:@"game"] count]) {
            item.content = [dic objectForKey:@"game"];
        }
    }
    [_tableView reloadData];

}

- (void)homepageGoodgameAndGoodappRequestFail:(id)userData{
    
    _failCount ++;
    
    if (_failCount >= 3)
    {
        if ([userData isEqualToString:IDEN_PULLREFRESH_JINGXUAN]) {
            if (isLoading) [self didRequestData];
            [self showDownRefreshFailedLabel];
        }
        else
        {
            [self setBackView];
        }
    }
}

#pragma mark - 专题



- (void)homepageSpecialRequestSucess:(NSDictionary *)dataDic userData:(id)userData{
    
    if (![_StaticImage checkSpecial:dataDic]){
        [self homepageSpecialRequestFail:userData];
        return;
    }
    
    no_data = NO;
    
    if (self->isLoading) [self didRequestData];
    
    ChoiceItem * item = [_dataArray objectAtIndex:TOPIC];
    
    NSArray * obj = [dataDic objectForKey:@"data"];
    
    if (IS_NSARRAY(obj) && obj.count > 0 ){
    
        item.content = [dataDic objectForKey:@"data"];

        [_tableView reloadData];

    }
    [self setBackView];
    
}

- (void)homepageSpecialRequestFail:(id)userData{
    
    _failCount ++;
    if (_failCount >= 3)
    {
        if ([userData isEqualToString:IDEN_PULLREFRESH_JINGXUAN]) {
            if (isLoading) [self didRequestData];
            [self showDownRefreshFailedLabel];
        }
        else
        {
            [self setBackView];
        }
    }
}

#pragma mark - 活动
//取消活动
/*
- (void)homePageActivityRequestSucess:(NSDictionary *)dataDic userData:(id)userData{
    
    if (![_StaticImage checkActivity:dataDic]){
        [self homePageActivityRequestFail:userData];
        return;
    }
    
    
    no_data = NO;
    if (self->isLoading) [self didRequestData];

    ChoiceItem * item = [_dataArray objectAtIndex:ACTIVITY];
    
    NSArray * obj = [dataDic objectForKey:@"data"];
    
    if (IS_NSARRAY(obj) && obj.count > 0 ){
        
        item.content = [dataDic objectForKey:@"data"];
        
        [_tableView reloadData];
        
    }
    
    [self setBackView];
    
}

- (void)homePageActivityRequestFail:(id)userData{
    _failCount ++;
    if (_failCount >= 3)
    {
        if ([userData isEqualToString:IDEN_PULLREFRESH_JINGXUAN]) {
            if (isLoading) [self didRequestData];
            [self showDownRefreshFailedLabel];
        }
        else
        {
            [self setBackView];
        }
    }
    
}
*/
#pragma mark - 新增功能区_礼包
- (void)requestPackageWebUrlSucess:(id)userData webUrl:(NSString*)webUrl{
    giftWeb.navigationUrl = [NSURL URLWithString:webUrl];
}
- (void)requestPackageWebUrlFail:(id)userData{
    
}
#pragma mark - 精彩推荐

static int recommend = 1;



- (void)homePageSplendidRecommendRequestSucess:(NSDictionary *)dataDic pageCount:(int)pageCount userData:(id)userData{
    
    if (![_StaticImage checkAppList:dataDic]){
        [self homePageSplendidRecommendRequestFail:pageCount userData:userData];
        return;
    }
    
    
    if ([[[dataDic objectForKey:@"flag"] objectForKey:@"dataend"] isEqualToString:@"n"]) isHave = NO;
    
    no_data = NO;
    
    recommend ++;
    
    ChoiceItem * item = [_dataArray objectAtIndex:RECOMMEND];
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:item.content];
    
    
    NSArray * obj = [dataDic objectForKey:@"data"];
    
    if (IS_NSARRAY(obj) && obj.count > 0 ){
        [array addObjectsFromArray:obj];
    }
    
    isShow = YES;
    item.content = array;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:RECOMMEND]];
    [CATransaction commit];
    
    isRequest = NO;
    
}

- (void)homePageSplendidRecommendRequestFail:(int)pageCount userData:(id)userData{
    
    isShow = NO;
    [_tableView reloadData];
    isRequest = NO;
}

#pragma mark - collectionView delgate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == RECOMMEND) {
        if (indexPath.row == ((ChoiceItem *)[_dataArray objectAtIndex:indexPath.section]).content.count) {
            return REQUESTCELLSIZE;
        }
    }
    
    return [self collectionViewItemSize:indexPath.section];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * view = nil;
    
    view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
    
    CollectionViewHeaderView * head = (CollectionViewHeaderView *)view;
    
    head.indexPath = indexPath;
    
    ChoiceItem * item = [_dataArray objectAtIndex:indexPath.section];
    
    head.imageView.image = item.titleImage;
    
    if (indexPath.section == RECOMMEND) {
        head->_button.hidden = YES;
    }else{
        head->_button.hidden = NO;
    }
    
    
    [head setIndexWithBlock:^(NSIndexPath *indexPath) {
        
        [_moreViewController setChoiceView:indexPath.section];
        [_navgationController pushViewController:_moreViewController animated:YES];
    }];
    
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (no_data) return CGSizeZero;
    
    return CGSizeMake(collectionView.bounds.size.width, 40);//30
}

BOOL isHave = YES;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    ChoiceItem * item = [_dataArray objectAtIndex:section];
    NSInteger count = item.content.count;
    if (section == RECOMMEND) {
        if (isHave && !no_data) {
            return count+1;
        }
        return count;
    }
    if (!no_data){
        if (section == GAME || section == APP) {
            if (!count) return 8;
        }
//        if (section == ACTIVITY) {
//            if (!count) return 2;
//        }
        if (section == TOPIC) {
            if (!count) return 2;
        }
    }
    return ((ChoiceItem *)[_dataArray objectAtIndex:section]).content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionViewCell * cell = nil;
    ChoiceItem * item = [_dataArray objectAtIndex:indexPath.section];

    if (indexPath.section ==TOPIC) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_TOPIC forIndexPath:indexPath] ;
        
        if (!item.content) goto image__;
        
        cell.iconImageView.url = [NSURL URLWithString:[[item.content objectAtIndex:indexPath.row] objectForKey:SPECIAL_PIC_URL]];
        cell.baoguang = [[item.content objectAtIndex:indexPath.row] objectForKey:SPECIALID];
        
    }
    //取消活动
    /*
    else if (indexPath.section == ACTIVITY){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_ACTIVITY forIndexPath:indexPath] ;
        
        if (!item.content) {
            cell.downButton.hidden = YES;
            if (indexPath.row == 1) cell->__view.hidden = YES;
            goto image__;
        }
        
        cell.baoguang = [[item.content objectAtIndex:indexPath.row] objectForKey:@"id"];
        cell.nameLabel.text = [[item.content objectAtIndex:indexPath.row] objectForKey:@"title"];
        [cell layoutSubviews];
        cell.subLabel.text = [[item.content objectAtIndex:indexPath.row] objectForKey:@"date"];
//        cell.downButton.hidden = NO;
//        [cell.downButton setTitle:[[item.content objectAtIndex:indexPath.row] objectForKey:@"view_count"] forState:UIControlStateNormal];
        cell.iconImageView.url = [NSURL URLWithString:[[item.content objectAtIndex:indexPath.row] objectForKey:@"pic_url"]];
        
        //最后一行隐藏cell间隔线
        if (item.content.count-1 == indexPath.row) cell->__view.hidden = YES;
        
    }
     */
    else if (indexPath.section == RECOMMEND){
        
        if (indexPath.row < item.content.count) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_RECOMMEND forIndexPath:indexPath];
            
            if (!item.content) goto image__;
            cell.baoguang = [[item.content objectAtIndex:indexPath.row] objectForKey:APPID];
            cell.iconImageView.url = [NSURL URLWithString:[[item.content objectAtIndex:indexPath.row] objectForKey:APPICON]];
            cell.nameLabel.text = [[item.content objectAtIndex:indexPath.row] objectForKey:APPNAME];
            cell.subLabel.text = [NSString stringWithFormat:@"%@  |  %@",[[item.content objectAtIndex:indexPath.row] objectForKey:APPCATEGROY],[DownloadStatus changeValue:[[item.content objectAtIndex:indexPath.row] objectForKey:APPSIZE] WithValueClass:Value_MB]];      //@"动作游戏  |  694.13M";
            
            [cell.zanButton setTitle:[DownloadStatus changeValue:[[item.content objectAtIndex:indexPath.row] objectForKey:APPREPUTATION] WithValueClass:Value_Count] forState:UIControlStateNormal];
            
            [cell.downButton setTitle:[DownloadStatus changeValue:[[item.content objectAtIndex:indexPath.row] objectForKey:APPDOWNCOUNT] WithValueClass:Value_Count] forState:UIControlStateNormal];
            
            cell.downloadButton.buttonIndexPath = indexPath;
            [DownloadStatus checkButton:cell.downloadButton
                            WithAppInfo:[item.content objectAtIndex:indexPath.row] ];
            
        }else{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_REQUESTMORE forIndexPath:indexPath] ;
            
            if (isShow) {
                [cell.juhua startGif];
            }else{
                [cell.juhua stopGif];
            }
        }

    }else{
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_NORMOL forIndexPath:indexPath] ;
        
        if (!item.content) goto image__;
        
        cell.nameLabel.text = [[item.content objectAtIndex:indexPath.row] objectForKey:APPNAME];
        [cell layoutSubviews];
        cell.iconImageView.url = [NSURL URLWithString:[[item.content objectAtIndex:indexPath.row] objectForKey:APPICON]];
        cell.baoguang = [[item.content objectAtIndex:indexPath.row] objectForKey:APPID];
    }
    
image__:
    

    [cell.iconImageView sd_setImageWithURL:cell.iconImageView.url placeholderImage:[_StaticImage collectionViewItemImage:indexPath.section]];
    
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiceItem * item = [_dataArray objectAtIndex:indexPath.section];
    
    if (!item.content.count) return;
    
    if (indexPath.section == TOPIC) {

        [_detailViewController setDetailInfo:[item.content objectAtIndex:indexPath.row] andStyle:_DETAIL_STYLE_TOPIC];
        [_navgationController pushViewController:_detailViewController animated:YES];
        
        
        
    }
    //取消活动
    /*
    else if (indexPath.section == ACTIVITY){
        
        if ([[[item.content objectAtIndex:indexPath.row] objectForKey:@"content_url_open_type"] integerValue] == 1) {
            FindDetailViewController * _activeViewController = [FindDetailViewController new];
            [_activeViewController reloadActivityDetailVC:[item.content objectAtIndex:indexPath.row]];
            [_navgationController pushViewController:_activeViewController animated:YES];
        }else if ([[[item.content objectAtIndex:indexPath.row] objectForKey:@"content_url_open_type"] integerValue] == 2){
            NSURL * url = [NSURL URLWithString:[[item.content objectAtIndex:indexPath.row] objectForKey:@"content"]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
     */
    else{
        if (item.content.count == indexPath.row) return;
        
        [[ReportManage instance] ReportAppDetailClick:[DownloadStatus dlfrom:indexPath] appid:[[item.content objectAtIndex:indexPath.row] objectForKey:APPID]];
        
        [_detail setAppSoure:[DownloadStatus dlfrom:indexPath]];
        [_detail beginPrepareAppContent:[item.content objectAtIndex:indexPath.row]];
        [_navgationController pushViewController:_detail animated:YES];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == RECOMMEND ) {//取消活动 || section == ACTIVITY
        return 0.0;
    }
    return 11.0;
}

#define ___width 4
#define ____width 2
#define boarder 12
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat wid = self.view.bounds.size.width-[self collectionViewItemSize:section].width * ___width;
    if (section == RECOMMEND ){//取消活动 || section == ACTIVITY
        return 0.0;
    }else if (section == TOPIC){
        wid = self.view.bounds.size.width-[self collectionViewItemSize:section].width * ____width;
        return wid/(____width+1);
    }

    return (wid - boarder*PHONE_SCALE_PARAMETER*2)/(___width - 1);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == RECOMMEND) {
        return UIEdgeInsetsZero;
    }else if (section == TOPIC){
        return UIEdgeInsetsMake(10, 10*(MainScreen_Width/320), 20, 8*(MainScreen_Width/320));
    }
    //取消活动
    /*
     else if (section == ACTIVITY){
        return UIEdgeInsetsMake(0, 0, 11, 0);
    }
     */
    return UIEdgeInsetsMake(10, 12*(MainScreen_Width/320), 12, 12*(MainScreen_Width/320));
}

#pragma mark - 获取更多

static BOOL isRequest = NO;

static BOOL isShow = YES;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _rotationView.offsetY = scrollView.contentOffset.y;
    newFunctionView.frame = CGRectMake(0, _rotationView.frame.origin.y + _rotationView.frame.size.height, _rotationView.frame.size.width, newAddFunctionButton_height);
    
    
    [_refreshHeader egoRefreshScrollViewDidScroll:scrollView];
    
    if (no_data) return;
    if (isRequest) return;
    if (!_dataArray.count) return;
    if (!isHave) return;
    if (isLoading == YES) return;
    
    if (scrollView.contentOffset.y + _tableView.bounds.size.height + 49 >= [_tableView.collectionViewLayout collectionViewContentSize].height) {
        
        
        {
            isRequest = YES;
            isShow = YES;
            [_tableView reloadData];
            [self performSelector:@selector(requestMore) withObject:nil afterDelay:delayTime];
        }
    }
    
}

- (void)requestMore{
    [_server getHomePageSplendidRecommend:recommend userData:nil];
    
}


#pragma mark - 下拉刷新

static bool _deceler = false;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _deceler = true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate && _deceler == false) [self baoguang]; _deceler = false;
    
    if (!no_data) [_refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self baoguang];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (isLoading) {
        return ;
    }
    if (scrollView.contentOffset.y<-(_tableView.contentInset.top+65)) {
        *targetContentOffset = _tableView.contentOffset;
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    isLoading = YES;
    [self performSelector:@selector(pullRefreshRquest) withObject:nil afterDelay:delayTime];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return isLoading;
}

- (void)didRequestData{
    isLoading = NO;
    [_refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}


#pragma mark - button点击事件

#pragma mark - 曝光日志


- (void)baoguang{
    _baoguang(_tableView, [NSIndexPath indexPathForRow:0 inSection:-1]);
}

@end
