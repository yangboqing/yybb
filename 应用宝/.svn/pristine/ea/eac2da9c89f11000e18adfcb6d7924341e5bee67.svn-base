//
//  AppStatusManage.m
//  browser
//
//  Created by liull on 14-6-30.
//
//

#import "AppStatusManage.h"
#import "BppDistriPlistManager.h"
#import "NSDictionary+noNIL.h"


@implementation AppStatusManage

+(AppStatusManage*)getObject{
    @synchronized(@"AppStatusManage") {
        static AppStatusManage *getObject = nil;
        if (getObject == nil){
            getObject = [[AppStatusManage alloc] init];
        }
        return getObject;
    }
}
- (id)init{
    if ( self=[super init] ) {
        gettingLock = [[NSLock alloc] init];
    }
    return self;
}



//获取应用的状态
-(DOWNLOAD_STATE) appStatus:(NSString*)appid appVersion:(NSString*)version {
    
    
    NSDictionary * itemInfo = [[BppDistriPlistManager getManager] ItemInfoInDownloadingByAttriName:DISTRI_APP_ID
                                                                                             value:appid];
    if(itemInfo) {
        if( [version isEqualToString: [itemInfo objectForKey:DISTRI_APP_VERSION]] ) {
            //在下载中，且版本一致
            return STATE_DOWNLONGING;
        }
    }
    
    
    
    itemInfo = [[BppDistriPlistManager getManager] ItemInfoInDownloadedByAttriName:DISTRI_APP_ID value:appid];
    if(itemInfo){
        if( [version isEqualToString: [itemInfo objectForKey:DISTRI_APP_VERSION]] ) {
            return STATE_INSTALL;
        }
    }
    
    return STATE_DOWNLOAD;
}



- (void)dealloc{
}

@end
