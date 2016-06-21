
#import <UIKit/UIKit.h>




typedef enum {
	UIImageCornerPositionTop = 1,
	UIImageCornerPositionBottom
} UIImageCornerPosition;


typedef enum {
    CapLeft          = 0,  //带有 左cap
    CapMiddle        = 1,  //不带 cap
    CapRight         = 2,  //带有 右cap
    CapLeftAndRight  = 3   //带有 左右cap
} CapLocation;


@interface UIImage (UIImageScale)

//辅助函数
void addRoundedRectToPathEx(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight, UIImageCornerPosition position);
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);

//截取部分图像
- (UIImage*) getSubImage:(CGRect)rect;

//把图片缩放到指定大小
+ (UIImage*) resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height;

//创建圆角IMAGE
+ (UIImage *) getRoundedRectImage:(UIImage*)image;
+ (UIImage *) getRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (UIImage *) getRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(NSInteger)radius;

//图片缩放
- (UIImage*) scaleToSize:(CGSize)size;

+ (UIImage *) scaleImage:(UIImage *)image  toScale:(float)scaleSize;
+ (UIImage *) reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *) captureView:(UIView *)theView;

//图片旋转
- (UIImage *) imageRotatedByRadians:(CGFloat)radians;
- (UIImage *) imageRotatedByDegrees:(CGFloat)degrees;

//图片带边框图片
- (UIImage *) imageWithBorderWidth:(CGFloat)width;
//设置指定位置, 幅度的圆角图片
- (UIImage *) imageWithRoundCornerWidth:(int)cornerWidth Height:(int)cornerHeight Position:(UIImageCornerPosition)position;



/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;



//
+ (UIImage *) imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage;
+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *) sourceImage;

//创建是否带有左右Cap的按钮
+(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;


//根据项目类型取资源
//+ (UIImage *) imageNamedForIphone:(NSString *)name;

@end


/*
 // 裁剪图片
 //image = [image getSubImage:CGRectMake(10, 10, 70, 80)];
 
 //等比列缩放
 image = [image scaleToSize:CGSizeMake(200, 300)]; 
 
 */


