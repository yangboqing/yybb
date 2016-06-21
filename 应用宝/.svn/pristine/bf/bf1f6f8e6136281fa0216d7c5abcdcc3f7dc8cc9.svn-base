//
//  StaticImage.m
//  browser
//
//  Created by niu_o0 on 14-6-4.
//
//   定义 全局图片  防止重复从本地加载图片 浪费资源


#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "Context.h"

static Context * _staticContext = nil;

@implementation Context
@synthesize digID;
+ (instancetype)defaults{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticContext = [Context new];
    });
    return _staticContext;
}

+ (UIBarButtonItem *)addNavLeftBarType:(LeftBarItemType)leftItemType Target:(id)target Action:(SEL)action
{
    UIBarButtonItem *leftBarButtonItem;
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor=[UIColor clearColor];
    switch (leftItemType) {
        case leftBarItem_backType:
        {
           NSString * leftbarImgName = @"nav_back.png";
            UIImage *leftBarImg = [UIImage imageNamed:leftbarImgName];
            [leftButton setImage:leftBarImg forState:UIControlStateNormal];
            leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
            leftButton.frame = CGRectMake(0, 0, leftBarImg.size.width*0.5, leftBarImg.size.height*0.5);
             [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        }
            break;
        case leftBarItem_downArrowType:
        {
            leftButton.frame=CGRectMake(0, 0, 70, 44);
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 18, 16, 8.5)];
            imageView.image=[UIImage imageNamed:@"up.png"];
            [leftButton addSubview:imageView];
            UILabel *btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 10, 50, 24)];
            btnLabel.textAlignment=NSTextAlignmentCenter;
            btnLabel.font=[UIFont systemFontOfSize:15];
            btnLabel.textColor=[UIColor colorWithRed:0.1 green:0.48 blue:1 alpha:1];
            btnLabel.backgroundColor=[UIColor clearColor];
            btnLabel.textColor = [UIColor colorWithRed:93.f/255 green:86.f/255 blue:127.f/255 alpha:1];
            btnLabel.text=@"收起";
            [leftButton addSubview:btnLabel];
            [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        }
            break;
        case leftBarITem_pop:
        {
            NSString * leftbarImgName = @"nav_categoryIcon.png";
            UIImage *leftBarImg = [UIImage imageNamed:leftbarImgName];
            [leftButton setImage:leftBarImg forState:UIControlStateNormal];
//            leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
            leftButton.frame = CGRectMake(0, 0, leftBarImg.size.width*0.5, leftBarImg.size.height*0.5);
            [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
            
            
        
        }
            break;
        default:
            break;
    }
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)addNavRightBarType:(RightBarItemType)rightItemType Target:(id)target Action:(SEL)action
{
    UIBarButtonItem *rightBarButtonItem;
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor=[UIColor clearColor];
    if (rightItemType == rightBarItem_searchType) {
        UIImage *btnImg = [UIImage imageNamed:@"nav_search.png"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:btnImg forState:UIControlStateNormal];
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(0, 0, btnImg.size.width*0.5, btnImg.size.height*0.5);
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    else if (rightItemType == rightBarItem_categoryIconType)
    {
        rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:target action:action];
        UIOffset offset;
        offset.horizontal = -5.0;
        offset.vertical =0.0;
        [rightBarButtonItem setTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
        [rightBarButtonItem setTintColor:hllColor(93.f, 86.f, 127.f, 1.0)];
    
    }else if (rightItemType==rightBarItem_downArrowType){
        rightButton.frame=CGRectMake(0, 0, 70, 44);
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 16, 8.5)];
        imageView.image=[UIImage imageNamed:@"up.png"];
        [rightButton addSubview:imageView];
        UILabel *btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(28, 10, 50, 24)];
        btnLabel.textAlignment=NSTextAlignmentCenter;
        btnLabel.font=[UIFont systemFontOfSize:15];
        btnLabel.textColor=[UIColor colorWithRed:0.1 green:0.48 blue:1 alpha:1];
        btnLabel.backgroundColor=[UIColor clearColor];
        btnLabel.textColor = [UIColor colorWithRed:93.f/255 green:86.f/255 blue:127.f/255 alpha:1];
        btnLabel.text=@"收起";
        [rightButton addSubview:btnLabel];
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return rightBarButtonItem;
    
}

- (NSUInteger)homeToolBarBtnCount
{
    int k = (SHOW_REAL_VIEW_FLAG || HAS_CONNECTED_PC)?5:4;
    return k;
}

@end
