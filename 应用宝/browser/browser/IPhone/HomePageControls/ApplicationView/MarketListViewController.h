//
//  MarketListViewController.h
//  browser
//
//  Created by liguiyang on 14-10-8.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    marketList_AppHotType = 1200, // 最热应用
    marketList_AppLatestType, // 最新应用
    marketList_AppWeekRankingType, // 应用排行榜(周、月、总榜)
    marketList_AppMonthRankingType,
    marketList_AppTotalRankingType,
    marketList_GameHotType, // 最热游戏
    marketList_GameLatestType, // 最新游戏
    marketList_GameFengCeType, // 封测游戏
    marketList_GameWeekRankingType, // 游戏排行榜(周、月、总榜)
    marketList_GameMonthRankingType,
    marketList_GameTotalRankingType,
    marketList_NewAddFreeApp,//2.7版本新增,免费应用
    marketList_NewAddFreeGame,//2.7版本新增,免费游戏
}MarketListType;

@protocol MarketListViewDelegate <NSObject>

@optional
-(void)aCellHasBeenSelected:(NSDictionary *)infoDic;

@end

@interface MarketListViewController : UIViewController

@property (nonatomic, weak) id <MarketListViewDelegate>delegate;
@property (nonatomic, assign) BOOL isFreeCell;


-(id)initWithMarketListType:(MarketListType)marketListType;

-(void)initRequest;

-(void)removeListener;

@end
