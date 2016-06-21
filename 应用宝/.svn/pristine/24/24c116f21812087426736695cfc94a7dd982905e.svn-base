//
//  KyShared.m
//  browser
//
//  Created by niu_o0 on 14-6-13.
//
//

#import "KyShared.h"
#import "UIImageEx.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "IphoneAppDelegate.h"
#import "BppDownloadToLocal.h"

@implementation KyShared


@synthesize description = _description;

+ (instancetype)shared{
    static KyShared * _shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [KyShared new];
    });
    
    return _shared;
}

- (void)dealloc{
    
    _activity = nil;
    
}

+ (NSArray *)titles{
    return @[@"微信好友", @"微信朋友圈", @"新浪微博"];
}

+ (NSArray *)images{
    return @[@"sns_icon_22", @"sns_icon_23", @"sns_icon_1"];
}

- (void)show{
    _activity = [[LXActivity alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:[KyShared titles] withShareButtonImagesName:[KyShared images]];
    [_activity showInView:nil];
}

- (void)didClickOnImageIndex:(NSInteger *)imageIndex{
    switch ((int)imageIndex) {
        case 0:
            //             NSLog(@"微信分享");
            [self sendWXMessage:WXSceneSession];
            break;
        case 1:
            [self sendWXMessage:WXSceneTimeline];
            break;
            
        case 2:
            //            NSLog(@"新浪微博分享");
            [self sendMessageToSina];
            break;
        default:
            break;
    }
}

//sina微博分享

- (void)sendMessageToSina
{
    browserAppDelegate.shareID = 1;
    WBMessageObject * message = [WBMessageObject message];
    message.text = _weiboText;//用户可编辑的微博内容
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@", _objectID];//@"com.tencent.xin";
    webpage.title = [NSString stringWithFormat:@"%@", _title];//@"王毅测试微博";
    webpage.description = [NSString stringWithFormat:@"%@", _description];//[NSString stringWithFormat:@"王毅正在尝试测试微博分享-%.0f", [[NSDate date] timeIntervalSince1970]];
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(_image, 0.1)];
    _image = [UIImage imageWithData:imageData];
    if (_image) {
        webpage.thumbnailData = UIImageJPEGRepresentation(_image, 0.5);//多媒体框体内的icon
    }else{
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"more_logo" ofType:@"png"]];
    }
    webpage.webpageUrl = _webpageUrl;//点多媒体框体跳转到的地址
    if(_webpageUrl.length <= 0) {
        _webpageUrl = @"https://appsto.re/cn/Prfy5.i";
    }
    message.mediaObject = webpage;
    
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
        
    }else{
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"未安装微博客户端，\n是否现在去下载?" message:nil delegate:self cancelButtonTitle:@"以后在说" otherButtonTitles:@"现在下载", nil];
        av.tag = 1000;
        av.delegate = self;
        [av show];
    }
}


//微信分享

- (void)sendWXMessage:(int)_scene
{
    browserAppDelegate.shareID = 2;
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        //确保字段不空,否则微信无反应
        message.title = [NSString stringWithFormat:@"%@",_title];//@"王毅测试微信";
        //确保字段不空,否则微信无反应
        message.description = [NSString stringWithFormat:@"%@",_description];//@"王毅正在尝试测试微信分享";
        NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(_image, 0.1)];
        _image = [UIImage imageWithData:imageData];
        if (_image) {
            [message setThumbImage:_image];
        }else{
            //            [message setThumbImage:LOADIMAGE(@"more_logo", @"png")];
            [LocalImageManager setImageName:@"more_logo.png" complete:^(UIImage *image) {
                [message setThumbImage:image];
            }];
        }
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        message.mediaObject = ext;
        ext.webpageUrl = _webpageUrl;
        if(ext.webpageUrl.length <= 0){ //确保字段不空,否则微信无反应
            ext.webpageUrl = @" https://appsto.re/cn/Prfy5.i";
        }
        req.message = message;
        req.scene = _scene; //WXSceneSession 会话, 朋友圈(WXSceneTimeline)
        
        if(self.showType == show_more && _scene == WXSceneTimeline) {
            //文本类型
            req.bText = YES;
            req.text = _description;
        }
        else{
            //多媒体类型
            req.bText = NO;
        }
        
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alView = [[UIAlertView alloc] initWithTitle:@"未安装微信客户端，\n是否现在去下载?" message:nil delegate:self cancelButtonTitle:@"以后在说" otherButtonTitles:@"现在下载", nil];
        alView.tag = 200;
        [alView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200 && buttonIndex)
    {
        //        通过appid向快用服务器获取微信下载地址，然后通过不走下载管理的本地下载安装方式进行下载安装
        //        [[BppDownloadToLocal getObject] getIpaPlist:@"com.tencent.xin"];
        
        //增加点击下载应用的appid和appdigitalid的对应关系
        [[NSUserDefaults standardUserDefaults] setObject:@"414478124" forKey:@"com.tencent.xin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
        [tmpDic setObjectNoNIL:@"com.tencent.xin" forKey:@"appid"];
        
        [browserAppDelegate addDistriPlistURL:nil appInfo:tmpDic];
    }
    
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            //增加点击下载应用的appid和appdigitalid的对应关系
            [[NSUserDefaults standardUserDefaults] setObject:@"350962117" forKey:@"com.sina.weibo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
            [tmpDic setObjectNoNIL:@"com.sina.weibo" forKey:@"appid"];
            
            [browserAppDelegate addDistriPlistURL:nil appInfo:tmpDic];
        }
    }
}

@end
