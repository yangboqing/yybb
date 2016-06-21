//
//  AuthorizationGuideViewController.m
//  browser
//
//  Created by 王毅 on 14-7-2.
//
//

#import "AuthorizationGuideViewController.h"

@interface AuthorizationGuideViewController (){
    UIScrollView *scroll;
    UIImageView *imageView;
    UILabel *label;
    UIButton *btn;
}

@end

@implementation AuthorizationGuideViewController
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#define FONTCOLOR [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define BACKCOLOR [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1]
    
    // Do any additional setup after loading the view.
    //新春版
//    self.view.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];
    self.view.backgroundColor = BACKCOLOR;
    
    CGFloat topSpace;
    topSpace = (INT_SYSTEMVERSION >= 7)?64.0f:44.0f;
    scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, topSpace, self.view.frame.size.width, self.view.frame.size.height-topSpace );
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, 903- 20);

    scroll.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    imageView = [[UIImageView alloc] init];
    SET_IMAGE(imageView.image, @"popview_iphone.png");
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 882);
    [scroll addSubview:imageView];
    [self.view addSubview:scroll];
    
    
    
    label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    label.textAlignment = NSTextAlignmentCenter;
    //新春版
    label.textColor = FONTCOLOR;
//    label.textColor = [UIColor whiteColor];
    label.text = @"闪退修复";
    //新春版
//    label.backgroundColor  = [UIColor colorWithRed:232.0/255.0 green:100.0/255.0 blue:88.0/255.0 alpha:1];
    label.backgroundColor = BACKCOLOR;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
    }];
    [btn addTarget:self action:@selector(closeRepairLesson:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineimageView=[[UIImageView alloc] init];
    lineimageView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1];
    
#define LABEL_HEIGHT 44
    
    CGFloat StartY = IOS7 ? 20 :0;;
    
    
    label.frame = CGRectMake(0, StartY, self.view.frame.size.width, LABEL_HEIGHT);
    [self.view addSubview:label];
    
    btn.frame = CGRectMake(15 , StartY+5, 34, 34);
    [self.view addSubview:btn];
    
    lineimageView.frame = CGRectMake(0, StartY + LABEL_HEIGHT-0.5, self.view.frame.size.width, 0.5);
    [self.view addSubview:lineimageView];
    
}

- (void)closeRepairLesson:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openAuthorizationPage)]) {
        [self.delegate openAuthorizationPage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    self.delegate = nil;
}


@end
