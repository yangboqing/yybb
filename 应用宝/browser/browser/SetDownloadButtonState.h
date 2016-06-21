//
//  SetDownloadButtonState.h
//  browser
//
//  Created by caohechun on 14-4-22.
//
//

#import <Foundation/Foundation.h>

@interface SetDownloadButtonState : NSObject
- (void)setDownloadButton:(UIButton *)targetButton
          withAppInforDic:(NSDictionary *)appInforDic
           andDetailSoure:(NSString *)detailSource
              andUserData:(id)userData;
@end
