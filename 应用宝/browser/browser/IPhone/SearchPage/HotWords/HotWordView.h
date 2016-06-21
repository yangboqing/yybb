//
//  HotWordsHomePageView.h
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHotWordLabel.h"

@protocol HotWordViewDelegate <NSObject>

-(void)aHotWordHasBeenSelected:(NSString *)hotWord;

@end

@interface HotWordView : UIView<HotWordLabelDelegate>
{
    UIHotWordLabel *firstOneLabel; // 第一行，第一列
    UIHotWordLabel *firstTwoLabel; // 第一行，第二列
    UIHotWordLabel *firstThreeLabel;
    UIHotWordLabel *secondOneLabel;
    UIHotWordLabel *secondTwoLabel;
    UIHotWordLabel *secondThreeLabel;
    UIHotWordLabel *thirdOneLabel;
    UIHotWordLabel *thirdTwoLabel;
    UIHotWordLabel *thirdThreeLabel;
}

@property (nonatomic, weak) id <HotWordViewDelegate>delegate;

-(id)initWithHotWords:(NSArray *)wordArr;
-(void)setLabelTextWithWords:(NSArray *)wordArr;

@end
