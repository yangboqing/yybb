//
//  CollectionViewCell.m
//  333
//
//  Created by niu_o0 on 14-5-16.
//  Copyright (c) 2014年 niu_o0. All rights reserved.
//

#import "CollectionViewCell.h"

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#pragma mark - CollectionViewCellButton

@implementation CollectionViewCellButton

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    self.titleLabel.frame = CGRectMake(self.bounds.size.height+5, 0, self.bounds.size.width-self.bounds.size.height, self.bounds.size.height);
    
    if (self.down) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.frame = CGRectMake(2.5, 0, self.imageView.image.size.width/2, self.imageView.image.size.height/2);
        self.titleLabel.frame = CGRectMake(0, self.imageView.bounds.size.width+self.imageView.frame.origin.y, self.imageView.frame.size.width+5, 12.0);
    }
}

@end


@implementation CollectionViewCellImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maskLayer = [CAShapeLayer new];
        _maskLayer.fillColor = [UIColor whiteColor].CGColor;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:_maskLayer];
    }
    return self;
}

- (void)setMaskCornerRadius:(CGFloat)maskCornerRadius{
    _maskCornerRadius = maskCornerRadius;
    _maskLayer.borderWidth = 0.5;
    _maskLayer.borderColor = hllColor(120, 120, 120, 0.3).CGColor;
    _maskLayer.cornerRadius = maskCornerRadius;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _maskLayer.frame = self.layer.bounds;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.maskCornerRadius]];
    _maskLayer.path = path.CGPath;
    
}

@end



#pragma mark - CollectionViewCell

@implementation CollectionViewCell

#define JUHUATAG 100

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    
    if ([self.reuseIdentifier isEqualToString:__STYLE_RECOMMEND] || [self.reuseIdentifier isEqualToString:__STYLE_MORE_TOPIC] || [self.reuseIdentifier isEqualToString:__STYLE_ACTIVITY]) {
        
        if (highlighted) {
            self.backgroundColor = CONTENT_BACKGROUND_COLOR;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _iconImageView.maskLayer.fillColor = CONTENT_BACKGROUND_COLOR.CGColor;
            [CATransaction commit];
        }else{
            
            self.backgroundColor = [UIColor clearColor];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _iconImageView.maskLayer.fillColor = WHITE_BACKGROUND_COLOR.CGColor;
            [CATransaction commit];
        }
    }
}

- (void)makeViews{
    
    //图标
    _iconImageView = [[CollectionViewCellImageView alloc] init];
    _iconImageView.backgroundColor = [UIColor clearColor];
    _iconImageView.maskCornerRadius = 12.f;
    [self.contentView addSubview:_iconImageView];
    
    
    
    //名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:_nameLabel];

    
    //类型和大小
    _subLabel = [[UILabel alloc] init];
    _subLabel.backgroundColor = [UIColor clearColor];
    _subLabel.font = [UIFont systemFontOfSize:11.f];
    _subLabel.textColor = hllColor(87, 87, 87, 1.0);
    [self.contentView addSubview:_subLabel];


    //赞
    _zanButton = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    _zanButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [_zanButton setTitleColor:hllColor(87, 87, 87, 1.0) forState:UIControlStateNormal];
    _zanButton.backgroundColor = [UIColor clearColor];
    [_zanButton setImage:_StaticImage.zan forState:UIControlStateNormal];
    [_zanButton setImage:_StaticImage.zan forState:UIControlStateHighlighted];
    [self.contentView addSubview:_zanButton];
    
    //下载量
    _downButton = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    _downButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [_downButton setTitleColor:hllColor(87, 87, 87, 1.0) forState:UIControlStateNormal];
    _downButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_downButton];
    
    //下载按钮
    _downloadButton = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    _downloadButton.backgroundColor = [UIColor clearColor];
    _downloadButton.down = YES;
    [self.contentView addSubview:_downloadButton];
    
    __view = [[UIView alloc] init];
    __view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.contentView addSubview:__view];

}

- (NSArray *)reuseIdentifierArray{
    return @[__STYLE_NORMOL, __STYLE_TOPIC, __STYLE_ACTIVITY, __STYLE_RECOMMEND, __STYLE_REQUESTMORE, __STYLE_MORE_TOPIC];
}

