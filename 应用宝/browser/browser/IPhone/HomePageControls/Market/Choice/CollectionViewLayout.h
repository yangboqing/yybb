//
//  Layout.h
//  33
//
//  Created by niu_o0 on 14-4-29.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UICollectionElementKindSectionBackground @"UICollectionElementKindSectionFooter"

@interface CollectionViewLayout : UICollectionViewFlowLayout{
    NSMutableArray * DecorationArray;
}
@property (nonatomic, assign) BOOL registBackground;
@property (nonatomic, assign) BOOL collectionBackground;

@end
