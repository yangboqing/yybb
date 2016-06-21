//
//  DetailViewController.m
//  browser
//
//  Created by niu_o0 on 14-6-9.
//
//

#import "DetailViewController.h"
#import "MarketServerManage.h"
#import "CollectionViewCell.h"
#import "CollectionViewLayout.h"
#import "CollectionViewBack.h"
#import "DetailHeaderView.h"
#import "DownloadStatus.h"
#import "SearchResult_DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImage+TintColor.h"
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif




#pragma mark - subtitleview

@interface SubTitleView : UIView{
@public
    
    UILabel * _label;
}

@property (nonatomic, strong) NSString * title;

+(id)defaults;
@end


@implementation SubTitleView

+(id)defaults{
    static SubTitleView * _subView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _subView = [SubTitleView new];
    });
    
    return _subView;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.0f];
        _label.textColor = hllColor(38, 38, 38, 0.8);
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _label.frame = self.bounds;
}

- (void)setTitle:(NSString *)title{
    _label.text = title;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    
    CGContextSetRGBStrokeColor(context, 163.0/255.0, 163.0/255.0, 163.0/255.0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, rect.size.height-0.5);
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
    
    CGContextStrokePath(context);
}

@end


#pragma mark - navgationbar titleview

#define TITLESIZE 16.0

typedef void(^animationBlock)(BOOL isRotation);
typedef void(^animationCom)(BOOL show);
@interface TitleView : UIView{
    animationBlock _animationBlock;
    animationCom _animationCom;
    @public
    UILabel * _titleLabel;
    UIControl * _control;
}
@property (nonatomic, strong) NSString * title;

- (void)setTitleAnimationWithBlock:(animationBlock)_block andCompletion:(animationCom)_com;

@end

@implementation TitleView

- (id)init
{
    self = [super init];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)setTitleAnimationWithBlock:(animationBlock)_block andCompletion:(animationCom)_com{
    _animationBlock = _block;
    _animationCom = _com;
}

- (void)makeViews{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:TITLESIZE];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //下拉展开小箭头
    //展开未显示完整的标题

    _control = [UIControl new];
    [_control addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
    _control.backgroundColor = [UIColor clearColor];
    [_control setExclusiveTouch:YES];
    [self addSubview:_control];
    
    
    UIImageView * _imageView = [UIImageView new];
    _imageView.image = _StaticImage.jiantou;
    [_control addSubview:_imageView];
    
}
//展开未显示完整的标题
- (void)press{
    
    CGAffineTransform  tr = _control.transform;
    
    if (tr.a > 0) {
        
        [UIView animateWithDuration:0.3f animations:^{
            
            _control.transform = CGAffineTransformMakeRotation(M_PI);
            
            if (_animationBlock) _animationBlock(YES);
            
        } completion:^(BOOL finished) {
            if (_animationCom) _animationCom(YES);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3f animations:^{
            
            _control.transform = CGAffineTransformMakeRotation(0);
            
            if (_animationBlock) _animationBlock(NO);
            
        } completion:^(BOOL finished) {
            if (_animationCom) _animationCom(NO);
        }];
    }
    
    
    
    
//    if ([_control.layer animationForKey:@"anim"]) {
//        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        animation.duration = 0.3f;
//        animation.toValue = [NSNumber numberWithFloat:2*M_PI];
//        animation.cumulative = YES;
//        animation.removedOnCompletion = NO;
//        animation.delegate = self;
//        animation.fillMode = kCAFillModeForwards;
//        [_control.layer addAnimation:animation forKey:nil];
//        
//        
//        return;
//    }
//    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.duration = 0.3f;
//    animation.toValue = [NSNumber numberWithFloat:M_PI];
//    animation.cumulative = YES;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    [_control.layer addAnimation:animation forKey:@"anim"];
    
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    [_control.layer removeAllAnimations];
//}

- (void)setTitle:(NSString *)title{
    
//    if (_title) _title = nil;
//    
//    _title = title;
    _titleLabel.text = title;
    
    if ([self getToInt:title] > 28) {
        [[SubTitleView defaults] setTitle:title];
        _control.hidden = NO;
    }else{
        _control.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, TITLESIZE*14, self.bounds.size.height);
    _control.frame = CGRectMake((TITLESIZE*14-40)/2-25, self.bounds.size.height-14, 40, 14);
    UIView * view = [_control.subviews firstObject];
    view.frame = CGRectMake((_control.bounds.size.width-_StaticImage.jiantou.size.width/2)/2, (_control.bounds.size.height-_StaticImage.jiantou.size.height/2)/2, _StaticImage.jiantou.size.width/2, _StaticImage.jiantou.size.height/2);
    
    
}

- (int)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [strtemp dataUsingEncoding:enc];
    return[data length];
}

@end




#pragma mark - DetailViewController

#define DETAIL_HEADVIEW @"detailheadview"
#define HEIGHT (IOS7 ? 64 : 0)
@interface DetailViewController () <MarketServerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EGORefreshTableHeaderDelegate>{
    @package
    MarketServerManage * _marketServer;
    TitleView * _titleView;
    UICollectionView * _collectionView;
    CollectionViewLayout * layout;
    SubTitleView * _subTitleView;
    NSDictionary * topic_dic;
    NSDictionary * info;
    NSMutableArray * _dataArray;
    BOOL requestFail;
    SearchResult_DetailViewController * detailViewController;
    EGORefreshTableHeaderView * _refreshView;
    CollectionViewBack * _backView;
//chc新增内容
    UIView *topView;//仿导航栏
    DetailHeaderView *detailHeadView;//专题图片和文字
    UIButton *backButton;//返回按钮
    UILabel *titile;//标题
    int bounceHeight;//下拉幅度,定义为int而非float,防止某些情况下出现的值可能为0.0几,导致仿导航栏异常
    EGORefreshTableHeaderView *refreshView;
    UIImage *backImg;//返回按钮图片
    UIView *coverView;//仿导航栏的底部背景
    float introTextHeight;
    UILabel *line;//仿导航栏底部红线
    
}

@end

@implementation DetailViewController

+ (id)defaults{
    
    static DetailViewController * _detailViewController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _detailViewController = [DetailViewController new];
    });
    
    return _detailViewController;
}

