//
//  LoginServerManage.m
//  browser
//
//  Created by 王毅 on 15/1/14.
//
//

#import "LoginServerManage.h"
#import "ReportManage.h"

#define REQUEST_HEAD @"http://proxy.mysjzs.com"
#define CACHE_TIME 86400

#define CACHE_DATE @"cachedate"

#define FAIL_MESSAGE @"绑定异常，请更换网络环境重试一下"

@interface LoginServerManage (){
}
@property (nonatomic , strong) NSMutableDictionary *tempDic;
@end

@implementation LoginServerManage

- (id)init{
    self = [super init];
    if (self) {
        self.tempDic = [NSMutableDictionary new];
    }
    return self;
}

+(LoginServerManage *) getManager {
    
    @synchronized(@"lock") {
        static id obj = nil;
        if (obj == nil) {
            obj = [[LoginServerManage alloc] init];
        }
        return obj;
    }
    
}

- (void)requestLoginFromServer:(NSString*)account password:(NSString*)password userData:(id)userData{
    
    
    
    NSDictionary *cacheDic = [[FileUtil instance] getLoginKey];
    NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
    NSInteger modTime = [[cacheDic objectNoNILForKey:CACHE_DATE] integerValue];
    if (nowDate - modTime <= CACHE_TIME) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerSucess:password:dataDic:userData:)]) {
            [self.delegate requestLoginFromServerSucess:account password:password dataDic:cacheDic userData:userData];
        }
        return;
    }
    
NSDictionary*dic=@{@"RESULT":@"",@"USER":account,@"PWD":password,@"SIGNATURE":@"",@"POSTE":@"",@"KBDATA":@"",@"GUID":@"",@"MACHINENAME":@"",@"NUMID":@""};

    NSString *jsDicStr = [dic JSONString];
    jsDicStr = [DESUtils encryptUseDES:jsDicStr key:@"HBSMY4yF"];
    jsDicStr = [[FileUtil instance] encodeToPercentEscapeString:jsDicStr];
    NSString*requestStr = [NSString stringWithFormat:@"%@/i_info_proxy.php?cmd=%d&data=%@",REQUEST_HEAD,1,jsDicStr];
    
    NSURL *url = [NSURL URLWithString:requestStr];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        responseString = [DESUtils decryptUseDES:responseString key:@"HBSMY4yF"];
        NSMutableDictionary * map = [NSMutableDictionary dictionaryWithDictionary:[[FileUtil instance] analysisJSONToDictionary:responseString]];
        
        if ([map objectForKey:@"RESULT"]&&[[map objectForKey:@"RESULT"] isKindOfClass:[NSString class]] &&[[map objectForKey:@"RESULT"] isEqualToString:@"0"]) {
            
            
            
            NSDictionary* LoginDic = [self loginAppStore:[map objectForKey:@"SIGNATURE"] postString:[map objectForKey:@"POSTE"]];
            if (LoginDic) {
                //sucess
                if (self.tempDic) {
                    self.tempDic = [NSMutableDictionary new];
                }
                [self.tempDic setObject:[map objectForKey:@"POSTE"] forKey:@"poste"];
                [self.tempDic setObject:[map objectForKey:@"SIGNATURE"] forKey:@"signature"];

                [map setObject:[LoginDic objectForKey:@"dsPersonId"] forKey:@"NUMID"];
                
                [self requestSecondLoginFromServer:map userData:userData];
                    

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [requestSelf error];
//                    NSLog(@"登录2请求失败---%@",error);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:1]];
//                    });
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerFail:password:userData:)]) {
                        [self.delegate requestLoginFromServerFail:account password:password userData:userData];
                    }
                });

            }
            
            
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
//                NSLog(@"登录1请求失败---%@",error);
                [self saveFailString:FAIL_MESSAGE];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:1]];
