//
//  MyVerifyDataValid.m
//  MyHelper
//
//  Created by liguiyang on 14-12-29.
//  Copyright (c) 2014年 myHelper. All rights reserved.
//

#import "MyVerifyDataValid.h"

@interface MyVerifyDataValid ()

// 内部调用方法
- (BOOL)verifyAppArray:(id)dataArray; // 检测应用数据是否有误
- (BOOL)verifyFlagDic:(id)dataDic; // 检测服务器返回的falg字典

@end

@implementation MyVerifyDataValid

+ (instancetype)instance
{
    static MyVerifyDataValid *myVerifyDataValid = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myVerifyDataValid = [[MyVerifyDataValid alloc] init];
    });
    
    return myVerifyDataValid;
}

#pragma mark verify data valid

- (BOOL)verifySelfUpdateInfoData:(NSDictionary *)dataDic
{ // 自更新数据检测
    BOOL isValidFlag = NO;
    
    NSDictionary *updateDic = [dataDic objectForKey:@"data"];
    NSDictionary *appInfoDic = [updateDic objectForKey:@"appinfo"];
    if (IS_NSSTRING([updateDic objectForKey:@"forcedupgrade"]) &&
        IS_NSSTRING([updateDic objectForKey:@"selfupdatetype"]) &&
        IS_NSARRAY([updateDic objectForKey:@"upgradeinfo"]) &&
        IS_NSDICTIONARY(appInfoDic) &&
        IS_NSSTRING([appInfoDic objectForKey:@"appdigitalid"]) &&
        IS_NSSTRING([appInfoDic objectForKey:@"appversion"]) &&
        IS_NSSTRING([appInfoDic objectForKey:@"appid"]) &&
        IS_NSSTRING([appInfoDic objectForKey:@"plist"])) {
        isValidFlag = YES;
    }
    
    return isValidFlag;
}

- (BOOL)verifySearchAssociateWordsData:(NSDictionary *)dataDic
{ // 搜索联想词
    BOOL isValidFlag = YES;
    if (!IS_NSDICTIONARY(dataDic)) return NO;
    
    NSArray *dataArray = [dataDic objectForKey:@"data"];
    if (IS_NSARRAY(dataArray)) {
        for (NSDictionary *obj in dataArray) {
            if (IS_NSDICTIONARY(obj) &&
                [obj getNSStringObjectForKey:@"appname"] &&
                [obj getNSStringObjectForKey:@"appiconurl"]) {
            }
            else
            {
                isValidFlag = NO;
                break;
            }
        }
    }
    else
    {
        isValidFlag = NO; // 非数据
    }
    
    return isValidFlag;
}

- (BOOL)verifySearchHotWordsData:(NSArray *)dataArray;
{ // 搜索热词
    BOOL isValidFlag = YES;
    
    if (IS_NSARRAY(dataArray) && dataArray.count>=1) {
        for (NSString *hotWord in dataArray) {
            if (!IS_NSSTRING(hotWord) || hotWord.length<1) {
                isValidFlag = NO;
                break;
            }
        }
    }
    else
    {
        isValidFlag = NO; // 数据有误
    }
    
    return isValidFlag;
}

- (BOOL)verifySearchResultListData:(NSDictionary *)dataDic
{ // 搜索结果列表
    BOOL isValidFlag = NO;
    
    if (IS_NSDICTIONARY(dataDic) &&
        [self verifyAppArray:[dataDic objectForKey:@"data"]] &&
        [self verifyFlagDic:[dataDic objectForKey:@"flag"]]) {
        isValidFlag = YES;
    }
    
    return isValidFlag;
}

- (BOOL)verifySearchNoResultData:(NSDictionary *)dataDic
{
    BOOL isNullFlag = NO;
    
    if (IS_NSDICTIONARY(dataDic) &&
        IS_NSARRAY([dataDic objectForKey:@"data"])) {
        
        NSArray *obj = [dataDic objectForKey:@"data"];
        if (obj.count < 1) {
            isNullFlag = YES;
        }
    }
    
    return isNullFlag;
}

