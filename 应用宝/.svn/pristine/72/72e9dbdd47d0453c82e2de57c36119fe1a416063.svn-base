//
//  LicenseAgreementView.m
//  browser
//
//  Created by liguiyang on 14-5-23.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "LicenseAgreementView.h"

@implementation LicenseAgreementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.frame = [UIScreen mainScreen].bounds;
        // interiorView
        licenseView = [[UITextView alloc] init];
        licenseView.text = [self getFreeflowAgreement];
        licenseView.editable = NO;
        if (IOS7) {
            licenseView.selectable = NO;
        }
        
        self.acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.acceptBtn setImage:[UIImage imageNamed:@"accept_license.png"] forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"accept_license.png" complete:^(UIImage *image) {
            [self.acceptBtn setImage:image forState:UIControlStateNormal];
        }];
        
        self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.rejectBtn setImage:[UIImage imageNamed:@"reject_license.png"] forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"reject_license.png" complete:^(UIImage *image) {
            [self.rejectBtn setImage:image forState:UIControlStateNormal];
        }];
        
        interiorView = [[UIImageView alloc] init];
        SET_IMAGE(interiorView.image, @"licenseBg.png");
        interiorView.userInteractionEnabled = YES;
        
        [interiorView addSubview:licenseView];
        [interiorView addSubview:_acceptBtn];
        [interiorView addSubview:_rejectBtn];
        [self addSubview:interiorView];
        
        // closeButton
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.closeBtn setImage:[UIImage imageNamed:@"close_license.png"] forState:UIControlStateNormal];
        [LocalImageManager setImageName:@"close_license.png" complete:^(UIImage *image) {
            [self.closeBtn setImage:image forState:UIControlStateNormal];
        }];
        
        [self addSubview:_closeBtn];
        
        [self.acceptBtn addTarget:self action:@selector(acceptLicenseAgreementClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rejectBtn addTarget:self action:@selector(rejectLicenseAgreementClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // set frame
        [self setCustomFrame];
        
    }
    return self;
}

#pragma mark - Action

-(void)closeButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_3GLICENSE object:@"NO"];
}

-(void)acceptLicenseAgreementClick:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"YES" forKey:ADMIT3GLICENSE];
    [userDefault synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_3GLICENSE object:@"NO"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_3GDOWNLOADVIEW object:nil];
}

-(void)rejectLicenseAgreementClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_3GLICENSE object:@"NO"];
}

#pragma mark - Utility

-(void)setCustomFrame
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat stateBarHeight = IOS7?20:0;
    interiorView.frame = CGRectMake(20, stateBarHeight+10, rect.size.width-40, rect.size.height-48-stateBarHeight);
    licenseView.frame = CGRectMake(10, 18, interiorView.frame.size.width-20, interiorView.frame.size.height-75);
    self.acceptBtn.frame = CGRectMake(10, interiorView.frame.size.height-45, 102, 35);
    self.rejectBtn.frame = CGRectMake(interiorView.frame.size.width-10-102, _acceptBtn.frame.origin.y, _acceptBtn.frame.size.width, _acceptBtn.frame.size.height);
    //
    self.closeBtn.frame = CGRectMake(interiorView.frame.origin.x+interiorView.frame.size.width-12, interiorView.frame.origin.y-12, 24, 24);
    
}

-(NSString *)getFreeflowAgreement
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"freeflowAgreement" ofType:@"txt"];
    NSString *agreement = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return  agreement;
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
