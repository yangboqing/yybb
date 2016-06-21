//
//  NSDictionary+noNIL.h
//  browser
//
//  Created by liull on 14-5-19.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (noNIL)

-(id)objectNoNILForKey:(id)aKey;

//判断是否为nil
-(NSString*)getNSStringObjectForKey:(id <NSCopying>)aKey;
//判断是否为nil
-(NSArray*)getNSArrayObjectForKey:(id <NSCopying>)aKey;
//判断是否为nil
-(NSDictionary*)getNSDictionaryObjectForKey:(id <NSCopying>)aKey;

//判断是否为nil
-(NSNumber*)getNSNumberObjectForKey:(id <NSCopying>)aKey;

@end

@interface NSMutableDictionary (noNIL)

- (void)setObjectNoNIL:(id)anObject forKey:(id <NSCopying>)aKey;

//判断是否为nil
-(NSString*)getNSStringObjectForKey:(id <NSCopying>)aKey;
//判断是否为nil
-(NSArray*)getNSArrayObjectForKey:(id <NSCopying>)aKey;
//判断是否为nil
-(NSDictionary*)getNSDictionaryObjectForKey:(id <NSCopying>)aKey;

@end