- (void)dealloc{
    
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [_marketServer removeListener:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _marketServer = [MarketServerManage new];
        [_marketServer addListener:self];
        
        _titleView = [TitleView new];
        _subTitleView = [SubTitleView defaults];
        
        detailViewController = [SearchResult_DetailViewController new];
        introTextHeight = 100.0;
    }
    return self;
}


- (void)setDetailInfo:(NSDictionary *)_info andStyle:(_DETAIL_STYLE)_style{
    
    info = _info;
    
    
    if (_style == _DETAIL_STYLE_TOPIC) {
        
        _titleView.title = nil;
        
         __weak typeof(self) mySelf = self;
        SubTitleView * __weak __subTitleView = _subTitleView;
        [_titleView setTitleAnimationWithBlock:^(BOOL isRotation) {
            [mySelf animation:isRotation];
            
        } andCompletion:^(BOOL show) {
            
            if (!show)  __subTitleView.hidden = YES;
        }];
        _titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        
        _subTitleView.frame = CGRectMake(0, HEIGHT-65/2, self.view.bounds.size.width, 65/2);
        
        _subTitleView.hidden = YES;
        
        [self setBackView];
    }else{
        
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.view addSubview:_subTitleView];
    });
    
    [self requestAll];
    
}

- (void)requestAll{
    [_marketServer getSpecialInfo:[[info objectForKey:SPECIALID] integerValue] userData:nil];
}