//                });
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerFail:password:userData:)]) {
                    [self.delegate requestLoginFromServerFail:account password:password userData:userData];
                }
            });
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            [self saveFailString:FAIL_MESSAGE];
//            NSLog(@"登录1请求失败---%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerFail:password:userData:)]) {
                [self.delegate requestLoginFromServerFail:account password:password userData:userData];
            }
        });
    }];
    
}
#define AUTHENTICATE_URL    "-buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/authenticate"
#define	USER_AGENT	"iTunes/11.0.5 (Windows; Microsoft Windows 7 Ultimate Edition Service Pack 1 (Build 7601)) AppleWebKit/536.30.1"
-(NSDictionary*)loginAppStore:(NSString*)xappleaction postString:(NSString*)postString{
    
    NSDictionary *appleDic = @{};
    
    NSString *pod = @"27";
    NSString * x_apple_actionsignature = xappleaction;
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://p%@%@", pod, @AUTHENTICATE_URL] ];
    
    do {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [ASIFormDataRequest setDefaultTimeOutSeconds:20];
        [request setRequestMethod:@"POST"];
        
        //清空指定URL的Cookie
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = [cookies cookiesForURL:url];
        for (NSHTTPCookie* cookie in facebookCookies) {
            [cookies deleteCookie:cookie];
        }
        //忽略证书认证
        [request setValidatesSecureCertificate:NO];
        //设置请求头部
        [request addRequestHeader:@"User-Agent"
                            value:@USER_AGENT];
        [request addRequestHeader:@"Content-Type"
                            value:@"application/x-apple-plist"];//;charset=UTF-8"];
        [request addRequestHeader:@"Referer"
                            value:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewGrouping?cc=cn&id=29099&mt=8"];
        [request addRequestHeader:@"Accept-Language"
                            value:@"zh-cn,zh;q=0.75, en-us;q=0.50, en;q=0.25"];
        [request addRequestHeader:@"Connection" value:@"close"];
        [request addRequestHeader:@"X-Apple-Tz" value:@"28800"];
        [request addRequestHeader:@"X-Apple-Store-Front" value:@"143465-19,12"];
        [request addRequestHeader:@"X-Apple-ActionSignature" value:x_apple_actionsignature];

        
        NSData *poste =[postString dataUsingEncoding:NSUTF8StringEncoding];

        
        [request appendPostData:poste];
        
        
        //发送请求
        [request startSynchronous];
        NSError *error = [request error];
        if (error) {
//            NSLog(@"%@", [request error]);
            return nil;
        }
        
        if (request.responseStatusCode  != 200) {
            return nil;
        }
        //请求成功,获取返回信息
        pod = [[request responseHeaders] objectForKey:@"pod"];
        
        NSPropertyListFormat format;
        
        //        NSString *str = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        //
        //        NSLog(@"%@",str);
        
        NSDictionary * responseDic = [NSPropertyListSerialization propertyListFromData:[request responseData] mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
        
        if ([responseDic objectForKey:@"customerMessage"]) {
            [self saveFailString:[responseDic objectForKey:@"customerMessage"]];
        }else{
            [self saveFailString:FAIL_MESSAGE];
        }
        
        if ([responseDic objectForKey:@"passwordToken"] == nil || [responseDic objectForKey:@"clearToken"] == nil || [responseDic objectForKey:@"dsPersonId"] == nil) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[LoginServerManage getManager] reportAccountError:[responseDic objectForKey:@"failureType"]?[responseDic objectForKey:@"failureType"]:@"" loginMessage:[responseDic objectForKey:@"customerMessage"]?[responseDic objectForKey:@"customerMessage"]:@"" loginText:[responseDic objectForKey:@"customerMessage"]?[responseDic objectForKey:@"customerMessage"]:@"" buyCode:@"" buyMessage:@"" buyText:@"" isDelete:NO];
            });
            return nil;
        }
        appleDic = responseDic;
        
        if ( [[request.responseHeaders allKeys] containsObject:@"Location"] ) {
            //重新赋值URL
            url = [NSURL URLWithString: [request.responseHeaders objectForKey:@"Location"] ];
            continue;
        }
        
        //中断
        break;
        
    } while (TRUE);
    
    
    return  appleDic;
}

