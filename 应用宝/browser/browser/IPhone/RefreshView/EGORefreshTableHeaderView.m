//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "GifView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView ()
{
    GifView * _gifView;
}

- (void)setStates:(EGOPullRefreshState)aState;

@end

@implementation EGORefreshTableHeaderView

@synthesize egoDelegate;

#define Size CGSizeMake(15.0f, 15.0f)
#define SPACE 3

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize labelSize = CGSizeMake(75, 65.0);//[_statusLabel.text boundingRectWithSize:CGSizeMake(MainScreen_Width, 65.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil].size;
    CGFloat originX = (self.frame.size.width-labelSize.width-Size.width-SPACE)*0.5;
    
    _arrowImage.frame = CGRectMake(originX, self.frame.size.height - 65.0f + (65.0f-Size.height)/2, Size.width, Size.height);
    _statusLabel.frame = CGRectMake(originX+Size.width+SPACE, self.frame.size.height - 65.0f, labelSize.width, 65.0f);
    
//    _gifView.frame = CGRectMake(_arrowImage.frame.origin.x, _arrowImage.frame.origin.y, 20, 20);
    CGFloat oriX = (self.frame.size.width-110)*0.5;
    _gifView.frame = CGRectMake(oriX,_arrowImage.frame.origin.y+5,110,10);
    
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        
        _gifView = [GifView new];
        [self addSubview:_gifView];
        //[_gifView release];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		
		UILabel * label = [[UILabel alloc] init];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		label.font = [UIFont systemFontOfSize:10.f];
		label.textColor = textColor;

		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		_statusLabel=label;
        //[label release];
		
		CALayer * layer = [CALayer layer];
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		
		[self setStates:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"xiala.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
	
	if ([self.egoDelegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [self.egoDelegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新时间: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
//		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setStates:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = @"松开即可刷新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = @"下拉即可刷新...";
//			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			//[self refreshLastUpdatedDate];
			break;
		case EGOOPullRefreshLoading:
			
//			_statusLabel.text = FRASHLOAD_ING;
            _statusLabel.text = @"";
            _arrowImage.hidden = YES;
            [_gifView startGif];
//			[_activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = YES;
//			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

#define Offset (self.inset.top+65.0f)

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(self.inset.top+60.0, 0, 0, 0);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.egoDelegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.egoDelegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -Offset && scrollView.contentOffset.y < self.inset.top && !_loading) {
			[self setStates:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -Offset && !_loading) {
			[self setStates:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = self.inset;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.egoDelegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.egoDelegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - Offset && !_loading) {
		
		if ([self.egoDelegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[self.egoDelegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setStates:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(self.inset.top+60.0, 0, 0, 0);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [self setStates:EGOOPullRefreshNormal];
    
    [UIView animateWithDuration:.3 animations:^{
        scrollView.contentInset = self.inset;
    } completion:^(BOOL finished) {
        scrollView.contentInset = self.inset;
    }];
    
	[_gifView stopGif];
}

#pragma mark - gif



#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
	self.egoDelegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    //[super dealloc];
}


@end