- (BOOL)verifyFindAppsData:(NSDictionary*)dataDic{
    BOOL isValidFlag = NO;
    
    if ([self verifyAppDic:dataDic]) {
        isValidFlag=YES;
    }
    return isValidFlag;
}

- (BOOL)verifyInstallEssentialData:(NSDictionary *)dataDic;
{
    //装机必备
    BOOL isValidFlag = NO;
    if (IS_NSDICTIONARY(dataDic) &&
        [self verifyAppArray:[dataDic objectForKey:@"data"]] &&
        [self verifyFlagDic:[dataDic objectForKey:@"flag"]]) {
        isValidFlag = YES;
    }
    return isValidFlag;
}

- (BOOL)verifyTopicData:(NSDictionary *)dataDic // 专题
{
    BOOL isValidFlag = NO;
    if (IS_NSDICTIONARY(dataDic) &&
        [self verifyTopicArray:[dataDic objectForKey:@"data"]] &&
        [self verifyFlagDic:[dataDic objectForKey:@"flag"]]) {
        isValidFlag = YES;
    }
    return isValidFlag;
}

#pragma mark - 轮播图
- (BOOL)checkLunboData:(NSDictionary *)lunboData {
    
    if (!IS_NSDICTIONARY(lunboData) || ![lunboData allKeys].count || ![self verifyFlagDic:[lunboData objectForKey:@"flag"]] || !IS_NSARRAY([lunboData objectForKey:@"data"])) return NO;
    
    NSArray *array = [lunboData objectForKey:@"data"];
    if (!array.count) return NO;
    
    for (id obj in array) {
        if (!IS_NSDICTIONARY(obj) || ![obj getNSStringObjectForKey:LUNBO_LINK]) return NO;
        
        NSString *typeStr = [obj objectForKey:LUNBO_LINK];
        
        if ([typeStr isEqualToString:@"app"]) {
            //应用
//            if (!IS_NSDICTIONARY([obj objectForKey:LUNBO_LINK_DETAIL])) return NO;
//            
//            NSDictionary *appDataDic = [obj objectForKey:LUNBO_LINK_DETAIL];
//            if (![self verifyAppDic:appDataDic]) return NO;
            
        }else if ([typeStr isEqualToString:@"article"]) {
            //文章
            if (!IS_NSDICTIONARY([obj objectForKey:LUNBO_LINK_DETAIL])) return NO;
            
            NSDictionary *articleDataDic = [obj objectForKey:LUNBO_LINK_DETAIL];
            if (![articleDataDic getNSStringObjectForKey:@"content_url"]) return NO;
//            if (![articleDataDic getNSStringObjectForKey:@"content_url"] || !IS_NSARRAY([articleDataDic objectForKey:@"apps"])) return NO;
//            
//            NSArray *array = [articleDataDic objectForKey:@"apps"];
//            if (!array.count) return NO;
//            
//            if (![self verifyAppArray:array]) return NO;
            
        }else if ([typeStr isEqualToString:@"mobileLink"]) {
            //外链
            if (![obj getNSStringObjectForKey:LUNBO_LINK_DETAIL]) return NO;
            
        }else if ([typeStr isEqualToString:@"special"]) {
            //专题
            if (!IS_NSDICTIONARY([obj objectForKey:LUNBO_LINK_DETAIL])) return NO;
            
            NSDictionary *specialDataDic = [obj objectForKey:LUNBO_LINK_DETAIL];
            if (![specialDataDic getNSStringObjectForKey:SPECIAL_ID]) return NO;
        }else if ([typeStr isEqualToString:@"safariLink"]) {
            //safar外链
            if (![obj getNSStringObjectForKey:LUNBO_LINK_DETAIL]) return NO;
        }
    }
   
    
    return YES;
}

