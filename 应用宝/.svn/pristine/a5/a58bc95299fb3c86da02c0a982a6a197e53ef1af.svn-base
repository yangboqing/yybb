//
//  back.h
//  33
//
//  Created by niu_o0 on 14-4-29.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REQUESTCELLSIZE CGSizeMake(self.view.bounds.size.width, 45)
#define REQUESTEDTEXT  @"网络有点堵塞，试试再次上拉"
#define REQUESTINGTEXT   @"加载中 请稍后..."


@class GifView;
@interface RefreshView : UIView{
    GifView * _gifView;//gif图
    UILabel * _textLabel;
}

- (void)startGif;

- (void)stopGif;

@end







@interface BackAnimation : UIView{
    UIImageView * imageview2;
    UIImageView * imageView;
    UILabel * label;
}
- (void)start;
- (void)stop;
@end

@interface AnimationView : UIView{
    UILabel *label;
    
    @public
    GifView *gifView;
}

//- (void)start;
//- (void)stop;
@end

@interface BackFail : UIView{
    UIImageView * imageView;
    UILabel * label;
}

@end


typedef void(^tap)(void);

typedef enum {
    Loading = 0,        //加载中
    Failed,             //加载失败
    Hidden,             //加载完成
}Request_status;

@interface CollectionViewBack : UIView{
    tap _tap;
//    BackAnimation * _animation;
    AnimationView * _animation;
    BackFail * _failView;
}

@property (nonatomic, assign) Request_status status;

- (void)setClickActionWithBlock:(tap)_block;

@end
