//
//  WallPaperListViewController.h
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import <UIKit/UIKit.h>
#import "DesktopViewDataManage.h"
#import "WallPaperClassifyViewController.h"
#import "MyNavigationController.h"

typedef enum {
    wallPaper_back = 0,
    wallPaper_presentClassfyView
}LeftBarButtonType;

@protocol WallPaperListViewDelegate <NSObject>
-(void)presentToClassifyView;
@end

@interface WallPaperListViewController : UIViewController
{
    LeftBarButtonType _type;
}

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id <WallPaperListViewDelegate>delegate;
- (id)initWithLeftType:(LeftBarButtonType)type;
-(void)initWallPaperList:(NSString *)urlStr dataManage:(DesktopViewDataManage *)dataManage AndTitle:(NSString *)title;

-(void)scrollToIndex:(NSInteger)index byData:(NSMutableArray *)items nextPageUrl:(NSString *)pageUrl lastReqUrl:(NSString *)lastUrl;

-(void)initRequest;
-(void)setDataArr:(NSArray *)arr;
@end
