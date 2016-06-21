//
//  WallpaperInfoViewController.h
//  browser
//
//  Created by 王毅 on 14-8-27.
//
//

#import <UIKit/UIKit.h>
#import "WallpaperFlowLayout.h"
#import "WallpaperCollectionCell.h"
#import "TMCache.h"
#import "DesktopViewDataManage.h"
#import "YulanPageView.h"
#import "FileUtil.h"
#import "PhotosAlbumManager.h"

@protocol wallpaperInfoCollectDelegate <NSObject>
@optional

- (void)CollectionItem:(UIImage*)wallpaperImage settingReportAddress:(NSString *)reportAddress;
- (void)clickCollectionItem;
- (void)notifitionInterfaceReloadArray:(NSMutableArray*)array current:(NSUInteger)index nextUrlAdress:(NSString*)next lastRequest:(NSString*)str;
@end

@interface WallpaperInfoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIActionSheetDelegate,DesktopviewManageDelegate,YulanPageDelegate>{
    
    UICollectionView *_collectView;
    WallpaperFlowLayout* _layout;
    NSMutableArray *collectItems;
    NSString *_prevStr;
    NSString *_nextStr;
    
    DesktopViewDataManage *wallManage;
    YulanPageView *_yulanView;
    BOOL isEnableButton;
    PhotosAlbumManager *photosAlbumManager;
    
}
@property (nonatomic ,weak)id<wallpaperInfoCollectDelegate>delegate;
@property (nonatomic ,strong) NSString *currentbigImageUrl;
@property (nonatomic ,strong) NSString *currentReportUrl;
@property (nonatomic ,strong) NSString *currentSmaillImageUrl;
- (void)setCollectItems:(NSMutableArray *)items currentItme:(NSInteger)index prevAddress:(NSString*)prevStr nextAddress:(NSString*)nextStr from:(NSString*)from;
@end
