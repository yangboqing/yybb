//
//  AppDetailView.m
//  browser
//
//  Created by caohechun on 14-4-2.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppDetailView.h"
#import "UIImageEx.h"
#import "PreViewImageView.h"
#import "AppInforFootView.h"
#import "CollectionViewBack.h"
@interface AppDetailView()
{
 
    UITextView *detailTextView;
    CGRect detailLabelRect;
    UIPageControl *pageControl;
    NSString *praiseCount;
    NSMutableArray *allPreviews;
    AppInforFootView *appInforFootView;
    BOOL scrollViewFixed;//scrollview上的picture是否适配过
    int currentImgIndex;
    float imgWidth;
    UIView *imagesContainer;
    int imagesCount;
    UIImageView *line_;

}
@end
@implementation AppDetailView
- (void)dealloc{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.scrollEnabled = NO;
        imgWidth = PREVIEW_SCROLLVIEW_WEIGTH;
        _scrollImageView = [[UIScrollView alloc]init];
        _scrollImageView.backgroundColor = WHITE_BACKGROUND_COLOR;
        _scrollImageView.frame = CGRectMake(-INTERACTIVE_POPGESTURE_WIDTH, 10, PREVIEW_SCROLLVIEW_WEIGTH + BOARDER_WIDTH , PREVIEW_SCROLLVIEW_HEIGHT);//MainScreen_Width - 20
        _scrollImageView.contentSize = CGSizeMake(MainScreen_Width, PREVIEW_SCROLLVIEW_HEIGHT);
        _scrollImageView.showsHorizontalScrollIndicator = NO;
        _scrollImageView.bounces = YES;
        _scrollImageView.decelerationRate = 0.5;
        _scrollImageView.pagingEnabled = YES;
        _scrollImageView.clipsToBounds = NO;

        imagesContainer = [[UIView alloc]initWithFrame:CGRectMake(INTERACTIVE_POPGESTURE_WIDTH, 0, MainScreen_Width, PREVIEW_SCROLLVIEW_HEIGHT)];
        imagesContainer.userInteractionEnabled = YES;
        [imagesContainer addSubview:_scrollImageView];
        [imagesContainer addGestureRecognizer:_scrollImageView.panGestureRecognizer];
        self.imagesContainer = imagesContainer;
        
        
        pageControl = [[UIPageControl alloc]init] ;
//        pageControl.frame =  CGRectMake(0, 0, 30, 20);
//        pageControl.frame =  CGRectMake(imagesContainer.frame.origin.x - 46, imagesContainer.frame.origin.y + IMAGES_SCROLLVIEW_HEIGHT + 10, 30, 20);
        pageControl.center = CGPointMake(3,  imagesContainer.frame.origin.y + IMAGES_SCROLLVIEW_HEIGHT + 25);
        pageControl.currentPage = 1;
        pageControl.pageIndicatorTintColor = SEPERATE_LINE_COLOR;
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, pageControl.frame.origin.y + pageControl.frame.size.height + 15, MainScreen_Width - 20, 0.5)];
        line.backgroundColor = SEPERATE_LINE_COLOR;
        
        
        
        detailTextView = [[UITextView alloc]init];
        detailTextView.backgroundColor = [UIColor clearColor];
        detailTextView.font = [UIFont systemFontOfSize:DETAIL_FONT_SIZE];
//        detailTextView.lineBreakMode = NSLineBreakByTruncatingTail;
        detailTextView.textAlignment = NSTextAlignmentLeft;
        detailTextView.textColor = OTHER_TEXT_COLOR;
        detailTextView.userInteractionEnabled = YES;
        detailTextView.scrollEnabled = NO;
        detailTextView.editable = NO;
        detailLabelRect = CGRectMake(20, _scrollImageView.frame.origin.y + _scrollImageView.frame.size.height + 30, MainScreen_Width - 20*2, 80);
        detailTextView.frame = detailLabelRect;
        
        
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [LocalImageManager setImageName:@"expand_reading.png" complete:^(UIImage *image) {
            [_expandButton setImage:image forState:UIControlStateNormal];
        }];
        [_expandButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        line_ = [[UIImageView alloc]init];
        line_.backgroundColor = SEPERATE_LINE_COLOR;
        self.expandLine  = line_;
        appInforFootView = [[AppInforFootView alloc]init];
        
        [self addSubview:imagesContainer];
        [self addSubview:detailTextView];
        [self addSubview:line_];
        [self addSubview:line];
        [self addSubview:_expandButton];
        [self addSubview:appInforFootView];
        
        allPreviews = [[NSMutableArray alloc]init];
        for (int i  = 0; i<6; i++) {
            PreViewImageView *preview = [[PreViewImageView alloc]init];
            [allPreviews addObject:preview];
        }
    }
    return self;
}


