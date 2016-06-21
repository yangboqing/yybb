//
//  AppStoreNewDownload.h
//  browser
//
//  Created by 王毅 on 15/1/26.
//
//

#import <Foundation/Foundation.h>
# import "AppStoreDownload.h"

#define DOWNLOAD_AU_SUCCESS   0
#define GET_BUYINFO_ERROR 1

//登陆URL
#define AUTHENTICATE_URL    "-buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/authenticate"
//购买URL
#define BUY_PRODUCT_URL     "-buy.itunes.apple.com/WebObjects/MZBuy.woa/wa/buyProduct"
//购买完成URL
#define BUY_COMPLETE_URL    "-buy.itunes.apple.com/WebObjects/MZFastFinance.woa/wa/songDownloadDone?"
#define	USER_AGENT	"iTunes/12.0.1 (Windows; Microsoft Windows 7 Ultimate Edition Service Pack 1 (Build 7601)) AppleWebKit/536.30.1"

#define BUY_AGAIN_URL "-buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/pendingSongs"
//苹果sinf文件扩展名
#define SINF_APPLE      @"sinf.apple"
@interface AppStoreNewDownload : NSObject{
    BOOL isLogin;
    BOOL isBuy;
    BOOL isClean;
    BOOL isgetInfo;
}
@property (nonatomic , strong)NSString *currentAppid;
@property (nonatomic , strong) NSString *md5Str;
-(NSUInteger)downloadIPAByAU:(NSString*)appid download:( void (^)(NSDictionary* httpHeaders ,NSString *ipaURL) )downloader;
-(BOOL)packageIPA:(NSString*)ipaPath appid:(NSString*)appid;
@end
