//
//  SearchToolBar.h
//  MyHelper
//
//  Created by liguiyang on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchToolBarDelegate <NSObject>

- (void)searchToolBarContentChange:(NSString *)content; // 搜索框内容改变
- (void)searchToolBarSearch:(NSString *)keyWord; // 搜索
- (void)searchToolBarCancelClick:(id)sender; // 搜索框点击取消按钮
- (void)searchToolBarBackClick:(id)sender; // 搜索框点击返回按钮

@end

@interface SearchToolBar : UIView<UITextFieldDelegate>

@property (nonatomic, weak) id <SearchToolBarDelegate>delegate;

// 设置/获取 搜索词
- (void)setSearchContent:(NSString *)content;
- (NSString *)getSearchContent;

// 取消键盘
- (void)hideKeyboard;
// 设置搜索框 聚焦对应的状态
- (void)setFocus:(BOOL)focus;

@end
