//
//  PCServer.m
//  PCServer
//
//  Created by liull on 14-3-4.
//  Copyright (c) 2014年 taig. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "PCServer.h"
#import "GCDAsyncSocket.h"


//接收数据长度
#define RECV_DATA_LENGTH_TAG        100
#define RECV_DATA_TAG               101
//发送数据长度
#define SEND_DATA_LENGTH_TAG        102
#define SEND_DATA_TAG               103



//PrivateAPI
@interface PCServer ( ) <GCDAsyncSocketDelegate>
//socket服务
@property (nonatomic, strong) GCDAsyncSocket   *listenSocket;
@property (nonatomic, strong) GCDAsyncSocket   *mySocket;
//接收的客户端连接
@property (nonatomic, strong) NSMutableArray   *connectedSockets;
@property (nonatomic, assign) BOOL               isRunning;

#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic) dispatch_queue_t socketQueue;
#else
@property (assign, nonatomic) dispatch_queue_t socketQueue;
#endif

@end


@implementation PCServer

@synthesize listenSocket;
@synthesize connectedSockets;
@synthesize isRunning;
@synthesize socketQueue;


@synthesize serverDelegate;


-(void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
    /*原因就是  对于最低sdk版本>=ios6.0来说,GCD对象已经纳入了ARC的管理范围,我们就不需要再手工调用 dispatch_release了,否则的话,在sdk<6.0的时候,即使我们开启了ARC,这个宏OS_OBJECT_USE_OBJC 也是没有的,也就是说这个时候,GCD对象还必须得自己管理
     */
#if !OS_OBJECT_USE_OBJC   //这个宏是在sdk6.0之后才有的,如果是之前的,则OS_OBJECT_USE_OBJC为0
    dispatch_release(self.socketQueue);
#endif
}

-(id)init {
    
    if( self = [super init] ) {
        
        // Setup our socket.
		// The socket will invoke our delegate methods using the usual delegate paradigm.
		// However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
		//
		// Now we can configure the delegate dispatch queues however we want.
		// We could simply use the main dispatc queue, so the delegate methods are invoked on the main thread.
		// Or we could use a dedicated dispatch queue, which could be helpful if we were doing a lot of processing.
		//
		// The best approach for your application will depend upon convenience, requirements and performance.
		
        self.socketQueue      = dispatch_queue_create("socketQueue", NULL);
		
        self.listenSocket     = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
		
		// 存储接收的客户端连接
        self.connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
		
        self.isRunning        = NO;
        
        self.mySocket = [[GCDAsyncSocket alloc] init];
        // 返还消息通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(respondMessage:)
                                                     name:@"respondMessage"
                                                   object:nil];
    }
    
    return self;
}

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

//启动服务
-(void)start:(NSInteger)port {
    
    if( self.isRunning ) {
        return ;
    }
    
    NSError *error = nil;
    if(![self.listenSocket acceptOnPort:9000 error:&error]){
        return;
    }
    
    [self.listenSocket performBlock:^{
        [self.listenSocket enableBackgroundingOnSocket];
    }];
    
    
    NSLog(@"Echo server started on port %hu", [listenSocket localPort]);
    
    isRunning = YES;
}


//停止服务
-(void)stop {
    
    if(!self.isRunning) {
        return ;
    }
    
    // Stop accepting connections
    [listenSocket disconnect];
    
    // Stop any client connections
    @synchronized(connectedSockets)
    {
        NSUInteger i;
        for (i = 0; i < [connectedSockets count]; i++)
        {
            // Call disconnect on the socket,
            // which will invoke the socketDidDisconnect: method,
            // which will remove the socket from the list.
            [[connectedSockets objectAtIndex:i] disconnect];
        }
    }
    
    NSLog(@"Stopped Echo server");
    self.isRunning = NO;
}


