//
//  CategoryCell.m
//  browser
//
//  Created by caohechun on 14-5-23.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "CategoryCell.h"
@interface CategoryCell()
{
    UILabel *nameLabel;
    UILabel *countLabel;
    NSString *categoryID;
}
@end
@implementation CategoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _categoryDetialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _categoryDetialButton.backgroundColor = [UIColor clearColor];
        _categoryDetialButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _categoryDetialButton.layer.borderWidth = 1;
        _categoryDetialButton.layer.borderColor = CONTENT_BACKGROUND_COLOR.CGColor;
        [self addSubview:_categoryDetialButton];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.frame = CGRectMake(0, 10, _categoryDetialButton.frame.size.width, 20);
        [_categoryDetialButton addSubview:nameLabel];

        countLabel = [[UILabel alloc]init];
        countLabel.font = [UIFont systemFontOfSize:10];
        countLabel.textColor = [UIColor darkGrayColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.frame = CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height, _categoryDetialButton.frame.size.width, 10);

        [_categoryDetialButton addSubview:countLabel];
        
    }
    return self;
}
- (void)setTitileColorSelected:(BOOL)selected{
    if (selected) {
        countLabel.textColor = [UIColor whiteColor];
        nameLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = TOP_RED_COLOR;
    }else{
        countLabel.textColor = GRAY_TEXT_COLOR;
        nameLabel.textColor = CONTENT_COLOR;
        self.backgroundColor = [UIColor clearColor];
    }
}
- (void)setCategoryName:(NSString *)name andCount:(NSString *)count andID:(NSString *)categoryID_{
    nameLabel.text = name;
    countLabel.text = [NSString stringWithFormat:@"%@款",count];
    categoryID  = categoryID_;
}

- (NSString *)getCategoryID{
    return categoryID;
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