- (void)layoutSubviews{

    _expandButton.frame = CGRectMake( MainScreen_Width- 99 +20, detailTextView.frame.origin.y + detailTextView.frame.size.height, 66, 29);
    if (_expandButton.hidden) {
       line_.frame = CGRectMake(10, _expandButton.frame.origin.y + _expandButton.frame.size.height/2, MainScreen_Width - 20, 0.5);
    }else{
       line_.frame = CGRectMake(10, _expandButton.frame.origin.y + _expandButton.frame.size.height/2, MainScreen_Width -90, 0.5);
    }

    appInforFootView.frame = CGRectMake(6, _expandButton.frame.origin.y + 20, MainScreen_Width, 60);
    
}

//获取整个scrollView的高度
- (float)getAppDetailViewHeight{
    [self layoutSubviews];
    return appInforFootView.frame.origin.y + appInforFootView.frame.size.height + 20;
}
//根据实际文字内容的多少确定展开后detailLabel 的frame
- (void)setExpandedDetailLabelHeight:(float)newHeight{
    detailTextView.frame = CGRectMake(detailLabelRect.origin.x, detailLabelRect.origin.y, detailLabelRect.size.width, newHeight);
//    detailTextView.numberOfLines = 0;
    
    self.frame = CGRectMake(0, 0, MainScreen_Width, [self getAppDetailViewHeight]);
    self.contentSize = self.frame.size;
    
}
//detailLabel内容收起
- (void)recoverDetailLabel{
    detailTextView.frame = detailLabelRect;
//    detailTextView.numberOfLines = 4;
//    detailTextView.lineBreakMode = NSLineBreakByTruncatingTail;
    self.frame = CGRectMake(0, 0, MainScreen_Width, [self getAppDetailViewHeight]);
    self.contentSize = self.frame.size;
}

- (NSString *)getDetailContent{
    return detailTextView.text;
}

- (NSString *)getPraiseCount{
    return praiseCount;
}
- (void)setDetailContent:(NSString *)content{
    if (content) {
        content  = [content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        content  = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    }else{
        content = @"";
    }
    
    detailTextView.text  = content;
    
    //临时解决可能会显示半行文字的情况
    detailTextView.frame = CGRectMake(20, _scrollImageView.frame.origin.y + _scrollImageView.frame.size.height + 30, self.frame.size.width- 20*2, 70);
}

- (void)setIntroImage:(UIImage *)image withPageIndex:(int )index pageCount:(int)count{
    if (count <1) {
        pageControl.numberOfPages = 1;

    }else{
        pageControl.numberOfPages = count;
        imagesCount = count;
    }

    if (count ==-1 ){//置空
        [self resetPreviewsFrameWithWidth:IMAGES_SCROLLVIEW_WEIGHT withCount:2];
        for (int i =[allPreviews count] - 1; i>=0; i --) {
            [allPreviews[i] removeFromSuperview];
            [allPreviews[i] setPicture:nil];
        }
    }else{

        PreViewImageView *preview = allPreviews[index];
        if (image.size.width > image.size.height) {
            image = [image imageRotatedByDegrees:- 90];
        }

        _scrollImageView.pagingEnabled = YES;
        if (count ==1) {
            _scrollImageView.pagingEnabled = NO;
        }
        [preview setPicture:image];
    }
}
- (int)getImagesCount{
    return imagesCount;
}
- (void)showNextImage{
    
}
- (void)showLastImage{
    
}

- (void)resetPreviewsFrameWithWidth:(float) newWidth withCount:(int )count{
    imgWidth = newWidth;
    CGRect tmpRect = _scrollImageView.frame;
    tmpRect.size.width =  BOARDER_WIDTH +newWidth;
    _scrollImageView.frame = tmpRect;
    _scrollImageView.contentSize = CGSizeMake((BOARDER_WIDTH + newWidth)*count +BOARDER_WIDTH, PREVIEW_SCROLLVIEW_HEIGHT);
    
    for (UIView *view in _scrollImageView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i  = 0; i<[allPreviews count]; i++) {
        PreViewImageView *preview = allPreviews[i];
        if (newWidth == IMAGES_SCROLLVIEW_WEIGHT) {
            [preview resetBackgroundImgForIphone4];
        }else if(newWidth == IMAGES_SCROLLVIEW_WEIGHT_IPHONE5){
            [preview resetBackgroundImgForIphone5];
        }
        preview.frame = CGRectMake(BOARDER_WIDTH + (newWidth + BOARDER_WIDTH)*i  , 0, newWidth, PREVIEW_SCROLLVIEW_HEIGHT );
        if (i<count) {
            [_scrollImageView addSubview:preview];
        }
    }
    
}
- (void)setPageControl:(int )page{
    pageControl.currentPage = page;
}
- (void)setIntroImagesNil{
    scrollViewFixed = NO;
    imgWidth = PREVIEW_SCROLLVIEW_WEIGTH;
    [self setIntroImage:nil withPageIndex:0 pageCount:-1];
    _scrollImageView.contentOffset = CGPointZero;
}

- (void)setAppInfor:(NSDictionary *)dataDic{
    [appInforFootView initAppInforWithData:dataDic];
}


- (float)getCurrentImgWidth{
    return imgWidth;
}
@end
