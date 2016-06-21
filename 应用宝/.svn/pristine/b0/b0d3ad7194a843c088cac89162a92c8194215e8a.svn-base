//
//  ClassificationBackView.h
//  MyHelper
//
//  Created by 李环宇 on 14-12-18.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationCell.h"
#import "MyServerRequestManager.h"
#import "CollectionCells.h"

@protocol ClassificationBackViewDelegate <NSObject>
- (void)dismissCategoryViewController:(UIViewController *)categoryVC;
@end

@interface ClassificationBackView : UIViewController<UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,MyServerRequestManagerDelegate,UIGestureRecognizerDelegate>{
}
@property (nonatomic, weak)   id <ClassificationBackViewDelegate>delegate;
@property (nonatomic, strong) NSArray *dataArr;

- (void)AppRequrtManager;
- (void)GameRequrtManager;
@end
