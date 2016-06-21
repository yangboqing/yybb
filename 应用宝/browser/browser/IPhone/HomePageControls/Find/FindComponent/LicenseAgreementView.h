//
//  LicenseAgreementView.h
//  browser
//
//  Created by liguiyang on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface LicenseAgreementView : UIView
{
    UIImageView *interiorView;
    UITextView *licenseView;
}
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *rejectBtn;

@end
