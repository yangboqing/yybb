//
//  LocalImageManager.m
//  browser
//
//  Created by liguiyang on 14-10-15.
//
//

#import "LocalImageManager.h"

@implementation LocalImageManager

+(void)setImageName:(NSString *)imgName complete:(void (^)(UIImage *image))completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self){
            @try {
                UIImage * t = [UIImage imageNamed:imgName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(t);
                });
            }
            @catch (NSException *exception) {
                NSLog(@"load image error %@  exception%@",imgName,[exception name]);
            }
            @finally {
                
            }
            
        }
    });
}


@end