- (void)layoutSubviews{
    
    switch ([[self reuseIdentifierArray] indexOfObject:self.reuseIdentifier]) {
            
            
        case _STYLE_NORMOL:     //应用 游戏
            
            //_iconImageView.image = _StaticImage.icon_60x60;
            _nameLabel.font = [UIFont systemFontOfSize:12.f];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            _nameLabel.numberOfLines = 0;
            
            _iconImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
            
            CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(self.bounds.size.width+5, 32)];
            
            _nameLabel.frame = CGRectMake(-2.5, _iconImageView.bounds.size.height + 8, self.frame.size.width+5, size.height);
        
            break;
           
        case _STYLE_TOPIC:      //专题
            
            _iconImageView.image = _StaticImage.icon_topic;
            _iconImageView.frame = self.bounds;

            break;
        
        case _STYLE_ACTIVITY:       //活动
            
            //_iconImageView.image = _StaticImage.icon_acti;
            _iconImageView.maskCornerRadius = 0.0f;
            
            //[_downButton setImage:_StaticImage.acti forState:UIControlStateNormal];
            //[_downButton setImage:_StaticImage.acti forState:UIControlStateHighlighted];
            
            _subLabel.numberOfLines = 1;
            _subLabel.font = [UIFont systemFontOfSize:12.0];
            _subLabel.textColor = hllColor(165, 165, 165, 1.0);
            //[_downButton setTitleColor:hllColor(165, 165, 165, 1.0) forState:UIControlStateNormal];
            
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            _nameLabel.font = [UIFont systemFontOfSize:15.f];
            _nameLabel.numberOfLines = 0;
            _iconImageView.frame = CGRectMake(10, 11, 250/2, 140/2);
            
            float _width = _iconImageView.frame.origin.x + _iconImageView.frame.size.width + 8;
            
            CGSize size1 = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(self.bounds.size.width-_width, 36)];
            
            _nameLabel.frame = CGRectMake(_width , _iconImageView.frame.origin.y, size1.width, size1.height);
            
            _subLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _iconImageView.frame.origin.y+_iconImageView.frame.size.height-16, 70, 16);
            
            //_downButton.frame = CGRectMake(_subLabel.frame.origin.x+_subLabel.frame.size.width+15, _iconImageView.frame.origin.y+_iconImageView.frame.size.height-16,42, 16);
            
            __view.frame = CGRectMake(_iconImageView.frame.origin.x, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
            break;
            
        case _STYLE_RECOMMEND:        //精彩推荐
            
            //_iconImageView.image = _StaticImage.icon_60x60;
            //[_downloadButton setImage:_StaticImage.download forState:UIControlStateNormal];
            //[_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
            //[_downloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_downButton setImage:_StaticImage.down forState:UIControlStateNormal];
            [_downButton setImage:_StaticImage.down forState:UIControlStateHighlighted];
            _subLabel.numberOfLines = 1;
            _subLabel.font = [UIFont systemFontOfSize:12.0];
            
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            _nameLabel.font = [UIFont systemFontOfSize:15.0];
            _nameLabel.numberOfLines = 1;
            _iconImageView.frame = CGRectMake(12, (self.bounds.size.height-60)/2, 60, 60);
            _nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+10, _iconImageView.frame.origin.y, MainScreen_Width-_iconImageView.frame.origin.x-_iconImageView.frame.size.width-10-68, 18);
            _subLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+5, _nameLabel.bounds.size.width, 11);
            _zanButton.frame = CGRectMake(_subLabel.frame.origin.x, _subLabel.frame.origin.y+_subLabel.frame.size.height+5, 52, 16);
            _downButton.frame = CGRectMake(_zanButton.frame.origin.x + _zanButton.frame.size.width + 10, _zanButton.frame.origin.y, _zanButton.frame.size.width+20, _zanButton.frame.size.height);
            
            //_downloadButton.frame = CGRectMake(self.frame.size.width - 44-8, (self.frame.size.height-46)/2, 32, 46);
            _downloadButton.frame = CGRectMake(self.frame.size.width-55, 0, 55, self.frame.size.height);
            __view.frame = CGRectMake(10, self.bounds.size.height-0.5, self.bounds.size.width-10, 0.5);
            break;
        
        case _STYLE_REQUESTMORE:
            
            _juhua = (RefreshView *)[self.contentView viewWithTag:JUHUATAG];
            if (!_juhua){
                _juhua = [RefreshView new];
                _juhua.tag = JUHUATAG;
                [self.contentView addSubview:_juhua];
            }
            _juhua.frame = self.bounds;
            
            break;
        
        case _STYLE_MORE_TOPIC:
            
            _subLabel.numberOfLines = 0;
            _subLabel.font = [UIFont systemFontOfSize:12.0];
            _iconImageView.frame = CGRectMake(10, (self.bounds.size.height-60)/2, 236/2, 120/2);
            _nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+9, _iconImageView.frame.origin.y, MainScreen_Width-10-_iconImageView.frame.size.width-9-5, 19);
            _subLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+8, _nameLabel.bounds.size.width, 30.0);
            __view.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width, 0.5);
            
            break;
            
        default:
            break;
    }
    
    
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
