//
//  DetailHeaderView.h
//  browser
//
//  Created by niu_o0 on 14-6-10.
//
//

#import <UIKit/UIKit.h>
#import "TopicImageView.h"
//专题图展示原始尺寸640x360
//专题图展示下拉尺寸640x420
//占位图尺寸 580x296


#define imageHeight 147.5
#define ORIGINAL_IMAGE_HEIGHT 180 * (MainScreen_Width/320)  //初始高度
#define NORMAL_IMAGE_HEIGHT 210 * (MainScreen_Width/320) //图片显示完全时的高度
#define MAX_IMAGE_HEIGHT 240 * (MainScreen_Width/320) //拉伸后的最大高度
#define textFont    12.0f

@interface DetailHeaderView : UICollectionReusableView{
    @package
    UILabel * _contentView;
    @private
    CGSize _size;
}

@property (nonatomic, strong) TopicImageView * imageView;
@property (nonatomic, strong) NSString * contentText;
//设置简介占用高度
- (void)setIntroTextHeight:(float)theHeight;
//置空
- (void)reset;
//下拉刷新后恢复正常
- (void)recover;
@end
