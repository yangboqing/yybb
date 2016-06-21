//
//  gifLayer.h
//  browser
//
//  Created by niu_o0 on 14-7-1.
//
//

#import <QuartzCore/QuartzCore.h>

@interface GifView : UIView{
    NSMutableArray * _frameDelayTimes;
    NSMutableArray * _frames;
    CGFloat  _totalTime;
}

- (id)initWithUrl:(NSURL *)url;

- (void)startGif;

- (void)stopGif;
@end
