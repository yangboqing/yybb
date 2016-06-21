//
//  SearchViewController.h
//  browser
//
//  Created by 王毅 on 13-10-23.
//
//搜索页面主控制器

#import <UIKit/UIKit.h>
#import "SearchManager.h"
#import "SearchZoomView.h"
#import "SearchHistoryRecordTableViewController.h" // 搜索记录
#import "SearchAssociationTableViewController.h" // 搜索联想TableViewController
#import "SearchHotWordHomeViewController.h" // 搜索热词页面
#import "MarketServerManage.h"
@interface SearchViewController : UIViewController<SearchHotWordHomeViewDelegate,SearchAssociationTableViewDelegate,SearchHistoryRecordDelegate,MarketServerDelegate,SearchManagerDelegate>
{
    UILabel *titleLabel;
    UIButton *backButton;
    SearchZoomView *searchZoomView;
    SearchHistoryRecordTableViewController *searchHistoryRecordTableViewController; // 搜索记录
    SearchAssociationTableViewController *searchAssociationTableViewController; // 搜索联想
    SearchHotWordHomeViewController *searchHotWordHomeViewController; // 搜索热词
}
- (void)requestTheHotWord;
@end
