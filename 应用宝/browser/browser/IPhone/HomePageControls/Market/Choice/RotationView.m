//
//  RotationView.m
//  33
//
//  Created by niu_o0 on 14-4-28.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import "RotationView.h"
#import "SearchManager.h"
#import "UIImageEx.h"
#define kImageTag 100
#define kLabelTag 200

@interface MyPageControl : UIView

@property (nonatomic, retain) UIImage * imagePageStateNormal;
@property (nonatomic, retain) UIImage * imagePageStateHighlighted;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;
@end

@implementation MyPageControl

@synthesize imagePageStateNormal = _imagePageStateNormal;
@synthesize imagePageStateHighlighted = _imagePageStateHighlighted;
@synthesize numberOfPages = _numberOfPages, currentPage = _currentPage;


#define kImageHight 10/2
#define kImagewidth 10/2


- (void)setNumberOfPages:(NSUInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    for (int i=0; i<_numberOfPages; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = kImageTag+i;
        [self addSubview:imageView];
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage{
    _currentPage = currentPage;
    for (NSInteger i = 0; i < self.subviews.count; i++)
    {
        UIImageView * dot = (UIImageView *)[self.subviews objectAtIndex:i];
        dot.image = self.currentPage == i ? _imagePageStateHighlighted : _imagePageStateNormal;
    }
}

- (void)layoutSubviews{
    self.backgroundColor = [UIColor clearColor];
    for (int i=0; i<_numberOfPages; i++) {
        UIImageView * image = (UIImageView *)[self viewWithTag:kImageTag+i];
        image.backgroundColor = [UIColor clearColor];
        image.frame = CGRectMake(i*(9 + kImagewidth/2), (self.bounds.size.height-3)/2, kImagewidth, kImagewidth);
    }
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片

    _imagePageStateNormal = image;
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    _imagePageStateHighlighted = image;
    [self updateDots];
}

- (void)updateDots {
    
    if (_imagePageStateNormal && _imagePageStateHighlighted)
    {
        for (NSInteger i = 0; i < self.subviews.count; i++)
        {
            UIImageView * dot = (UIImageView *)[self.subviews objectAtIndex:i];
            dot.image = self.currentPage == i ? _imagePageStateHighlighted : _imagePageStateNormal;
        }
    }
}

- (void)dealloc {
}

@end

@interface RimageView : UIImageView
@property (nonatomic, retain) NSString * text;
@end
@implementation RimageView

@end


@interface RotationView () <SearchManagerDelegate>{
    UIScrollView * _scrollView;
    MyPageControl * _pageControl;
    NSMutableArray * _dataArray;
    
    //2.7显示红线和三角
    UIImageView * redLine;
    UIImageView * redTriangle;
    
    UILabel * _cuntentText;
    NSTimer * _timer;
    NSUInteger time;
    BOOL isRunLoop;
    int preReportIndex; // 上次报的轮播图(防止连续汇报两张轮播)
    NSMutableArray * __array;
    SearchManager * _imageServer;
    UIImageView * backImageView;
    NSMutableDictionary * _imageDic;
}

@property (nonatomic, assign) SEL timerSelector;

@property (nonatomic, assign) SEL click;

@end

@implementation RotationView

@synthesize timerSelector = _timerSelector, click = _click;

static CGRect myRect;

- (id)initWithFrame:(CGRect)frame andScrollTimer:(NSUInteger)timer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageServer = [SearchManager new];
        _imageServer.delegate = self;
        _imageDic = [NSMutableDictionary new];
        [self setTimerSelector:@selector(reloadTimer)];
        [self setClick:@selector(clickScrollView)];
        time = timer;
        _timer = [NSTimer timerWithTimeInterval:timer target:self selector:_timerSelector userInfo:nil repeats:YES];
        
        //2.7显示红线和三角
        
//        UIImage * line = [UIImage imageNamed:@"cut_75.png"];
//        redLine = [[UIImageView alloc] initWithImage:line];
//        redLine.frame = CGRectMake(10, self.bounds.size.height-35*(MainScreen_Width/320), self.frame.size.width - 20, line.size.height/2);
//        [self addSubview:redLine];
//        
//        line = _StaticImage.jiantou;
//        redTriangle = [[UIImageView alloc] initWithImage:line];
//        redTriangle.frame = CGRectMake(redLine.frame.origin.x+2, redLine.frame.origin.y+redLine.frame.size.height, line.size.width/2, line.size.height/2);
//        [self addSubview:redTriangle];

        
        backImageView = [UIImageView new];
        backImageView.image = _StaticImage.lunbo;
        backImageView.frame = CGRectMake(0, 0, self.frame.size.width, _StaticImage.lunbo.size.height/2);
        [self addSubview:backImageView];
        
        myRect = redTriangle.frame;
        
    }
    return self;
}

