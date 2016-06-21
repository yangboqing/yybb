//
//  encryAppID.cpp
//  browser
//
//  Created by liull on 15-2-11.
//
//

#include "encryAppID.h"
#include "NSString+Hashing.h"
#import "GTMBASE64.h"


#include <string>
using namespace std;






//$password 暂定为：hXtgFEDzXXhT7cw7
#define APPIDCRYPT_PASSWORD "hXtgFEDzXXhT7cw7"
//标识
#define APPID_FLAG "|th9NHnPhrYCTvFh9|"
/**
 * 可逆的字符串加密函数
 * @param int $txtStream 待加密的字符串内容
 * @param int $password 加密密码
 * @return string 加密后的字符串
 */
string str_replace(string astrOldValue,string astrNewValue,string astrSrc)
{
    size_t lPos = astrSrc.find(astrOldValue);
    while (lPos != string::npos)
    {
        astrSrc.erase(lPos,astrOldValue.length());
        astrSrc.insert(lPos,astrNewValue);
        lPos = astrSrc.find(astrOldValue);
    }
    return astrSrc;
}

string enCrypt(string & txtStream,string & password)
{
    //混淆串，是base64加密结果中所有的字符集
    string lockstream = "stlDEF/ABCNO=Pyzghij-QRSTUwxkVWXYZ+abcdefIJK67nopqr89LMmGH012345uv";
    int lockLen = lockstream.length();
    
    string seed;
    seed += lockstream.at(rand()%lockLen);
    int ordseed = seed[0];
    
    //生成MD5后的密码
    
    //$password = md5($password);
    password = [[[[NSString stringWithUTF8String:password.c_str()] MD5Hash] lowercaseString] UTF8String];
    
    //开始对字符串加密
    // $txtStream = base64_encode($txtStream);
    //txtStream = CBase64::Encode((unsigned char*)txtStream.c_str(),txtStream.length());
    NSData* data = [GTMBASE64 encodeBytes:(unsigned char*)txtStream.c_str() length:txtStream.length()];
    txtStream = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] UTF8String];
    
    
    //$tmpStream = '';
    string tmpStream;
    int k = 0;
    for (int i=0; i<txtStream.length(); i++) {
        k = (k == password.length()) ? 0 : k;
        int j = (lockstream.find(txtStream[i]) + (int)password[k] + ordseed)%(lockLen);
        tmpStream += lockstream[j];
        k++;
    }
    tmpStream += seed;
    tmpStream = str_replace("/",".a",tmpStream);
    tmpStream = str_replace("=",".b",tmpStream);
    tmpStream = str_replace("+",".c",tmpStream);
    tmpStream = str_replace("-",".d",tmpStream);
    return tmpStream;
}

/**
 * 可逆的字符串解密函数
 * @param int $txtStream 待加密的字符串内容
 * @param int $password 解密密码
 * @return string 解密后的字符串
 */
string deCrypt(string & txtStream,string & password)
{
    //将base64的特殊字符，替换回来
    txtStream = str_replace(".a","/",txtStream);
    txtStream = str_replace(".b","=",txtStream);
    txtStream = str_replace(".c","+",txtStream);
    txtStream = str_replace(".d","-",txtStream);
    
    string seed;
    seed += txtStream.at(txtStream.length() - 1);
    int ordseed = seed[0];
    
    txtStream = txtStream.substr(0,txtStream.length() - 1);
    //加密混淆串
    string lockstream = "stlDEF/ABCNO=Pyzghij-QRSTUwxkVWXYZ+abcdefIJK67nopqr89LMmGH012345uv";
    int lockLen = lockstream.length();
    
    //生成MD5后的密码
    //password = CUIMD5::MD5(password.c_str(),password.length());
    password = [[[[NSString stringWithUTF8String:password.c_str()] MD5Hash] lowercaseString] UTF8String];
    
    string tmpStream;
    int k = 0;
    //将待加密字符串内容用混淆串内容替换
    for(int i=0; i<txtStream.length(); i++){
        //超过了password md5 字符串长度，从第一位重新开始
        k = (k == password.length()) ? 0 : k;
        //混淆字符替换算法，当前字符串在混淆串中的位置，减去md5相应混淆字符的ascii码位数，取余
        int j = lockstream.find(txtStream[i]) - (int)password[k] - ordseed;
        while(j < 0){
            j = j + (lockLen);
        }
        tmpStream += lockstream[j];
        k++;
    }
    
//    int liOutLen;
//    CBase64::ByteVector loData = CBase64::Decode(tmpStream.c_str(),tmpStream.length(), liOutLen);
//    string lstrRes = (const char*)loData.c_str();
    NSData* loData = [GTMBASE64 decodeString:[NSString stringWithUTF8String:tmpStream.c_str()]];
    NSString * t = [[NSString alloc] initWithData:loData encoding:NSUTF8StringEncoding];
    string lstrRes = t.length<=0? "" : [t UTF8String];
    
    return lstrRes;
}

