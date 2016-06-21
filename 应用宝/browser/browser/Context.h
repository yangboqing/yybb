//
//  StaticImage.h
//  browser
//
//  Created by niu_o0 on 14-6-4.
//
//

#import <Foundation/Foundation.h>
#import "MyNavigationController.h"

typedef enum { // 导航栏 leftBarButtonItem样式
    leftBarItem_backType = 300,
    leftBarItem_downArrowType,
    leftBarITem_pop
}LeftBarItemType;

typedef enum { // 导航栏 rightBarButtonItem样式
    rightBarItem_searchType = 310,
    rightBarItem_praiseType,
    rightBarItem_downArrowType,
    rightBarItem_categoryIconType
}RightBarItemType;

#define addNavigationLeftBarButton(leftBarType, target, action) \
            self.navigationItem.hidesBackButton = YES; \
            self.navigationItem.leftBarButtonItem = [Context addNavLeftBarType:leftBarType Target:target Action:action]

#define addNavigationRightBarButton(rightBarType, target, action) \
            self.navigationItem.rightBarButtonItem = [Context addNavRightBarType:rightBarType Target:target Action:action]

#define lunboHeight     (150*(MainScreen_Width/375))

typedef enum {
    tagNav_home = 1100,
    tagNav_choice = 10,
    tagNav_game,
    tagNav_app,
    tagNav_search,
    tagNav_my,
    tagNav_other,
}TagNavType; // choice、game、app与searchType响应值对应

typedef enum{
    homeToolBar_ChoiceType = 100,
    homeToolBar_GameType,
    homeToolBar_AppType,
    homeToolBar_SearchType,
    homeToolBar_MyType
}HomeToolBarItemType;

@interface Context : NSObject

+ (instancetype) defaults;
// 当前显示的导航tag值（解决搜索热词界面接收数据混乱的问题）
@property (nonatomic, assign) TagNavType currentNavTag;
@property (nonatomic, assign) HomeToolBarItemType currentBarTag; // 底部导航
@property (nonatomic, assign) NSUInteger homeToolBarBtnCount; // 底部导航按钮个数
@property (nonatomic, strong) MyNavigationController *homeNav;
@property (nonatomic, strong) NSString *adUrlStr; // 广告URL
@property(nonatomic,retain)NSString *digID;

+ (UIBarButtonItem *)addNavLeftBarType:(LeftBarItemType)leftItemType Target:(id)target Action:(SEL)action;
+ (UIBarButtonItem *)addNavRightBarType:(RightBarItemType)rightItemType Target:(id)target Action:(SEL)action;

@end
