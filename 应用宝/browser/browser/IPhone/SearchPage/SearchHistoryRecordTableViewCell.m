//
//  SearchHistoryRecordTableViewCell.m
//  browser
//
//  Created by 王毅 on 14-4-2.
//
//

#import "SearchHistoryRecordTableViewCell.h"

@interface SearchHistoryRecordTableViewCell (){
    UIImageView *cutLineView;
}

@end


@implementation SearchHistoryRecordTableViewCell
@synthesize deleteButton = _deleteButton;
@synthesize recordLabel = _recordLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 38);
        //记录文字
        self.recordLabel = [[UILabel alloc]init];
        self.recordLabel.numberOfLines = 1;
        self.recordLabel.textAlignment = NSTextAlignmentLeft;
        self.recordLabel.backgroundColor = [UIColor clearColor];
        self.recordLabel.font = [UIFont systemFontOfSize:14.0f];
        self.recordLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1];;
        //删除按钮
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.tag = (NSUInteger)self;
        [LocalImageManager setImageName:@"delete_searchHistory.png" complete:^(UIImage *image) {
            [self.deleteButton setImage:image forState:UIControlStateNormal];
        }];
        
        // 分割线
        cutLineView = [[UIImageView alloc] init];
        SET_IMAGE(cutLineView.image, @"cuttingLine.png");
        [self addSubview:self.recordLabel];
        [self addSubview:self.deleteButton];
        [self addSubview:cutLineView];
        
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat x_delbtn = MainScreen_Width-50;
    self.recordLabel.frame = CGRectMake(20, 10, 220, 18);//CGRectMake(20, 10, 267, 18);
    self.deleteButton.frame = CGRectMake(x_delbtn, 0, 50, 38);
    cutLineView.frame = CGRectMake(10, self.frame.size.height-0.5f, self.frame.size.width - 10, 0.5f);
//    self.recordLabel.frame = CGRectMake(13, 10, 275, 18);
//    self.deleteButton.frame = CGRectMake(self.frame.size.width - 12 - 20, 0, 50, 38);
    
}

- (void)setHistroyRecord:(NSString *)recordStr{
    if (!recordStr) {
        self.recordLabel.text = @"出错啦";
    }
    self.recordLabel.text = recordStr;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
}

@end
