//
//  KyShared.h
//  browser
//
//  Created by niu_o0 on 14-6-13.
//
//

#import <Foundation/Foundation.h>
#import "LXActivity.h"


typedef enum showType{
    show_more =0,
    show_app_detail,
    show_find_detail,
    show_bizhi
}showType;


@interface KyShared : NSObject <LXActivityDelegate>{
    LXActivity * _activity;
}

//共有属性
//传入appName
@property (nonatomic, strong) NSString *title;
//传入应用简介
@property (nonatomic, strong) NSString *description;
//传入icon--注意接收变量的类型为UIImage
@property (nonatomic, strong) UIImage *image;
//传入跳转的url地址
@property (nonatomic, strong) NSString *webpageUrl;
//设置来源类型
@property (nonatomic, assign) showType showType;


//微博专用属性
@property (nonatomic, strong) NSString * weiboText;
@property (nonatomic, strong) NSString *objectID;

+ (instancetype)shared;

- (void)show;

@end
