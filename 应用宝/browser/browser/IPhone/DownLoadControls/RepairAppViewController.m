//
//  RepairAppViewController.m
//  browser
//
//  Created by liguiyang on 14-12-1.
//
//

#import "RepairAppViewController.h"
#import "EGORefreshTableHeaderView.h" // 下拉刷新
#import "CollectionViewBack.h"
#import "PublicTableViewCell.h"
#import "CustomNavigationBar.h"
#import "AlertLabel.h"

#import "BppDistriPlistManager.h"
#import "IphoneAppDelegate.h"
#import "FileUtil.h"

#define REQUEST_NORMAL @"request_Normal"
#define REQUEST_PULL   @"request_Pull"
#define TAG_CELL_NORMAL 22
#define TAG_CELL_NULL 23

@interface RepairAppViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate,CustomNavigationBarDelegate>
{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL isLoading;
    
    AlertLabel *alertLabel;
    CollectionViewBack *backView;
    
    CGFloat topHeight;
    CGFloat bottomCellHeight;
    CGFloat emptyLabelHeight;
    
    // 7.0系统以上，下载管理处模拟导航条
    UIToolbar *customToolBar;
    CustomNavigationBar *customBar;
    UILabel *lineLabel;
    
    // 返回数据为空时，提示
    UIImageView *faceImgView;
    UIImage *faceImg;
    UILabel *emptyLabel;
    UIView  *emptyView;
    UILabel *coverLabel;//新春版顶部红色背景
}

@property (nonatomic, strong) NSArray *repairAppArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RepairAppViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.repairListType = repairApp_Normal;
    }
    
    return self;
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1 && _repairAppArray.count>0) {
        return _repairAppArray.count;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 || indexPath.section==2) {
        static NSString *bottomCellIden = @"BottomCellIdenitifier";
        UITableViewCell *cell_bottom = [tableView dequeueReusableCellWithIdentifier:bottomCellIden];
        if (cell_bottom == nil) {
            cell_bottom = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bottomCellIden];
            cell_bottom.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_bottom.backgroundColor = [UIColor clearColor];
            cell_bottom.tag = TAG_CELL_NULL;
        }
        
        return cell_bottom;
    }
    
    if (_repairAppArray.count > 0) {
        // section == 0 (有数据的cell)
        static NSString *CellIdentifier = @"informationCellIden";
        PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.tag = TAG_CELL_NORMAL;
        }
        
        // 设置数据源
        cell.downLoadSource = REPAIR_APP(indexPath.row);
        NSDictionary *appInfor = _repairAppArray[indexPath.row];
        NSNumber *number = [appInfor objectForKey:@"appreputation"];
        NSString *reputation = [NSString stringWithFormat:@"%@",number];
        [cell initCellInfoDic:appInfor];
        [cell setNameLabelText:[appInfor objectForKey:@"appname"]];
        [cell setGoodNumberLabelText: reputation];
        [cell setDownloadNumberLabelText:[appInfor objectForKey:@"appdowncount"]];
        [cell setLabelType:[appInfor objectForKey:@"category"] Size:[appInfor objectForKey:@"appsize"]];
        [cell setDetailText:[appInfor objectForKey:@"appintro"]];
        cell.appVersion = [appInfor objectForKey:@"appversion"];
        cell.iconURLString = [appInfor objectForKey:@"appiconurl"];
        cell.previewURLString = [appInfor objectForKey:@"apppreview"];
        //按钮状态显示
        cell.appID = [appInfor objectForKey:@"appid"];
        cell.plistURL = [appInfor objectForKey:@"plist"];
        //加载图片
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:_StaticImage.icon_60x60];
        
        [cell reloadRepairButtonState];
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // section == 0（数据为空cell）
    static NSString *cellEmptyIden = @"emptyCellIdentifier";
    UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:cellEmptyIden];
    if (emptyCell == nil) {
        emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEmptyIden];
        emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [emptyCell addSubview:emptyView];
        emptyCell.tag = TAG_CELL_NULL;
    }
    
    return emptyCell;
    
}

