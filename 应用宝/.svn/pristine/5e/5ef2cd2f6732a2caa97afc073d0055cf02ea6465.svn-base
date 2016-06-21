//
//  HotWordsHomePageView.m
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import "HotWordView.h"

@implementation HotWordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHotWordsLabel];
        [self setCustomFrame];
    }
    return self;
}

-(id)initWithHotWords:(NSArray *)wordArr
{
    self = [super init];
    if (self) {
        [self createHotWordsLabel];
        [self setLabelTextWithWords:wordArr];
        [self setCustomFrame];
    }
    return self;
}

#pragma mark - Utility
-(void)setLabelTextWithWords:(NSArray *)wordArr
{
    // 容错
    if (wordArr == nil) {
        return;
    }
    
    NSMutableArray *words = [wordArr mutableCopy];
    if (words.count < 9)
    {
        int lackCounts = 9 - words.count;
        for (int i=0; i < lackCounts; i++) {
            [words addObject:@""];
        }
    }
    // 赋值
    firstOneLabel.text = [self cutLabelText:words[0]];
    firstTwoLabel.text = [self cutLabelText:words[1]];
    firstThreeLabel.text = [self cutLabelText:words[2]];
    secondOneLabel.text = [self cutLabelText:words[3]];
    secondTwoLabel.text = [self cutLabelText:words[4]];
    secondThreeLabel.text = [self cutLabelText:words[5]];
    thirdOneLabel.text = [self cutLabelText:words[6]];
    thirdTwoLabel.text = [self cutLabelText:words[7]];
    thirdThreeLabel.text = [self cutLabelText:words[8]];
}
- (NSString *)cutLabelText:(NSString *)text{
    if (text.length > 6) {
        return [text substringToIndex:6];
    }
    return text;
}


-(void)createHotWordsLabel
{
    firstOneLabel = [[UIHotWordLabel alloc] init];
    firstOneLabel.textColor = [UIColor redColor];
    firstOneLabel.delegate = self;
    firstTwoLabel = [[UIHotWordLabel alloc] init];
    firstTwoLabel.delegate = self;
    firstThreeLabel = [[UIHotWordLabel alloc] init];
    firstThreeLabel.textColor = [UIColor redColor];
    firstThreeLabel.delegate = self;
    
    secondOneLabel = [[UIHotWordLabel alloc] init];
    secondOneLabel.delegate = self;
    secondTwoLabel = [[UIHotWordLabel alloc] init];
    secondTwoLabel.delegate = self;
    secondThreeLabel = [[UIHotWordLabel alloc] init];
    secondThreeLabel.delegate = self;
    
    thirdOneLabel = [[UIHotWordLabel alloc] init];
    thirdOneLabel.delegate = self;
    thirdTwoLabel = [[UIHotWordLabel alloc] init];
    thirdTwoLabel.delegate = self;
    thirdThreeLabel = [[UIHotWordLabel alloc] init];
    thirdThreeLabel.delegate = self;
    
    [self addSubview:firstOneLabel];
    [self addSubview:firstTwoLabel];
    [self addSubview:firstThreeLabel];
    [self addSubview:secondOneLabel];
    [self addSubview:secondTwoLabel];
    [self addSubview:secondThreeLabel];
    [self addSubview:thirdOneLabel];
    [self addSubview:thirdTwoLabel];
    [self addSubview:thirdThreeLabel];
}

-(void)setCustomFrame
{
    CGFloat originalX = 12;
    CGFloat originalY = 0;
    CGFloat space_horizontal = 22;
    CGFloat space_vertical = 30;
    CGFloat lab_width = (MainScreen_Width-originalX*2-space_horizontal*2)/3;
    CGFloat lab_height = 15;
    if (!iPhone5) {
        space_vertical = 20;
    }
    
    firstOneLabel.frame = CGRectMake(originalX, originalY, lab_width, lab_height);
    firstTwoLabel.frame = CGRectMake(originalX+lab_width+space_horizontal, originalY, lab_width, lab_height);
    firstThreeLabel.frame = CGRectMake(originalX+(lab_width+space_horizontal)*2, originalY,lab_width, lab_height);
    secondOneLabel.frame = CGRectMake(originalX, originalY+lab_height+space_vertical, lab_width, lab_height);
    secondTwoLabel.frame = CGRectMake(originalX+lab_width+space_horizontal, originalY+lab_height+space_vertical, lab_width, lab_height);
    secondThreeLabel.frame = CGRectMake(originalX+(lab_width+space_horizontal)*2, originalY+lab_height+space_vertical, lab_width, lab_height);
    thirdOneLabel.frame = CGRectMake(originalX, originalY+(lab_height+space_vertical)*2, lab_width, lab_height);
    thirdTwoLabel.frame = CGRectMake(originalX+lab_width+space_horizontal, originalY+(lab_height+space_vertical)*2, lab_width, lab_height);
    thirdThreeLabel.frame = CGRectMake(originalX+(lab_width+space_horizontal)*2, originalY+(lab_height+space_vertical)*2, lab_width, lab_height);
    
}

#pragma mark - HotWordLabelDelegate
-(void)aHotWordLabelHasBeenSelected:(NSString *)hotWord
{
    if ([self.delegate respondsToSelector:@selector(aHotWordHasBeenSelected:)]) {
        [self.delegate aHotWordHasBeenSelected:hotWord];
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
