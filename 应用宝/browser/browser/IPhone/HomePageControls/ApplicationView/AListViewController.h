//
//  AListViewController.h
//  browser
//
//  Created by mingzhi on 14-5-14.
//
//  应用排行榜页面

#import <UIKit/UIKit.h>
#import "MarketListViewController.h"
#import "MarketServerManage.h"

typedef enum{
    rankingListType_App = 400,
    rankingListType_Game
}RankingListType;

@interface AListViewController : UIViewController<MarketServerDelegate,MarketListViewDelegate>

- (id)initWithRankingListType:(RankingListType)listType;

@end