#pragma mark - UITabelViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return topHeight;
    if (indexPath.section == 2) return bottomCellHeight;
    // section == 1
    if (_repairAppArray.count > 0) return PUBLICNOMALCELLHEIGHT;
    
    return self.view.frame.size.height-topHeight-bottomCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshHeaderView egoRefreshScrollViewDidScroll:_tableView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:_tableView];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(_tableView.contentInset.top+65)) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - EGORefreshHeaderViewDelegate

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self performSelector:@selector(requestRepairAppData:) withObject:REQUEST_PULL afterDelay:delayTime];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isLoading;
}

#pragma mark - repairListDelegate

-(void)requestRepairListSucess:(NSDictionary *)dic userData:(id)userData
{
    // 数据检测
    BOOL valueFlag = [self checkListData:dic];
    if (valueFlag) {
        self.repairAppArray = [dic objectForKey:@"data"];
        [self.tableView reloadData];
        
        backView.status = Hidden;
        [self hideRefreshHeaderViewLoading];
    }
    else
    {
        if ([userData isEqualToString:REQUEST_NORMAL]) {
            backView.status = Hidden;
        }
        else
        { // 下拉刷新请求失败
            [self hideRefreshHeaderViewLoading];
        }
        NSLog(@"数据检测失败");
    }
}

-(void)requestRepairListFail:(id)userData
{
    [self execRequestFailedCode:userData];
}

#pragma mark - CustomNavigationBarDelegate

-(void)popCurrentViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_REPAIRAPP_DOWNLOAD object:@"close"];
}

#pragma mark - Utility

