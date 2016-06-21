//
//  RotatingLoadView.h
//  HotWordSearch
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotateView.h"

@interface RotatingLoadView : UIImageView
{
    RotateView *rotateView;
}

-(void)startRotationAnimation;
-(void)stopRotationAnimation;
- (void)setRotatingLoadFrame:(CGRect)frame;
@end
