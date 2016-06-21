//
//  RealtimeShowAdvertisement.h
//  browser
//
//  Created by 王毅 on 14-4-10.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FileUtil.h"
#import "CJSONDeserializer.h"

@protocol requestRealtimeShowDelegate <NSObject>
@optional

- (void)requestRealtimeShowsuccessWithDic:(NSDictionary *)dic;

- (void)requestRealtimeShowFaild;

@end

@interface RealtimeShowAdvertisement : NSObject

@property (nonatomic , weak) id<requestRealtimeShowDelegate>delegate;

+(RealtimeShowAdvertisement *)getObject;
//37-开屏图
- (void)requestRealtimeShowNew;
- (BOOL) writeFileData:(NSData*)data filePath:(NSString*)path;
@end
