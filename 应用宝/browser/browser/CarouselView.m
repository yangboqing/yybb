
//
//  CarouselView.m
//  MyHelper
//
//  Created by liguiyang on 15-1-8.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "CarouselView.h"

@interface CarouselView ()<UIScrollViewDelegate>
{
    CGRect preFrame;
    CGRect curFrame;
    CGRect nextFrame;
    UIImageView  *preImgView;
    UIImageView  *curImgView;
    UIImageView  *nextImgView;
    UIScrollView *cycleScrollView;
    
    UILabel *trackLabel; // 轨道
    UILabel *segmentLabelOne; // 线段
    UILabel *segmentLabelTwo;
    NSInteger segmentWidth;
    BOOL    segmentHideFlag; // 外部控制tanckLabel是否显示
    
    //
    NSInteger numberOfPages; // 总页数
    NSInteger globalCurPage; // 当前页数
    
    //
    UIImage *defaultImg;
    dispatch_source_t timer;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) NSArray *carouselArray; // 轮播图数据源

@end

@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 全局数据
        numberOfPages = 1;
        defaultImg = (frame.size.height==lunboHeight)?[UIImage imageNamed:@"rotationDefault.png"]:[UIImage imageNamed:@"jingxuan_lunbo.png"];
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        preFrame = CGRectMake(0, 0, width, height);
        curFrame = CGRectMake(width, 0, width, height);
        nextFrame = CGRectMake(width*2, 0, width, height);
        
        // 滚动图片
        preImgView = [[UIImageView alloc] initWithImage:defaultImg];
        curImgView = [[UIImageView alloc] initWithImage:defaultImg];
        nextImgView = [[UIImageView alloc] initWithImage:defaultImg];
        
        cycleScrollView = [[UIScrollView alloc] init];
        cycleScrollView.pagingEnabled = YES;
        cycleScrollView.delegate = self;
        cycleScrollView.showsHorizontalScrollIndicator = NO;
        cycleScrollView.showsVerticalScrollIndicator = NO;
        
        [cycleScrollView addSubview:preImgView];
        [cycleScrollView addSubview:curImgView];
        [cycleScrollView addSubview:nextImgView];
        [self addSubview:cycleScrollView];
        
        // 滑动线段
        trackLabel = [[UILabel alloc] init];
        trackLabel.backgroundColor = hllColor(0.0, 0.0, 0.0, 0.3);
        segmentLabelOne = [[UILabel alloc] init];
        segmentLabelTwo = [[UILabel alloc] init];
        segmentLabelOne.backgroundColor = hllColor(255.0, 204.0, 0.0, 1.0);
        segmentLabelTwo.backgroundColor = hllColor(255.0, 204.0, 0.0, 1.0);
        [self addSubview:trackLabel];
        [self addSubview:segmentLabelOne];
        [self addSubview:segmentLabelTwo];
        
        // tapGesture
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
        [self addGestureRecognizer:tapGesture];
        
        [self setOriginFrame];
//        [self setEventTimer]; // timer
        cycleScrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark TapGesture(call delegate)

- (void)tapGestureClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carouselViewClick:)]) {
        [self.delegate carouselViewClick:globalCurPage];
    }
}

- (void)callScrollToIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(carouselViewScroll:)]) {
        [self.delegate carouselViewScroll:index];
    }
}

#pragma mark outside interface

- (void)setCarous_dataSource:(NSArray *)array
{
    // 数据为空
    if (array==nil || array.count==0) {
        [self setCarousTimerStop:YES];
        return;
    }
    // 数据变
    if ([_carouselArray isEqualToArray:array] && array.count!=0) {
        return ;
    }
    
    // 数据改变
    if (array && array.count>1)
    {
        self.carouselArray = array;
        numberOfPages = _carouselArray.count;
        globalCurPage = 0;
        [self setImageValid];
        [self setCarousTimerStop:NO];
        
        // segment
        segmentWidth = MainScreen_Width/numberOfPages;
        CGFloat oriY = self.bounds.size.height-1.5;
        segmentLabelOne.frame = CGRectMake(0, oriY, segmentWidth, 1.5);
        segmentLabelTwo.frame = CGRectMake(-segmentWidth, oriY, segmentWidth, 1.5);
        
        [self setOriginFrame];
    }
    else if(array.count == 1)
    {
        self.carouselArray = array;
        
        [self setCarousTimerStop:YES];
        [self setImageValid];
        [self setImgViewFrameValid];
    }
}