//该方法在socketQueue中执行，非主线程
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	// This method is executed on the socketQueue (not the main thread)
	@synchronized(connectedSockets)
	{
		[connectedSockets addObject:newSocket];
	}
	
	NSString *host = [newSocket connectedHost];
	UInt16 port = [newSocket connectedPort];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		@autoreleasepool {
			NSLog(@"Accepted client %@:%hu", host, port);
	        
            if( [self.serverDelegate respondsToSelector:@selector(onPCConnected)] ) {
                [self.serverDelegate onPCConnected];
            }
        }
	});
    
    
    //获取消息的头部
    [newSocket readDataToLength:sizeof(int32_t) withTimeout:-1 tag:RECV_DATA_LENGTH_TAG];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"传值前：%@ %@",self.mySocket,sock);
    
    self.mySocket = sock;
    
	// This method is executed on the socketQueue (not the main thread)
    if(tag == RECV_DATA_LENGTH_TAG) {
        
        assert( data.length == 4 );
        
        //接收消息Payload
        int32_t datalength = *(int32_t *)[data bytes];
        [sock readDataToLength:datalength withTimeout:-1 tag:RECV_DATA_TAG];
        
        NSLog(@"will data length=%d", datalength);
        
    }else if(tag == RECV_DATA_TAG){
        
        //接收Payload完毕
        NSPropertyListFormat format;
        NSError * error = nil;
        NSMutableDictionary * propertyList = [NSPropertyListSerialization propertyListWithData:data
                                                                                       options:NSPropertyListMutableContainersAndLeaves
                                                                                        format:&format
                                                                                         error:&error];
        NSLog(@"接收\r\n%@" , propertyList);
        
        BOOL bRet = FALSE;
        //通知上层，收到消息了
        if( [self.serverDelegate respondsToSelector:@selector(onRecvPCCommand:)] ) {
            bRet = [self.serverDelegate onRecvPCCommand:propertyList];
        }
        
//        //回应消息
//        //NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:bRet], @"result", nil];
//        NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:propertyList, @"NameArray",[NSNumber numberWithBool:bRet], @"result", nil];
//        NSData * data = [NSPropertyListSerialization dataWithPropertyList:dic format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
//        int32_t length = data.length;
//        NSData * header = [NSData dataWithBytes:&length length:sizeof(int32_t)];
//        [sock writeData:header withTimeout:-1 tag:SEND_DATA_LENGTH_TAG];
//        [sock writeData:data withTimeout:-1 tag:SEND_DATA_TAG];
    }
}
//回应消息
- (void)respondMessage:(NSNotification *)note
{
    NSDictionary *dic = (NSDictionary *)[note object];
    //NSLog(@"传值后：%@",self.mySocket);
    NSLog(@"发给PC回应%@",dic);
    NSData * data = [NSPropertyListSerialization dataWithPropertyList:dic format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    int32_t length = data.length;
    NSData * header = [NSData dataWithBytes:&length length:sizeof(int32_t)];
    [self.mySocket writeData:header withTimeout:-1 tag:SEND_DATA_LENGTH_TAG];
    [self.mySocket writeData:data withTimeout:-1 tag:SEND_DATA_TAG];
}
/**
 * This method is called if a read has timed out.
 * It allows us to optionally extend the timeout.
 * We use this method to issue a warning to the user prior to disconnecting them.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    //	if (elapsed <= READ_TIMEOUT)
    //	{
    //		NSString *warningMsg = @"Are you still there?\r\n";
    //		NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
    //
    //		[sock writeData:warningData withTimeout:-1 tag:WARNING_MSG];
    //
    //		return READ_TIMEOUT_EXTENSION;
    //	}
	return 0.0;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	// This method is executed on the socketQueue (not the main thread)
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	if (sock != self.listenSocket)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			@autoreleasepool {
				NSLog(@"Client Disconnected");
                
                if( [self.serverDelegate respondsToSelector:@selector(onPCDisConnected)] ) {
                    [self.serverDelegate onPCDisConnected];
                }
			}
		});
		
		@synchronized(self.connectedSockets)
		{
			[self.connectedSockets removeObject:sock];
		}
	}
}

@end