#pragma mark - 精选
- (BOOL)checkChoiceData:(NSDictionary *)totaldata {
    
    if (!IS_NSDICTIONARY(totaldata) || ![totaldata allKeys].count || ![self verifyFlagDic:[totaldata objectForKey:@"flag"]]) return NO;
    
    NSDictionary *dic = [totaldata objectForKey:@"data"];
    
    //是字典 && 字典项大于等于5
    if (!IS_NSDICTIONARY(dic) || [dic allKeys].count < 5) return NO;
    
    
    //字典里取LIMITEDFREEAPPS 是数组 && 数组不为空
    if (!IS_NSARRAY([dic objectForKey:LIMITEDFREEAPPS]) || ![[dic objectForKey:LIMITEDFREEAPPS] count]) return NO;
    
    NSArray * array = [dic objectForKey:LIMITEDFREEAPPS];
    if (!array.count) return NO;
    
    if (![self verifyAppArray:array]) return NO;
    
    //字典里取FREEAPPS 是数组 && 数组不为空
    if (!IS_NSARRAY([dic objectForKey:FREEAPPS]) || ![[dic objectForKey:FREEAPPS] count]) return NO;
    
    array = [dic objectForKey:FREEAPPS];
    if (!array.count) return NO;
    
    if (![self verifyAppArray:array]) return NO;
    
    //字典里取CHARGEAPPS 是数组 && 数组不为空
    if (!IS_NSARRAY([dic objectForKey:CHARGEAPPS]) || ![[dic objectForKey:CHARGEAPPS] count]) return NO;
    
    array = [dic objectForKey:CHARGEAPPS];
    if (!array.count) return NO;
    
    if (![self verifyAppArray:array]) return NO;
    
    //字典里取RECOMMENDAPPS 是数组 && 数组数>27
    if (!IS_NSARRAY([dic objectForKey:RECOMMENDAPPS])) return NO;
    
    array = [dic objectForKey:RECOMMENDAPPS];
//    if (array.count<56) return NO;
    
    if (![self verifyAppArray:array]) return NO;
    
    
    //字典里取SPECIALS 是数组 && 数组数>4
    if (!IS_NSARRAY([dic objectForKey:SPECIALS]) || [[dic objectForKey:SPECIALS] count] < 1) return NO;
    
    array = [dic objectForKey:SPECIALS];
    if (array.count<1) return NO;
    
//    for (id obj in array) {
//        if (!IS_NSDICTIONARY(obj)) return NO;
//        
////        if (![obj getNSStringObjectForKey:SPECIAL_ID] || !IS_NSARRAY([obj objectForKey:@"display_appinfo"]) || ![[obj objectForKey:@"display_appinfo"] count]) return NO;
//        
//        NSArray *array1 = [obj objectForKey:@"display_app_info"];
//        if (!array1.count) return NO;
//        
//        for (id obj1 in array1) {
//            if (!IS_NSDICTIONARY(obj1)) return NO;
//            
//            if (![obj1 getNSStringObjectForKey:APPNAME] || ![obj1 getNSStringObjectForKey:APPICONURL]) return NO;
//        }
//        
//    }
    
    return YES;
}

#pragma mark - 专题详情
- (BOOL)checkSpecialDetails:(NSDictionary *)dataDic {
    if (!IS_NSDICTIONARY(dataDic) || ![dataDic allKeys].count || ![self verifyFlagDic:[dataDic objectForKey:@"flag"]]) return NO;
    
    NSDictionary *dic = [dataDic objectForKey:@"data"];
    
    if (!IS_NSDICTIONARY(dic) || ![dic getNSStringObjectForKey:TITLE] || ![dic getNSStringObjectForKey:INTRODUCE] || ![dic getNSStringObjectForKey:BANNER] || !IS_NSARRAY([dic objectForKey:@"apps"])) return NO;
    
    NSArray *array = [dic objectForKey:@"apps"];
    if (!array.count) return NO;
    
    if (![self verifyAppArray:array]) return NO;
    
    return YES;
}

