//
//  BppDistriPlistParser.h
//  browser
//
//  Created by 刘 亮亮 on 13-1-9.
//
//

#import <Foundation/Foundation.h>


@class BppDistriPlistParser;

@protocol BppDistriPlistParserDelegate <NSObject>

//分析parser完毕
- (void) onDidParserDistriPlistResult:(BppDistriPlistParser *)parser errorAttr:(NSDictionary*)attr;


//先关IPA ICON等全部下载完毕
- (void) onDidPlistDownloadIPASuccess:(BppDistriPlistParser *)parser;
- (void) onDidPlistDownloadIPAError:(BppDistriPlistParser *)parser  dicAttr:(NSDictionary*)attr;

//获取购买信息失败
- (void) onDidDownloadAUIPAError:(BppDistriPlistParser *)parser  appid:(NSString*)appid;


//解析处理
- (void) onDistriPlistParserIPAProgress:(BppDistriPlistParser *)parser  attr:(NSDictionary*)dicAttr;

//文件正在md5验证
- (void) onPlistDownloadMD5Checking:(BppDistriPlistParser *)parser;

@end


//BppDistriPlistParser
@interface BppDistriPlistParser : NSObject
{
    
}

@property (atomic, weak) id<BppDistriPlistParserDelegate> parserDelegate;


@property (atomic, strong)  NSString * appID;             //app 唯一ID
@property (atomic, strong)  NSString * appVersion;        //app 版本
@property (atomic, strong)  NSString * appName;           //app 名字
@property (atomic, strong)  NSString * ipaPath;           //IPA本地地址
@property (atomic, strong)  NSString * ipaIconURL;         //IPA图标的下载地址

@property (atomic, strong) id userInfo;                  //用户数据
@property (atomic, strong) NSString *appPrice;
@property (atomic, strong) NSString *downType;

@property (atomic, strong) NSString *orignalDistriPlistURL;   //传入参数的plist发布地址，带有参数

@property (atomic, strong) NSString *plistCachePath;   //plist文件的cache目录



-(BOOL) ParserPlist:(NSString*)plist  userData:(id)userData;

- (void) StopParser;
@end
