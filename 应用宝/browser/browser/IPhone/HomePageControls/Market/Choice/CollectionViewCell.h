//
//  CollectionViewCell.h
//  333
//
//  Created by niu_o0 on 14-5-16.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewBack.h"

@interface CollectionViewCellButton : UIButton

@property (nonatomic, strong) NSIndexPath * buttonIndexPath;
@property (nonatomic, assign) BOOL down;

@end

@interface CollectionViewCellImageView : UIImageView

@property (nonatomic, strong) CAShapeLayer * maskLayer;
@property (nonatomic, assign) CGFloat   maskCornerRadius;
@property (nonatomic, strong) NSURL * url;

@end

typedef enum {
    //_STYLE_NONE = 0,          //空
    _STYLE_NORMOL = 0,            //一般
    _STYLE_TOPIC,             //专题
    _STYLE_ACTIVITY,          //活动
    _STYLE_RECOMMEND,         //推荐
    _STYLE_REQUESTMORE,       //加载更多
    _STYLE_MORE_TOPIC,          //全部专题
}_CollectionViewCell_Style;

#define __STYLE_NORMOL       @"__STYLE_NONE"
#define __STYLE_TOPIC        @"__STYLE_TOPIC"
#define __STYLE_ACTIVITY     @"__STYLE_ACTIVITY"
#define __STYLE_RECOMMEND    @"__STYLE_RECOMMEND"
#define __STYLE_REQUESTMORE  @"__STYLE_REQUESTMORE"
#define __STYLE_MORE_TOPIC   @"__STYLE_MORE_TOPIC"



@interface CollectionViewCell : UICollectionViewCell{

    @public
    UIView * __view;

}

@property (nonatomic, strong) CollectionViewCellImageView * iconImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * subLabel;
@property (nonatomic, strong) CollectionViewCellButton * downloadButton;
@property (nonatomic, strong) CollectionViewCellButton * downButton;
@property (nonatomic, strong) CollectionViewCellButton * zanButton;
@property (nonatomic, strong) RefreshView * juhua;

@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) NSString * baoguang;
@end
