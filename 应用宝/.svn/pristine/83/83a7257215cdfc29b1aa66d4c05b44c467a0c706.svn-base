//
//  LFView.h
//  browser
//
//  Created by liguiyang on 14-6-18.
//
//

#import <UIKit/UIKit.h>

@protocol LFViewDelegate <NSObject>
-(void)failedViewHasBeenTaped;
@end

@interface LFView : UIView
@property (nonatomic, weak) id <LFViewDelegate>delegate;

-(id)initWithLFIdentifier:(NSString *)iden;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void)showFailedView;
-(void)hideFailedView;

@end