- (void)dealloc{
    
    [self stopTimer];
    _scrollView.delegate = nil;
    _imageServer.delegate = nil;
    _dataArray = nil;
    
    __array = nil;
    
    _clickBlock = nil;
    
}

- (void)getImageSucessFromImageUrl:(NSString *)urlStr image:(UIImage *)aimage userData:(id)userdata{

    for (int i=0; i<_dataArray.count; i++) {
        RimageView * imageView = (RimageView *)[_scrollView viewWithTag:kImageTag+i];
        if ([imageView.text isEqualToString:urlStr]) {
            //2.7预先对图片进行处理
            UIImage *tmp;
            if (aimage.size.width == 600) {
                tmp  = [UIImage scaleImage:aimage toScale:646.0/600];//640会有白边
                imageView.image = tmp;
                ;
            }else{
                imageView.image = aimage;
            }
            
            
            [_imageDic setObject:imageView.image forKey:imageView.text];
        }
    }
}
- (void)getImageFailFromUrl:(NSString *)urlStr userData:(id)userdata{
    
}

- (void)setLunbo_data:(NSArray *)_array{
    
    if (!_array || _array.count<1)  {
        return ;
    }

    __array = [NSMutableArray arrayWithArray:_array];
    if (__array.count > 1) {
        [__array insertObject:[__array lastObject] atIndex:0];
        [__array addObject:[__array objectAtIndex:1]];
    }
    
    if ([_dataArray isEqualToArray:__array]) {
        return ;
    }
    
    [self setSourceArray:_array];
}

- (void)setSourceArray:(NSArray *)array{

    backImageView.hidden = YES;
    if (_dataArray) {
        if (_dataArray.count != array.count+2) {
            [_scrollView removeFromSuperview];
            [_pageControl removeFromSuperview];
            _scrollView = nil;
            _pageControl = nil;
        }
        _dataArray = nil;
    }
    
    _dataArray = [NSMutableArray arrayWithArray:array];
    if (_dataArray.count > 1)
    {
        [_dataArray insertObject:[_dataArray lastObject] atIndex:0];
        [_dataArray addObject:[_dataArray objectAtIndex:1]];
        
        if (_pageControl) {
            _pageControl.hidden = NO;
        }
    }
    
    [self viewMake];
    
    for (int i=0; i<_dataArray.count; i++) {
        
        UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:kImageTag+i];
        
        UIImage * image = [_imageDic objectForKey:[[_dataArray objectAtIndex:i] objectForKey:@"pic_url"]];
        if (image) {
            
            imageView.image = image;
        }else{
            imageView.image = _StaticImage.lunbo;
            [_imageServer downloadImageURL:[NSURL URLWithString:[[_dataArray objectAtIndex:i] objectForKey:@"pic_url"]] userData:nil];
        }
    }
    if (array.count > 1) {
        if (!isRunLoop && _timer) {
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            isRunLoop = YES;
        }
    }
}

- (void)viewMake{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];NSLog(@"scrollView: %@",_scrollView);
        _scrollView.frame = self.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        [self addSubview:_scrollView];

        [self sendSubviewToBack:_scrollView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:_click];
        [_scrollView addGestureRecognizer:tap];

        [self makePageControl];
        //2.7需要对轮播图片的大小进行处理,兼容新老格式:600*330,640*260
        CGRect rect = CGRectMake(0, 0, MainScreen_Width, (MainScreen_Width)*_StaticImage.lunbo.size.height/_StaticImage.lunbo.size.width);//600*330
        for (int i=0; i<_dataArray.count; i++) {
            RimageView * imageView = [[RimageView alloc] init];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            rect.origin.x = self.frame.size.width*i;
            //rect.origin.y = 0;
            imageView.frame = rect;
            imageView.tag = kImageTag+i;
            if ([[_dataArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                imageView.image = [_dataArray objectAtIndex:i];
            }
            imageView.text = [[__array objectAtIndex:i] objectForKey:@"pic_url"];
            [_scrollView addSubview:imageView];
            
//            UILabel * label = [[UILabel alloc] init];
//            label.tag = kLabelTag+i;
//            label.font = [UIFont systemFontOfSize:15.0];
//            label.text = [[__array objectAtIndex:i] objectForKey:@"lunbo_intro"];
//            label.frame = CGRectMake( imageView.frame.origin.x + _pageControl.frame.size.width, redLine.frame.origin.y + redLine.frame.size.height , 250, self.bounds.size.height-redLine.frame.origin.y - redLine.frame.size.height);
//            [_scrollView addSubview:label];
            
        }
    }
    
    // (_dataArray.count == array.count+2)时，_scrollView!=nil
    for (int i=0; i<_dataArray.count; i++) {
        RimageView * imageView = (RimageView *)[_scrollView viewWithTag:kImageTag+i];
        if ([[_dataArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            imageView.image = [_dataArray objectAtIndex:i];
        }
        imageView.text = [[__array objectAtIndex:i] objectForKey:@"pic_url"];
        
        UILabel * label = (UILabel *)[_scrollView viewWithTag:kLabelTag+i];
        label.text = [[__array objectAtIndex:i] objectForKey:@"lunbo_intro"];
    }
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _dataArray.count, self.frame.size.height);
    
}

- (void)makePageControl{
    _pageControl = [[MyPageControl alloc] init];
    _pageControl.backgroundColor = [UIColor whiteColor];
    
    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"page_n.png"]]; //LOADIMAGE(@"page_n", @"png")];
    [_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"page_h.png"]]; // LOADIMAGE(@"page_h", @"png")
    if (_dataArray.count > 2) {
        _pageControl.numberOfPages = _dataArray.count-2;
    }else{
        _pageControl.numberOfPages = _dataArray.count;
    }
    _pageControl.currentPage = 0;
    
