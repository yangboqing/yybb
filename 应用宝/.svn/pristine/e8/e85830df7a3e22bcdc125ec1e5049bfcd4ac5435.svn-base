//
//  UserActiveLog.m
//  browser
//
//  Created by liull on 14-8-27.
//
//

#import "UserActiveLog.h"
#import "FileUtil.h"



#define USER_ACTIVE_PATH  [@"~/Library/userActive.plist" stringByExpandingTildeInPath]

//启动次数
#define KEY_FOR_TOTAL_LOGIN_COUNT   @"tlogin"


@implementation UserActiveLog

+(void)userLogin {
    
    if( ![[NSFileManager defaultManager] fileExistsAtPath:USER_ACTIVE_PATH] ) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSDictionary dictionary] forKey:@"daysinfo"];
        [dic writeToFile:USER_ACTIVE_PATH atomically:YES];
    }
    
    NSMutableDictionary * staticInfo = [NSMutableDictionary dictionaryWithContentsOfFile:USER_ACTIVE_PATH];
    
    //增加启动次数
    NSInteger totalloginCount = [[staticInfo objectForKey:KEY_FOR_TOTAL_LOGIN_COUNT] integerValue];
    [staticInfo setObject:[NSNumber numberWithInteger: ++totalloginCount ]
                   forKey:KEY_FOR_TOTAL_LOGIN_COUNT];
    
    
    //每天的统计次数
    NSMutableDictionary * daysInfo = [[staticInfo objectForKey:@"daysinfo"] mutableCopy];
    if(!IS_NSDICTIONARY(daysInfo))
        return ;
    
    //增加今天的启动次数
    NSInteger timestamp = [[FileUtil instance] currentTimeStamp];
    NSString * strtimestamp = [[FileUtil instance] timeStampToTime:timestamp format:@"YYYY-MM-dd"];
    NSInteger todayloginCount = [[daysInfo objectForKey:strtimestamp] integerValue];
    [daysInfo setObject:[NSNumber numberWithInteger: ++todayloginCount ]
                   forKey:strtimestamp];
    
    
    [staticInfo setObject:daysInfo forKey:@"daysinfo"];
    
    [staticInfo writeToFile:USER_ACTIVE_PATH atomically:YES];
}

+(NSDictionary *)getUserLoginInfo {
    
    NSMutableDictionary * dicInfo = [NSMutableDictionary dictionaryWithContentsOfFile:USER_ACTIVE_PATH];
    NSDictionary * daysinfo = [dicInfo objectForKey:@"daysinfo"];
    
    //取得今天的日期
    NSInteger timestamp = [[FileUtil instance] currentTimeStamp];
    
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //连续7天
    for(int i=0; i<7; i++) {
        timestamp = timestamp - 24*60*60;
        
        NSInteger count = [daysinfo objectForKey: [[FileUtil instance] timeStampToTime:timestamp format:@"YYYY-MM-dd"]];
        
        [info setObject:[NSNumber numberWithInteger:count]
                     forKey:[[FileUtil instance] timeStampToTime:timestamp format:@"YYYY-MM-dd"] ];
    }
    
    
    [dicInfo setObject:info forKey:@"daysinfo"];
    
    return dicInfo;
}

@end
