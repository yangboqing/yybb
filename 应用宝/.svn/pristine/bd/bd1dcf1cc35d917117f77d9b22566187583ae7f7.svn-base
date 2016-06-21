//
//  DownLoadingTableViewController.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  正在下载列表

typedef enum {
    downLoadingType_showEmpty = 10,
    downLoadingType_refresh
    
}DownLoading_Type;

typedef enum {
    topButtonType_AllEnable = 0,
    topButtonType_AllDisable,
    TopButtonType_AllStart,
    TopButtonType_AllPause
}TopButton_StateType;

#import <UIKit/UIKit.h>
#import "DownLoadingTableViewCell.h"
#import "SettingPlistConfig.h"

@protocol DownLoadingTableViewDelegate <NSObject>

-(void)downloadingTableViewChanged:(DownLoading_Type)type;

@optional
-(void)downloadingChangeTopButtonState:(TopButton_StateType)type;

@end

@interface DownLoadingTableViewController : UITableViewController<UIAlertViewDelegate>
{
    BOOL editFlag;
    BOOL hasEditFlag;
    NSMutableArray *selectToDeleteArray;
}

@property (nonatomic , weak)id<DownLoadingTableViewDelegate>delegate;
@property (nonatomic , strong) NSMutableArray *selectToDeleteArray;
@property (nonatomic , strong) NSString *cellselectStyle;

-(void)setTableViewEdit:(BOOL)edit;
-(BOOL)tableViewEditStyleDone; // tableView是否是编辑状态

- (NSInteger)numberOfPauseItems;
- (void)clickAllStartBtn;
- (void)clickAllPauseBtn;
- (void)clickPlistStartBtn:(NSString *)_urlString;
- (void)deleteSpeedDic;
- (void)deleteSelectedRows;
- (void)selectAllCells:(BOOL)flag;
@end