- (void)requestSecondLoginFromServer:(NSMutableDictionary*)dataDic userData:(id)userData{
    NSString*account = nil;
    NSString*password = nil;
    NSString *jsDicStr = [dataDic JSONString];
    jsDicStr = [DESUtils encryptUseDES:jsDicStr key:@"HBSMY4yF"];
    jsDicStr = [[FileUtil instance] encodeToPercentEscapeString:jsDicStr];
    NSString*requestStr = [NSString stringWithFormat:@"%@/i_info_proxy.php?cmd=%d&data=%@",REQUEST_HEAD,2,jsDicStr];
    
    NSURL *url = [NSURL URLWithString:requestStr];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        NSString *responseString = [requestSelf responseString];
        responseString = [DESUtils decryptUseDES:responseString key:@"HBSMY4yF"];
        NSMutableDictionary * map = [NSMutableDictionary dictionaryWithDictionary:[[FileUtil instance] analysisJSONToDictionary:responseString]];
        
        if ([[map objectForKey:@"RESULT"] isEqualToString:@"0"]) {
            
            //sucess
            
            NSInteger nowDate = [[FileUtil instance] currentTimeStamp];
            [map setObject:[self.tempDic objectForKey:@"poste"] forKey:@"POSTE"];
            [map setObject:[self.tempDic objectForKey:@"signature"] forKey:@"SIGNATURE"];
            [map setObject:[NSNumber numberWithInteger:nowDate] forKey:CACHE_DATE];
            NSString*account = [map objectForKey:@"USER"];
            NSString*password = [map objectForKey:@"PWD"];
            
            [[FileUtil instance] saveLoginKey:map account:account pwd:password];
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:0]];
            //                    });
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerSucess:password:dataDic:userData:)]) {
                    [self.delegate requestLoginFromServerSucess:[map objectForKey:@"USER"] password:[map objectForKey:@"PWD"] dataDic:map userData:userData];
                }
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[ReportManage instance] reportLoginInfo:[map objectForKey:@"USER"]];
                });
                
                
                
            });
            
        }else{
            //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [requestSelf error];
                [self saveFailString:FAIL_MESSAGE];
//                NSLog(@"登录3请求失败---%@",error);
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:1]];
                //                });
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerFail:password:userData:)]) {
                    [self.delegate requestLoginFromServerFail:account password:password userData:userData];
                }
            });
        }
    }];
    
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [requestSelf error];
            [self saveFailString:FAIL_MESSAGE];
//            NSLog(@"登录3请求失败---%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerFail:password:userData:)]) {
                [self.delegate requestLoginFromServerFail:account password:password userData:userData];
            }
        });
    }];
    
    
    
}


- (BOOL)isRepeatLogin:(NSString*)account{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[SAVE_ACCOUNTS stringByAppendingString:account]]) {
        return YES;
    }

    return NO;
}
-(void)addAccountToAccounts:(NSString*)account{
    
    if ([self isRepeatLogin:account]) {
        return;
    }


    [[NSUserDefaults standardUserDefaults] setObject:[SAVE_ACCOUNTS stringByAppendingString:account] forKey:[SAVE_ACCOUNTS stringByAppendingString:account]];
    
}

- (void)saveFailString:(NSString *)str{
    
    [[TMCache sharedCache] setObject:str forKey:@"savefailstring"];
    
}

- (void)requestAppleLoginSwitch{
    
    NSString*bodyStr = @"r=settings/getSettings";
    
    bodyStr = [[FileUtil instance] urlEncode:[DESUtils encryptUseDES:bodyStr key:@"i2.0908o"]];
    
    NSString *urlStr = [IPHONE_REQUEST_ADDRESS stringByAppendingString:bodyStr];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        
        NSDictionary * map = [[FileUtil instance] analysisJSONToDictionary:responseString];
        
        if (map && [map objectForKey:@"data"]){
            if([[map objectForKey:@"data"] objectForKey:@"euSettings"]) {
                NSString *loginSwitch = [[map objectForKey:@"data"] objectForKey:@"euSettings"];
                
                [[NSUserDefaults standardUserDefaults] setObject:loginSwitch forKey:LOGIN_SWITCH];
            }else{
//                NSLog(@"获取euSettings失败");
            }
            
            if([[map objectForKey:@"data"] objectForKey:@"giveAccountSettings"]) {
                NSString *loginSwitch = [[map objectForKey:@"data"] objectForKey:@"giveAccountSettings"];
                [[NSUserDefaults standardUserDefaults] setObject:loginSwitch forKey:WILL_GIVE_ACCOUNT];
            }else{
//                NSLog(@"获取是否开启账号赠送信息失败");
            }
            
        }else{
//            NSLog(@"登录开关数据出错");
        }
        
    }];
    
    [request setFailedBlock:^{
         NSError *error = [requestSelf error];
//        NSLog(@"请求登录开关失败,原因---%@",error);
        
    }];

    
    
}

