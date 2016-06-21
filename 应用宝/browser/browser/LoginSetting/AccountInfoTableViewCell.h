//
//  AccountInfoTableViewCell.h
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import <UIKit/UIKit.h>

@interface AccountInfoTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel *leftName;
@property (nonatomic , strong) UILabel *rightInfo;
- (void)setBackGroundImage:(int)index;
- (void)showLine:(BOOL)isShow;
@end
