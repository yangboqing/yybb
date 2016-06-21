//
//  DownLoadManageViewController.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  管理应用页面

#import <UIKit/UIKit.h>
#import "DownLoadManageTopView.h"
#import "DownLoadingTableViewController.h"
#import "DownOverTableViewController.h"
#import "HeadImageView.h"

@interface DownLoadManageViewController : UIViewController<DownLoadManageTopViewDelegate,DownOverTableViewDelegate,DownLoadingTableViewDelegate,UIAlertViewDelegate>{
    @public
    DownLoadManageTopView *topView;
    @protected
    
    HeadImageView * _headImageView;
    
    DownLoadingTableViewController * _downLoadingTableViewController;
    DownOverTableViewController * _downOverTableViewController;
    
    BOOL isPopDeleteShowView;//判断是否弹出全选删除页面
}

- (void)showDownloadPage:(NSString *)pageName;

@end
