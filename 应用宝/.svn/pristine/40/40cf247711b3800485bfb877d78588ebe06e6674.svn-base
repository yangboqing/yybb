//
//  EightSquaresViewController.h
//  KY20Version
//
//  Created by liguiyang on 14-5-22.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisplayCollectionViewDelegate <NSObject>

-(void)displayCollectionView:(UICollectionView *)collectionView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
-(void)displayCollectionView:(UICollectionView *)collectionView rightTopButtonClick:(id)sender;

@end

@interface DisplayCollectionViewController : UIViewController
{
    UIImageView *separatorLineImgView;
    //
    CGRect screenRect;
}

@property (nonatomic, weak) id <DisplayCollectionViewDelegate>delegate;
@property (nonatomic, strong) UIImageView *leftTopImgView;
@property (nonatomic, strong) UIButton    *rightTopButton;
@property (nonatomic, strong) UICollectionView *collectionView;

-(id)initWithAppDisplayInformation:(NSArray *)infoArray;
-(void)setAppDisplayInformationValue:(NSArray *)infoArray;

@end