- (void)requestGetFreeAccountInfo{
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO] && [[FileUtil instance] getAccountPasswordInfo]) {
//        
//        NSString *responseString = [[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO];
//        responseString = [DESUtils decryptUseDES:responseString key:APPLE_ACCOUNT_KEY];
//        NSDictionary * map = [[FileUtil instance] analysisJSONToDictionary:responseString];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(requestLoginFromServerSucess:password:dataDic:userData:)]) {
//            [self.delegate requestLoginFromServerSucess:[map objectForKey:@"name"] password:[map objectForKey:@"pwd"] dataDic:[[FileUtil instance] getAccountPasswordInfo] userData:nil];
//        }
//        return;
//    }
    

    //限制24小时内用户最多获得2个账号
    NSMutableDictionary  *account_date = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_ACCOUNT_DATE]];

    if (account_date) {
        for (NSString *name in [account_date allKeys]) {
            NSString *date = [[account_date  objectForKey:name ] objectForKey:name];
            if ((NSInteger)[[NSDate date] timeIntervalSince1970] - [date integerValue] > 3600*24) {
                [account_date removeObjectForKey:name];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:account_date forKey:SAVED_ACCOUNT_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([account_date count]>1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"moreThanTwo"];
        });
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂时不能获取账号,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        

        return;
    }
    
    
    
    //获取账号
    NSString *idfaStr = [[@"iPhone_" stringByAppendingString:[[FileUtil instance] getDeviceIDFA]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *infoString = [NSString stringWithFormat:@"flag=1&uuid=%@&ver=%@",idfaStr,[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    
    
    NSString *infoStr = [infoString stringByAppendingString:@"wangyi"];

    NSString *infoMD5 = [DESUtils getMD5:infoStr];

    if (!infoMD5 || infoMD5.length<26) {
        return;
    }

    NSString *subMD5 = [infoMD5 substringWithRange:NSMakeRange(13, 14)];
    
    NSString *desKey = [subMD5 stringByAppendingString:@"0M89n"];
    
    
    infoStr = [DESUtils encryptUseDES:infoStr key:desKey];
    
    infoStr = [[FileUtil instance] base64Str:infoStr];
    
    
    NSString *postStr = [DESUtils encryptUseDES:infoString key:desKey];
    
    NSMutableData *data = (NSMutableData*)[postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString*urlStr = [NSString stringWithFormat:@"https://aua.wanmeiyueyu.com/wga?sign=%@",infoMD5];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setValidatesSecureCertificate:NO];
    [request setPostBody:data];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        
        responseString = [DESUtils decryptUseDES:responseString key:desKey];
        responseString = [responseString substringWithRange:NSMakeRange(1, responseString.length -1)];
        
        NSDictionary * map = [[FileUtil instance] analysisJSONToDictionary:responseString];
        
        if (map && [map allKeys].count > 3) {
            //获取免费账号成功
            if ([[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:APPLEID_ACCOUNT_INFO];
            }
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[DESUtils encryptUseDES:responseString key:APPLE_ACCOUNT_KEY] forKey:APPLEID_ACCOUNT_INFO];
            
            
            
            [[FileUtil instance] saveAccountPasswordInfo:[map objectForKey:@"name"] pwd:[map objectForKey:@"pwd"]];
            
            //保存成功获取账号的时间,账号名称

            NSMutableDictionary  *account_date = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_ACCOUNT_DATE]];
            if (![[account_date allKeys] containsObject:[map objectForKey:@"name"]] ) {
                NSString *date = [NSString stringWithFormat:@"%d",(NSInteger)[[NSDate date] timeIntervalSince1970]];
                [account_date setObject:@{[map objectForKey:@"name"]:date} forKey:[map objectForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults] setObject:account_date forKey:SAVED_ACCOUNT_DATE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestGetFreeAccountSucess:password:)]) {
                    [self.delegate requestGetFreeAccountSucess:[map objectForKey:@"name"] password:[map objectForKey:@"pwd"]];
                }
            });
            
            [self requestLoginFromServer:[map objectForKey:@"name"] password:[map objectForKey:@"pwd"] userData:nil];
           
            
        }else{
            //获取免费账号数据格式错误
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:1]];
//            });
            if ( map && [[map allKeys] containsObject:@"result"] ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"赠送账号已完毕，请明天认领！" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"no_account"];
            });
            
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [requestSelf error];
//        NSLog(@"请求免费账号失败,原因---%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HIDDEN_LOGIN_LOADING object:@"loginfail"];
        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_APPID_RESULT object:[NSNumber numberWithInt:2]];
