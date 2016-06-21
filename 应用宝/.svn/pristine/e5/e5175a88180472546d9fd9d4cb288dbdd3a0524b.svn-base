//
//  UpdataViewController.m
//  browser
//
//  Created by 王 毅 on 13-4-2.
//
//

#import "UpdataViewController.h"
#import "FileUtil.h"
#import "ServiceManage.h"
#import "IphoneAppDelegate.h"

@interface UpdataViewController (){
    UIImageView *emtpyListImageView;
    UIImageView *emtpyListBGImageView;
    
    
    UIImageView *updataingImageVIew;
    UIActivityIndicatorView *activityIndicator;
    UILabel *updataingLabel;
    
    // 全部更新按钮
    BOOL isNotAllDownloading;
    
    UILabel *messageLabel;//没有任务时提示语
    
}

@end

@implementation UpdataViewController

+ (UpdataViewController *)DefaultViewController{
    static UpdataViewController * viewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewController = [[UpdataViewController alloc] init];
    });
    return viewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //加载需要更新的列表
        updataTableView = [[UpdataTableViewController_iphone alloc]initWithStyle:UITableViewStylePlain];
        updataTableView.view.hidden = NO;
        updataTableView.delegate = self;
        [self.view addSubview:updataTableView.view];
        
        //加载没有需要更新时的视图
        emtpyListBGImageView = [[UIImageView alloc]init];
        emtpyListBGImageView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        emtpyListBGImageView.hidden = YES;
        [self.view addSubview:emtpyListBGImageView];
        
        emtpyListImageView = [[UIImageView alloc]init];
        emtpyListImageView.backgroundColor = [UIColor clearColor];
        emtpyListImageView.image = LOADIMAGE(@"update_empty_iphone", @"png");
        [emtpyListBGImageView addSubview:emtpyListImageView];
        
        messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
        messageLabel.font = [UIFont systemFontOfSize:15.0f];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"没有待更新的应用";
        [emtpyListImageView addSubview:messageLabel];
        
        
        {
            updataingImageVIew = [[UIImageView alloc]init];
            updataingImageVIew.layer.cornerRadius = 10;
            updataingImageVIew.backgroundColor = [UIColor blackColor];
            updataingImageVIew.userInteractionEnabled = NO;
            updataingImageVIew.hidden = YES;
            [self.view addSubview:updataingImageVIew];
            
            activityIndicator = [[UIActivityIndicatorView alloc]init];
            activityIndicator.hidesWhenStopped = YES;
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            activityIndicator.hidden = YES;
            [updataingImageVIew addSubview:activityIndicator];
            
            updataingLabel = [[UILabel alloc]init];
            updataingLabel.backgroundColor = [UIColor clearColor];
            updataingLabel.textColor = [UIColor whiteColor];
            updataingLabel.textAlignment = NSTextAlignmentCenter;
            updataingLabel.text = @"更新中";
            //[updataingImageVIew addSubview:updataingLabel];
        }
        
        if ([[UpdateAppManager getManager] ItemCount] > 0) {

            emtpyListBGImageView.hidden = YES;
        }else{
            emtpyListBGImageView.hidden = NO;
        }
        
        
    }
    return self;
}

- (void)dealloc{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateAppsRefresh:)
												 name:UPDATE_APPS_REFRESH
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUpdataCount:)
												 name:RELOAD_UPDATE_COUNT
                                               object:nil];
    
    
}

- (void)reloadUpdataCount:(NSNotification *)note{
    
    if ([[UpdateAppManager getManager] ItemCount] > 0) {
        emtpyListBGImageView.hidden = YES;
        
    }else{
        emtpyListBGImageView.hidden = NO;
    }
    
}
- (void)UpdateAppsRefresh:(NSNotification *)note{
    
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[UpdateAppManager getManager] ItemCount];
        [self isEnableRightButton];
        [self reloadTable];
    

}

#pragma mark - UpdataVCDelegate
- (void)delayAfterClickUpdataBtnWithAppName:(NSString *)_name{
    BOOL isTure = NO;
    NSDictionary * itemInfo = [[BppDistriPlistManager getManager] ItemInfoInDownloadedByAttriName:DISTRI_APP_NAME
                                                                                            value:_name];
    if(itemInfo)
        isTure = YES;
    
    
    if (isTure == NO) {
        updataingImageVIew.hidden = NO;
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        updataTableView.tableView.userInteractionEnabled = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(chanelUpdataingImageView:) userInfo:nil repeats:NO];
    }
}
- (void)chanelUpdataingImageView:(NSTimer *)timer{
    updataingImageVIew.hidden = YES;
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    updataTableView.tableView.userInteractionEnabled = YES;
}


