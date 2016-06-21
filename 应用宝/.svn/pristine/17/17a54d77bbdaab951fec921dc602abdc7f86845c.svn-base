//
//  PopViewController.m
//  browser
//
//  Created by admin on 13-9-4.
//
//

#import "PopViewController.h"
#import "PopView.h"

@interface PopViewController ()
@property (nonatomic, strong) NSString *lessonTitle;
@end

@implementation PopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        //imageView = [[UIImageView alloc] init];
    }
    return self;
}

-(id)initWithLessonTitle:(NSString *)title
{
    if (self = [super init])
    {
        self.lessonTitle = title;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    
	// Do any additional setup after loading the view.
    CGFloat topSpace; // 区分更多、管理模块

    topSpace = (IOS7)?64:44;
    
    scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, topSpace, self.view.frame.size.width, self.view.frame.size.height - topSpace);
    scroll.backgroundColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"popview_iphone.png"];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, imageView.image.size.height*0.5*(MainScreen_Width/320));
    
    if (IOS7) {
        scroll.contentSize = CGSizeMake(self.view.frame.size.width,imageView.frame.size.height);
    }else{
        scroll.contentSize = CGSizeMake(self.view.frame.size.width, imageView.frame.size.height);
    }
    
    [scroll addSubview:imageView];
    [self.view addSubview:scroll];
    
    //顶部标题栏
    PopView * pop = [[PopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topSpace)];
    [self.view addSubview:pop];
}

- (void)dealloc{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
