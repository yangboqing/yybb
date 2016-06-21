//
//  FindPicInfoCollectionViewCell.h
//  browser
//
//  Created by 王毅 on 14-10-30.
//
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"
@interface FindPicInfoCollectionViewCell : UICollectionViewCell{
    UIImageView *wallSubImageView;
}
@property (nonatomic , strong) UIImageView *wallpaperImageView;
@property (nonatomic , strong) PICircularProgressView *progressView;
@property (nonatomic , strong) NSString *reportAddress;
@property (nonatomic , strong) NSString *smallImageUrlStr;
@property (nonatomic , strong) NSString *bigImageUrlStr;
@property (nonatomic , strong) UIImageView *progressBackgroundView;

- (void)isProgressHidden:(BOOL)isHidden;
- (void)setProgress:(double)progress;

- (void)setCurrentBoundsToImage:(UIImage*)image;

@end
