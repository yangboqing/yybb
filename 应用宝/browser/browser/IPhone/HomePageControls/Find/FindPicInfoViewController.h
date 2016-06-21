//
//  FindPicInfoViewController.h
//  browser
//
//  Created by mahongzhi on 14-10-23.
//
//

#import <UIKit/UIKit.h>
#import "WallpaperFlowLayout.h"
#import "FindPicInfoCollectionViewCell.h"
#import "PhotosAlbumManager.h"
#import "YulanPageView.h"
@protocol FindPicInfoViewDelegate <NSObject>
@optional

- (void)clickFindWebYulanBackButton;
@end

@interface FindPicInfoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIActionSheetDelegate,YulanPageDelegate,UIAlertViewDelegate>{

    UICollectionView *_collectView;
    WallpaperFlowLayout* _layout;
    YulanPageView *_yulanView;
    NSMutableArray *collectItems;
    PhotosAlbumManager *photosAlbumManager;
}

@property (nonatomic ,weak)id<FindPicInfoViewDelegate>delegate;
@property (nonatomic ,strong) NSString *currentbigImageUrl;
@property (nonatomic, assign) NSInteger currentIndex;
- (void)setCollectItems:(NSMutableArray *)items index:(NSInteger)index;
@end
