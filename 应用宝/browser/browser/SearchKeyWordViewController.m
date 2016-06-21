//
//  SearchKeyWordViewController.m
//  MyHelper
//
//  Created by liguiyang on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "SearchKeyWordViewController.h"
#import "AssociativeKeywordCell.h" // 联想cell
#import "SearchRecordCell.h" // 历史记录cell
#import "SearchManager.h"
#import "FileUtil.h"

@interface SearchKeyWordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    KeyWordListType keyWordListType;
}
@property (nonatomic, strong) NSArray     *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchKeyWordViewController

- (instancetype)initWithSearchListType:(KeyWordListType)listType
{
    self = [super init];
    if (self) {
        keyWordListType = listType;
    }
    
    return self;
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (keyWordListType==keyWordList_associateKeyWordType) {
        return _dataArray.count;
    }
    
    return (_dataArray.count>20)?20:_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (keyWordList_associateKeyWordType == keyWordListType) {
        static NSString *assoIden = @"associativeIdentifier";
        AssociativeKeywordCell *assoCell = [tableView dequeueReusableCellWithIdentifier:assoIden];
        
        if (assoCell == nil) {
            assoCell = [[AssociativeKeywordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assoIden];
        }
        
        NSDictionary *tmpDic = _dataArray[indexPath.row];
        [assoCell.iconImgView sd_setImageWithURL:[NSURL URLWithString:[tmpDic objectForKey:@"appiconurl"]] placeholderImage:nil];
        assoCell.titleLabel.text = [tmpDic objectForKey:@"appname"];
        
        return assoCell;
        
    }
    
    // 搜索历史记录
    static NSString *recordIden = @"recordIdentifier";
    SearchRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:recordIden];
    if (recordCell == nil) {
        recordCell = [[SearchRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordIden];
        [recordCell.closeBtn addTarget:self action:@selector(deleteSearchHistorykeyWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    recordCell.closeBtn.tag = indexPath.row;
    recordCell.titleLabel.text = [[FileUtil instance]urlDecode:_dataArray[indexPath.row]];
    
    return recordCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyWordWasSelected:)]) {
        NSString *keyWord = @"";
        if (keyWordListType==keyWordList_associateKeyWordType) {
            keyWord = [_dataArray[indexPath.row] objectForKey:@"appname"];
        }
        else
        {
            keyWord = [[FileUtil instance] urlDecode:_dataArray[indexPath.row]];
        }
        
        [_delegate keyWordWasSelected:keyWord];
    }
}

#pragma mark Utility

- (void)setKeyWordDataSource:(NSArray *)dataSource
{
    self.dataArray = dataSource;
    [self.tableView reloadData];
}

- (void)deleteSearchHistorykeyWord:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [[SearchManager getObject] deleteSearchHistoryRecord:btn.tag];
    NSArray *recordArr = [[SearchManager getObject] getSearchHistoryArray];
    [self setKeyWordDataSource:recordArr];
}

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
