//
//  guideView.m
//  browser
//
//  Created by caohechun on 15/3/18.
//
//

#import "GuideView.h"
@interface GuideView()
{
    UIScrollView *content;
    UIButton *confirm;
}
@end
@implementation GuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    UIImage *image = [UIImage imageNamed:@"guide.png"];

    content = [[UIScrollView alloc] initWithFrame:self.frame];
    content.contentSize = CGSizeMake(MainScreen_Width, image.size.height/(image.size.width/MainScreen_Width));
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, content.contentSize.width, content.contentSize.height)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [content addSubview:imageView];
    
    [self addSubview:content];
    
    confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.backgroundColor = [UIColor clearColor];
    confirm.frame = CGRectMake(0, content.contentSize.height - 70, MainScreen_Width, 70);
    [confirm addTarget:self action:@selector(guideConfirm) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:confirm];
    
}

- (void)guideConfirm{
    self.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"guideView"];

}

@end
