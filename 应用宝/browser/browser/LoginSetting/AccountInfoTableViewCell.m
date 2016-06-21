//
//  AccountInfoTableViewCell.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "AccountInfoTableViewCell.h"

@interface AccountInfoTableViewCell (){
    
    UIImageView *bgImageView;
    UIImageView *line;
    
}

@end

@implementation AccountInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        bgImageView = [UIImageView new];
        bgImageView.backgroundColor = CLEAR_COLOR;
        
        
        self.leftName = [UILabel new];
        self.leftName.textColor = BLACK_COLOR;
        self.leftName.backgroundColor = CLEAR_COLOR;
        self.leftName.font = [UIFont systemFontOfSize:16.0f];
        self.leftName.textAlignment = NSTextAlignmentLeft;
        
        
        self.rightInfo = [UILabel new];
        self.rightInfo.textColor = hllColor(150, 150, 150, 1.0);
        self.rightInfo.backgroundColor = CLEAR_COLOR;
        self.rightInfo.font = [UIFont systemFontOfSize:10.0f];
        self.rightInfo.textAlignment = NSTextAlignmentRight;
        
        line = [UIImageView new];
        line.backgroundColor = hllColor(217, 217, 217, 1);
        
        
        [self addSubview:bgImageView];
        [self addSubview:self.leftName];
        [self addSubview:self.rightInfo];
        [self addSubview:line];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    bgImageView.frame = CGRectMake(16*IPHONE6_XISHU, 0, self.frame.size.width - 32*IPHONE6_XISHU, self.frame.size.height-1);
    
    self.leftName.frame = CGRectMake(20*IPHONE6_XISHU, 0, bgImageView.frame.size.width/3 - 10*IPHONE6_XISHU, self.frame.size.height);
    self.rightInfo.frame = CGRectMake(self.leftName.frame.origin.x + self.leftName.frame.size.width, 0, (bgImageView.frame.size.width*2)/3 - 4*IPHONE6_XISHU, self.frame.size.height);
    line.frame = CGRectMake(16*IPHONE6_XISHU, self.frame.size.height - 1, self.frame.size.width - 32*IPHONE6_XISHU, 1);
}

- (void)setBackGroundImage:(int)index{
    
    UIImage *img;
    
    switch (index) {
        case 0:
            img = [UIImage imageNamed:@"shang"];
            break;
        case 1:
            img = [UIImage imageNamed:@"zhong"];
            break;
        case 2:
            img = [UIImage imageNamed:@"di"];
            break;
            
        default:
            break;
    }
    
    bgImageView.image = img;
    
    
}

- (void)showLine:(BOOL)isShow{
    
    line.hidden = !isShow;
    
}

@end
