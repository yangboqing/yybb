//
//  AppTestTableViewCell.m
//  browser
//
//  Created by caohechun on 14-4-17.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "AppTestTableViewCell.h"
@interface AppTestTableViewCell()
{
    UILabel *introLabel;
    UILabel *timeLabel;
    UIImageView * bottomLineImageView;
    NSDictionary *detailDic;
}
@end
@implementation AppTestTableViewCell
- (void)dealloc{

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        preView  = [[UIImageView alloc]init];
        SET_IMAGE(preView.image, @"testPage_default.png");
        preView.layer.cornerRadius = 5;
        preView.clipsToBounds  = YES;
        
        introLabel = [[UILabel alloc]init];
        introLabel.textColor = NAME_COLOR;
        introLabel.font  = [UIFont systemFontOfSize:16];
        introLabel.numberOfLines = 0;
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = GRAY_TEXT_COLOR;
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        bottomLineImageView = [[UIImageView alloc]init];
        bottomLineImageView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        
        [self addSubview:preView];
        [self addSubview:introLabel];
        [self addSubview:timeLabel];
        [self addSubview:bottomLineImageView];
        
    }
    return self;
}

- (void)layoutSubviews{
    preView.frame = CGRectMake(8, 10, 100, 58);
    introLabel.frame = CGRectMake(preView.frame.origin.x + preView.frame.size.width + 10, preView.frame.origin.y, self.frame.size.width - preView.frame.origin.x - preView.frame.size.width - 20, 33);
    timeLabel.frame = CGRectMake(introLabel.frame.origin.x, introLabel.frame.origin.y + introLabel.frame.size.height + 5, introLabel.frame.size.width, 15);
    bottomLineImageView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setTestCellDetail:(NSDictionary *)dic{
    detailDic = dic;
    introLabel.text = [dic objectForKey:@"title"];
//    timeLabel.text = [NSString stringWithFormat:@"%@(%@人阅读)",[dic objectForKey:@"date"], [dic objectForKey:@"viewCount"]];
    timeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]];
}
- (NSDictionary *)getTestCellDetail{
    return detailDic;
}
- (void)setTestImage:(UIImage *)image{
    preView.image = image;
}

- (UIImage *)getTestImage{
    return preView.image;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
