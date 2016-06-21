//
//  FindDetailViewController.h
//  KY20Version
//
//  Created by liguiyang on 14-5-21.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

typedef enum{
    activity_Type = 0,
    argument_Type
}WebViewType;

#define MULTIPLE [[UIScreen mainScreen] bounds].size.width/375//适配倍数

#import <UIKit/UIKit.h>

@interface FindDetailViewController_my : UIViewController

@property (nonatomic, strong) NSString *fromSource;
@property (nonatomic, strong) NSString *source;//find详情页的来源
@property (nonatomic, strong) UIImage  *shareImage;
@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) UINavigationController *navigationController;

-(void)reloadActivityDetailVC:(NSDictionary *)dic;

-(void)removeObserverAndListener; //pop出FindDetailViewController实例之后调用

@end
