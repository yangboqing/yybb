//
//  ListMangerTopView.m
//  browser
//
//  Created by mingzhi on 14-5-15.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "ListMangerTopView.h"

@interface ListMangerTopView ()
{
    UIImageView *bgImageView;
    UIImageView *spaceBtnLine1;
    UIImageView *spaceBtnLine2;
}
@end

#define selectcolor hllColor(222, 53, 46, 1)
#define unselectcolor hllColor(81, 81, 81, 1)
//新春版
//#define unselectcolor hllColor(244, 188, 184, 1)
//
//#define selectcolor hllColor(255, 255, 255, 1)

#define MINFONT 15.0
#define MAXFONT 19.0

@implementation ListMangerTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
//        self.line = [[UIView alloc]init];
//        self.line.backgroundColor = [UIColor colorWithRed:231.0/255 green:73.0/255 blue:51.0/255 alpha:1];
        
        bgImageView = [[UIImageView alloc]init];
        if (!IOS7) {
            bgImageView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        }
        
        
        //返回按钮
//        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.backButton.backgroundColor = [UIColor clearColor];
//        [self.backButton setImage:LOADIMAGE(@"nav_back", @"png") forState:UIControlStateNormal];
        
        self.weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.weekBtn.backgroundColor = [UIColor clearColor];
        self.weekBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.weekBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.weekBtn setTitle:[NSString stringWithFormat:@"周榜"] forState:UIControlStateNormal];
        
        spaceBtnLine1 = [[UIImageView alloc] init];
        spaceBtnLine1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        //新春版
        spaceBtnLine1.image = [UIImage imageNamed:@"cut_41.png"];
        
        self.monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.monthBtn.backgroundColor = [UIColor clearColor];
        self.monthBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.monthBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.monthBtn setTitle:[NSString stringWithFormat:@"月榜"] forState:UIControlStateNormal];
        
        spaceBtnLine2 = [[UIImageView alloc] init];
        spaceBtnLine2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        //新春版
        spaceBtnLine2.image = [UIImage imageNamed:@"cut_41.png"];
        
        self.totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.totalBtn.backgroundColor = [UIColor clearColor];
        self.totalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.totalBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
        [self.totalBtn setTitle:[NSString stringWithFormat:@"总榜"] forState:UIControlStateNormal];
        
        self.weekBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        self.monthBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        self.totalBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];

        bgImageView.userInteractionEnabled = YES;
        
        [self addSubview:bgImageView];
        //[bgImageView addSubview:self.backButton];
        [bgImageView addSubview:self.weekBtn];
        [bgImageView addSubview:spaceBtnLine1];
        [bgImageView addSubview:self.monthBtn];
        [bgImageView addSubview:spaceBtnLine2];
        [bgImageView addSubview:self.totalBtn];
        //[bgImageView addSubview:self.line];
        
        _selectButtonTag = 1;
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat oriX = 5;
    CGFloat oriY = 0;
    CGFloat width = (self.frame.size.width-10-2)/3;
    CGFloat height = 44;
    bgImageView.frame = self.bounds;
    
    self.weekBtn.frame = CGRectMake(oriX , oriY, width, height);
    spaceBtnLine1.frame = CGRectMake(oriX + width , 11, 1, 22);
    self.monthBtn.frame = CGRectMake(oriX + width+1, oriY, width, height);
    spaceBtnLine2.frame = CGRectMake(oriX + 2*width+1 , 11, 1, 22);
    self.totalBtn.frame = CGRectMake(oriX + 2*width+2, oriY, width, height);
}


