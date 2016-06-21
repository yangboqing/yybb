//
//  DownOverTableViewCell.h
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//  

#import <UIKit/UIKit.h>

@interface DownOverTableViewCell : UITableViewCell{
    UIImageView *iconImageView;
    UILabel *infoLabel;
    UIImage *defaultImg;
    UIImageView *cellBGimageView;
    
//@private
	UIImageView*	m_checkImageView;
	BOOL			m_checked;
}

@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UIButton *installBtn;
@property (nonatomic , assign) BOOL m_checked;

@property (nonatomic , strong) NSString *idenStr;
@property (nonatomic , strong) NSString *appID;

- (void)downOverCellIconImage:(UIImage *)img;
- (void)downOverCellName:(NSString *)nameStr;
- (void)downOverCellVersion:(NSString *)str volume:(NSUInteger)volume; //版本和容量
- (void)setIphoneButtonImage:(UIImage *)img;

- (void) setChecked:(BOOL)checked;//设置选中状态

- (NSString *)getCellVersion;

@end