- (void)request{
    [_marketServer getSpecialApp:[topic_dic objectForKey:SPECIALID] pageCount:1 userData:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IOS7) self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    addNavgationBarBackButton(self, back)
//
//    self.navigationItem.titleView = _titleView;
    
    layout = [CollectionViewLayout new];
    
    topView = [[UIView alloc]init];
    coverView = [[UIView alloc]init];
    
    //新春版
//    coverView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];
    coverView.backgroundColor = [UIColor whiteColor];
    
    coverView.alpha = 0;
    line = [[UILabel alloc]init];
    line.backgroundColor = TOP_RED_COLOR;
    [coverView addSubview:line];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backImg = [UIImage imageNamed:@"nav_back.png"];
    [backButton setBackgroundImage:[backImg imageWithTintColor:[UIColor colorWithWhite:0.0 alpha:1.0] blendMode:kCGBlendModeOverlay] forState:UIControlStateNormal] ;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    titile = [[UILabel alloc]init];
    titile.text = @"";
    titile.textAlignment = NSTextAlignmentCenter;
    titile.textColor = [UIColor whiteColor];
    
    [topView addSubview:backButton];
    [topView addSubview:titile];
    
    [self.view addSubview:coverView];
    [self.view addSubview:topView];
    
    detailHeadView = [[DetailHeaderView alloc]init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:__STYLE_RECOMMEND];
    [_collectionView addSubview:detailHeadView];
    _collectionView.contentInset = UIEdgeInsetsMake(ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20, 0, 0, 0);
    [self.view addSubview:_collectionView];
    
    _refreshView = [EGORefreshTableHeaderView new];
//    _refreshView.egoDelegate = self;
    _refreshView.hidden = YES;
    [_collectionView addSubview:_refreshView];
    
    _backView = [CollectionViewBack new];
    [_collectionView addSubview:_backView];
    __weak typeof(self) mySelf = self;
    [_backView setClickActionWithBlock:^{
        [mySelf setRequestFail:NO];
        [mySelf performSelector:@selector(requestAll) withObject:nil afterDelay:delayTime];
    }];
    
    [self setBackView];

    //将仿导航条放在所有view的最上层
    [self.view bringSubviewToFront:coverView];
    [self. view bringSubviewToFront:topView];

}


- (void)setRequestFail:(BOOL)fail{
    requestFail = fail;
}