#pragma mark 内部调用方法（public）

//专题检测
- (BOOL)verifyTopicArray:(id)dataArray
{ // 应用列表数组
    if (dataArray == nil) return NO;
    
    BOOL isValidFlag = YES;
    
    if (IS_NSARRAY(dataArray) && ((NSArray*)dataArray).count>=1)
    {
        for (id obj in dataArray) {
            if (![self verifyTopicDic:obj]) {
                isValidFlag = NO; //字典字段数据
                break;
            }
        }
    }
    else
    {
        isValidFlag = NO; // 非数组或数组=nil
    }
    
    return isValidFlag;
}


- (BOOL)verifyAppArray:(id)dataArray
{ // 应用列表数组
    if (dataArray == nil) return NO;
    
    BOOL isValidFlag = YES;
    
    if (IS_NSARRAY(dataArray) && ((NSArray*)dataArray).count>=1)
    {
        for (id obj in dataArray) {
            if (![self verifyAppDic:obj]) {
                isValidFlag = NO; //字典字段数据
                break;
            }
        }
    }
    else
    {
        isValidFlag = NO; // 非数组或数组=nil
    }
    
    return isValidFlag;
}

- (BOOL)verifyFlagDic:(id)dataDic
{ // flag字典
    BOOL isValidFlag = NO;
    
    if (dataDic == nil) return NO;
    if (IS_NSDICTIONARY(dataDic) &&
        [dataDic getNSStringObjectForKey:@"dataend"] &&
        [dataDic getNSStringObjectForKey:@"expire"] &&
        [dataDic getNSStringObjectForKey:@"md5"]) {
        isValidFlag = YES;
    }
    
    return isValidFlag;
}

- (BOOL)verifyTopicDic:(id)obj
{ // 是否是一个有效的app字典
    if (IS_NSDICTIONARY(obj) &&
        [obj getNSStringObjectForKey:BANNER] &&
        [obj getNSStringObjectForKey:CREAT_TIME] &&
        [obj getNSStringObjectForKey:TOPIC_ID] &&
        [obj getNSStringObjectForKey:INTRODUCE] &&
        [obj getNSStringObjectForKey:APPCOUNT]&&
        [obj getNSStringObjectForKey:TITLE])
    {     
        return YES;
    }
    
    return NO;
}

- (BOOL)verifyAppDic:(id)obj
{ // 是否是一个有效的app字典
    if (IS_NSDICTIONARY(obj)){
        if([obj getNSStringObjectForKey:APPDIGITALID] &&
        [obj getNSStringObjectForKey:APPID] &&
        [obj getNSStringObjectForKey:APPSIZE_MY] &&
        [obj getNSStringObjectForKey:APPNAME] &&
        [obj getNSStringObjectForKey:APPVERSION] &&
        [obj getNSStringObjectForKey:APPDISPLAYVER] &&
        [obj getNSStringObjectForKey:APPUPDATETIME] &&
        [obj getNSStringObjectForKey:PLIST] &&
        [obj getNSStringObjectForKey:APPICONURL] &&
        [obj getNSStringObjectForKey:APPREPUTATION] &&
        [obj getNSStringObjectForKey:CATEGORY] &&
        [obj getNSStringObjectForKey:APPDOWNCOUNT] &&
        [obj getNSStringObjectForKey:APPINTRO] &&
        [obj getNSStringObjectForKey:IPADETAILINFOR] &&
        [obj getNSStringObjectForKey:APPMINOSVER] &&
        [obj getNSStringObjectForKey:APPOMSERTTIME] &&
        [obj getNSStringObjectForKey:APPPRICE] &&
        [obj getNSStringObjectForKey:INSTALLTYPE]) {
            
            return YES;
        }
    }
    
    return NO;
}

@end
