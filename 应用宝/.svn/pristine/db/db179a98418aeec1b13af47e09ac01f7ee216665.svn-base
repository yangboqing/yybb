//
//  PublicTableViewCell.h
//
//
//  Created by mingzhi on 14-5-8.
//  
//  自定义cell

#import <UIKit/UIKit.h>
@class PriceLabel;
@interface IconImageView : UIImageView

@property (nonatomic, strong) CAShapeLayer *imageLayer;
@property (nonatomic, assign) CGFloat radius;

@end

@interface PublicTableViewCell : UITableViewCell <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *downLoadSource;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSString *sizeString;

@property (nonatomic, strong) UILabel *goodNumberLabel;
@property (nonatomic, strong) UILabel *downloadNumberLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) NSString *iconURLString;//图标
@property (nonatomic, strong) NSString *previewURLString;//大图

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *plistURL;
@property (nonatomic, strong) NSString *identifier;//用于区分cell所属tableview
@property (nonatomic, strong) NSString *appPrice;//价格 2.7新增

@property (nonatomic, strong) IconImageView *iconImageView;

@property (nonatomic, strong) UIImageView *iconNumImageView;
@property (nonatomic, retain) PriceLabel *priceLabel;



- (void)initCellInfoDic:(NSDictionary *)dic;
- (void)setAppIconImageView:(UIImage *)image;
- (void)setNameLabelText:(NSString *)nameStr;
- (void)setGoodNumberLabelText:(NSString *)goodNumberStr;
- (void)setDownloadNumberLabelText:(NSString *)downloadNumberStr;
- (void)setLabelType:(NSString *)typeStr Size:(NSString *)sizeStr;
- (void)setDetailText:(NSString *)detailText;

- (void)initDownloadButtonState; // 市场列表cell 状态设置
- (void)setAngleNumber:(NSInteger)number; // 设置排行榜排名显示

- (void)reloadRepairButtonState; // 应用修复cell 状态设置
- (void)setPrice;//设置价格
@end