//是否为加密后的appid验证
static bool enAppIDCheck(string astrAppID)
{
    for (int i = 0;i < astrAppID.length();++i)
    {
        if ((astrAppID[i]<='z'&&astrAppID[i]>='a')||
            (astrAppID[i]<='Z'&&astrAppID[i]>='A')||
            (astrAppID[i]<='9'&&astrAppID[i]>='0')||
            (astrAppID[i]=='.'))
        {//合格
            continue;
        }else
        {
            return false;
            break;
        }
    }
    return true;
}
//[bundleId]|th9NHnPhrYCTvFh9|[自增int]
//是否为解密后的appid验证
static bool deAppIDCheck(string astrAppID)
{
    size_t lPos = astrAppID.rfind(APPID_FLAG);
    if (lPos == string::npos)
    {//没有 特殊标识符
        return false;
    }
    lPos += strlen(APPID_FLAG);
    if (lPos >= astrAppID.length())
    {//没有数字
        return false;
    }
    
    for (int i = 0;i < astrAppID.length();++i)
    {
        if (i>=lPos)
        {//特殊标识符 后面必须全是 数字
            if ((astrAppID[i]<='9'&&astrAppID[i]>='0'))
            {//合格
                continue;
            }else
            {
                return false;
                break;
            }
        }else
        {//特殊标识符前必须 是 a-z A-Z 0-9 .-|
            if ((astrAppID[i]<='z'&&astrAppID[i]>='a')||
                (astrAppID[i]<='Z'&&astrAppID[i]>='A')||
                (astrAppID[i]<='9'&&astrAppID[i]>='0')||
                (astrAppID[i]=='.')||
                (astrAppID[i]=='-')||
                (astrAppID[i]=='|'))
            {//合格
                continue;
            }else
            {
                return false;
                break;
            }
        }
        
    }
    return true;
}



@implementation DecryAppID

//解密Appid
+(NSString*)DecryAppID:(NSString*)appid{
    
    string txtStream = [appid UTF8String];
    string password = APPIDCRYPT_PASSWORD;
    string ret = deCrypt(txtStream, password);
    
    return [NSString stringWithUTF8String:ret.c_str()];
}

//是否为加密后的appid验证
+(BOOL)enAppIDCheck:(NSString*)enAppid {
    
    string astrAppID = [enAppid UTF8String];
    return enAppIDCheck(astrAppID);
}

//是否为解密后的appid验证
+(BOOL)deAppIDCheck:(NSString*)enAppid {

    string astrAppID = [enAppid UTF8String];
    return deAppIDCheck(astrAppID);
}

//取得解密后的Appid 索引部分
+(NSInteger)getAppIDPart_Index:(NSString*)decAppID {
    NSString * ret=nil;
    NSRange range = [decAppID rangeOfString:@APPID_FLAG];
    if(range.location != NSNotFound){
        ret = [decAppID substringFromIndex:range.location + [@APPID_FLAG length]];
    }
    return [ret integerValue];
}

//取得解密后的Appid 伪AppID部分
+(NSString*)getAppIDPart_AppID:(NSString*)decAppID {
    NSString * ret=nil;
    NSRange range = [decAppID rangeOfString:@APPID_FLAG];
    if(range.location != NSNotFound){
        ret = [decAppID substringToIndex:range.location];
    }
    return ret;
}

+(NSString*)getBundlePesudoAppID{
    
    NSString * appID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *decAppID = [DecryAppID DecryAppID:appID];
    if(decAppID.length > 0 && [DecryAppID deAppIDCheck:decAppID]){
        //经过加密处理的Appid
        //NSInteger index = [DecryAppID getAppIDPart_Index:decAppID];
        appID = [DecryAppID getAppIDPart_AppID:decAppID];
    }
    
    return appID;
}

+(NSString*)getPseudoAppID:(NSString*)enAppID {

    NSString * appID = enAppID;
    NSString *decAppID = [DecryAppID DecryAppID:appID];
    if(decAppID.length > 0 && [DecryAppID deAppIDCheck:decAppID]){
        //经过加密处理的Appid
        //NSInteger index = [DecryAppID getAppIDPart_Index:decAppID];
        appID = [DecryAppID getAppIDPart_AppID:decAppID];
    }
    
    return appID;
}

@end





