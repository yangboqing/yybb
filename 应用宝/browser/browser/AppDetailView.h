//
//  AppDetailView.h
//  browser
//
//  Created by caohechun on 14-4-2.
//
//

#import <UIKit/UIKit.h>
#define BOARDER_WIDTH 10
#define DETAIL_FONT_SIZE 13
#define INTERACTIVE_POPGESTURE_WIDTH 5
@interface AppDetailView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,retain)    UIButton *expandButton;
@property(nonatomic,retain)   UIScrollView *scrollImageView;
@property(nonatomic,retain)    UIButton *promoteButton;
@property (nonatomic,retain)UIImageView *expandLine;
@property(nonatomic,retain)   UIView *imagesContainer;
- (float) getAppDetailViewHeight;
//根据实际文字内容的多少确定展开后detailLabel 的frame
- (void)setExpandedDetailLabelHeight:(float)newHeight;
//detailLabel内容收起
- (void)recoverDetailLabel;
//设置内容
- (void)setDetailContent:(NSString *)content;
//获取内容
- (NSString *)getDetailContent;
//设置截图scrollView
- (void)setIntroImage:(UIImage *)image withPageIndex:(int )index pageCount:(int)count;
//设置pageControl
- (void)setPageControl:(int )page;
//截图内容置空
- (void)setIntroImagesNil;
//设置应用基本信息
- (void)setAppInfor:(NSDictionary *)dataDic;

//获取当前图片的宽度
- (float)getCurrentImgWidth;
//- (void)setImgsScrollContentOffset;

//获取当前截图数量
- (int)getImagesCount;
//调整截图默认图的大小和数量
- (void)resetPreviewsFrameWithWidth:(float) newWidth withCount:(int )count;
@end
