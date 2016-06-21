//
//  AppInforFootView.h
//  browser
//
//  Created by caohechun on 14-6-3.
//
//

#import <UIKit/UIKit.h>
//app 详情页的表视图的footView,用于显示app基本信息
@interface AppInforFootView : UIView
@property(nonatomic,retain) NSString *appID;
- (void)initAppInforWithData:(NSDictionary *)dataDic;//设置常规信息
@end
