//
//  EnableView.m
//  browser
//
//  Created by 王毅 on 15/3/25.
//
//

#import "EnableView.h"

#define PAGE_COUNT 3

@implementation EnableView{
    UIScrollView *_scrollView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *imageArray = @[];
        UIImage *startImage;
        UIImage *passImage;
        if ([[UIScreen mainScreen] bounds].size.height>480) {
            imageArray = [NSArray arrayWithObjects:@"iPhone-6Plus_01",@"iPhone-6Plus_02",@"iPhone-6Plus_03",nil];
            startImage = [UIImage imageNamed:@"btn-link"];
            passImage = [UIImage imageNamed:@"btn-skip"];
        }else{
            imageArray = [NSArray arrayWithObjects:@"yindao_4s_01",@"yindao_4s_02",@"yindao_4s_03",nil];
            startImage = [UIImage imageNamed:@"btn-4s_link"];
            passImage = [UIImage imageNamed:@"btn-4s_skip"];
        }
        
        
        _scrollView = [[UIScrollView alloc] init];NSLog(@"scrollView: %@",_scrollView);
        _scrollView.frame = self.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(MainScreen_Width*PAGE_COUNT, self.frame.size.height);
        [self addSubview:_scrollView];
        
        
        for (int i = 0; i < PAGE_COUNT; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen_Width*i, 0, MainScreen_Width, self.frame.size.height)];
            imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
            [_scrollView addSubview:imageView];
        }
        
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startBtn.backgroundColor = CLEAR_COLOR;
        [self.startBtn setImage:startImage forState:UIControlStateNormal];
        [self.startBtn addTarget:self action:@selector(gotoLockAccount:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startBtn];
        
        self.passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.passBtn.backgroundColor = CLEAR_COLOR;
        [self.passBtn setImage:passImage forState:UIControlStateNormal];
        self.passBtn.alpha = 0;
        [self.passBtn addTarget:self action:@selector(hiddenWindow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.passBtn];
        
        [self makeFrame];
    }
    return self;
    
}

- (void)makeFrame{
    
    
    
    
    CGFloat bottom_height;
    CGFloat btn_width;
    CGFloat btn_height;
    
    if ([[UIScreen mainScreen] bounds].size.height>480) {
        bottom_height = 155.0f+20.0f;
        btn_width = 253.0f;
        btn_height = 53.0f;
        self.passBtn.frame = CGRectMake(MainScreen_Width - 27 - 47, self.frame.size.height - 37 - 20, 47, 20);
    }else{
        bottom_height = 84.0f+20.0f;
        btn_width = 190.0f;
        btn_height = 40.0f;
        self.passBtn.frame = CGRectMake(MainScreen_Width - 15 - 35, self.frame.size.height - 15 - 14, 35, 14);
    }
    
    CGFloat buttonY = self.frame.size.height;
    
    self.startBtn.frame = CGRectMake((self.frame.size.width - btn_width)/2, buttonY, btn_width, btn_height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat bottom_height;
    CGFloat btn_width;
    CGFloat btn_height;
    
    if ([[UIScreen mainScreen] bounds].size.height>480) {
        bottom_height = 155.0f+20.0f;
        btn_width = 253.0f;
        btn_height = 53.0f;
    }else{
        bottom_height = 84.0f+20.0f;
        btn_width = 190.0f;
        btn_height = 40.0f;
    }
    
    if (scrollView.contentOffset.x <= MainScreen_Width*2 && scrollView.contentOffset.x >= MainScreen_Width*1.5) {
        
        CGFloat offsetW = scrollView.contentOffset.x - MainScreen_Width*1.5;
        
        CGFloat ratio = offsetW/(MainScreen_Width/2);
        
        self.passBtn.alpha = ratio;
        
        
        
        CGFloat buttonY = [[UIScreen mainScreen] bounds].size.height - bottom_height*ratio;
        
        self.startBtn.frame = CGRectMake((MainScreen_Width - btn_width)/2, buttonY, btn_width, btn_height);
        
    }
    else{
        if (scrollView.contentOffset.x > MainScreen_Width*2) {
            self.passBtn.alpha = 1;
            self.startBtn.frame = CGRectMake((self.frame.size.width - btn_width)/2, [[UIScreen mainScreen] bounds].size.height - bottom_height, btn_width, btn_height);
        }else if (scrollView.contentOffset.x < MainScreen_Width*1.5){
            self.passBtn.alpha = 0;
            self.startBtn.frame = CGRectMake((self.frame.size.width - btn_width)/2, [[UIScreen mainScreen] bounds].size.height, btn_width, btn_height);
        }
        
    }
    
}
- (void)hiddenWindow:(UIButton *)sender{
    [self hiddenEnableWindow];
}
- (void)gotoLockAccount:(UIButton*)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openLockPage" object:nil];;
    
    [self hiddenEnableWindow];
}
- (void)showEnableWindow{
    self.hidden = NO;
    [self makeKeyAndVisible];
}
- (void)hiddenEnableWindow{
    self.hidden = YES;
    [self resignKeyWindow];
}
@end

