//
//  FindListViewController.h
//  KY20Version
//
//  Created by liguiyang on 14-5-19.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    findColumn_choiceType = 800, // 精选
    findColumn_evaluateType, // 评测
    findColumn_informationType, // 资讯
    findColumn_applePieType // 苹果派
}FindColumnType;

@protocol FindListViewDelegate <NSObject>

-(void)findNavControllerPushViewController:(UIViewController *)viewController;

@end

@interface FindListViewController : UIViewController

@property (nonatomic, weak) id <FindListViewDelegate>delegate;

-(instancetype)initWithFindColumnType:(FindColumnType)columnType;
-(void)initilizationRequest; // 初次请求
@end
