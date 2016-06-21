//
//  ResourceHomePageViewController.h
//  browser
//
//  Created by 王 毅 on 13-6-3.
//
//

#import <UIKit/UIKit.h>
#import "UITextFieldEx.h"
#import <QuartzCore/QuartzCore.h>
#import "MoreManageViewController.h" // 更多页面
#import "ResourceHomeBottom.h"
#import "DownLoadManageViewController.h"
#import "SearchViewController.h"
#import "FindViewController.h" // 发现页面
#import "FindDetailViewController.h"
#import "AdvisePageView.h"
#import "MLNavigationController.h"
#define HOME_FLAG @"homeFlag"
#define SEARCH_FALG @"searchFlag"
#define DOWNLOAD_FLAG @"downloadFlag"
#define UPDATA_FLAG @"updataFlag" //发现
#define MORE_FLAG @"moreFlag" // 更多
#define BOTTOM_FLAG @"bottomFlag"

@protocol RHomePageMainVCDelegate <NSObject>

- (void)AlertPopvpView:(DOWNLOAD_STATUS)status distriPlist:(NSString *)distriPlist;

@end


@interface ResourceHomePageViewController : UIViewController<UIAlertViewDelegate,
ResourceHomeBottomDelegate,
UIActionSheetDelegate,
AdvisePageViewDelegate,
NavDelegate>{
    
    
    MLNavigationController *moreNavController;
    //屏幕底部的按钮，自定义tabbar
    ResourceHomeBottom *resourceHomeBottom;
    
    
    UIImageView *bgTapImageView;
    
    //下载
    DownLoadManageViewController *downMangerViewController;
    MLNavigationController *downLoadNaViewController;
    //搜索
    SearchViewController *searchViewController;
    MLNavigationController *searchNaViewController;
    
    MLNavigationController *findNavController;
    //发现
    FindViewController  *findViewController;
    // 更多
    MoreManageViewController *moreManageVC;

}

typedef enum _PAGE_SHOW_STATUS{
    HOMEPAGE_SHOW,                        //快用市场
    SEARCHVIEW_SHOE,                      //搜索页面
    DOWNLOADPAGE_SHOW,                    //下载页
    UPDATAPAGE_SHOW,                       //更新页
    MOREMANAGE_SHOW                       // 更多页
}PAGE_SHOW_STATUS;

@property (nonatomic , weak) id<RHomePageMainVCDelegate>mainVCDelegate;
@property (nonatomic, retain) NSMutableDictionary * saveBottomFlagDictionary;
//webView
- (void)isCanNotUse:(BOOL)bl;
- (void)changeShowPage:(PAGE_SHOW_STATUS)showPage;
- (void)changeSelectToHomeFlag;
- (void)changeToHomeFlag;
- (void)setSaveBottomFlagKey:(NSString *)key Value:(NSString *)value;
- (void)startUpdata;
- (void)show3GFreeFlowView;// 显示3G免流
- (void)openMoreSettingPage;
@end

