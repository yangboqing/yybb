//
//  PCServer.h
//  PCServer
//
//  Created by liull on 14-3-4.
//  Copyright (c) 2014年 taig. All rights reserved.
//



#import <Foundation/Foundation.h>



@protocol PCServerDelegate <NSObject>


//PC端的链接通知
-(void)onPCConnected;
//PC端断开链接通知
-(void)onPCDisConnected;


//接收到PC端数据
//返回值: 执行客户端命令的结果
//说明: 函数返回后底层会给PC端回应命令执行的结果
-(BOOL)onRecvPCCommand:(NSDictionary*)cmd;

@end



@interface PCServer : NSObject

@property(nonatomic, weak) id<PCServerDelegate> serverDelegate;

-(id)init;

//启动服务
-(void)start:(NSInteger)port;
//停止服务
-(void)stop;



@end
