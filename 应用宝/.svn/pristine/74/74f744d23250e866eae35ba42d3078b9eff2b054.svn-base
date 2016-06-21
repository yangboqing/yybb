//
//  HotWordViewController.m
//  MyHelper
//
//  Created by liguiyang on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "HotWordViewController.h"
#import "hotwordCollectionViewCell.h"

static NSString *hotCellIdentifier = @"hotWordCellIdentifier";

@interface HotWordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *hotCollectionView; // 热词UI
    UIImageView *shakeImgView; // 摇一摇ImageView
    UIImage     *shakeImg;
    
    //
    HotWordClick hotClick;
    CGFloat scale; // 比例
    
}

@property (nonatomic, strong) NSArray *hotArray; // 热词数据源

@end

@implementation HotWordViewController

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotWordCollectionViewCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:hotCellIdentifier forIndexPath:indexPath];
    
    hotCell.titleLabel.text = _hotArray[indexPath.row];
    
    return hotCell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (hotClick) {
        // 数据容错
        if (_hotArray == nil) return;
        if (indexPath.row > _hotArray.count-1) return;
        
        hotClick(_hotArray[indexPath.row]);
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(105*scale, 45*scale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 11*scale;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15*scale;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(18*scale, 17.5*scale, 18*scale, 17.5*scale);
}

#pragma mark Utility

- (void)setHotWords:(NSArray *)hotArr
{
    self.hotArray = hotArr;
    [hotCollectionView reloadData];
}

- (void)setHotWordClickBlock:(HotWordClick)block
{
    hotClick = block;
}

#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    scale = MainScreen_Width/375;
    
    // 搜索热词
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    hotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [hotCollectionView registerClass:[HotWordCollectionViewCell class] forCellWithReuseIdentifier:hotCellIdentifier];
    hotCollectionView.showsVerticalScrollIndicator = NO;
    hotCollectionView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    hotCollectionView.delegate = self;
    hotCollectionView.dataSource = self;
    [self.view addSubview:hotCollectionView];
    
    // 摇一摇imageView
    shakeImg = [UIImage imageNamed:@"shake.png"];
    shakeImgView = [[UIImageView alloc] init];
    shakeImgView.image = shakeImg;
    [self.view addSubview:shakeImgView];
}

- (void)viewWillLayoutSubviews
{
    CGRect  frame = self.view.bounds;
    CGFloat collectionHeight = 202*scale;
    CGFloat shakeOriX = (frame.size.width-shakeImg.size.width*scale)*0.5;
    CGFloat shakeOriY = (frame.size.height-collectionHeight-shakeImg.size.height*scale-BOTTOM_HEIGHT)*0.5+collectionHeight;
    
    hotCollectionView.frame = CGRectMake(0, 0,frame.size.width, collectionHeight);
    shakeImgView.frame = CGRectMake(shakeOriX, shakeOriY, shakeImg.size.width*scale, shakeImg.size.height*scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    hotClick = nil;
}

@end
