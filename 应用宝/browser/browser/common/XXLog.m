//
//  XXLog.m
//  kydesktop
//
//  Created by liull on 13-9-5.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "XXLog.h"



@interface XLog : NSObject
{
}

//获取程序单件实例
+(id)Instance;

//输出日志
-(void)traceLog:(NSDictionary *)logEntry;
@end


@interface XLog ( )
{
    NSString * logBasePath;
}

@property(nonatomic, retain) NSCondition * condition;   //日志锁
@property(nonatomic, retain) NSMutableArray * logQueue; //日志队列
@property(nonatomic, retain) NSString * runTime;        //程序的启动时间

-(NSString*)systemTime;
@end



@implementation XLog

@synthesize condition;
@synthesize logQueue;
@synthesize runTime;


+(id)Instance {
    @synchronized(@"XLog"){
        
        static id instance = nil;
        if (!instance) {
            instance = [[XLog alloc] init];
        }
        
        return instance;
    }
}


-(id)init {
    
    self = [super init];
    if (self) {

        self.condition = [[NSCondition alloc] init];
        
        self.logQueue = [NSMutableArray array];
        //记录启动时间
        self.runTime = [self systemTime];
        

        logBasePath = [@"~/Documents/Log" stringByExpandingTildeInPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:logBasePath withIntermediateDirectories:YES attributes:nil error:nil];
        
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           @autoreleasepool {
                               [self threadProc];
                           }
                       }
                       );
    }
    
    return self;
}

-(NSString*)systemTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString * time = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);

    return time;
}

//负责输出日志的线程
- (void)threadProc
{
    do
    {
        @autoreleasepool {
            for ( int i = 0; i < 20; i++ )
            {
                //获取所有待输出日志到临时数组
                [self.condition lock ];
                while ( [ self.logQueue count ] == 0 )
                    [ self.condition wait ];
                
                NSArray* items = [ NSArray arrayWithArray: self.logQueue ];
                [self.logQueue removeAllObjects ];
                
                [ self.condition unlock ];
                
                // 输出到文件以及控制台
                if ( items.count > 0) {
                    [self logToFile: items ];
                }
            }
            
            //每20次清理一次 自动释放池
        }
        
    } while ( YES );
}

//输出到文件
-(void)logToFile:(NSArray*)logs {

    
    //    NSInteger index = 0;
    
    do {
        //开打日志文件
        //        NSString * filePath = [NSString stringWithFormat:@"%@(%ld).txt", self.runTime, (long)index];
        NSString * filePath = [NSString stringWithFormat:@"%@.txt", self.runTime];
        filePath = [logBasePath stringByAppendingPathComponent: filePath];
        BOOL lbExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (!lbExist) {
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil] ;
        }
//        else{
//            NSDictionary * fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:@"" error:nil];
//            if ([fileAttr fileSize] > 1024*1024) {
//                index++;
//                continue;
//            }
//        }
        
        
        NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath: filePath];
        
        //找到了合适的日志文件路径
        for (NSDictionary *dicItem in logs) {
            
            //组合输出的日志
            NSString * strlevel = @"";
            int level = [(NSNumber *)[dicItem objectForKey:@"Level"] unsignedIntValue];
            if ( level == CinLogLevelDebug) {
                strlevel = @"DEBUG";
            }else if (level == CinLogLevelInfo){
                strlevel = @"INFO";
            }else if (level == CinLogLevelWarning){
                strlevel = @"WARNING";
            }else if (level == CinLogLevelError) {
                strlevel = @"ERROR";
            }
            
            NSString * logData = [NSString stringWithFormat:@"<- %@ %@ -> [%@][%@:%@] %@\r\n%@\r\n",
                                  [self systemTime],    //日志的时间
                                  strlevel,             //本条日志级别
                                  [dicItem objectForKey:@"ThreadName"],     //本条日志所在的线程名称
                                  [dicItem objectForKey:@"FileName"],       //文件名
                                  [dicItem objectForKey:@"LineName"],       //行号
                                  [dicItem objectForKey:@"FunctionName"],   //本条日志所在的函数名称
                                  [dicItem objectForKey:@"Message"]        //日志内容
                                  ];
            //写入文件
            [handle seekToEndOfFile];
            [handle writeData: [logData dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //输出到控制台
            NSLog(@"%@", logData);
        }

        [handle closeFile];
        
        break;
    } while (NO);

}


//把日志添加到队列中
-(void)traceLog:(NSDictionary *)logEntry {
    
    //等待
    [self.condition lock];
    
    //记录
    [self.logQueue addObject: logEntry];

    [self.condition signal];
    
    //解锁
    [self.condition unlock];
}

- (void)dealloc {
    
    self.condition = nil;
    self.logQueue = nil;
}

@end



@implementation XXLog

+(void) wirteLog:(const char*)function
            file:(const char*)file
            line:(int)line
        logLevel:(CinLogLevel)level
          format:(NSString*)format,...
{
    
    //如果这条日志不需要输出，就不用做字符串格式化
    if ( !format )
        return;
    
    va_list args;
    va_start( args, format );
    NSString* str = [ [ NSString alloc ] initWithFormat: format arguments: args ];
    va_end( args );
    if ( ! str )
        str = @"";
    
    NSString* threadName = [ [ NSThread currentThread ] name ];
    if ( ! threadName ) {
        threadName = @"";
    }
    NSString* functionName = [ NSString stringWithUTF8String: function ];
    if ( ! functionName ) {
        functionName = @"";
    }

    NSString* fileName = [ NSString stringWithUTF8String: file];
    NSString* lineName = [ NSString stringWithFormat:@"%d", line];
    
    
    // NSDictionary中加入所有需要记录到日志中的信息
    NSDictionary* entry = [ NSDictionary dictionaryWithObjectsAndKeys:
                           @"LogEntry", @"Type",
                           str, @"Message",                                              // 日志内容
                           [ NSDate date ], @"Date",                                     // 日志生成时间
                           [ NSNumber numberWithUnsignedInteger: level ], @"Level",      // 本条日志级别
                           threadName, @"ThreadName",                                    // 本条日志所在的线程名称
                           functionName, @"FunctionName",                                   // 本条日志所在的函数名称
                           lineName,  @"LineName",
                           fileName,  @"FileName",
                           nil ];
    
    
     //[ [XLog sharedInstance] traceLog: entry ];
    @synchronized(@"XXLog_wirteLog") {
        [[XLog Instance] logToFile:[NSArray arrayWithObject: entry] ];
    }
}


@end


