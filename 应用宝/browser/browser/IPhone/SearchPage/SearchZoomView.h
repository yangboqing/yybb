//
//  SearchZoomView.h
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//搜索页面顶部搜索栏所在的视图

#import <UIKit/UIKit.h>
#import "WYTextFieldEx.h"

@protocol SearchZoomViewDelegate <NSObject>

@optional
- (void)showSearchHistory:(id)sender;
- (void)cancleSearching:(id)sender;
- (void)showAssociate:(id)sender;
- (void)beginSearching:(id)sender;
@end

#define PLACEHOLDER @"请输入搜索关键词"
@interface SearchZoomView : UIView<UITextFieldDelegate>{
    UIToolbar *toolbar;
    BOOL isSearch;
    BOOL isResultPage;
    UIImageView *cuttingLineView;
    UIImageView *searchGlassImageView;
}
@property (nonatomic , retain) WYTextFieldEx *searchBar;
@property (nonatomic , retain) UIButton *searchButton;
@property (nonatomic , weak) id <SearchZoomViewDelegate>delegate;

- (void)isSearchFrame:(BOOL)isSearchStaute andIsResulePage:(BOOL)resultPage;
@end
