//
//  HorizontalSlidingView.m
//  Mymenu
//
//  Created by mingzhi on 14/11/24.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import "HorizontalSlidingView.h"


#pragma mark - GrayPageControl
@implementation GrayPageControl

- (void) setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size = CGSizeMake(4, 4);
        if (subviewIndex==0) {
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
        }else
        {
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
        }
        
    }
}

@end


#pragma mark - CollectionHeadView

@implementation CollectionHeadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        
        _showLabel = [UILabel new];
        //_showLabel.textColor=hllColor(98,98,98,1);
        _showLabel.font=[UIFont systemFontOfSize:15.0];
        _showLabel.backgroundColor=[UIColor clearColor];
        
        
        __pageControl = [GrayPageControl new];
        __pageControl.userInteractionEnabled=NO;
        __pageControl.currentPageIndicatorTintColor = hllColor(238, 139, 18, 1);
        __pageControl.pageIndicatorTintColor = hllColor(247, 194, 117, 1);
        __pageControl.backgroundColor = [UIColor clearColor];
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allButton.backgroundColor = [UIColor clearColor];
        [_allButton setImage:[UIImage imageNamed:@"all_btn"] forState:UIControlStateNormal];

        [self addSubview:_imageView];
        [self addSubview:_showLabel];
        [self addSubview:__pageControl];
        [self addSubview:_allButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _imageView.frame = CGRectMake(ThestartX, 10*MULTIPLE, 16, 16);
    _imageView.center = CGPointMake(_imageView.center.x, self.bounds.size.height/2);
    _showLabel.frame = CGRectMake(self.imageView.frame.size.width + self.imageView.frame.origin.x+7,0, 300, self.bounds.size.height);
    _allButton.frame = CGRectMake(self.bounds.size.width - _allButton.imageView.image.size.width/2-8, 10, _allButton.imageView.image.size.width/2, _allButton.imageView.image.size.height/2);
    __pageControl.frame = CGRectMake(0, 0, 50, 15);
    __pageControl.center = CGPointMake(_allButton.center.x-(_allButton.frame.size.width)/2-__pageControl.frame.size.width+32, _allButton.center.y+2);
}

- (void)setIconColor:(UIImage *)img andName:(NSString *)name
{
    _imageView.image = img;
    _showLabel.text = name;
}

@end

#pragma mark - HorizontalAppCellView
@implementation HorizontalAppCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        //图标
        _iconImageView = [CollectionViewCellImageView_my new];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.maskCornerRadius = 12.f;
        [self.contentView addSubview:_iconImageView];
        
        //名字
        _appLabel=[KYLabel new];
        _appLabel.backgroundColor = [UIColor clearColor];
        _appLabel.font = [UIFont systemFontOfSize:13.0f];
        _appLabel.textColor=namelableColor;
//        label.font = [UIFont fontWithName:@"STHeiti-Medium" size:10];
//        _appLabel.font=[UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:13.0f];
        _appLabel.textAlignment = NSTextAlignmentCenter;
        [_appLabel setVerticalAlignment:VerticalAlignmentTop];
        _appLabel.numberOfLines = 2;
        
        [self addSubview:_appLabel];
        [self addSubview:_iconImageView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    CGRect rect = self.bounds;
    _iconImageView.frame=CGRectMake(0, 0, rect.size.width, rect.size.width);
    _appLabel.frame=CGRectMake(0, _iconImageView.frame.origin.y + _iconImageView.frame.size.height + 5, rect.size.width, 40);
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end


#pragma mark - CollectionView

@interface HorizontalSlidingView () <UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *myCollectionView;//热搜APP
    CollectionHeadView *headView;//标题
    
}
@end

#define TITLEVIEWHEIGHT 45

static NSString *CellIdentifier_hori = @"HorizontalAppCell";

@implementation HorizontalSlidingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _nameColor = [UIColor blackColor];
        //列表
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [myCollectionView registerClass:[HorizontalAppCellView class] forCellWithReuseIdentifier:CellIdentifier_hori];
        myCollectionView.backgroundColor = [UIColor clearColor];
        myCollectionView.showsHorizontalScrollIndicator = NO;
        myCollectionView.dataSource = self;
        myCollectionView.delegate = self;
        //头
        headView = [CollectionHeadView new];
        [headView.allButton addTarget:self action:@selector(allButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:headView];
        [self addSubview:myCollectionView];
        
        [myCollectionView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
        
    }
    return self;
}

