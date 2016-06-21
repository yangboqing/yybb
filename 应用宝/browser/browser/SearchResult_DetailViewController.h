//
//  SearchResult_DetailViewController.h
//  browser
//
//  Created by caohechun on 14-4-9.
//
//

#import <UIKit/UIKit.h>
#import "SearchServerManage.h"
#import "SearchResult_DetailTableViewController.h"
#import "RotatingLoadView.h"
#import "AppTestTableViewController.h"
#import "AppRelevantTableViewController.h"

@interface SearchResult_DetailViewController : UIViewController<TestDetailDelegate,relevantDelegate>
@property (nonatomic,retain)RotatingLoadView *rotatingLoadView;
@property (nonatomic,retain) UIView *BG;
@property (nonatomic,retain) NSString *detailSource;
@property (nonatomic,retain) NSString *detailType;
@property (nonatomic,retain) UIImage *icon;
@property (nonatomic,retain) UIImage *tmpTestImg;
@property (nonatomic,assign) BOOL isPushByClassification;//是否从分类推入

@property (nonatomic,retain) NSString *mianliuPList;

- (void)beginPrepareAppContent:(NSDictionary *)appDic;
- (void)setDetailToZeroPoint;
- (void)showDetailTableView;
- (void)hideDetailTableView;
- (void)setAppSoure:(NSString *)soure;
- (void)checkPraiseButtonState;//检查并设置推荐按钮状态
- (void)goBackVC;
//禁止或启用点击分享/推荐等按钮
- (void)lockFunctionButton:(BOOL)lock;//YES锁 NO解锁
@end
