//
//  gifLayer.m
//  browser
//
//  Created by niu_o0 on 14-7-1.
//
//

#import "GifView.h"
#import <ImageIO/ImageIO.h>

@implementation GifView

- (id)init{
    return [self initWithUrl:nil];
}

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        
        if (!url) url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
        
        _frameDelayTimes = [NSMutableArray new];
        _frames = [NSMutableArray new];
        _totalTime = 0.0f;
        getFrameInfo((__bridge CFURLRef)url, _frames, _frameDelayTimes, &_totalTime, NULL, NULL);
    }
    return self;
}

void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight)
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i) {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // get gif info with each frame
        NSDictionary *dict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
        //NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
        
        // get gif size
        if (gifWidth != NULL && gifHeight != NULL) {
            *gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime) {
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
        }
        
        CFRelease((__bridge CFTypeRef)(dict));
    }
    
    if (gifSource) {
        CFRelease(gifSource);
    }
}

- (void)startGif
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray array];
    CGFloat currentTime = 0;
    NSUInteger count = _frameDelayTimes.count;
    for (int i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 0; i < count; ++i) {
//        [images addObject:[_frames objectAtIndex:i]];
//    }
    [animation setValues:_frames];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    animation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
}

- (void)stopGif
{
    [self.layer removeAnimationForKey:@"gifAnimation"];
}

// remove contents when animation end
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.layer.contents = nil;
}
@end
