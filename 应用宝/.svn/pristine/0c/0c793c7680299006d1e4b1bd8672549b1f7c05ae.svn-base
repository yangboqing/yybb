//
//  UIHotWordLabel.h
//  KYSearchForWords
//
//  Created by liguiyang on 14-4-1.
//  Copyright (c) 2014年 liguiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotWordLabelDelegate <NSObject>

-(void)aHotWordLabelHasBeenSelected:(NSString *)hotWord;

@end

@interface UIHotWordLabel : UILabel
@property (nonatomic, weak) id <HotWordLabelDelegate>delegate;
@end