- (void)setColor:(UIImage *)img andName:(NSString *)name
{
    [headView setIconColor:img andName:name];
}
- (void)setTitleViewHidden:(BOOL)bl
{
    headView.hidden = bl;
    _nameColor = bl?[UIColor whiteColor]:[UIColor blackColor];
    
}
#pragma mark - 设置数据
- (void)setDataArr:(NSArray *)dataArr
{
    if (!IS_NSARRAY(dataArr) || ![dataArr count])  return;

    //取12个
    NSMutableArray *__dataArray = [NSMutableArray arrayWithArray:dataArr];
    if ([__dataArray count] > HORIZONTAL) {
        [__dataArray removeObjectsInRange:NSMakeRange(HORIZONTAL, __dataArray.count-HORIZONTAL)];
    }
    
    _dataArr = __dataArray;
    
    if (_dataArr.count) {
        headView._pageControl.hidden = NO;
        if (_dataArr.count%4==0) {
            headView._pageControl.numberOfPages = _dataArr.count/4;
        }else{
            headView._pageControl.numberOfPages = _dataArr.count/4+1;
            headView._pageControl.hidden = _dataArr.count/4==0?YES:NO;
        }
    }else{
        headView._pageControl.hidden = YES;
    }
    if (!headView._pageControl.hidden) {
        [headView._pageControl setCurrentPage:0];
    }
    [myCollectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    headView.frame = CGRectMake(0, 0, self.frame.size.width, TITLEVIEWHEIGHT);
    myCollectionView.frame = CGRectMake(0, TITLEVIEWHEIGHT*MULTIPLE, self.frame.size.width, self.frame.size.height - TITLEVIEWHEIGHT);
}

#pragma mark - UICollectionView datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalAppCellView *cell = (HorizontalAppCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier_hori forIndexPath:indexPath];
    
    //设置数据
    NSDictionary *showCellDic = [_dataArr objectAtIndex:indexPath.row];
    //设置属性
    cell.dataDic = showCellDic;
    cell.appdigitalid = [showCellDic objectForKey:APPDIGITALID];
    cell.appID = [showCellDic objectForKey:APPID];
    cell.plist = [showCellDic objectForKey:PLIST];
    cell.installtype = [showCellDic objectForKey:INSTALLTYPE];
    //设置显示
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[FileUtil URLEncodedString:[showCellDic objectForKey:APPICONURL]]] placeholderImage:[UIImage imageNamed:@"icon60x60"] size:CGSizeMake(175, 175) radius:(cell.iconImageView.maskCornerRadius)*175/(70*MULTIPLE)];
    cell.appLabel.text = [showCellDic objectForKey:APPNAME];
    cell.appLabel.textColor = _nameColor;
    
    return cell;
}
#pragma mark - UICollectionViewLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(MULTIPLE*140/2,collectionView.frame.size.height);
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, ThestartX, 0, ThestartX);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return ThestartX*2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalAppCellView *cell = (HorizontalAppCellView *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapHorizontalApp:path:)]) {
        [self.delegate tapHorizontalApp:cell.appdigitalid path:indexPath];
    }
}

- (void)allButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(theAllBtnClick:)]) {
        [self.delegate theAllBtnClick:sender];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.pagingEnabled = NO;
    //NSLog(@"===%f",scrollView.contentOffset.x/scrollView.frame.size.width);
    [headView._pageControl setCurrentPage:(ceil((scrollView.contentOffset.x/scrollView.frame.size.width)))];
    [self baoguang];
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
//    myCollectionView.userInteractionEnabled = myCollectionView.contentOffset.x<0?NO:YES;
//    myCollectionView.scrollEnabled = myCollectionView.contentOffset.x<0?NO:YES;
}

#pragma mark - 曝光
BOOL _deceler_horizen;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    scrollView.pagingEnabled = YES;
    if (scrollView.decelerating) _deceler_horizen = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate && !_deceler_horizen) [self baoguang]; _deceler_horizen = NO;
}

- (void)baoguang{
    
    NSMutableArray *appidArray;
    NSMutableArray *appdigidArray;
    if (!appidArray) appidArray = [NSMutableArray array];
    if (!appdigidArray) appdigidArray = [NSMutableArray array];
    
    for (HorizontalAppCellView * cell in myCollectionView.visibleCells) {
        [appidArray addObject:cell.appID];
        [appdigidArray addObject:cell.appdigitalid];
    }
    
    NSString *colorm;
    switch (_mytype) {
        case limiteCharge_App:
            colorm = HOME_PAGE_LIMITFREE_APP((long)-1);
            break;
            
        case free_App:
            colorm = HOME_PAGE_FREE_APP((long)-1);
            break;
            
        case charge_App:
            colorm = HOME_PAGE_PAID_APP((long)-1);
            break;
            
        default:
            break;
    }
    [[ReportManage instance] reportAppBaoGuang:colorm appids:appidArray digitalIds:appdigidArray];
}

@end