//        });
        
    }];

}

/*
 uuid:pc的标识
 ver:版本号
 id:name的md5值
 s:账号状态， 0：可用；1：停用；
 
 lc:登陆返回错误码logincode；
 lm:登陆返回错误消息loginmessage；
 lt:登陆返回不可知文本logintext;
 bc:购买返回错误码buycode；
 bm:购买返回错误消息buymessage；
 bt:购买返回不可知文本buytext;
 */
- (void)reportAccountError:(NSString *)logincode loginMessage:(NSString*)loginMessage loginText:(NSString*)loginText buyCode:(NSString*)buyCode buyMessage:(NSString*)buyMessage buyText:(NSString*)buyText isDelete:(BOOL)isDelete{
    
    NSString *idfaStr = [[@"iPhone_" stringByAppendingString:[[FileUtil instance] getDeviceIDFA]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    NSString *accountJson = [[NSUserDefaults standardUserDefaults] objectForKey:APPLEID_ACCOUNT_INFO];
    accountJson = [DESUtils decryptUseDES:accountJson key:APPLE_ACCOUNT_KEY];
    NSDictionary * accountMap = [[FileUtil instance] analysisJSONToDictionary:accountJson];
    NSString *nameInfo = [accountMap objectForKey:@"name"];
    if (!nameInfo) {
        nameInfo = @"";
    }else{
        nameInfo = [DESUtils getMD5:nameInfo];
    }
    
    NSString *infoString = [NSString stringWithFormat:@"bc=%@&bm=%@&bt=%@&id=%@&lc=%@&lm=%@&lt=%@&s=1&uuid=%@&ver=%@",buyCode,buyMessage,buyText,nameInfo,logincode,loginMessage,loginText,idfaStr,[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    
    
    NSString *infoStr = [infoString stringByAppendingString:@"wangyi"];
    
    NSString *infoMD5 = [DESUtils getMD5:infoStr];
    
    if (!infoMD5 || infoMD5.length<26) {
        return;
    }
    
    NSString *subMD5 = [infoMD5 substringWithRange:NSMakeRange(13, 14)];
    
    NSString *desKey = [subMD5 stringByAppendingString:@"0M89n"];
    
    
    infoStr = [DESUtils encryptUseDES:infoStr key:desKey];
    
    infoStr = [[FileUtil instance] base64Str:infoStr];
    
    
    NSString *postStr = [DESUtils encryptUseDES:infoString key:desKey];
    
    NSMutableData *data = (NSMutableData*)[postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString*urlStr = [NSString stringWithFormat:@"https://aua.wanmeiyueyu.com/as?sign=%@",infoMD5];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setValidatesSecureCertificate:NO];
    [request setPostBody:data];
    [request startAsynchronous];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        if ([responseString isEqualToString:@"ok"]) {
            //成功
            NSDictionary *dic = [[FileUtil instance] getAccountPasswordInfo];
            if (dic && [dic objectForKey:SAVE_ACCOUNT] && [dic objectForKey:SAVE_PASSWORD]) {
                NSString *account = [dic objectForKey:SAVE_ACCOUNT];
                NSString *password = [dic objectForKey:SAVE_PASSWORD];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[account stringByAppendingString:password]];
            }
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCOUNTPASSWORD];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:APPLEID_ACCOUNT_INFO];

            
        }

    }];
    
    [request setFailedBlock:^{
        NSError *error = [requestSelf error];
//        NSLog(@"上报免费账号异常失败,原因---%@",error);

    }];


    
}



@end
