//
//  PopViewController.h
//  browser
//
//  Created by admin on 13-9-4.
//
//  闪退修复帮助页面

#import <UIKit/UIKit.h>

@interface PopViewController : UIViewController

{
    UIScrollView * scroll;
    UIImageView * imageView;
}

-(id)initWithLessonTitle:(NSString *)title;

@end