- (void)setBackView{
    
    if (!topic_dic) {
    
        if (requestFail){
            [_backView setStatus:Failed];
        }else{
            [_backView setStatus:Loading];
        }
        _collectionView.scrollEnabled = NO;
    }else{
        _collectionView.scrollEnabled = YES;
        [_backView setStatus:Hidden];
        if (isLoading) [self didRequestData];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    topView.frame =  CGRectMake(0, 0, self.view.frame.size.width, 64);
    backButton.frame = CGRectMake(10, 20 + (44 - 34)/2 , 34, 34);
    coverView.frame = topView.frame;
    line.frame = CGRectMake(0, coverView.frame.size.height - 0.5, MainScreen_Width, 0.5);
    titile.frame = CGRectMake((topView.frame.size.width-200)*0.5, 20, 200, 44);
    
    _collectionView.frame = self.view.bounds;
    _collectionView.contentOffset = CGPointMake(0, - (ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20));
    detailHeadView.frame  = CGRectMake(0,_collectionView.contentOffset.y, MainScreen_Width, -_collectionView.contentOffset.y);

    _refreshView.inset = _collectionView.contentInset;
    CGFloat startY = IOS7 ? 64 : 0;
    _refreshView.frame = CGRectMake(0, -_collectionView.bounds.size.height-_collectionView.contentInset.top+startY, _collectionView.bounds.size.width, _collectionView.bounds.size.height);
    _backView.frame = _collectionView.bounds;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
    self.navigationItem.hidesBackButton = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha  = 1.0f;
    //2.7
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //新春版
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if (!self.navigationController) {
        [self clearCache];
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearCache{
    titile.text = @"";
    [detailHeadView reset];
    bounceHeight = 0;
    introTextHeight = 100;
    _collectionView.contentInset = UIEdgeInsetsMake(ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20, 0, 0, 0);
    [_collectionView setContentOffset:CGPointMake(0, - (ORIGINAL_IMAGE_HEIGHT + 20)) animated:NO];

    
    [backButton setBackgroundImage: [backImg imageWithTintColor:[UIColor colorWithWhite:1 alpha:1.0] blendMode:kCGBlendModeOverlay] forState:UIControlStateNormal];
    titile.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    coverView.alpha = 0;
//    _titleView->_control.transform = CGAffineTransformMakeRotation(0);
//    [[SubTitleView defaults] setTitle:nil];
    requestFail = NO;
    topic_dic = nil;
    _dataArray = nil;
    [_collectionView reloadData];
}


- (void)animation:(BOOL)_istotation{
    if (_istotation) {
        _subTitleView.hidden = NO;
        _subTitleView.frame = CGRectMake(0, HEIGHT, self.view.bounds.size.width, 65/2);
        _collectionView.contentInset = UIEdgeInsetsMake(HEIGHT+65/2, 0, 0, 0);
        _collectionView.contentOffset = CGPointMake(0, -65/2-HEIGHT);
    }else{
        _collectionView.contentInset = UIEdgeInsetsMake(HEIGHT, 0, 0, 0);
        _subTitleView.frame = CGRectMake(0, HEIGHT-65/2, self.view.bounds.size.width, 65/2);
    }
}


#pragma mark - 专题 详情 上部分

- (void)specialInfoRequestSucess:(NSDictionary *)dataDic specialID:(int)specialID userData:(id)userData{
    
    NSDictionary * dic = [dataDic getNSDictionaryObjectForKey:@"data"];
    if (!dic) return;
    
    titile.text = [dic getNSStringObjectForKey:SPECIALNAME];
    topic_dic = dic;
    [self setBackView];
    if (!([dic getNSStringObjectForKey:SPECIAL_PIC_URL] && [dic getNSStringObjectForKey:SPECIALID])) return;
    
    introTextHeight = [[topic_dic objectForKey:SPECIALCONTENT] sizeWithFont:[UIFont systemFontOfSize:textFont] constrainedToSize:CGSizeMake(self.view.bounds.size.width-20, MAXFLOAT)].height;
    [detailHeadView setIntroTextHeight:introTextHeight];
    detailHeadView.contentText = [topic_dic objectForKey:SPECIALCONTENT];

    _collectionView.contentInset = UIEdgeInsetsMake(ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20, 0, 0, 0);
    _collectionView.contentOffset = CGPointMake(0, - (ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20));
    [self.view setNeedsLayout];

    //正式代码
    [detailHeadView.imageView sd_setImageWithURL:[NSURL URLWithString:[topic_dic getNSStringObjectForKey:SPECIAL_PIC_URL]] placeholderImage:_StaticImage.icon_topic];
    
    
    //测试代码640x420
//    detailHeadView.imageView.image = [UIImage imageNamed:@"test.png"];

//    [_collectionView reloadData];
    [_marketServer getSpecialApp:[dic objectForKey:SPECIALID] pageCount:1 userData:nil];
}

- (void)specialInfoRequestFail:(int)specialID userData:(id)userData{
    
    requestFail = YES;
    
    [self setBackView];
}

#pragma mark - 专题 应用列表

- (void)specialAppRequestSucess:(NSDictionary *)dataDic specialID:(NSString *)specialID pageCount:(int)pageCount userData:(id)userData{
    
    if (![_StaticImage checkAppList:dataDic]){
        [self specialAppRequestFail:specialID pageCount:pageCount userData:userData];
        return;
    }
    
    _dataArray = [dataDic objectForKey:@"data"];
    
    if (isLoading) [self didRequestData];
    
    [_collectionView reloadData];
}

- (void)specialAppRequestFail:(NSString *)specialID pageCount:(int)pageCount userData:(id)userData{
    
    if (isLoading) [self didRequestData];
}


#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!_dataArray) return 0;
    return _dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.bounds.size.width, 176/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:__STYLE_RECOMMEND forIndexPath:indexPath];

    cell.iconImageView.url = [NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPICON]];
    cell.nameLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:APPNAME];
    cell.subLabel.text = [NSString stringWithFormat:@"%@  |  %@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPCATEGROY],[DownloadStatus changeValue:[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPSIZE] WithValueClass:Value_MB]];      //@"动作游戏  |  694.13M";
    [cell.zanButton setTitle:[DownloadStatus changeValue:[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPREPUTATION] WithValueClass:Value_Count] forState:UIControlStateNormal];
    [cell.downButton setTitle:[DownloadStatus changeValue:[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPDOWNCOUNT] WithValueClass:Value_Count] forState:UIControlStateNormal];
    
    cell.downloadButton.buttonIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:[[topic_dic objectForKey:SPECIALID] integerValue]+100];
    [DownloadStatus checkButton:cell.downloadButton
                    WithAppInfo:[_dataArray objectAtIndex:indexPath.row]];
    
    cell.baoguang = [[_dataArray objectAtIndex:indexPath.row] objectForKey:APPID];
    
    [cell.iconImageView sd_setImageWithURL:cell.iconImageView.url placeholderImage:[_StaticImage collectionViewItemImage:indexPath.section]];
    
    return cell;
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * view = nil;
    
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAIL_HEADVIEW forIndexPath:indexPath];
        DetailHeaderView * headView = (DetailHeaderView *)view;
    
        [headView.imageView sd_setImageWithURL:[NSURL URLWithString:[topic_dic getNSStringObjectForKey:SPECIAL_PIC_URL]] placeholderImage:_StaticImage.icon_topic];
        
        
        headView.contentText = [topic_dic objectForKey:SPECIALCONTENT];
    
    
    
    return view;
}
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [detailViewController setAppSoure:SPECIAL_APP([info objectForKey:SPECIALID], indexPath.row)];
    [detailViewController beginPrepareAppContent:[_dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    
    CollectionViewCell * cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [[ReportManage instance] ReportAppDetailClick:[DownloadStatus dlfrom:cell.downloadButton.buttonIndexPath] appid:[[_dataArray objectAtIndex:indexPath.row] objectForKey:APPID]];
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = [[topic_dic objectForKey:SPECIALCONTENT] sizeWithFont:[UIFont systemFontOfSize:textFont] constrainedToSize:CGSizeMake(self.view.bounds.size.width-20, MAXFLOAT)];
    return CGSizeMake(collectionView.bounds.size.width, imageHeight+20+size.height+10);
}
*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

#pragma mark - 下拉刷新

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
    

    //定义为int而非float,防止某些情况下出现的值可能为0.0几,导致仿导航栏异常
    bounceHeight = -scrollView.contentOffset.y - (ORIGINAL_IMAGE_HEIGHT + introTextHeight + 20);
    //下拉时大于0
    if (bounceHeight >0) {
        //调整headView位置大小并自动调整专题图显示
        detailHeadView.frame  = CGRectMake(0,_collectionView.contentOffset.y, MainScreen_Width, -_collectionView.contentOffset.y);
        //避免返回时scrollview执行
        //2.7
        
        if ([[self.navigationController class] isSubclassOfClass:[self class]]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
        //新春版
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }else{
        float colorValue = -bounceHeight/100.0;
        [backButton setBackgroundImage: [backImg imageWithTintColor:[UIColor colorWithWhite:1 - colorValue alpha:1.0] blendMode:kCGBlendModeOverlay] forState:UIControlStateNormal];
        
        //新春版
        titile.textColor = [UIColor colorWithWhite:1.0 - colorValue alpha:1.0];
        
        coverView.alpha = colorValue;
        
        //新春版
        if (colorValue>0.5&&self.navigationController) {
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            [backButton setBackgroundImage:backImg forState:UIControlStateNormal];
        }
        
    }

}

static bool _decelerating = false;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.decelerating) _decelerating = true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate && _decelerating == false) [self baoguang];
    
    _decelerating = false;
    
