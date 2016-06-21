//
//  MirrorViewController.h
//  MyHelper
//
//  Created by zhaolu  on 15-3-5.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MirrorViewController : UIViewController<UIPopoverControllerDelegate,UIAlertViewDelegate>
//check control properties
@property (nonatomic) BOOL isHiddenControls;

// AVFoundation Properties
@property (strong, nonatomic) AVCaptureSession * mySesh;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureDevice * myDevice;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;

// Photo/Capture Properties
@property (strong, nonatomic) UIView *imageStreamV;
@property (strong, nonatomic) UIImageView *capturedImageV;
@property (strong, nonatomic) UITapGestureRecognizer *mirrorTap;
@property (strong, nonatomic) UIPopoverController *sharePopoverController;
@property (strong, nonatomic)UIToolbar *toolBar;


@end
