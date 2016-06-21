//
//  DownOverTableViewController.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  完成下载列表

typedef enum {
    downOverType_showEmpty = 0,
    downOverType_refresh
}DownOver_Type;

typedef enum {
    topEditButton_Enable = 0,
    topEditButton_Disable
}TopEditButton_State;

#import <UIKit/UIKit.h>
#import "DownOverTableViewCell.h"
#import "GetDevIPAddress.h"
#import "BppDistriPlistManager.h"

@protocol DownOverTableViewDelegate <NSObject>

-(void)downOverTableViewChanged:(DownOver_Type)type;
@optional
-(void)downOverChangeTopButtonState:(TopEditButton_State)state;

@end

@interface DownOverTableViewController : UITableViewController<UIAlertViewDelegate,BppDistriPlistManagerDelegate>

@property (nonatomic , weak)id<DownOverTableViewDelegate>delegate;

@property (nonatomic , strong) NSMutableArray *selectToDeleteArray;
@property (nonatomic , strong) NSString *cellselectStyle;

@property (nonatomic , strong) NSMutableArray *installArray;  //安装列表
@property (nonatomic , strong) NSMutableArray *reinstallArray; //重装列表

-(void)setTableViewEdit:(BOOL)edit;
-(BOOL)tableViewEditStyleDone; // tableView是否是编辑状态

- (void)clearAllAppAndReloadDataSource;
- (void)clickdeleteSelectedRows:(id)sender;//删除选中
- (void)selectAllCells:(BOOL)flag;
@end
