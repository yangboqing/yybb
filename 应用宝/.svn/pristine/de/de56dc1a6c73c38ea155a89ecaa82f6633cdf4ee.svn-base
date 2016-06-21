//
//  AppRelevantTableViewController.m
//  browser
//
//  Created by caohechun on 14-4-17.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "AppRelevantTableViewController.h"
#import "SearchManager.h"
#import "SearchResult_DetailViewController.h"
#import "SearchResultCell.h"
#import "SetDownloadButtonState.h"
@interface AppRelevantTableViewController ()
{
    UILabel *relevantCountLabel;
    NSMutableArray *relevantData;
    SearchManager *searchManager;
}
@end

@implementation AppRelevantTableViewController

- (void)dealloc{
    searchManager.delegate = nil;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    relevantData  = [[NSMutableArray alloc]init];
    searchManager = [[SearchManager alloc]init];
    searchManager.delegate = self;
    
    //用于更新下载按钮状态

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadListData)
                                                 name:ADD_APP_DOWNLOADING
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadListData)
                                                 name:RELOAD_UPDATA_AFTER_SCREEN
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadListData)
                                                 name:RELOADDOWNLOADCOUNT
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadListData)
                                                name:UPDATE_DOWNLOAD_TOPVIEW_COUNT
                                              object:nil];

}

- (void)setRelevantData:(NSArray *)array{
    [relevantData removeAllObjects];
    [relevantData  addObjectsFromArray:array ];
    relevantCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreen_Width, 30)];
    relevantCountLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    relevantCountLabel.textAlignment = NSTextAlignmentCenter;
    relevantCountLabel.font = [UIFont systemFontOfSize:15];
    relevantCountLabel.backgroundColor = CONTENT_BACKGROUND_COLOR;
    relevantCountLabel.text = [NSString stringWithFormat:@"  开发商其他应用 (%lu)",(unsigned long)[relevantData count]];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, MainScreen_Width, 30);
    bgView.backgroundColor  = [UIColor clearColor];
    [bgView addSubview:relevantCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height - 0.5, MainScreen_Width, 0.5)];
    lineView.backgroundColor =  [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    [bgView addSubview:lineView];
    
    return bgView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [relevantData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"relevant";
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *appInfor = relevantData[indexPath.row];
    //初始化cell显示内容
    [cell initCellwithInfor:appInfor];

    //首先还原成默认图
    cell.source = DEVELOPER_OTHER_APP(cell.appID, indexPath.row);
    
    //下载按钮状态
    [cell initDownloadButtonState];
//    SetDownloadButtonState *buttonManager = [[SetDownloadButtonState alloc] init];
//    [buttonManager setDownloadButton:cell.downLoadBtn withAppInforDic:appInfor andDetailSoure:@"relevant" andUserData:buttonManager];

    
    //请求新图片

    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:cell.iconURLString] placeholderImage:_StaticImage.icon_60x60];
    
    return cell;

}
- (void)reloadListData
{
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell *cell = (SearchResultCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.relevantDelegate) {
        [self.relevantDelegate loadAnotherApp_source_relevant:cell.source];
        [self.relevantDelegate showOrHideRotation_relevant:@"show"];
        [self.relevantDelegate loadAnotherApp_relevent:relevantData[indexPath.row]];
    }

}



@end
