//
//  MyCollectionViewController.h
//  MyHelper
//
//  Created by mingzhi on 15/1/5.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCells.h"
#import "ChargeFreeViewController.h"
typedef void(^CollectionViewRequestBlock)(BOOL hasdata);

@class EGORefreshTableHeaderView;
@interface MyCollectionViewController : UIViewController
{
    //功能
    CollectionViewRequestBlock collectionViewRequestBlock;
    BOOL isRequesting;//是否正在数据请求
@public
    //下拉
    EGORefreshTableHeaderView * _refreshHeader;
    BOOL isLoading;
    //上拉
    BOOL hasNextPage;
    BOOL _isFailed;
}
@property (nonatomic, assign) MenuType collectionlistType;
@property (nonatomic, assign) TagType collectionrequestType;

@property (nonatomic, retain) ChargeFreeViewController *parentVC;
//UI
@property (nonatomic, retain) UICollectionView *myCollectionView;
- (NSInteger)getCount;
- (void)setDataArray:(NSMutableArray *)dataArray;
- (void)setcollectionViewRequestBlock:(CollectionViewRequestBlock)block;
- (void)endloading;//下拉还原
- (void)freshLoadingCell:(CollectionCellRequestStyle)state;//

@end
