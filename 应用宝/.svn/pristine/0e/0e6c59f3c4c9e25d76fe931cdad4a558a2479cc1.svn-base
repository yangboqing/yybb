//
//  SearchKeyWordViewController.h
//  MyHelper
//
//  Created by liguiyang on 14-12-30.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchKeyWordViewDelegate <NSObject>
@optional
- (void)keyWordWasSelected:(NSString *)keyWord;

@end

typedef enum{
    keyWordList_associateKeyWordType = 10,
    keyWordList_recondType,
}KeyWordListType;

@interface SearchKeyWordViewController : UIViewController

@property (nonatomic, weak) id <SearchKeyWordViewDelegate>delegate;

- (instancetype)initWithSearchListType:(KeyWordListType)listType;
- (void)setKeyWordDataSource:(NSArray *)dataSource;

@end
