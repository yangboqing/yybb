//
//  XXLog.h
//  kydesktop
//
//  Created by liull on 13-9-5.
//
//

#import <Foundation/Foundation.h>


//是否同步跟踪日志输出
#define SYN_TRACE_LOG       0


typedef enum CinLogLevel {
    CinLogLevelDebug = 1,
    CinLogLevelInfo = 2,
    CinLogLevelWarning = 3,
    CinLogLevelError = 4
}CinLogLevel;


/**日志输出类
 */
@interface XXLog : NSObject

/**日志输出
 
 @param function 日志所在的函数名称
 @param level 日志级别，Debug、Info、Warn、Error
 @param format 日志内容，格式化字符串
 @param ... 格式化字符串的参数
 */
+(void) wirteLog:(const char*)function
            file:(const char*)file
            line:(int)line
        logLevel:(CinLogLevel)level
          format:(NSString*)format,...;

@end




#define   PRINT_LOG   0

#if PRINT_LOG == 1
#define FeLogDebug(logformat,...)       \
[XXLog wirteLog:__FUNCTION__ file:__FILE__ line:__LINE__ logLevel:CinLogLevelDebug format:logformat ,##__VA_ARGS__]

#define FeLogInfo(logformat,...)        \
[XXLog wirteLog:__FUNCTION__ file:__FILE__ line:__LINE__ logLevel:CinLogLevelInfo format:logformat ,##__VA_ARGS__]

#define FeLogWarn(logformat,...)        \
[XXLog wirteLog:__FUNCTION__ file:__FILE__ line:__LINE__ logLevel:CinLogLevelWarning format:logformat ,##__VA_ARGS__]

#define FeLogError(logformat,...)       \
[XXLog wirteLog:__FUNCTION__ file:__FILE__ line:__LINE__ logLevel:CinLogLevelError format:logformat ,##__VA_ARGS__]

#else

#define FeLogDebug(logformat,...)   {}
#define FeLogInfo(logformat,...)    {}
#define FeLogWarn(logformat,...)    {}
#define FeLogError(logformat,...)   {}

#endif




