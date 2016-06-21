//
//  EightSquaresViewController.m
//  KY20Version
//
//  Created by liguiyang on 14-5-22.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "DisplayCollectionViewController.h"
#import "SingleCellectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SearchServerManage.h"

static NSString *singCellIdentifier = @"singleSquareCellIdentifier";

@interface DisplayCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SearchManagerDelegate>
{
    UIImage *defaultImage;
    NSString *iconUrlKey;
    //
    BOOL isNoData; // yes:表示没有数据； no:表示有数据
    int  numOfCell; // 要显示的cell的个数
}

@property (nonatomic, strong) NSArray *displayInfoArray;

@end

@implementation DisplayCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithAppDisplayInformation:(NSArray *)infoArray
{
    self = [super init];
    if (self) {
        // utility
        
        defaultImage = _StaticImage.icon_60x60;
        iconUrlKey = @"appiconurl";
        screenRect = [UIScreen mainScreen].bounds;
        // 设置数据源
        [self setAppDisplayInformationValue:infoArray];
        
        // cuttingline、image、Button
        separatorLineImgView = [[UIImageView alloc] init];
        separatorLineImgView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1];
        UIImage *img;
        self.leftTopImgView = [[UIImageView alloc] initWithImage:img];
        
        self.rightTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.rightTopButton setImage:[UIImage imageNamed:@"all_btn.png"] forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"all_btn.png" complete:^(UIImage *image) {
            [self.rightTopButton setImage:image forState:UIControlStateNormal];
        }];
        [self.rightTopButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // UICollectionView
        UICollectionViewLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,screenRect.size.width, 0) collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[SingleCellectionViewCell class] forCellWithReuseIdentifier:singCellIdentifier];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        
        //2.7去掉分隔线
//        [self.view addSubview:separatorLineImgView];
        [self.view addSubview:_leftTopImgView];
        [self.view addSubview:_rightTopButton];
        [self.view addSubview:_collectionView];
        
        // set frame
        [self setCustomFrame];
        
    }
    
    return self;
}

#pragma mark - UICollectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (numOfCell>4)?2:1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 无数据时
    if (isNoData) {
        return 4;
    }
    
    // 有数据时
    if (section==0) {
        return ((NSArray *)_displayInfoArray[0]).count;
    }
    else
    {
        return ((NSArray *)_displayInfoArray[1]).count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SingleCellectionViewCell *cell = (SingleCellectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:singCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
    }
    
    if (!isNoData) {
        NSDictionary *tempDic =  ((NSArray*)_displayInfoArray[indexPath.section])[indexPath.row];
        
        cell.nameLabel.text  = [tempDic objectForKey:@"appname"];
        NSString *iconUrl = [tempDic objectForKey:iconUrlKey];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:defaultImage];
    }
    else
    {
        cell.imageView.image = defaultImage;
        cell.nameLabel.text = @"";
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(WIDTH_ICON, WIDTH_ICON*31/20);
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat bottom = 0;
    if (section == 0) {
        bottom = 16;
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 13, bottom, 13);
    return insets;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (screenRect.size.width-13*2-WIDTH_ICON*4)/3;
}

#pragma mark - UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isNoData && self.delegate && [self.delegate respondsToSelector:@selector(displayCollectionView:didSelectedItemAtIndexPath:)]) {
        [self.delegate displayCollectionView:collectionView didSelectedItemAtIndexPath:indexPath];
    }
}

#pragma mark - Click Action
-(void)buttonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayCollectionView:rightTopButtonClick:)]) {
        [self.delegate displayCollectionView:_collectionView rightTopButtonClick:sender];
    }
}

#pragma mark - Utility

-(NSArray *)convertToDisplayArrayWithInfor:(NSArray *)array
{
    NSMutableArray *infoArr1 = [NSMutableArray array];
    NSMutableArray *infoArr2 = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < 4) {
            [infoArr1 addObject:obj];
        }
        else if (idx < 8)
        {
            [infoArr2 addObject:obj];
        }
    }];
    
    return @[infoArr1,infoArr2];
}

-(void)setAppDisplayInformationValue:(NSArray *)infoArray
{
    if (infoArray != nil && infoArray.count>0) {
         // 有数据
        isNoData = NO;
        numOfCell = infoArray.count;
        self.displayInfoArray =  [self convertToDisplayArrayWithInfor:infoArray];
    }
    else
    {
        // 无数据
        isNoData = YES;
        numOfCell = 8; // 无数据返回8(默认图)
    }
    
    [self.collectionView reloadData];
}

-(NSInteger)getIndexRowByUrl:(NSString *)url fromArray:(NSArray *)appArr
{// -1:url 不在appArr中
    __block NSInteger row = -1;
    [appArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([url isEqualToString:[(NSDictionary*)obj objectForKey:iconUrlKey]]) {
            row = idx;
            *stop = YES;
        }
    }];
    
    return row;
}

-(void)setCustomFrame
{ // self.frame = {(0,0),(320,264)}
    separatorLineImgView.frame = CGRectMake(8, 0, screenRect.size.width, 0.5);
    self.leftTopImgView.frame = CGRectMake(10, separatorLineImgView.frame.origin.y+separatorLineImgView.frame.size.height+13, 159, 16);
    self.rightTopButton.frame = CGRectMake(screenRect.size.width-60, _leftTopImgView.frame.origin.y-6, 60, 25);
    self.collectionView.frame = CGRectMake(0, _leftTopImgView.frame.origin.y+_leftTopImgView.frame.size.height+11, screenRect.size.width, (WIDTH_ICON+HEIGHT_LABEL+7)*2+11-3);
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
