//
//  SimilarNavigationView.m
//  MyHelper
//
//  Created by mingzhi on 14/12/31.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "SimilarNavigationView.h"
#import "CollectionCells.h"

#define FunselectColor hllColor(237, 185, 16, 1)
#define FunUnselectColor hllColor(255, 255, 255, 0)

@implementation SimilarNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        changeStartX = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setClipsToBounds:YES];
        toolbar = [[UIToolbar alloc] initWithFrame:[self bounds]];
        [self.layer insertSublayer:[toolbar layer] atIndex:0];
        //标题
        titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.textColor = [UIColor blackColor];
        //左右按钮
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];leftBtn.tag = leftBtn_tag;
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];rightBtn.tag = rightBtn_tag;
        [leftBtn addTarget:self action:@selector(leftRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(leftRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //功能按钮
        segmentedControl=[UISegmentedControl new];
        segmentedControl.tintColor = FunselectColor;
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.momentary = NO;
        segmentedControl.multipleTouchEnabled = NO;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0f],NSFontAttributeName ,nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0f],NSFontAttributeName,nil];
        [segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        [segmentedControl setTitleTextAttributes:dic1 forState:UIControlStateNormal];
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        //下线
        cuttingLineView = [UIImageView new];
        cuttingLineView.backgroundColor = BottomColor;
        
        [self addSubview:titleLabel];
        [self addSubview:leftBtn];
        [self addSubview:rightBtn];
        [self addSubview:cuttingLineView];
        [self addSubview:segmentedControl];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title AndBtnTitleNameArray:(NSArray *)btnNameArray
{
    titleLabel.text = title;
    if ([title isEqualToString:@"应用"]||[title isEqualToString:@"游戏"]) {
        leftBtn.hidden = YES;
    }
    if (btnNameArray && btnNameArray.count >= 2) {
        if (segmentedControl.numberOfSegments) {
            for (int i=0; i<btnNameArray.count; i++) {
                [segmentedControl setTitle:btnNameArray[i] forSegmentAtIndex:i];
            }
            segmentedControl.selectedSegmentIndex = 0;
        }else
        {
            for (int i=0; i<btnNameArray.count; i++) {
                [segmentedControl insertSegmentWithTitle:btnNameArray[i] atIndex:i animated:NO];
            }
            segmentedControl.selectedSegmentIndex = 0;
        }
    }
}

- (void)setBtnImage:(NSArray *)imageArray
{
    if (imageArray && imageArray.count >= 2) {
        [leftBtn setImage:[UIImage imageNamed:imageArray[0]] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:imageArray[1]] forState:UIControlStateNormal];
    }else
    {
        if (imageArray && imageArray.count) {
            leftBtn.hidden = NO;
            [leftBtn setImage:[UIImage imageNamed:imageArray[0]] forState:UIControlStateNormal];
            rightBtn.hidden = YES;
        }else
        {
            leftBtn.hidden = YES;
            rightBtn.hidden = YES;
        }
    }
}
- (void)btnImage:(NavAppGameType)type{
    if (type==new_tag) {
    
        segmentedControl.selectedSegmentIndex = 1;
    }
    if(type==good_tag){

        segmentedControl.selectedSegmentIndex = 0;
    }
    if (type==top_tag) {
        
        segmentedControl.selectedSegmentIndex=2;
    }
    if (type==four_tag) {
        segmentedControl.selectedSegmentIndex=3;
    }
}
- (void)initAppGameBtn{
    [leftBtn setImage:[UIImage imageNamed:@"nav_categoryIcon"] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.5]];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [rightBtn setTitleColor:hllColor(86, 71, 147, 1) forState:UIControlStateNormal];
    
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    changeStartX = -3;
    [self layoutSubviews];
}
- (void)initFindBtn{
    [leftBtn setImage:[UIImage imageNamed:@"nav_categoryIcon"] forState:UIControlStateNormal];
    changeStartX = -3;
    [self layoutSubviews];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnWidth = 80/2;
    
    toolbar.frame = self.bounds;
    titleLabel.frame = CGRectMake(0, 20, self.bounds.size.width, 44);
    
    leftBtn.frame = CGRectMake(15+changeStartX, 20+(44-btnWidth)/2+2, btnWidth, btnWidth);
    rightBtn.frame = CGRectMake(self.bounds.size.width - 15 - btnWidth, leftBtn.frame.origin.y, btnWidth, btnWidth);
    if (self.bounds.size.height > 200/2) {
        segmentedControl.frame = CGRectMake(34/2, self.bounds.size.height-12/2-58/2, self.bounds.size.width-34, 58/2);
    }else
    {
        segmentedControl.frame = CGRectZero;
    }
    
    cuttingLineView.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
}

- (void)dealloc{
    
}

- (void)leftRightBtnClick:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    [self funBtnClick:(long)tmpBtn.tag];
}

- (void)segmentAction:(UISegmentedControl *)Seg{
    
    segmentedControl.selectedSegmentIndex = Seg.selectedSegmentIndex;
    [self funBtnClick:(long)segmentedControl.selectedSegmentIndex];
}

#pragma mark - 按钮点击
- (void)funBtnClick:(SimilarNavigationBtnType)sender
{
    if (navigationViewBtnclickBlock) {
        navigationViewBtnclickBlock(sender);
    }
}
- (void)setnavigationViewBtnclickBlock:(NavigationViewBtnclickBlock)block{
    
    navigationViewBtnclickBlock = block;
}

@end
