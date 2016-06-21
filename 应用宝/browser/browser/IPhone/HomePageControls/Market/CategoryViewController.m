//
//  CategoryViewController.m
//  browser
//
//  Created by caohechun on 14-5-23.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "CategoryViewController.h"
#import "CategoryCell.h"
#import "SearchServerManage.h"
#import "MarketServerManage.h"
#import "CollectionViewBack.h"
#define BORDER_X1 10
#define BORDER_X2 8
#define BORDER_Y1 10
#define BORDER_Y2 6
#define CELL_WIDTH ((MainScreen_Width-BORDER_X1*2-BORDER_X2*2)/3) //95
#define CELL_HEIGHT CELL_WIDTH*45/95  //45
@interface CategoryViewController ()
{

    UIScrollView *gameScrollView;//游戏分类
    UIScrollView *appScrollView;//应用分类
    UIButton *bottom;//底部拉杆

    NSMutableArray *gameData;//游戏分类数据
    NSMutableArray *appData;//应用分裂数据
    NSString *currentSearchKey;//当前查看的小分类名称,如应用分类的工具小分类
    NSRange currentSelectedCategoryTag;//当前选取的小分类的按钮tag值,location表示game还是app,length表示tag
    
    CategoryCell *selectedCell;
    MarketServerManage *maketServerManage;
    BOOL isCellLocked;//小分类是否锁定禁止点击
    UIImageView *bg;//背景
    CollectionViewBack * _backView;//加载中
    NSString *gameOrApp;//当前选择的哪个按钮
    CGPoint currentLocation;
    CGPoint beginLocation;

}
@end

@implementation CategoryViewController
- (void)dealloc{
    [[MarketServerManage getManager]removeListener:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    bg = [[UIImageView alloc]init];
    SET_IMAGE(bg.image, @"category_bg.png");
    if (IOS7) {
            bg.frame = CGRectMake(0, 20, MainScreen_Width, MainScreen_Height - 20- 20 -44 -BOTTOM_HEIGHT);
    }else{
            bg.frame = CGRectMake(0, 0, MainScreen_Width, MainScreen_Height - 20 -44 -BOTTOM_HEIGHT);
    }

    bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearCategory)];
    [bg addGestureRecognizer:tap];
    
    //分类拉杆上滑收起手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self  action:@selector(disappearCategory)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [bg addGestureRecognizer:swipe];
    [self.view addSubview:bg];
    
 
    gameData = [[NSMutableArray alloc]init];
    appData = [[NSMutableArray alloc]init];
    for (int i = 0; i<50; i++) {
        [gameData addObject:@"111"];
        [appData addObject:@"222"];
    }

    gameScrollView = [[ UIScrollView alloc]init];
    gameScrollView.backgroundColor = [UIColor clearColor];
    gameScrollView.hidden = YES;
    gameScrollView.tag = 999;
    [self.view addSubview:gameScrollView];
    
    appScrollView = [[ UIScrollView alloc]init];
    appScrollView.backgroundColor = [UIColor clearColor];
    appScrollView.hidden = YES;
    appScrollView.tag = 998;
    [self.view addSubview:appScrollView];

    [self initScrollView:gameScrollView andData:nil];
    [self initScrollView:appScrollView andData:nil];
    
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    [[MarketServerManage getManager] addListener:self];

    //加载中
    __weak typeof(self) mySelf = self;
    _backView = [CollectionViewBack new];
    [self.view addSubview:_backView];
    [_backView setClickActionWithBlock:^{
        [mySelf performSelector:@selector(loadFailedViewHasBeenTap) withObject:nil afterDelay:delayTime];
    }];
}
- (void)loadFailedViewHasBeenTap{
    [self requestCategoryData:gameOrApp];
}
- (void)loadingData{
    [_backView setStatus:Loading];
    gameScrollView.hidden = YES;
    appScrollView.hidden = YES;
}
- (void)loadingDataSuccess{
    [_backView setStatus:Hidden];
}
- (void)loadingDataFailed{
    [_backView setStatus:Failed];
    gameScrollView.hidden = YES;
    appScrollView.hidden = YES;
}

//通过处理触摸解决添加swipe手势不起作用的问题

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = [touches anyObject];
    beginLocation = [touch locationInView:bg];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = [touches anyObject];
    currentLocation = [touch locationInView:bg];
    if (beginLocation.y - currentLocation.y> 3) {
        [self disappearCategory];
    }
}
- (void)disappearCategory{
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_CATEGORY object:nil];
}

