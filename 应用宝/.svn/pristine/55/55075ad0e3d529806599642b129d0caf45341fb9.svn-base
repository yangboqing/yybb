//
//  HorizontalSlidingView.h
//  Mymenu
//
//  Created by mingzhi on 14/11/24.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "_PageControl.h"
#import "PublicCollectionCell.h"
#import "KYLabel.h"
#import "CollectionCells.h"

@protocol HorizontalSlidingDelegate <NSObject>
@required
- (void)tapHorizontalApp:(NSString *)appid path:(NSIndexPath *)indexPath;
- (void)theAllBtnClick:(id)sender;
@end

@interface GrayPageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@end

@interface CollectionHeadView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) GrayPageControl * _pageControl;
@property (nonatomic, strong) UIButton * allButton;

- (void)setIconColor:(UIImage *)img andName:(NSString *)name;
@end



@interface HorizontalAppCellView : UICollectionViewCell

//属性
@property (nonatomic, retain) NSDictionary *dataDic;
@property (nonatomic, retain) NSString *appdigitalid;
@property (nonatomic, retain) NSString *appID;
@property (nonatomic, retain) NSString *plist;
@property (nonatomic, retain) NSString *installtype;
//UI
@property (nonatomic, strong) CollectionViewCellImageView_my * iconImageView;
@property (nonatomic, strong) KYLabel *appLabel;
@end



@interface HorizontalSlidingView : UIView<UIScrollViewDelegate>

@property (nonatomic , strong) UIColor *nameColor;

@property (nonatomic, assign) MenuType mytype;
@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , weak) id<HorizontalSlidingDelegate>delegate;
- (void)setColor:(UIImage *)img andName:(NSString *)name;
- (void)setTitleViewHidden:(BOOL)bl;
@end
