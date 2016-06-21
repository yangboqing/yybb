//
//  PhotosAlbumManager.h
//  browser
//
//  Created by mingzhi on 14-4-16.
//
//

#import <Foundation/Foundation.h>

@protocol SaveUtilDelegate <NSObject>
@optional

- (void)mediaItemCopiedIsSuccess:(BOOL)success andPath:(NSString *)path;//保存完一个

@end

typedef enum{
	VISIABLESTATE = 0, //可以访问
	REFUSESTATE, //已拒绝
	CHOOCESTATE, //还为设置
} ALBUMVISITSTATE;

@interface PhotosAlbumManager : NSObject

@property (nonatomic,weak) id<SaveUtilDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

- (ALBUMVISITSTATE)ifCanVisitTheAlbum;//判断相册是否可访问

- (void)saveImageToNewAlbum:(NSArray*)mediaArray AlbumName:(NSString *)albumname;//保存到创建相册

- (void)saveMediaToCameraRoll:(NSArray *)mediaArray;//保存到系统相册


@end
