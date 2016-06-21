//
//  SearchViewController.h
//  browser
//
//  Created by 王毅 on 13-10-23.
//
//搜索页面主控制器

#import <UIKit/UIKit.h>

typedef enum{
    searchType_chosen = 10, // 精选模块
    searchType_game, // 应用模块
    searchType_app, // 游戏模块
    searchType_self,
}SearchType; // 与导航tag对应

@interface SearchViewController_my : UIViewController

- (instancetype)initWithSearchType:(SearchType)type;

@end