-(UIView *)getEmptyView
{
    faceImg = [UIImage imageNamed:@"happy_face.png"];
    faceImgView = [[UIImageView alloc] initWithImage:faceImg];
    
    UIFont  *font = [UIFont fontWithName:@"Helvetica" size:15];
    UIColor *fontColor = [UIColor colorWithRed:132.0/225.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacing = 5.0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font,NSForegroundColorAttributeName:fontColor};
    
    emptyLabel = [[UILabel alloc] init];
    emptyLabel.numberOfLines = 0;
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.attributedText = [[NSAttributedString alloc] initWithString:@"暂时没有可修复的应用\n我们的工作人员正在加班为您处理" attributes:dic];
    
    CGSize size = CGSizeMake(self.view.frame.size.width, 200);
    CGSize labelSize = [emptyLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    emptyLabelHeight = labelSize.height;
    
    
    
    UIView *localEmptyView = [[UIView alloc] init];
    localEmptyView.backgroundColor = [UIColor whiteColor];
    [localEmptyView addSubview:faceImgView];
    [localEmptyView addSubview:emptyLabel];
    
    return localEmptyView;
}

-(void)popRepairAppViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadRepaireList
{
    [self.tableView reloadData];
}

-(void)changeReapirCellState:(NSNotification *)notification
{ // 下载完成 更新按钮状态
    NSString *plistUrl = notification.object;
    if (plistUrl) {
        NSDictionary * dic = [[BppDistriPlistManager getManager] ItemInfoByAttriName:DISTRI_PLIST_URL value:plistUrl];
        NSString *appid = [dic objectForKey:DISTRI_APP_ID];
        
        for (PublicTableViewCell *cell in _tableView.visibleCells) {
            if (cell.tag == TAG_CELL_NORMAL && [cell.appID isEqualToString:appid]) {
                [cell reloadRepairButtonState];
            }
        }
    }
}

-(void)requestRepairAppData:(NSString *)userData
{
    
    // 隐藏下拉刷新
    [self hideRefreshHeaderViewLoading];
}

-(void)hideRefreshHeaderViewLoading
{
    isLoading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

-(void)execRequestFailedCode:(NSString *)userData
{
    if ([userData isEqualToString:REQUEST_NORMAL]) {
        backView.status = Hidden;
    }
    else
    { // 下拉刷新请求失败
        [self hideRefreshHeaderViewLoading];
        [alertLabel startAnimationFromOriginY:topHeight];
    }
}

#pragma mark - checkData

- (BOOL)checkListData:(NSDictionary *)dic
{// 有数据且类型正确、或者数据类型正确、个数为0
    if (!IS_NSARRAY([dic objectForKey:@"data"])) return NO;
    
    NSArray *tmpArray = [dic objectForKey:@"data"];
    if (tmpArray.count < 1) return YES;
    
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


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    topHeight = (IOS7)?64:44;
    bottomCellHeight = (_repairListType==repairApp_Normal)?BOTTOM_HEIGHT:0;
    
    // UI
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] init];
    refreshHeaderView.egoDelegate = self;
    [self.tableView addSubview:refreshHeaderView];
    
    //
    alertLabel = [[AlertLabel alloc] init];
    [self.view addSubview:alertLabel];
    //
    emptyView = [self getEmptyView];
    
    backView = [[CollectionViewBack alloc] init];
    __weak id mySelf = self;
    [backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(requestRepairAppData:) withObject:REQUEST_NORMAL afterDelay:delayTime];
    }];
    [self.view addSubview:backView];
    
    // 请求数据

    
    [self requestRepairAppData:REQUEST_NORMAL];
    backView.status = Loading;
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRepaireList) name:REFRESH_REPAIRAPP_ALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReapirCellState:) name:CHANGE_REPAIRCELL_STATE object:nil];
    
    // 导航
    if (_repairListType == repairApp_DownloadManage) {
        
        customBar = [[CustomNavigationBar alloc] init];
        [customBar showBackButton:YES navigationTitle:@"应用闪退修复" rightButtonType:rightButtonType_NONE];
        customBar.delegate = self;
        
        if (IOS7) { // 模拟导航栏
            customToolBar = [[UIToolbar alloc] init];
//            coverLabel = [[UILabel alloc]init];
//            coverLabel.backgroundColor = NEWYEAR_RED;
//            [customToolBar addSubview:coverLabel];
            customToolBar.clipsToBounds = YES;
            lineLabel = [[UILabel alloc] init];
            lineLabel.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1];
            [customToolBar addSubview:customBar];
            [customToolBar addSubview:lineLabel];
            [self.view addSubview:customToolBar];
        }
        else
        {
            customBar.backgroundColor = WHITE_BACKGROUND_COLOR;
            [self.view addSubview:customBar];
        }
        
    }
    else
    {
        addNavgationBarBackButton(self, popRepairAppViewController);

        self.title = @"应用闪退修复";

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //新春版 白色
    
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont systemFontOfSize:16.0],UITextAttributeFont, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset , nil];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    self.tableView.frame = rect;
    backView.frame = rect;
    refreshHeaderView.frame = CGRectMake(0, -height+topHeight, width, height);
    
    // emptyView
    CGFloat faceWidth = faceImg.size.width*0.5;
    CGFloat faceHeight = faceImg.size.height*0.5;
    CGFloat emptyHeight = height-topHeight-bottomCellHeight;
    CGFloat scaleHeight = 160.0/emptyHeight;
    emptyView.frame = CGRectMake(0, 0, width, emptyHeight);
    faceImgView.frame = CGRectMake((width-faceWidth)*0.5, emptyHeight*scaleHeight, faceWidth, faceHeight);
    emptyLabel.frame = CGRectMake(0, faceImgView.frame.origin.y+faceHeight+(16.0/emptyHeight)*emptyHeight, width, emptyLabelHeight);
    
    // 模拟NavBar
    if (IOS7) {
        customToolBar.frame = CGRectMake(0, 0, rect.size.width, topHeight);
        coverLabel.frame = customToolBar.frame;
        customBar.frame = CGRectMake(0, 20, customBar.frame.size.height, customBar.frame.size.height);
        lineLabel.frame = CGRectMake(0, customToolBar.frame.size.height-0.5, rect.size.width, 0.5);
    }
    else
    {
        customBar.frame = CGRectMake(0, 0, rect.size.width, topHeight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    
    self.repairAppArray = nil;
}

@end
