//
//  AppInforFootView.m
//  browser
//
//  Created by caohechun on 14-6-3.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppInforFootView.h"

@implementation AppInforFootView
{
    UILabel *typeLabel;
    UILabel *deviceLabel;
    UILabel *sizeLabel;
    UILabel *systemLabel;
    UILabel *timeLabel;
    UILabel *versionLabel;
}
- (void)dealloc{

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
#define LABEL_FONT_SIZE 12

        typeLabel = [[UILabel alloc]init];
        typeLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.textColor = OTHER_TEXT_COLOR;
        typeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        typeLabel.numberOfLines = 1;
        typeLabel.backgroundColor = [UIColor clearColor];
        
        deviceLabel = [[UILabel alloc]init];
        deviceLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        deviceLabel.textAlignment = NSTextAlignmentLeft;
        deviceLabel.textColor = OTHER_TEXT_COLOR;
        deviceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        deviceLabel.numberOfLines = 1;
        deviceLabel.backgroundColor = [UIColor clearColor];
        
        sizeLabel = [[UILabel alloc]init];
        sizeLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        sizeLabel.textAlignment = NSTextAlignmentLeft;
        sizeLabel.textColor = OTHER_TEXT_COLOR;
        sizeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        sizeLabel.numberOfLines = 1;
        sizeLabel.backgroundColor = [UIColor clearColor];
        
        systemLabel = [[UILabel alloc]init];
        systemLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        systemLabel.textAlignment = NSTextAlignmentLeft;
        systemLabel.textColor = OTHER_TEXT_COLOR;
        systemLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        systemLabel.numberOfLines = 1;
        systemLabel.backgroundColor  = [UIColor clearColor];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.textColor = OTHER_TEXT_COLOR;
        timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        timeLabel.numberOfLines = 1;
        timeLabel.backgroundColor = [UIColor clearColor];
        
        versionLabel = [[UILabel alloc]init];
        versionLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        versionLabel.textAlignment = NSTextAlignmentLeft;
        versionLabel.textColor = OTHER_TEXT_COLOR;
        versionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        versionLabel.numberOfLines = 1;
        versionLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:typeLabel];
        [self addSubview:deviceLabel];
        [self addSubview:sizeLabel];
        [self addSubview:versionLabel];
        [self addSubview:systemLabel];
        [self addSubview:timeLabel];

    }
    return self;
}

- (void)layoutSubviews{
#define label_space_y 7
#define label_font_size 12

    typeLabel.frame = CGRectMake(12,9, 108, label_font_size);
    deviceLabel.frame = CGRectMake(self.frame.size.width - 134, typeLabel.frame.origin.y, 134, label_font_size);
    sizeLabel.frame = CGRectMake(typeLabel.frame.origin.x, typeLabel.frame.origin.y + typeLabel.frame.size.height + label_space_y, typeLabel.frame.size.width, label_font_size);
    systemLabel.frame = CGRectMake(deviceLabel.frame.origin.x, deviceLabel.frame.origin.y + deviceLabel.frame.size.height + label_space_y, deviceLabel.frame.size.width, label_font_size);
    timeLabel.frame = CGRectMake(sizeLabel.frame.origin.x, sizeLabel.frame.origin.y + sizeLabel.frame.size.height + label_space_y, sizeLabel.frame.size.width, label_font_size);
    versionLabel.frame = CGRectMake(systemLabel.frame.origin.x, systemLabel.frame.origin.y + systemLabel.frame.size.height + label_space_y, systemLabel.frame.size.width, label_font_size);
}

- (void)initAppInforWithData:(NSDictionary *)dataDic{
    //待确定数据类型
    
    NSDictionary *tmpDic = [dataDic objectForKey:@"data"];
    typeLabel.text  = [NSString stringWithFormat:@"类型 %@",[tmpDic objectForKey:@"category"]];
    sizeLabel.text = [NSString stringWithFormat:@"大小 %@M",[tmpDic objectForKey:@"appdisplaysize"]];
    deviceLabel.text =  [NSString stringWithFormat:@"设备 %@",[tmpDic objectForKey:@"appdevice"]];
    systemLabel.text =  [NSString stringWithFormat:@"系统 %@及以上",[tmpDic objectForKey:@"appminosver"]];
    timeLabel.text =  [NSString stringWithFormat:@"时间 %@",[tmpDic objectForKey:@"appupdatetime"]];
    versionLabel.text  =  [NSString stringWithFormat:@"版本 %@",[tmpDic objectForKey:@"displayversion"]?[tmpDic objectForKey:@"displayversion"]:[tmpDic objectForKey:@"appversion"]];
}


@end
