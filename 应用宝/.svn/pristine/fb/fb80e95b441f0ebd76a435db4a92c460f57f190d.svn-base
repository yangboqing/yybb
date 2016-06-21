//
//  ChoiceViewController.h
//  Mymenu
//
//  Created by mingzhi on 14/11/20.
//  Copyright (c) 2014年 mingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCells.h"

typedef void(^LeftBtnclickBlock)(id sender);

@interface ChoiceViewController_my : UIViewController
{
    LeftBtnclickBlock leftclickBlock;
}
//数据
@property (nonatomic, retain) NSMutableDictionary *dataDic;
//UI
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIButton *leftButton;;

- (void)listButtonClick:(MenuType)sender;//限免免费收费
- (void)setleftClickBlock:(LeftBtnclickBlock)block;
- (void)requestData:(BOOL)isUseCache;
@end
