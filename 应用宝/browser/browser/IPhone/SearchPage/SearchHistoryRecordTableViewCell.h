//
//  SearchHistoryRecordTableViewCell.h
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import <UIKit/UIKit.h>

@interface SearchHistoryRecordTableViewCell : UITableViewCell
@property (nonatomic , retain) UIButton *deleteButton;
@property (nonatomic , retain) UILabel *recordLabel;
- (void)setHistroyRecord:(NSString *)recordStr;
@end