- (void)setCarousViewFrame:(CGRect)frame
{
    // imageFrame
    self.frame = frame;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    preFrame = CGRectMake(0, 0, width, height);
    curFrame = CGRectMake(width, 0, width, height);
    nextFrame = CGRectMake(width*2, 0, width, height);
    
    // segmentFrame
    if (_carouselArray.count > 1) {
        static BOOL onceFlag = YES;
        segmentWidth = MainScreen_Width/numberOfPages;
        CGFloat oriY = self.bounds.size.height-1.5;
        
        if (onceFlag) {
            onceFlag = NO;
            segmentLabelOne.frame = CGRectMake(0, oriY, segmentWidth, 1.5);
            segmentLabelTwo.frame = CGRectMake(-segmentWidth, oriY, segmentWidth, 1.5);
        }
        else
        {
            CGRect frame = segmentLabelOne.frame;
            frame.origin.y = oriY;
            segmentLabelOne.frame = frame;
            
            frame = segmentLabelTwo.frame;
            frame.origin.y = oriY;
            segmentLabelTwo.frame = frame;
        }
        
        
        // other frame
        [self setOriginFrame];
    }
    else
    {
        cycleScrollView.frame = self.bounds;
        cycleScrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        cycleScrollView.contentOffset = CGPointMake(0, 0);
        trackLabel.frame = CGRectMake(0, self.bounds.size.height-1.0, self.bounds.size.width, 0.5);
        [self setImgViewFrameValid];
    }
}

- (void)setCarousTimerStop:(BOOL)stopFlag
{
    if (timer) {
        if (stopFlag) {
            dispatch_source_cancel(timer);
        }
        else
        {
            dispatch_source_cancel(timer);
            if (_carouselArray.count >1) [self setEventTimer];
        }
    }
    else if(!stopFlag)
    {
        if (_carouselArray.count >1) [self setEventTimer];
    }
}

- (void)setCarousTrackHide:(BOOL)hideFlag
{
    segmentHideFlag = hideFlag;
    trackLabel.hidden = hideFlag;
    segmentLabelOne.hidden = hideFlag;
    segmentLabelTwo.hidden = hideFlag;
}

#pragma mark Utility

- (void)setImageValid
{
    if (_carouselArray==nil || _carouselArray.count<1) return;
    
    NSInteger prePage = [self getValidPageCount:globalCurPage-1];
    NSInteger curPage = [self getValidPageCount:globalCurPage];
    NSInteger nextPage = [self getValidPageCount:globalCurPage+1];
    
    [preImgView sd_setImageWithURL:[NSURL URLWithString:[_carouselArray[prePage] objectForKey:@"pic_url"]] placeholderImage:defaultImg];
    [curImgView sd_setImageWithURL:[NSURL URLWithString:[_carouselArray[curPage] objectForKey:@"pic_url"]] placeholderImage:defaultImg];
    [nextImgView sd_setImageWithURL:[NSURL URLWithString:[_carouselArray[nextPage] objectForKey:@"pic_url"]] placeholderImage:defaultImg];
}

- (void)setImgViewFrameValid
{
    preImgView.frame = preFrame;
    curImgView.frame = curFrame;
    nextImgView.frame = nextFrame;
}

- (NSInteger)getValidPageCount:(NSInteger)pageCount
{
    NSInteger validPage = pageCount;
    
    if (pageCount >= numberOfPages) {
        validPage = 0;
    }
    else if (pageCount < 0)
    {
        validPage = numberOfPages - 1;
    }
    
    return validPage;
}

- (void)setEventTimer
{
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), 5*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        [self scrollToLeft:YES];
    });
    dispatch_source_set_cancel_handler(timer, ^{
    });
    dispatch_resume(timer);
}

- (void)setOriginFrame
{
    cycleScrollView.frame = self.bounds;
    cycleScrollView.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
    cycleScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    trackLabel.frame = CGRectMake(0, self.bounds.size.height-1.0, self.bounds.size.width, 0.5);
    [self setImgViewFrameValid];
}

- (void)scrollToLeft:(BOOL)animation
{
    if (animation) {
        [self setImageValid];
        preImgView.frame = nextFrame;
        [UIView animateWithDuration:0.35 animations:^{
            curImgView.frame = preFrame;
            nextImgView.frame = curFrame;
            [self segmentScrollToRight];
            
            globalCurPage = [self getValidPageCount:globalCurPage+1];
        } completion:^(BOOL finished) {
            UIImageView *tmpImgView = curImgView;
            curImgView = nextImgView;
            nextImgView = preImgView;
            preImgView = tmpImgView;
            // 调用代理
            [self callScrollToIndex:globalCurPage];
        }];
    }
    else
    {
        UIImageView *tmpImgView = curImgView;
        curImgView = nextImgView;
        nextImgView = preImgView;
        preImgView = tmpImgView;
        
        [self segmentScrollToRight];
        [self setImgViewFrameValid];
        
        globalCurPage = [self getValidPageCount:globalCurPage+1];
        [self setImageValid];
        // 调用代理
        [self callScrollToIndex:globalCurPage];
    }
    
}

