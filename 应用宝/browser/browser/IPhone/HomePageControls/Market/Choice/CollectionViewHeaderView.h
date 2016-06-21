//
//  CollectionViewHeaderView.h
//  33
//
//  Created by niu_o0 on 14-4-28.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ind)(NSIndexPath * indexPath);

@interface CollectionViewHeaderView : UICollectionReusableView{
    ind __ind ;
    @public
    UIButton * _button;
    UIView *seperateView;
}

@property (nonatomic, retain) NSIndexPath * indexPath;
@property (nonatomic, retain) UIImageView * imageView;

- (void)setIndexWithBlock:(ind)_ind;

@end
