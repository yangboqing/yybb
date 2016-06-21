//
//  DESUtils.m
//  KY_PaySDK
//
//  Created by 呼啦呼啦圈 on 13-6-13.
//  Copyright (c) 2013年 吕冬剑. All rights reserved.
//

#import "DESUtils.h"
#import "GTMBASE64.h"
#include <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <AdSupport/ASIdentifierManager.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>



@implementation DESUtils

//+(DESUtils *)instance{
//    static DESUtils * instance = nil;
//    if(instance == nil){
//        instance = [[DESUtils alloc]init];
//    }
//    return instance;
//}

Byte iv1[] = {(Byte)0x12, (Byte)0x34, (Byte)0x56, (Byte)0x78, (Byte)0x90, (Byte)0xAB, (Byte)0xCD, (Byte)0xEF};
//Byte iv1[] = {1,2,3,4,5,6,7,8};

+ (NSString *) getIDFA{
   
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    
    if ([systemVersion hasPrefix:@"7"] || [systemVersion hasPrefix:@"6"]) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        return @"";
    }
}

+ (NSString *) macaddress{
    
    int mib[6];
    size_t len;
    char * buf = NULL;
    unsigned char * ptr = NULL;
    struct if_msghdr * ifm = NULL;
    struct sockaddr_dl * sdl = NULL;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = (char *)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        //        printf("Error: sysctl, take 2");
//        NSLog(@"Error: sysctl, take 2");
        free(buf);
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x-%02x-%02x-%02x-%02x-%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

//解密
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBASE64 decodeString:cipherText];
    
#define BUFFER_SIZE  1024*1024
    
    unsigned char * buffer = malloc(BUFFER_SIZE);
    memset(buffer, 0, BUFFER_SIZE);
    size_t numBytesDecrypted = 0;
    

    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          (const void *)iv1,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          BUFFER_SIZE,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    
    return plainText;
}

//加密
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char * buffer = (unsigned char *)malloc(1024*1024);
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          (const void *)iv1,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024*1024,
                                          &numBytesEncrypted);

    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBASE64 stringByEncodingData:dataTemp];
    }else{
//        NSLog(@"DES加密失败");
    }
    
    free(buffer);
    return plainText;
}

+ (NSString *)getMD5:(NSString *)str {

    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

+ (NSString *)getMD5Str:(NSDictionary *)map{
    NSMutableString *str = [NSMutableString string];
    
    
    NSArray * allKeys = [map allKeys];
    NSArray *allKey = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (int i = 0; i < allKey.count; i++) {
        
        NSString * key = [allKey objectAtIndex:i];
        NSString * value = [map objectForKey:key];
        [str appendFormat:@"%s%@=%@",(i == 0 ? "" : "&"),key,value];
    }
    return str;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}

+(BOOL)isExistFile:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    return [fileManager fileExistsAtPath:path isDirectory:&isDir];
}

+(NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv1,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:[GTMBASE64 encodeData:data] encoding:NSUTF8StringEncoding];
        
    }
    return ciphertext;
}
@end
