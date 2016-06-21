//
//  SSLServer.h
//  HttpsWebServer
//
//  Created by liull on 14-6-3.
//  Copyright (c) 2014年 taig. All rights reserved.
//

#import <Foundation/Foundation.h>


//
#define HTTPS_SERVER_REQUEST_PLIST_OK_NOTIFICATION     @"HTTPS_SERVER_REQUEST_PLIST_OK_NOTIFICATION"

#define HTTPS_NEED_RESTART_SERVER  @"ssl_need_restart_server"

@interface SSLServer : NSObject

@property(strong) NSString* basePath;

-(int)start:(NSInteger)port;
-(void)stop;

@end
