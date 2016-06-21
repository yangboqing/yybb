//
//  UtilityViewController.h
//  MyHelper
//
//  Created by liguiyang on 15-3-3.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "CollectionViewBack.h"
#import "MirrorViewController.h"
typedef enum {
    utility_phoneNumberType, // 手机号码归属地
    utility_deviceRecordType, // 设备维修记录
}UtilityType;

@interface UtilityViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITextField *_textField;
    UIView *_lineView;
    UIView *_backGroundView;//_tableView背景
    UITableView *_tableView;
    EGORefreshTableHeaderView *_egoRefreshView;
    BOOL _refreshHeaderLoading;
    MirrorViewController *_mirrorViewController;
    
    NSMutableArray *_dataArr;
    NSMutableArray *_numberNameArr;
    NSMutableArray *_deviceNameArr;
    NSMutableArray *_deviceDataArr;
}
- (instancetype)initWithUtilityType:(UtilityType)utilityType;

@end
