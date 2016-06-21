//
//  LocalImageManager.h
//  browser
//
//  Created by liguiyang on 14-10-15.
//
//

#import <Foundation/Foundation.h>



#define  SET_IMAGE(x, n) \
[LocalImageManager setImageName:n complete:^(UIImage *image) { \
x = image; \
}];



@interface LocalImageManager : NSObject

+(void)setImageName:(NSString *)imgName complete:(void (^)(UIImage *image))completion;

@end
