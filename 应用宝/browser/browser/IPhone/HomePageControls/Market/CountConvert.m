//
//  CountConvert.m
//  browser
//
//  Created by caohechun on 14-7-16.
//
//

#import "CountConvert.h"

@implementation CountConvert
+ (id)defaultConvert{
    static CountConvert * convert = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        convert = [[CountConvert alloc]init];
    });
    
    return convert;
}

- (NSString *)convert:(NSString *)content{
    if (content) {
        if ([content integerValue] > 10000) {
            return [NSString stringWithFormat:@"%.1f万",[content integerValue]/10000.0];
        }else{
            return content;
        }
        
    }else{
        return @"其他";
    }
}

@end
