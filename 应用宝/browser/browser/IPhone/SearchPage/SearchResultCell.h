//
//  SearchRuseltCell.h
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//搜索完成时显示结果的控制器的表视图的单元格

#import <UIKit/UIKit.h>
#import "SearchManager.h"
#import "SearchResultTabelViewController.h"
#import "CollectionViewCell.h"
@interface DownloadBtn : UIButton
@end
@interface SearchResultCell : UITableViewCell{
    UIImageView *introImageView;

    UIImageView *bottomLineImageView;
    
    
    UIImageView *goodIconImageView;
    UIImageView *downloadIconImageView;
    
    
    UILabel *typeSizeLabel;
    
    UILabel *detailLabel;
    
}
enum{
    APPSTATE_DOWNLOAD = 0,
    APPSTATE_DOWNLOADING,
    APPSTATE_UPDATE,
    APPSTATE_UPDATEING,
    APPSTATE_INSTALL,
    APPSTATE_INSTALLING,
    APPSTATE_REINSTALL
};
@property (nonatomic , retain) CollectionViewCellImageView *iconImageView;
@property (nonatomic , retain) UILabel *nameLabel;
@property (nonatomic , retain) NSString *typeString;
@property (nonatomic , retain) NSString *sizeString;
@property (nonatomic , retain) UILabel *goodNumberLabel;
@property (nonatomic , retain) UILabel *downloadNumberLabel;
@property (nonatomic , retain) DownloadBtn *downLoadBtn;
@property (nonatomic , retain) NSString *iconURLString;//图标
@property (nonatomic , retain) NSString *appID;
@property (nonatomic , retain) NSString *plistURL;
@property (nonatomic , retain) NSString *appVersion;
@property (nonatomic , retain) NSString *identifier;//用于区分cell所属tableview
@property (nonatomic , retain) NSString *source;//来源
- (void)setNameLabelText:(NSString *)nameStr;
- (void)setGoodNumberLabelText:(NSString *)goodNumberStr;
- (void)setDownloadNumberLabelText:(NSString *)downloadNumberStr;
- (void)setLabelType:(NSString *)typeStr Size:(NSString *)sizeStr;
- (void)setDetailText:(NSString *)detailText;
- (void)initDownloadButtonState;
- (void)initCellwithInfor:(NSDictionary *)infor;//初始化cell
- (void)setInforNil;//置空


@property (nonatomic,retain)SearchManager *searchManager;
@property(nonatomic,retain)SearchResultTabelViewController *searchResultTableViewController;
@end
