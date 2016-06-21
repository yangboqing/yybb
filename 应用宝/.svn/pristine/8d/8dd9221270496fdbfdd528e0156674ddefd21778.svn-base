//
//  WYTextFieldEx.m
//  browser
//
//  Created by 王毅 on 13-11-22.
//
//

#import "WYTextFieldEx.h"

@implementation WYTextFieldEx

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//指定矩形边界
- (CGRect)borderRectForBounds:(CGRect)bounds{
    //return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    return bounds;
}

//指定显示文本的边界
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-16-12/2-5, bounds.size.height);
    return bounds;
}

//指定编辑中文本的边界
- (CGRect)editingRectForBounds:(CGRect)bounds{
    if (IOS7) {
        return CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-16-12/2-5-6, bounds.size.height);
    }else
    {
        return CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-16-12/2-5-5-6, bounds.size.height);
    }
    
    return bounds;
}

//指定显示左附着视图的边界
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    //    return CGRectMake(self.frame.size.height * 1/4,self.frame.size.height * 1/4, self.frame.size.height * 1/2, self.frame.size.height * 1/2);
    //return CGRectMake((self.frame.size.height -20) / 2,(self.frame.size.height -20) / 2, 20, 20);
    return bounds;
}

//指定显示右附着视图的边界
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    //return CGRectMake(self.frame.size.width - self.frame.size.height + 4, 6, 18, 18);
    return bounds;
}

//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    //CFShow(NSStringFromCGRect(bounds));
    return CGRectMake(bounds.size.width - 6 - 21, bounds.origin.y + 9.0/2, 21, 21);
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10+15, bounds.origin.y, bounds.size.width -20, bounds.size.height);//更好理解些
    return inset;
}

@end