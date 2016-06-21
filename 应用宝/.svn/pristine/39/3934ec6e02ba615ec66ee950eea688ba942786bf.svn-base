//
//  LoginServerManage.h
//  browser
//
//  Created by 王毅 on 15/1/14.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FileUtil.h"
#import "TMCache.h"
#import "CJSONDeserializer.h"
#import "DESUtils.h"

@protocol LoginServerDelegate <NSObject>

@optional

//成功
- (void)requestLoginFromServerSucess:(NSString*)account password:(NSString*)password dataDic:(NSDictionary*)dataDic userData:(id)userData;
- (void)requestGetFreeAccountSucess:(NSString*)account password:(NSString *)password;


//失败
- (void)requestLoginFromServerFail:(NSString*)account password:(NSString*)password userData:(id)userData;


@end


@interface LoginServerManage : NSObject
@property (nonatomic , assign) id<LoginServerDelegate>delegate;
+(LoginServerManage *) getManager;
- (void)requestLoginFromServer:(NSString*)account password:(NSString*)password userData:(id)userData;
- (BOOL)isRepeatLogin:(NSString*)account;
-(void)addAccountToAccounts:(NSString*)account;
- (void)requestAppleLoginSwitch;//请求是否开启送账号开关
- (void)requestGetFreeAccountInfo;

- (void)reportAccountError:(NSString *)logincode loginMessage:(NSString*)loginMessage loginText:(NSString*)loginText buyCode:(NSString*)buyCode buyMessage:(NSString*)buyMessage buyText:(NSString*)buyText isDelete:(BOOL)isDelete;
@end
