//
//  UITextFieldEx.m
//  browser
//
//  Created by 毅 王 on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITextFieldEx.h"

@implementation UITextFieldEx

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
 borderRectForBounds指定矩形边界
 textRectForBounds 指定显示文本的边界
 placeholderRectForBounds指定站位文本的边界
 editingRectForBounds指定编辑中文本的边界
 clearButtonRectForBounds指定显示清除按钮的边界
 leftViewRectForBounds指定显示左附着视图的边界
 rightViewRectForBounds指定显示右附着视图的边界
 */
//
- (CGRect)borderRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, self.frame.size.width, 28);
//    return bounds;
    
}
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(40, 5, 225, 28);
}
//- (CGRect)placeholderRectForBounds:(CGRect)bounds{
//    return CGRectMake(26, 5, 14, 20);
//}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(40, 5, 220, 28);
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(284, 5, 20, 20);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(5,5, 20, 20);
//    return bounds;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    return CGRectMake(284, 5, 20, 20);
}

@end
