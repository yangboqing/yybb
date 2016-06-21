//
//  Market_top_bar.m
//  browser
//
//  Created by niu_o0 on 14-5-19.
//
//

#import "Market_top_bar.h"

#pragma mark - button

@implementation Top_button

- (id)init
{
    self = [super init];
    if (self) {
        _vImageView = [UIImageView new];
        [self addSubview:_vImageView];
        
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _vImageView.frame = CGRectMake(self.bounds.size.width-_vImageView.image.size.width/4, (self.bounds.size.height-_vImageView.image.size.height/2)/2, _vImageView.image.size.width/2, _vImageView.image.size.height/2);
    CGSize size = CGSizeMake(self.imageView.image.size.width/2, self.imageView.image.size.height/2);
    self.imageView.frame = CGRectMake((self.bounds.size.width-size.width)/2, (self.bounds.size.height-size.height)/2, size.width, size.height);
}

@end





#pragma mark - Market_top_bar



@interface Market_top_bar ()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) CALayer *blurLayer;

@end


@implementation Market_top_bar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor whiteColor];
        
        _selectButtonTag = 0;
        [self makeViews];
    }
    return self;
}

#define MINFONT 15.0
#define MAXFONT 18.0


/*
 
            14.0 : 20.0 = 1.0 : X ;
 
            X = 20.0/14.0
 
 
            X = 10:7
 */

- (void)makeViews{
    
    //[self setup];
    
    NSInteger width = self.bounds.size.width/[self itemArray].count;
    
    UIImage * _image1 = [UIImage imageNamed:@"cut_41.png"];
    UIImage * _image2 = [UIImage imageNamed:@"cut_36.png"];
    UIImage * _image3 = [UIImage imageNamed:@"cut_39.png"];
    
    for (int i=0; i<[self itemArray].count; i++) {
        
        Top_button * button = [[Top_button alloc] init];
        
        if (i<=3) {
            
            if (i == 3) {
                button.vImageView.image = _image2;
            }else{
                button.vImageView.image = _image1;
            }
        }
        
        [button setExclusiveTouch:YES];
        
        if (!i) {
            [button setTitleColor:SELECTED forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
        }else{
            [button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
        }
        
        if (i == [self itemArray].count-1) {
            [button setImage:_image3 forState:UIControlStateNormal];
            [button setImage:_image3 forState:UIControlStateHighlighted];
        }
        
        button.tag = TOP_BUTTON_TAG + i;
        
        button.frame = CGRectMake(i*width, 0,width, self.bounds.size.height);
        
        [button addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[[self itemArray] objectAtIndex:i] forState:UIControlStateNormal];
        
        [self addSubview:button];
    }
}

- (void)setup {
    
    [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
    [self setBlurLayer:[[self toolbar] layer]];
    //新春版
//    self.toolbar.alpha = 0.8;
    //2.7版
    self.toolbar.alpha = 1.0;
    
    UIView *blurView = [UIView new];
    [blurView setUserInteractionEnabled:NO];
    [blurView.layer addSublayer:[self blurLayer]];
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self insertSubview:blurView atIndex:0];
    //NSDictionaryOfVariableBindings  宏  其实 NSDictionaryOfVariableBindings(blurView) 等效于 [NSDictionary dictionaryWithObjectsAndKeys:blurView, @"blurView", nil];
    //@"H:|[blurView]|" 表示和父视图水平方向对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blurView)]];
    //@"V:|-(-1)-[blurView]-(-1)-|" 表示比父视图垂直方向多1像素
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-1)-[blurView]-(-1)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(blurView)]];
//新春版
//    [self setBackgroundColor:NEWYEAR_RED];
    //2.7版本
    [self setBackgroundColor:[UIColor clearColor]];
}



static Top_button * _select = nil;
static Top_button * _next = nil;
//static float _lastPosition = 0.0f;

- (void)setMarket_top_barDidScroll:(UIScrollView *)_scrollView{
    
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
    
    _select = (Top_button *)[self viewWithTag:_selectButtonTag+TOP_BUTTON_TAG];
    _next = (Top_button *)[self viewWithTag:next+TOP_BUTTON_TAG];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    //_next.titleLabel.layer.transform = CATransform3DMakeScale(_dur, _dur, _dur);
    //_select.titleLabel.layer.transform = CATransform3DMakeScale(__dur, __dur, __dur);
    
    _next.titleLabel.font = [UIFont systemFontOfSize:MINFONT*_dur];
    _select.titleLabel.font = [UIFont systemFontOfSize:MINFONT*__dur];
    
    [CATransaction commit];
    //2.7版
    [_next setTitleColor:hllColor(222*dur, 53, 46, 1.0) forState:UIControlStateNormal];
    [_select setTitleColor:hllColor(222*(1.0-dur), 53, 46, 1.0) forState:UIControlStateNormal];
    //新春版
//    [_next setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*dur) forState:UIControlStateNormal];
//    [_select setTitleColor:hllColor(255, 255, 255, 0.5 + 0.5*(1 - dur)) forState:UIControlStateNormal];

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

- (void)setMarket_top_barClickWithIndex:(NSUInteger)index{
    
    UIButton * _button = (UIButton *)[self viewWithTag:_selectButtonTag+TOP_BUTTON_TAG];
    [_button setTitleColor:NO_SELECTED forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:MINFONT];
    
    _button = (UIButton *)[self viewWithTag:index+TOP_BUTTON_TAG];
    [_button setTitleColor:SELECTED forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:MAXFONT];
    
    if (click) click(index);
    
    _selectButtonTag = index;
}

- (NSArray *)itemArray{
    return @[@"精选", @"应用", @"游戏", @"壁纸", @""];
}

- (void)setMarket_top_barClickWithBlock:(Top_bar_click)_click{
    click = _click;
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
