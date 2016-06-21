//
//  NSlogEx.m
//  browser
//
//  Created by liull on 14-11-6.
//
//

#import "NSLogEx.h"


#ifdef NSLog
#undef NSLog
#endif

@implementation LogK

+(void)log:(NSString *)format, ... {
    

    
#ifndef DEBUG
    NSString * tagFile = [[NSBundle  mainBundle] bundleIdentifier];
    tagFile = [[@"~/Documents/"  stringByExpandingTildeInPath] stringByAppendingPathComponent:tagFile];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tagFile])
        return ;
#endif
    
    va_list args;
    va_start(args, format); //一定要“...”之前的那个参数
    NSString* strLog = [ [ NSString alloc ] initWithFormat: format arguments: args ];
//    NSLog(@"%@",strLog);
    va_end(args);
}

@end

