//
//  RepairAppViewController.h
//  browser
//
//  Created by liguiyang on 14-12-1.
//
// 设置、下载管理、第一次启动引导

typedef enum {
    repairApp_Normal = 20,
    repairApp_DownloadManage,
}RepairAppListType;

#import <UIKit/UIKit.h>

@interface RepairAppViewController : UIViewController

@property (nonatomic, assign) RepairAppListType repairListType;

@end
