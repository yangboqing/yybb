//
//  MoreCell.m
//  browser
//
//  Created by liguiyang on 14-6-19.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "MoreCell.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        UIImageView *imgView = [[UIImageView alloc] init];
        self.headImgView = imgView;
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        topLineView = [[UIImageView alloc] init];
        SET_IMAGE(topLineView.image, @"cuttingLine.png");
        topLineView.hidden = YES;
        cuttingLineView = [[UIImageView alloc] init];
        SET_IMAGE(cuttingLineView.image, @"cuttingLine.png");
        
        [self addSubview:_headImgView];
        [self addSubview:_contentLabel];
        [self addSubview:topLineView];
        [self addSubview:cuttingLineView];
        
        [self setCustomFrame];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)showHorizontalLine:(LineType)lineType;
{
    CGFloat width = MainScreen_Width;
    CGFloat height = self.frame.size.height;
    if (lineType == topLine) {
        topLineView.frame = CGRectMake(0, 0, width, 0.5);
    }
    else
    {
        topLineView.frame = CGRectMake(0, height-0.5, width, 0.5);
    }
    topLineView.hidden = NO;
}

-(void)hideCuttingLine:(BOOL)flag
{
    cuttingLineView.hidden = flag;
}

-(void)setCustomFrame
{
    self.frame = CGRectMake(0, 0, MainScreen_Width, self.frame.size.height);
    CGFloat xWidth = (IOS7)?10:15;
    self.headImgView.frame = CGRectMake(xWidth, 7, 29, 29);
    self.contentLabel.frame = CGRectMake(55, 7, 150, 30);
    cuttingLineView.frame = CGRectMake(52, 43.5, MainScreen_Width-52, 0.5);
}

@end