- (void)scrollToRight:(BOOL)animation
{
    if (animation) {
        [self setImageValid];
        nextImgView.frame = preFrame;
        [UIView animateWithDuration:0.35 animations:^{
            curImgView.frame = nextFrame;
            preImgView.frame = curFrame;
            [self segmentScrollToLeft];
            
            globalCurPage = [self getValidPageCount:globalCurPage-1];
        } completion:^(BOOL finished) {
            UIImageView *tmpImgView = curImgView;
            curImgView = preImgView;
            preImgView = nextImgView;
            nextImgView = tmpImgView;
            // 调用代理
            [self callScrollToIndex:globalCurPage];
        }];
    }
    else
    {
        UIImageView *tmpImgView = curImgView;
        curImgView = preImgView;
        preImgView = nextImgView;
        nextImgView = tmpImgView;
        
        [self segmentScrollToLeft];
        [self setImgViewFrameValid];
        
        globalCurPage = [self getValidPageCount:globalCurPage-1];
        [self setImageValid];
        // 调用代理
        [self callScrollToIndex:globalCurPage];
    }
}

#pragma mark Segment

- (void)segmentScrollToRight
{
    CGFloat width = self.bounds.size.width;
    NSInteger origin_hide = -segmentWidth;
    NSInteger origin_show = 0;
    NSInteger end_hide = width;
    NSInteger end_show = (numberOfPages-1)*segmentWidth;
    
    CGRect segFrameOne = segmentLabelOne.frame;
    CGRect segFrameTwo = segmentLabelTwo.frame;
    
    if (segFrameOne.origin.x == end_hide) {
        segFrameOne.origin.x = origin_hide;
        segmentLabelOne.hidden = YES;
        segmentLabelOne.frame = segFrameOne;
    }
    if (segFrameTwo.origin.x == end_hide) {
        segFrameTwo.origin.x = origin_hide;
        segmentLabelTwo.hidden = YES;
        segmentLabelTwo.frame = segFrameTwo;
    }
    
    if (segFrameOne.origin.x >= end_show) {
        
        segFrameOne.origin.x = end_hide;
        segmentLabelOne.frame = segFrameOne;
        
        segFrameTwo.origin.x = origin_show;
        segmentLabelTwo.hidden = segmentHideFlag;
        segmentLabelTwo.frame = segFrameTwo;
    }
    else if (segFrameTwo.origin.x >= end_show)
    {
        segFrameTwo.origin.x = end_hide;
        segmentLabelTwo.frame = segFrameTwo;
        
        segFrameOne.origin.x = origin_show;
        segmentLabelOne.hidden = segmentHideFlag;
        segmentLabelOne.frame = segFrameOne;
    }
    else
    {
        if (segFrameOne.origin.x == origin_hide) {
            segFrameTwo.origin.x = (globalCurPage+1)*segmentWidth;
            segmentLabelTwo.frame = segFrameTwo;
        }
        else
        {
            segFrameOne.origin.x = (globalCurPage+1)*segmentWidth;
            segmentLabelOne.frame = segFrameOne;
        }
    }
}

- (void)segmentScrollToLeft
{
    CGFloat width = self.bounds.size.width;
    NSInteger origin_hide = width;
    NSInteger origin_show = (numberOfPages-1)*segmentWidth;
    NSInteger end_hide = -segmentWidth;
    NSInteger end_show = 0;
    
    CGRect segFrameOne = segmentLabelOne.frame;
    CGRect segFrameTwo = segmentLabelTwo.frame;
    
    if (segFrameOne.origin.x == end_hide) {
        segFrameOne.origin.x = origin_hide;
        segmentLabelOne.hidden = YES;
        segmentLabelOne.frame = segFrameOne;
    }
    if (segFrameTwo.origin.x == end_hide) {
        segFrameTwo.origin.x = origin_hide;
        segmentLabelTwo.hidden = YES;
        segmentLabelTwo.frame = segFrameTwo;
    }
    
    if (segFrameOne.origin.x <= end_show) {
        
        segFrameOne.origin.x = end_hide;
        segmentLabelOne.frame = segFrameOne;
        
        segFrameTwo.origin.x = origin_show;
        segmentLabelTwo.hidden = segmentHideFlag;
        segmentLabelTwo.frame = segFrameTwo;
    }
    else if (segFrameTwo.origin.x <= end_show)
    {
        segFrameTwo.origin.x = end_hide;
        segmentLabelTwo.frame = segFrameTwo;
        
        segFrameOne.origin.x = origin_show;
        segmentLabelOne.hidden = segmentHideFlag;
        segmentLabelOne.frame = segFrameOne;
    }
    else
    {
        if (segFrameOne.origin.x == origin_hide) {
            segFrameTwo.origin.x = (globalCurPage-1)*segmentWidth;
            segmentLabelTwo.frame = segFrameTwo;
        }
        else
        {
            segFrameOne.origin.x = (globalCurPage-1)*segmentWidth;
            segmentLabelOne.frame = segFrameOne;
        }
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int curPage_ = floor((scrollView.contentOffset.x - width*0.5)/width+1);
    
    if (curPage_ == 0) { // move right
        [self scrollToRight:NO];
    }
    else if (curPage_ == 2)
    {
        [self scrollToLeft:NO];
    }
    
    if (_carouselArray.count > 1) [self setEventTimer];
    scrollView.contentOffset = CGPointMake(width, 0);
}

@end
