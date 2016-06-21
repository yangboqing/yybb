//
//  WallpaperCollectionCell.h
//  browser
//
//  Created by 王毅 on 14-8-27.
//
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"
@interface WallpaperCollectionCell : UICollectionViewCell{
}
@property (nonatomic , strong) UIImageView *wallpaperImageView;
@property (nonatomic , strong) PICircularProgressView *progressView;
@property (nonatomic , strong) NSString *reportAddress;
@property (nonatomic , strong) NSString *smallImageUrlStr;
@property (nonatomic , strong) NSString *bigImageUrlStr;
@property (nonatomic , strong) UIImageView *progressBackgroundView;

- (void)isProgressHidden:(BOOL)isHidden;
- (void)setProgress:(double)progress;
@end
