//
//  Find_top_bar.m
//  browser
//
//  Created by mahongzhi on 14-10-15.
//
//

#import "Find_top_bar.h"

#pragma mark - button

@implementation FindTop_button

- (id)init
{
    self = [super init];
    if (self) {
//        2.7版本
        UIColor *bgColor = [UIColor whiteColor];
        //新春版
//        UIColor *bgColor = NEWYEAR_RED;
        if (IOS7) {
            bgColor = [UIColor clearColor];
        }
        self.backgroundColor = bgColor;
        
        _vImageView1 = [UIImageView new];
        [self addSubview:_vImageView1];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _vImageView1.frame = CGRectMake(self.bounds.size.width-_vImageView1.image.size.width/4, (self.bounds.size.height-_vImageView1.image.size.height/2)/2, _vImageView1.image.size.width/2, _vImageView1.image.size.height/2);
    CGSize size = CGSizeMake(self.imageView.image.size.width/2, self.imageView.image.size.height/2);
    self.imageView.frame = CGRectMake((self.bounds.size.width-size.width)/2, (self.bounds.size.height-size.height)/2, size.width, size.height);
}

@end

#pragma mark - Find_top_bar

@implementation Find_top_bar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectButtonTag = 0;
        [self makeViews];
    }
    return self;
}

#define MINFONT 15.0
#define MAXFONT 18.0

- (void)makeViews{

    
    NSInteger width = MainScreen_Width*0.25;
    
    UIImage * _image1 = [UIImage imageNamed:@"cut_41.png"];
    
    for (int i=0; i<[self itemArray].count; i++) {
        
        FindTop_button * button = [[FindTop_button alloc] init];
        button.vImageView1.image = _image1;
        
        [button setExclusiveTouch:YES];
        
        if (!i) {
            [button setTitleColor:SELECTED forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
        }else{
            [button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        }
        
        button.tag = TOP_BUTTON_TAG + i;
        
        button.frame = CGRectMake(i*width, 0, i == [self itemArray].count-1 ? (self.bounds.size.width-width*i) : width, self.bounds.size.height);
        
        [button addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[[self itemArray] objectAtIndex:i] forState:UIControlStateNormal];
        
        [self addSubview:button];
    }
}

- (void)press:(UIButton *)button{
    
    if (button.tag >= TOP_BUTTON_TAG + 4) {
        if (click) {
            click(button.tag - TOP_BUTTON_TAG);
        }
        return;
    }
    
    UIButton * _button = (UIButton *)[self viewWithTag:_selectButtonTag+TOP_BUTTON_TAG];
    [_button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
    [button setTitleColor:SELECTED forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    
    if (click) {
        click(button.tag - TOP_BUTTON_TAG);
    }
    _selectButtonTag = button.tag - TOP_BUTTON_TAG;
}


- (NSArray *)itemArray{
    return @[@"精选", @"评测", @"资讯", @"苹果派"];
}

- (void)setFind_top_barClickWithBlock:(Top_bar_click)_click
{
    click = _click;
}

static FindTop_button * _select = nil;
static FindTop_button * _next = nil;
- (void)setFind_top_barDidScroll:(UIScrollView *)_scrollView
{
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
    
    _select = (FindTop_button *)[self viewWithTag:_selectButtonTag+TOP_BUTTON_TAG];
    _next = (FindTop_button *)[self viewWithTag:next+TOP_BUTTON_TAG];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    //_next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    //_select.titleLabel.layer.transform = CATransform3DMakeScale(__dur, __dur, __dur);
    
    _next.titleLabel.font = [UIFont systemFontOfSize:MINFONT*_dur];
    _select.titleLabel.font = [UIFont systemFontOfSize:MINFONT*__dur];
    
    [CATransaction commit];
    //2.7
    [_next setTitleColor:hllColor(222*dur, 53, 46, 1.0) forState:UIControlStateNormal];
    [_select setTitleColor:hllColor(222*(1.0-dur), 53, 46, 1.0) forState:UIControlStateNormal];
    //新春版
//    [_next setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*dur) forState:UIControlStateNormal];
//    [_select setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*(1 - dur)) forState:UIControlStateNormal];
}

- (void)setFind_top_barClickWithIndex:(NSUInteger)index
{
    UIButton * _button = (UIButton *)[self viewWithTag:_selectButtonTag+TOP_BUTTON_TAG];
    [_button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
    _button = (UIButton *)[self viewWithTag:index+TOP_BUTTON_TAG];
    [_button setTitleColor:SELECTED forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    
    if (click) click(index);
    
    _selectButtonTag = index;
}


@end
