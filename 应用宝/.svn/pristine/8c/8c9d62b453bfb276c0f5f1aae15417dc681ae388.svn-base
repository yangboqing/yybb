//
//  ChoiceViewController.h
//  browser
//
//  Created by niu_o0 on 14-5-19.
//
//      精选

#import <UIKit/UIKit.h>
#import "CollectionViewHeaderView.h"
#import "CollectionViewLayout.h"
#import "RotationView.h"
#import "CollectionViewBack.h"
#import "CollectionViewCell.h"
#import "IphoneAppDelegate.h"
static NSString * CELL_IDENTIFIER = @"WaterfallCell";
static NSString * HEADER_IDENTIFIER = @"WaterfallHeader";
static NSString * FOOTER_IDENTIFIER = @"WaterfallFooter";




@interface ChoiceViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    @package
    UICollectionView * _tableView;
    RotationView * _rotationView;
    NSMutableArray * _dataArray;
    NSMutableDictionary * _countDic;
    BOOL isLoading;
}
@property (nonatomic, strong) UINavigationController * navgationController;

@end
