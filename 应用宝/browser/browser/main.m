
//
//  main.m
//  browser
//
//  Created by 毅 王 on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IphoneAppDelegate.h"

//int main(int argc, char *argv[])
//{
//    @autoreleasepool {
//        
////        NSLog(@"模块地址:%@", [NSString stringWithCString:(char*)argv[0] encoding:NSUTF8StringEncoding]);
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([IphoneAppDelegate class]));
//    }
//    
//}
typedef int (*PYStdWriter)(void *, const char *, int);
static PYStdWriter _oldStdWrite;


int __pyStderrWrite(void *inFD, const char *buffer, int size)
{
    if ( strncmp(buffer, "AssertMacros:", 13) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}

int main(int argc, char * argv[])
{
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([IphoneAppDelegate class]));
    }
}
