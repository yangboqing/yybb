//
//  AppStatusManage.h
//  browser
//
//  Created by liull on 14-6-30.
//
//

#import <Foundation/Foundation.h>


//App 状态有变化(安装，未安装)
#define REFRESH_MOBILE_APP_LIST @"REFRESH_MOBILE_APP_LIST"



#define DESK_APPID                  @"deskappid"
#define DESK_APPVER                 @"deskappversion"
#define DESK_PATH                   @"deskpath"


typedef enum _DOWNLOAD_STATE{
    STATE_DOWNLOAD,     //下载        (本地没有安装，不在下载中和已下载)
    STATE_DOWNLONGING,  //下载中       在下载中列表
    STATE_INSTALL,      //安装         本地没有安装，在已下载列表中，且本地没有安装 同版本的
//STATE_INSTALLED,    //已安装       本地安装，但没有在下载列表中
    
    STATE_REINSTALL,    //重新安装      在已下载列表中, 且本地安装相同版本应用
    STATE_UPDATE        //更新         不在下载中和已下载，且本地程序版本号低
}DOWNLOAD_STATE;



@interface AppStatusManage : NSObject
{
    NSLock *  gettingLock;
}

+(AppStatusManage*)getObject;


//获取应用的状态
-(DOWNLOAD_STATE) appStatus:(NSString*)appid appVersion:(NSString*)version;


@end
