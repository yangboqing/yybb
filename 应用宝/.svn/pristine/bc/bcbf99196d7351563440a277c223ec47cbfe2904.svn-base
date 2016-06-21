//
//  WallPaperClassifyViewController.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperClassifyViewController.h"
#import "WallPaperClassifyCell.h"
#import "TableViewLoadingCell.h"
#import "EGORefreshTableHeaderView.h"
#import "CollectionViewBack.h"
#import "WallPaperListViewController.h"

static NSString *cellClassifyIden = @"ClassifyCellIdentifier";
static NSString *headerViewIden = @"ClassifyHeaderIdentifier";
static NSString *footerViewIden = @"ClassifyFooterIdentifier";

@interface WallPaperClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DesktopviewManageDelegate>
{
    CGFloat screenWidth;
    CGFloat cellWidth;
    BOOL isLoading;
    UIImage *defalutIcon;
    CollectionViewBack *backView;
}

@property (nonatomic, strong) DesktopViewDataManage *deskTopDataManage;
@property (nonatomic, strong) NSArray *classifyArray;
@property (nonatomic, strong) UICollectionView *tableView;

@end

@implementation WallPaperClassifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        DesktopViewDataManage *deskTopDataManage = [DesktopViewDataManage getManager];
        deskTopDataManage.delegate = self;
        [deskTopDataManage requestMainData];
        self.deskTopDataManage = deskTopDataManage;
    }
    return self;
}

#pragma mark - UICollectionViewDatasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _classifyArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallPaperClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassifyIden forIndexPath:indexPath];
    
    NSDictionary *infoDic = _classifyArray[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"cover"]] placeholderImage:defalutIcon];
    cell.classifyNameLabel.text = [infoDic objectForKey:@"name"];
    cell.classifyUrlStr = [infoDic objectForKey:@"url"];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_classifyArray objectAtIndex:indexPath.row];
    NSString *urlStr = [dic objectForKey:@"url"];
    NSString *title = [dic objectForKey:@"name"];
   WallPaperListViewController * wallPaperListViewController = [[WallPaperListViewController alloc]initWithLeftType:wallPaper_back];
    [wallPaperListViewController initWallPaperList:urlStr dataManage:self.deskTopDataManage AndTitle:title];
    
    //MyNavigationController *nav = (MyNavigationController *)((MarketAppGameViewController_my *)(self.delegate)).navigationController;

    MyNavigationController* navigationController = (MyNavigationController*)self.navigationController;
    [navigationController prepairScreenShot:self];
    [self.navigationController pushViewController:wallPaperListViewController animated:YES];
    wallPaperListViewController.navigationController = self.navigationController;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(5, 5, 0, 5);
    return edgeInset;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}


#pragma mark - DesktopviewManageDelegate



//请求分类列表成功
- (void)requestCategorySucess:(NSArray*)saveArray userData:(id)userData
{
    if ([self checkClassifyWallPaperDataValidity:saveArray]) {
        [self setWallPaperClassifyDatasource:saveArray];
        [self showBackViewStatus:Hidden];
    }
    else
    {
        [self showBackViewStatus:Failed];
    }
    
}


//请求分类列表失败
- (void)requestCategoryFail:(id)userData
{
    [self showBackViewStatus:Failed];
    
}

#pragma mark - Request Methods

-(void)initClassifyRequest
{
    self.deskTopDataManage.delegate = self;
    [self.deskTopDataManage requestCategory:@"initRequest"];
    
    [self showBackViewStatus:Loading];
}

-(void)requestClassifyListData
{
    self.deskTopDataManage.delegate = self;
    [self.deskTopDataManage requestCategory:nil];
}

#pragma mark - Utility

-(void)setWallPaperClassifyDatasource:(NSArray *)array
{
    self.classifyArray = array;
    [self.tableView reloadData];
}

-(void)reloadCollectionView
{
    [self.tableView reloadData];
}


-(void)showBackViewStatus:(Request_status)status
{
    switch (status) {
        case Loading:
            backView.status = Loading;
            break;
        case Failed:
            backView.status = Failed;
            break;
        case Hidden:
            backView.status = Hidden;
            break;
            
        default:
            break;
    }
}

-(BOOL)checkClassifyWallPaperDataValidity:(NSArray *)data
{
    BOOL valid = YES;
    
    if (data == nil || !IS_NSARRAY(data)) {
        valid = NO;
    }
    else
    {
        for (NSDictionary *classifyDic in data) {
            if (IS_NSDICTIONARY(classifyDic) &&
                [classifyDic getNSStringObjectForKey:@"cover"] &&
                [classifyDic getNSStringObjectForKey:@"name"] &&
                [classifyDic getNSStringObjectForKey:@"url"]) {
                continue;
            }
            else
            {
                valid = NO;
                break;
            }
        }
    }
    
    return valid;
}

#pragma mark - Life Cycle


-(void)popMainWallPaper
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"壁纸分类";
//    addNavigationLeftBarButton(leftBarItem_downArrowType, self, @selector(popMainWallPaper));
    addNavigationRightBarButton(rightBarItem_downArrowType, self, @selector(popMainWallPaper));
    //请求数据
    [self.deskTopDataManage requestCategory:nil];
    defalutIcon = [UIImage imageNamed:@"defaultWPClassifyIcon.png"];
    screenWidth = MainScreen_Width;
    cellWidth = (screenWidth-20)/3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[WallPaperClassifyCell class] forCellWithReuseIdentifier:cellClassifyIden];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIden];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.tableView = collectionView;
    [self.view addSubview:_tableView];
    
    backView = [[CollectionViewBack alloc] init];
    __weak typeof(self) mySelf = self;
    [backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(initClassifyRequest) withObject:nil afterDelay:delayTime];
    }];
    [self.view addSubview:backView];
}

-(void)viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height);
    backView.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
