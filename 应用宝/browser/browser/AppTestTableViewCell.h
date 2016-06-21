//
//  AppTestTableViewCell.h
//  browser
//
//  Created by caohechun on 14-4-17.
//
//

#import <UIKit/UIKit.h>

@interface AppTestTableViewCell : UITableViewCell{
    @public
    UIImageView *preView;
}
- (void)setTestImage:(UIImage *)image;
- (void)setTestCellDetail:(NSDictionary *)dic;
- (UIImage *)getTestImage;
- (NSDictionary *)getTestCellDetail;
@property (nonatomic,retain)NSString *detailURLString;
@end
