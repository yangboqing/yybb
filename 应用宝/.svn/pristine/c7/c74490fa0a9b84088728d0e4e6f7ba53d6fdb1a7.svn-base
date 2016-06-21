//
//  WallPaperTopView.m
//  browser
//
//  Created by liguiyang on 14-8-19.
//
//

#import "WallPaperTopView.h"

#define SELECTED_COLOR hllColor(222, 53, 46, 1)
#define UNSELECTED_COLOR hllColor(233, 155, 155, 1)

@interface WallPaperTopView ()
{
    UIToolbar *toolBar;
}

@end

@implementation WallPaperTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//hllColor(246, 246, 246, 1);
        [self frostedGlass];
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        latestTitle_select = [[NSAttributedString alloc] initWithString:@"推荐" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:SELECTED_COLOR}];
        latestTitle_unselect = [[NSAttributedString alloc] initWithString:@"推荐" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UNSELECTED_COLOR}];
        classifyTitle_select = [[NSAttributedString alloc] initWithString:@"分类" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:SELECTED_COLOR}];
        classifyTitle_unselect = [[NSAttributedString alloc] initWithString:@"分类" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UNSELECTED_COLOR}];
        
        UIButton *latestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [latestBtn setAttributedTitle:latestTitle_select forState:UIControlStateNormal];
        [latestBtn addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
        latestBtn.tag = TAG_LATESTBTN;
        
        UIButton *classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [classifyBtn setAttributedTitle:classifyTitle_unselect forState:UIControlStateNormal];
        [classifyBtn addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
        classifyBtn.tag = TAG_CLASSIFYBTN;
        
        verticalImg = [UIImage imageNamed:@"cut_41.png"]; // LOADIMAGE(@"cut_41", @"png");
        verticalImageLine = [[UIImageView alloc] initWithImage:verticalImg];
        bottomLabelLine = [[UILabel alloc] init];
        bottomLabelLine.backgroundColor = [UIColor redColor];
        
        [self addSubview:latestBtn];
        [self addSubview:classifyBtn];
        [self addSubview:verticalImageLine];
        [self addSubview:bottomLabelLine];
        
        self.latestBtn = latestBtn;
        self.classifyBtn = classifyBtn;
    }
    return self;
}

-(void)layoutSubviews
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    leftRect = CGRectMake(5, height-1, width*0.5-5, 1);
    rightRect = CGRectMake(width*0.5, height-1, width*0.5-5, 1);
    
    self.latestBtn.frame = CGRectMake(0, 0, width*0.5, height);
    self.classifyBtn.frame = CGRectMake(_latestBtn.frame.origin.x+_latestBtn.frame.size.width,0, width*0.5, height);
    verticalImageLine.frame = CGRectMake((width-verticalImg.size.width*0.5)*0.5, (height-verticalImg.size.height*0.5)*0.5, verticalImg.size.width*0.5, verticalImg.size.height*0.5);
    bottomLabelLine.frame = leftRect;
    toolBar.frame = self.bounds;
}

#pragma mark - Utility

-(void)topClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == TAG_LATESTBTN) {
        [self.latestBtn setAttributedTitle:latestTitle_select forState:UIControlStateNormal];
        [self.classifyBtn setAttributedTitle:classifyTitle_unselect forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3f animations:^{
            bottomLabelLine.frame = leftRect;
        }];
    }
    else
    {
        [self.classifyBtn setAttributedTitle:classifyTitle_select forState:UIControlStateNormal];
        [self.latestBtn setAttributedTitle:latestTitle_unselect forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3f animations:^{
            bottomLabelLine.frame = rightRect;
        }];
    }
}

-(void)frostedGlass
{
    self.clipsToBounds = YES;
    if (IOS7 && !toolBar) {
        toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        [self.layer insertSublayer:toolBar.layer atIndex:0];
    }
    else
    {
        self.backgroundColor = hllColor(248, 248, 248, 1);
    }
    
    
}

@end
