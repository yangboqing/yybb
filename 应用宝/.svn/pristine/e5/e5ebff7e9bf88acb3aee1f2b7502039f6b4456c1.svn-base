//
//  UIApplication+MS.m
//  browser
//
//  Created by liguiyang on 14-6-27.
//
//

#import "UIApplication+MS.h"

@implementation UIApplication (MS)

+(NSString *)stringFromNetworkType:(NSUInteger)aNetworkType
{ //测试结果 GSM:2g或无网络; 3G/4G/WiFi 正确检测
    if (aNetworkType == 0) return @"GSM";
    if (aNetworkType == 1) return @"Edge";
    if (aNetworkType == 2) return @"3G";
    if (aNetworkType == 3) return @"4G";
    if (aNetworkType == 4) return @"LTE";
    if (aNetworkType == 5) return @"wifi";
    
    return nil;
}

+(NSNumber *)dataNetworkTypeFromStatusBar
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subViews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    id dataNetworkItemView = nil;
    
    for (id subView in subViews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subView;
            break;
        }
    }
    
    return [dataNetworkItemView valueForKey:@"dataNetworkType"];
}

+(NSString *)stringForCurrentNetState
{
    NSNumber *stateNumber = [self dataNetworkTypeFromStatusBar];
    NSString *netState = [self stringFromNetworkType:[stateNumber integerValue]];
    return netState;
}

@end
