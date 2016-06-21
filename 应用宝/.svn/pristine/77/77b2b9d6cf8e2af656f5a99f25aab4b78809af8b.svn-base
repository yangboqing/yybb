/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

@class SDWebImageManager;
@class UIImage;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(SDWebImageManager *)imageManager
                    url:(NSString*)url
     didFinishWithImage:(UIImage *)image;

- (void)webImageManager:(SDWebImageManager *)imageManager
                    url:(NSString*)url
       didFailWithError:(NSError *)error;

@end
