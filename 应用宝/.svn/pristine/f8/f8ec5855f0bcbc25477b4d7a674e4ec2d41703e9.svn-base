//
//  FindCell.h
//  KY20Version
//
//  Created by liguiyang on 14-5-19.
//  Copyright (c) 2014年 lgy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    Click_NO = 0,
    Click_YES
}Click_State;

@interface ImageLayerView : UIImageView

@property (nonatomic, strong) CAShapeLayer *imageLayer;
@property (nonatomic, assign) CGFloat radius;

@end

@interface FindCell : UITableViewCell
{
    UIView *separatorLine; // 分割线
    UIColor  *normalColor;
    UIColor  *clickColor;
}

@property (nonatomic, strong) ImageLayerView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, assign) Click_State clickState;

-(void)setCustomFrame;

@end