//    _pageControl.frame = CGRectMake(0, redLine.frame.origin.y+redLine.frame.size.height, _pageControl.numberOfPages*8+14, self.bounds.size.height - redLine.frame.origin.y-redLine.frame.size.height);
    _pageControl.frame = CGRectMake(0, 0, _pageControl.numberOfPages * 8 + 14, 7);
    _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 5 - 7);
    
//    [self insertSubview:_pageControl belowSubview:redTriangle];
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
}

- (void)removeFromSuperview{
    [self stopTimer];
}

#pragma mark - clickBlock

- (void)setClickWithBlock:(ClickBlock)block{
    
    _clickBlock = block;
}

- (void)clickScrollView{
    
    if (_clickBlock) {
        _clickBlock(_pageControl.currentPage);
    }
}

- (UIViewController *)viewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - timer

extern BOOL _reportFlag;
extern BOOL _nav;
extern int _tabBarIndex;
extern int _curMarkLunboIndex; // 0: 市场精选，1：应用，2：游戏，-1：无
extern int _curDiscoveryLunboIndex; // 3: 发现精选，-1：无
- (void)reloadTimer{
    
    // 导航 动画过程中  停止滚动
    if (_nav) return;
    if (!_reportFlag) return;
    
    if (_tabBarIndex) { // 发现
        if (_curDiscoveryLunboIndex == self.tag) {
            if (_offsetY < lunboHeight) {
                goto scroll_;
            }
            else{
                return ;
            }
        }
        else
        {
            return ;
        }
    }
    else
    { // 市场
        if (_curMarkLunboIndex == self.tag) {
            CGFloat reportHeight = (_curMarkLunboIndex==0)?-254+lunboHeight:lunboHeight;
            if (_offsetY < reportHeight || _offsetY==0) {
                goto scroll_;
            }
            else{
                return ;
            }
        }
        else
        {
            return ;
        }
    }
    
scroll_:
    
    if (_pageControl.numberOfPages <= 1) return;
    if (_scrollView) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(_pageControl.currentPage+2), 0) animated:YES];
    }
    
}

- (void)startTimer{
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:_timerSelector userInfo:nil repeats:YES];
    }
}

- (void)stopTimer{
    
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_dataArray.count <= 1) return;
    
    float cur = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    _pageControl.currentPage = cur;
//    if (cur > _dataArray.count-2) {
//        
//        redTriangle.frame = CGRectMake(myRect.origin.x+(_dataArray.count-1-cur)*(_dataArray.count-3)*8, myRect.origin.y, myRect.size.width, myRect.size.height);
//        
//    }else if (cur < 1){
//        
//        redTriangle.frame = CGRectMake(myRect.origin.x+(1-cur)*(_dataArray.count-3)*8, myRect.origin.y, myRect.size.width, myRect.size.height);
//        
//    }else{
//        
//        redTriangle.frame = CGRectMake(myRect.origin.x+(cur-1)*8, myRect.origin.y, myRect.size.width, myRect.size.height);
//    }
    
    // 滑动过程中 推导航  不会调用scroll完成的方法  手动调用
    NSInteger idx = (NSInteger)scrollView.contentOffset.x%(NSInteger)scrollView.bounds.size.width;
    if (!idx) {
        
        [self startTimer];
        [self scrollViewScroll:scrollView];
        
        if (_baoguangBlock && preReportIndex!=_pageControl.currentPage){
            _baoguangBlock(_pageControl.currentPage);
            preReportIndex = _pageControl.currentPage;
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewScroll:(UIScrollView *)scrollView{
    
    _pageControl.currentPage = (scrollView.contentOffset.x - self.frame.size.width)/self.frame.size.width;
    
    
    if (scrollView.contentOffset.x == self.frame.size.width * (_dataArray.count - 1)){
        [scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
        _pageControl.currentPage = 0;
    }
    
    if (scrollView.contentOffset.x == 0)
    {
        [scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * (_dataArray.count - 2), 0, self.frame.size.width, self.frame.size.height) animated:NO];
        _pageControl.currentPage = _pageControl.numberOfPages-1;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
