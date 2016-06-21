//
//  NSDictionary+noNIL.m
//  browser
//
//  Created by liull on 14-5-19.
//
//

#import "NSDictionary+noNIL.h"

@implementation NSDictionary (noNIL)

-(id)objectNoNILForKey:(id)aKey {
    
    id ret = [self objectForKey:aKey];
    if(ret == nil){
//        NSLog(@"NSDictionary Exception: for Key :%@  NIL",aKey);
        return @"";
    }
    
    return ret;
}


-(NSString*)getNSStringObjectForKey:(id <NSCopying>)aKey {
    
    NSString* obj = [self objectForKey:aKey];
    if( IS_NSSTRING(obj) && obj.length > 0 ){
        return obj;
    }
    
//    NSLog(@"%@ 检测出错", aKey);
    return @"";
}
-(NSArray*)getNSArrayObjectForKey:(id <NSCopying>)aKey {
    NSArray* obj = [self objectForKey:aKey];
    if( IS_NSARRAY(obj) && obj.count > 0 ){
        return obj;
    }
//    NSLog(@"%@ 检测出错", aKey);
    return nil;
}

-(NSDictionary*)getNSDictionaryObjectForKey:(id <NSCopying>)aKey {
    NSDictionary* obj = [self objectForKey:aKey];
    if( IS_NSDICTIONARY(obj) && [obj allKeys].count > 0 ){
        return obj;
    }
//        NSLog(@"%@ 检测出错", aKey);
    return nil;
}

//判断是否为nil
-(NSNumber*)getNSNumberObjectForKey:(id <NSCopying>)aKey {
    
    NSNumber* obj = [self objectForKey:aKey];
    if(IS_NSNUMBER(obj) ){
        return obj;
    }
    
//    NSLog(@"%@ 检测出错", aKey);
    return nil;
}

@end



@implementation NSMutableDictionary (noNIL)

- (void)setObjectNoNIL:(id)anObject forKey:(id <NSCopying>)aKey {
    
    if( anObject == nil) {
        [self setObject:@"" forKey:aKey];
        return ;
    }
    
    return [self setObject:anObject forKey:aKey];
    
}

-(NSString*)getNSStringObjectForKey:(id <NSCopying>)aKey {
    
    NSString* obj = [self objectForKey:aKey];
    if( IS_NSSTRING(obj) && obj.length > 0 ){
        return obj;
    }
    
    return @"";
    
}
-(NSArray*)getNSArrayObjectForKey:(id <NSCopying>)aKey {
    NSArray* obj = [self objectForKey:aKey];
    if( IS_NSARRAY(obj) && obj.count > 0 ){
        return obj;
    }
    
    return nil;
}

-(NSDictionary*)getNSDictionaryObjectForKey:(id <NSCopying>)aKey {
    NSDictionary* obj = [self objectForKey:aKey];
    if( IS_NSDICTIONARY(obj) && [obj allKeys].count > 0 ){
        return obj;
    }
    
    return nil;
}




@end