- (void)initScrollView:(UIScrollView *)scrollView andData:(NSArray *)theData{
    if (!theData) {
        return;
    }
    
    for (UIView *view in scrollView.subviews) {
        view.hidden = YES;
    }
    int row_count = [theData count] /3 + ([theData count]%3>0?1:0);
    scrollView.contentSize = CGSizeMake(MainScreen_Width, BORDER_Y1 *2 + (BORDER_Y2 + CELL_HEIGHT) * row_count - BORDER_Y2);
    for (int i = 0; i<row_count; i++) {
        
        for (int j = 0; j<3; j++) {
            int index =  i * 3+ j ;
            if (index >= [theData count]) {
                break;
            }
            if (![scrollView viewWithTag:1000 + index]) {
                CategoryCell *cell = [[CategoryCell alloc]initWithFrame:CGRectMake(BORDER_X1 + (BORDER_X2 +CELL_WIDTH)  * j, BORDER_Y1 + (BORDER_Y2 + CELL_HEIGHT) * i, CELL_WIDTH, CELL_HEIGHT)];
                 cell.tag = 1000 + index;
                [scrollView addSubview:cell];
//                
//                //添加手势用于过滤双击,避免双击同一个cell导致异常
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCategoryDetail:)];
                singleTap.numberOfTapsRequired = 1;
                [cell.categoryDetialButton addGestureRecognizer:singleTap];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCategoryDetail:)];
                doubleTap.numberOfTapsRequired = 2;
                [cell.categoryDetialButton addGestureRecognizer:doubleTap];
                
//                [cell.categoryDetialButton  addTarget:self action:@selector(showCategoryDetail:) forControlEvents:UIControlEventTouchUpInside];
                [singleTap requireGestureRecognizerToFail:doubleTap];
            }
            CategoryCell *cell = (CategoryCell *)[scrollView viewWithTag:1000 + index];
            cell.hidden  = NO;
            NSString *name = [theData[index] objectForKey:@"category_name"];
            NSString *count = [theData[index] objectForKey:@"category_count"];
            NSString *categoryID  = [ theData[index] objectForKey:@"category_id"];
            [cell setCategoryName:name andCount:count andID:categoryID];
         }
    }
}

- (void)showAppOrGameCategory:(NSString *)gameOrApp_{
    if ([gameOrApp_ isEqualToString:CLASSIFY_GAME]) {
        gameScrollView.hidden = NO;
        appScrollView.hidden  = YES;
    }else{
        gameScrollView.hidden = YES;
        appScrollView.hidden  = NO;
    }
}

- (void)requestCategoryData:(NSString *)gameOrApp_{
    gameOrApp = gameOrApp_;
    //请求分类数据
    [[MarketServerManage getManager] getClassifyList:gameOrApp userData:gameOrApp];
    [self loadingData];
}

- (void) setCellSelected:(UIButton *)button{
    CategoryCell *cell = nil;
    cell = (CategoryCell *)(button.superview);
    selectedCell = cell;
    [cell setTitileColorSelected:YES];
    if (currentSelectedCategoryTag.length != 0) {
        if (gameScrollView.hidden==currentSelectedCategoryTag.location&&cell.tag == currentSelectedCategoryTag.length) {
            return;
        }
        cell = (CategoryCell *)[ (currentSelectedCategoryTag.location==0?gameScrollView:appScrollView) viewWithTag:currentSelectedCategoryTag.length];
        [cell setTitileColorSelected:NO];
    }
    currentSelectedCategoryTag = NSMakeRange([button.superview.superview isEqual:gameScrollView]?0:1, button.superview.tag) ;
    
}

- (void)setCategory:(NSString *)gameOrApp_ withData:(id)data{
//    gameData = data;
    UIScrollView *scrollView = [gameOrApp_ isEqualToString:CLASSIFY_GAME]?gameScrollView:appScrollView;
    [self initScrollView:scrollView andData:data];
}
#pragma mark - 
#pragma mark 点击某一个小分类,显示该分类下的应用列表
//点击某一个小分类,显示该分类下的应用列表

- (void)showCategoryDetail:(id)sender{
    //禁止同时点击多个cell
    if (isCellLocked) {
        return;
    }
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//    [self setScrollViewLock:YES];
    isCellLocked = YES;
    [self performSelector:@selector(unlockCell) withObject:nil afterDelay:2];
    //设置按钮颜色
    [self setCellSelected:(UIButton *)(tap.view)];
    //请求数据
    currentSearchKey = [selectedCell getCategoryID];
//    self.view.frame = CGRectMake(0, - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_CATEGORY_LIST object:nil];
    [[MarketServerManage getManager] getClassifyApp:currentSearchKey pageCount:1 userData:currentSearchKey];
//    NSLog(@"currentSearchKey~~%@",currentSearchKey);
    
}
- (void)lockUserInterActive:(BOOL)lock{
    gameScrollView.userInteractionEnabled = !lock;
    appScrollView.userInteractionEnabled = !lock;
    bg.userInteractionEnabled = !lock;
}
- (void)unlockCell{
    isCellLocked = NO;
}
- (void)setScrollViewLock:(BOOL)lock{
    appScrollView.userInteractionEnabled = !lock;
    gameScrollView.userInteractionEnabled = !lock;
}

-(NSString *)getCurrentSearchKey{
    return currentSearchKey;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{

//    bottom.frame = CGRectMake(0, self.view.frame.size.height - 30,MainScreen_Width,30);
    if (IOS7) {
        appScrollView.frame = CGRectMake(0, 0, MainScreen_Width, self.view.frame.size.height - 35);
    }else{
        appScrollView.frame = CGRectMake(0, 0, MainScreen_Width, self.view.frame.size.height - 35 + 20 + 44);
    }
    gameScrollView.frame = appScrollView.frame;
    _backView.frame = CGRectMake(0, 0, MainScreen_Width, self.view.frame.size.height - 30);
}



@end