- (void)viewDidLayoutSubviews {
    
    updataTableView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 1);
    emtpyListBGImageView.frame = updataTableView.view.frame;
    emtpyListImageView.frame = CGRectMake(0, 0, 190, 120);
    messageLabel.frame = CGRectMake(0, 10, emtpyListImageView.frame.size.width, emtpyListImageView.frame.size.height);
    emtpyListImageView.center = CGPointMake(emtpyListBGImageView.frame.size.width/2, emtpyListBGImageView.frame.size.height/2);
    
    updataingImageVIew.frame = CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height-100)/2, 100, 100);
    updataingLabel.frame = CGRectMake(0, (updataingImageVIew.frame.size.height - 15)/2 - 12, updataingImageVIew.frame.size.width, 15);
    activityIndicator.frame = CGRectMake((updataingImageVIew.frame.size.width - 40)/2, (updataingImageVIew.frame.size.height - 40)/2 + 15, 40, 40);
}

#pragma mark - 全部更新
- (void)allUpdataBtnClick:(id)sender{
    
    if ([[UpdateAppManager getManager] ItemCount] <= 0) {
        return;
    }
    /*
     appIconUrl = "http://pic.wanmeiyueyu.com/Data/APPINFOR/16/78/com.sina.weibo/BigIcon_1402502400.jpg";
     appId = "com.sina.weibo";
     appName = "\U5fae\U535a";
     appSize = 34770836;
     appVersion = "4.4.0";
     plist = "itms-services://?action=download-manifest&url=https://dinfo.wanmeiyueyu.com/Data/APPINFOR/16/78/com.sina.weibo/dizigui_zhouyi_com.sina.weibo_1402502400_4.4.0_s.plist?dlfrom=iphonebrowser-update_4";
    */
    
    NSString *netStr = [[FileUtil instance] GetCurrntNet];    
    if ([netStr isEqualToString:@"3g"]){
        
        if ([[SettingPlistConfig getObject] getPlistObject:DOWN_ONLY_ON_WIFI] == YES){
            
            UIAlertView * netAlert = [[UIAlertView alloc] initWithTitle:@"快用"
                                                                message:ON_WIFI_DOWN_TIP
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"知道了", nil];
            [netAlert show];
        }else{
            [updataTableView updataAll];
        }
        
    }else if ([netStr isEqualToString:@"wifi"]){
        
        if (![[SettingPlistConfig getObject] getPlistObject:DOWNLOAD_TO_LOCAL])
        {
            [updataTableView updataAllByOpenURL];
        }
        else
        {
            [updataTableView updataAll];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self isUseTopRight:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(allStartTimerMethods:) userInfo:nil repeats:NO];
    
}
#pragma mark - 设置按钮状态
- (void)allStartTimerMethods:(NSTimer *)timer{
    
    if (updataTableView.view.hidden == NO) {
        if ([[UpdateAppManager getManager] ItemCount] > 0) {
            [self isUseTopRight:isNotAllDownloading];
        }else{
            [self isUseTopRight:NO];
        }
    }
}

- (void)isUseTopRight:(BOOL)bl{
    [[NSNotificationCenter defaultCenter] postNotificationName:IS_USE_UPDATE_BUTTON object:[NSNumber numberWithBool:bl]];
}

- (void)isEnableRightButton{
    
    if ([[UpdateAppManager getManager] ItemCount] >0) {

        emtpyListBGImageView.hidden = YES;
    }else{

        emtpyListBGImageView.hidden = NO;
    }
    
}


#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

- (void)reloadTable{
    [updataTableView.tableView reloadData];
    [updataTableView isAllDownloading];
}

- (void)passBadgeCount_over{
    //    [self isEnableRightButton];
    emtpyListBGImageView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark updataViewControllerDelegate

-(void)isAllUpdateButtonEnable:(BOOL)enable
{
    isNotAllDownloading = enable;
    [self isUseTopRight:enable];
}

@end