- (void)myAnimation:(float)dur anIndex:(NSUInteger)index{
    
    static UIButton * _select = nil;
    static UIButton * _next = nil;
    
    float _dur;
    _select = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    _next = (UIButton *)[self viewWithTag:(index + 1) * 111];
    //NSLog(@"_select %d _netx%d",_selectButtonTag,index);
    
    
    _dur = fabsf(dur) ? fabsf(dur)*(MAXFONT/MINFONT-1)+1 : 1;
    
    if (dur < 0) {
        
        if (_selectButtonTag > index) {
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
            [_select setTitleColor:unselectcolor forState:UIControlStateNormal];
        }else if (_selectButtonTag == index){
            UIButton * button = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111 + 111];
            [button setTitleColor:unselectcolor forState:UIControlStateNormal];
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
        }else{
            [_select setTitleColor:unselectcolor forState:UIControlStateNormal];
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
        }
//        _next.titleLabel.font = [UIFont systemFontOfSize:MAXFLOAT];
//        _select.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
//        
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        if (_selectButtonTag > index) {
//            _next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
//        }else{
//            _select.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
//        }
//        
//        [CATransaction commit];
        
        if (_selectButtonTag > index) {
            _next.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
        }else{
            _select.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
        }
        
    }else{
        
        if (_selectButtonTag > index) {
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
            [_select setTitleColor:unselectcolor forState:UIControlStateNormal];
        }else if (_selectButtonTag == index){
            if (_selectButtonTag==0) {
                _selectButtonTag = 1;
            }
            UIButton * button = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111 - 111];
            [button setTitleColor:unselectcolor forState:UIControlStateNormal];
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
        }else{
            [_select setTitleColor:unselectcolor forState:UIControlStateNormal];
            [_next setTitleColor:selectcolor forState:UIControlStateNormal];
        }
        
//        _next.titleLabel.font = [UIFont systemFontOfSize: MINFONT];
//        
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        _next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
//        [CATransaction commit];
        
        _next.titleLabel.font = [UIFont systemFontOfSize:_dur * MINFONT];
    }
}

- (void)myAnimation:(NSInteger)before{
    UIButton * beforeBtn = (UIButton *)[self viewWithTag:before];
    UIButton * selectBtn = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    
    [beforeBtn setTitleColor:unselectcolor forState:UIControlStateNormal];
    [selectBtn setTitleColor:selectcolor forState:UIControlStateNormal];
    
    beforeBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    float _dur = 1.2*(MAXFONT/MINFONT-1)+1;
    
    beforeBtn.titleLabel.layer.transform = CATransform3DMakeScale(1, 1, 1);
    selectBtn.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    
    [CATransaction commit];
    
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    selectBtn.titleLabel.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
}

- (void)setBtnEnable:(BOOL)enable
{
    self.weekBtn.enabled = enable;
    self.monthBtn.enabled = enable;
    self.totalBtn.enabled = enable;
}

- (void)setList_top_barDidScroll:(UIScrollView *)_scrollView
{
    static UIButton * _select = nil;
    static UIButton * _next = nil;
    
    _selectButtonTag = _scrollView.contentOffset.x/(_scrollView.bounds.size.width);
    
    NSInteger idx = (NSInteger)_scrollView.contentOffset.x % (NSInteger)_scrollView.bounds.size.width;
    
    if (idx == 0) return;
    
    NSInteger next = _selectButtonTag;
    
    if (_scrollView.contentOffset.x >= _selectButtonTag*_scrollView.bounds.size.width) {
        next ++;
    }else{
        next --;
    }
    
    float dur = idx/_scrollView.bounds.size.width;
    float _dur = fabsf(dur) ? fabsf(dur)*(MAXFONT/MINFONT-1)+1 : 1;
    float __dur = fabsf(dur) ? fabsf(1-dur)*(MAXFONT/MINFONT-1)+1 : 1;
    
    //NSLog(@"%d   %d",_selectButtonTag, next);
    
    _select = (UIButton *)[self viewWithTag:(_selectButtonTag + 1) * 111];
    _next = (UIButton *)[self viewWithTag:(next + 1) * 111];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    //_next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    //_select.titleLabel.layer.transform = CATransform3DMakeScale(__dur, __dur, __dur);
    
    _next.titleLabel.font = [UIFont systemFontOfSize:MINFONT*_dur];
    _select.titleLabel.font = [UIFont systemFontOfSize:MINFONT*__dur];
    
    [CATransaction commit];
    
    [_next setTitleColor:hllColor(222*dur, 53, 46, 1.0) forState:UIControlStateNormal];
    [_select setTitleColor:hllColor(222*(1.0-dur), 53, 46, 1.0) forState:UIControlStateNormal];
    //新春版
//    [_next setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*dur) forState:UIControlStateNormal];
//    [_select setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*(1 - dur)) forState:UIControlStateNormal];
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
