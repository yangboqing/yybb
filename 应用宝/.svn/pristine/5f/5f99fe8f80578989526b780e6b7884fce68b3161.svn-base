//
//  PopView.m
//  browser
//
//  Created by admin on 13-9-4.
//
//

#import "PopView.h"

@implementation PopView

#define FONTCOLOR [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define BACKCOLOR [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        //2.7
        self.backgroundColor = BACKCOLOR;
        //新春版
//        self.backgroundColor = NEWYEAR_RED;
        
        UILabel * label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = FONTCOLOR;
        //新春版
//        label.textColor = [UIColor whiteColor];
        label.text = @"设备授权";
        label.backgroundColor = [UIColor clearColor];

        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LocalImageManager setImageName:@"nav_back.png" complete:^(UIImage *image) {
            [btn setImage:image forState:UIControlStateNormal];
            [btn setImage:image forState:UIControlStateHighlighted];
            
        }];
        [btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1];
        
#define LABEL_HEIGHT 44
        
        CGFloat StartY = IOS7 ? 20 :0;;
        
        
        label.frame = CGRectMake(0, StartY, self.frame.size.width, LABEL_HEIGHT);
        [self addSubview:label];

        btn.frame = CGRectMake(15 , StartY+5, 34, 34);
        [self addSubview:btn];
        
        imageView.frame = CGRectMake(0, StartY + LABEL_HEIGHT-0.5, self.frame.size.width, 0.5);
        [self addSubview:imageView];
    }
    return self;
}

- (UIViewController *)viewController {
    for (UIView * next = [self superview];
         next;
         next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)pressBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closePopView" object:nil];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