//    [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self baoguang];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    self->isLoading = YES;
    [self performSelector:@selector(request) withObject:nil afterDelay:0.0f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return self->isLoading;
}

- (void)didRequestData{
    self->isLoading = NO;
//    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    [self performSelector:@selector(recoverHeadView) withObject:nil afterDelay:0.0f];
}

- (void)recoverHeadView{
    [backButton setBackgroundImage: [backImg imageWithTintColor:[UIColor colorWithWhite:1 alpha:1.0] blendMode:kCGBlendModeOverlay] forState:UIControlStateNormal];
    titile.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    coverView.alpha = 0;
    detailHeadView.frame = CGRectMake(0, -(ORIGINAL_IMAGE_HEIGHT + 20 + introTextHeight), MainScreen_Width, (ORIGINAL_IMAGE_HEIGHT + 20 + introTextHeight));
//    [UIView animateWithDuration:1.0f animations:^{
//        detailHeadView.frame = CGRectMake(0, -(ORIGINAL_IMAGE_HEIGHT + 20 + introTextHeight), MainScreen_Width, (ORIGINAL_IMAGE_HEIGHT + 20 + introTextHeight));
//    }];
}

- (void)baoguang{
    _baoguang(_collectionView, [NSIndexPath indexPathForRow:-1 inSection:[[topic_dic objectForKey:SPECIALID] integerValue]+100])
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
