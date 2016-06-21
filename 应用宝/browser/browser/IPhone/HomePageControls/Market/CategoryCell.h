//
//  CategoryCell.h
//  browser
//
//  Created by caohechun on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UIView
@property (nonatomic,strong)UIButton *categoryDetialButton;

- (void)setCategoryName:(NSString *)name andCount:(NSString *)count andID:(NSString *)categoryID;
- (NSString *)getCategoryID;
- (void)setTitileColorSelected:(BOOL)selected;
@end
