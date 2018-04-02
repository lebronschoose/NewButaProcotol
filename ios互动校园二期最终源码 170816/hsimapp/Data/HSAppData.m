//
//  HSAppData.m
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "HSAppData.h"
#include <netdb.h>

#include <sys/socket.h>

#include <arpa/inet.h>

@implementation HSAppData

+(void)clearUserInfo
{
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DYH_LOGINIP];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DYH_CHECKCODE];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DYH_IMIP];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DYH_IMPORT];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)setTestMode:(BOOL)isTest
{
    [[NSUserDefaults standardUserDefaults] setBool:isTest forKey:@"isTestMode"];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getTestMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isTestMode"];
}

+(void)setMuteSound:(BOOL)isMute
{
    [[NSUserDefaults standardUserDefaults] setBool:isMute forKey:@"isMuteSound"];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getMuteSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isMuteSound"];
}

+(void)setAccount:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:DYH_ACCOUNT];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getAccount
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_ACCOUNT];
    return result;
}

+(void)setDomain:(NSString *)domain
{
    [[NSUserDefaults standardUserDefaults] setObject:domain forKey:DYH_DOMAIN];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getDomain
{
    NSString *result = @"http://www.butaschool.com";
    return result;
}

+(void)setLoginServerIP:(NSString *)ip
{
    [[NSUserDefaults standardUserDefaults] setObject:ip forKey:DYH_LOGINIP];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLoginServerPort:(int)port
{
    [[NSUserDefaults standardUserDefaults] setInteger:port forKey:DYH_LOGINPORT];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setIMServerIP:(NSString *)ip
{
    [[NSUserDefaults standardUserDefaults] setObject:ip forKey:DYH_IMIP];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setCheckCode:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:DYH_CHECKCODE];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getCheckCode
{
//    return @"13000000004";
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_CHECKCODE];
    return result;
}

+(void)setToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DYH_TOKEN];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getToken
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_TOKEN];
    return result;
}
+(void)setIMServerPort:(int)port
{
    [[NSUserDefaults standardUserDefaults] setInteger:port forKey:DYH_IMPORT];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setChatImageSize:(int)s
{
    [[NSUserDefaults standardUserDefaults] setInteger:s forKey:@"chatmsgimagesize"];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getChatImageSize
{
    NSInteger s = [[NSUserDefaults standardUserDefaults] integerForKey:@"chatmsgimagesize"];
    return (int)s;
}

+(NSString *)getLoginServerIP
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_LOGINIP];
    return result;
}

+(void)setHelpDic:(NSDictionary *)helpDic
{
    [[NSUserDefaults standardUserDefaults] setObject:helpDic forKey:DYH_helpdic];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)gethelpDic
{
    NSDictionary *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_helpdic];
    return result;
}

+ (void)setClassid:(int)classid
{
    [[NSUserDefaults standardUserDefaults] setInteger:classid forKey:DYH_CLASSID];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)getClassid
{
    NSInteger classid = [[NSUserDefaults standardUserDefaults] integerForKey:DYH_CLASSID];
    return (int)classid;
}

+(int)getLoginServerPort
{
    NSInteger iPort = [[NSUserDefaults standardUserDefaults] integerForKey:DYH_LOGINPORT];
    return (int)iPort;
}

+(NSString *)getIMServerIP
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_IMIP];
    return result;
}

+(int)getIMServerPort
{
    NSInteger iPort = [[NSUserDefaults standardUserDefaults] integerForKey:DYH_IMPORT];
    return (int)iPort;
}

////


/*******************************************************************************************
 Syntax
 void FirstLetter(int nCode, CString& strLetter)
 Remarks:
 Get the first letter of pinyin according to specified Chinese character code.
 Parameters:
 nCode         - the code of the chinese character.
 strLetter      - a CString object that is to receive the string of the first letter.
 Return Values:
 None.
 Author:
 lixiaosan
 Create Date:
 05-26-2006
 *******************************************************************************************/
+(int)FirstLetter:(int)nCode
{
	if(nCode >= 1601 && nCode < 1637) return 1;//strLetter = _T("A");
	if(nCode >= 1637 && nCode < 1833) return 2;//strLetter = _T("B");
	if(nCode >= 1833 && nCode < 2078) return 3;//strLetter = _T("C");
	if(nCode >= 2078 && nCode < 2274) return 4;//strLetter = _T("D");
	if(nCode >= 2274 && nCode < 2302) return 5;//strLetter = _T("E");
	if(nCode >= 2302 && nCode < 2433) return 6;//strLetter = _T("F");
	if(nCode >= 2433 && nCode < 2594) return 7;//strLetter = _T("G");
	if(nCode >= 2594 && nCode < 2787) return 8;//strLetter = _T("H");
	if(nCode >= 2787 && nCode < 3106) return 10;//strLetter = _T("J");
	if(nCode >= 3106 && nCode < 3212) return 11;//strLetter = _T("K");
	if(nCode >= 3212 && nCode < 3472) return 12;//strLetter = _T("L");
	if(nCode >= 3472 && nCode < 3635) return 13;//strLetter = _T("M");
	if(nCode >= 3635 && nCode < 3722) return 14;//strLetter = _T("N");
	if(nCode >= 3722 && nCode < 3730) return 15;//strLetter = _T("O");
	if(nCode >= 3730 && nCode < 3858) return 16;//strLetter = _T("P");
	if(nCode >= 3858 && nCode < 4027) return 17;//strLetter = _T("Q");
	if(nCode >= 4027 && nCode < 4086) return 18;//strLetter = _T("R");
	if(nCode >= 4086 && nCode < 4390) return 19;//strLetter = _T("S");
	if(nCode >= 4390 && nCode < 4558) return 20;//strLetter = _T("T");
	if(nCode >= 4558 && nCode < 4684) return 23;//strLetter = _T("W");
	if(nCode >= 4684 && nCode < 4925) return 24;//strLetter = _T("X");
	if(nCode >= 4925 && nCode < 5249) return 25;//strLetter = _T("Y");
	if(nCode >= 5249 && nCode < 5590) return 26;//strLetter = _T("Z");
    return 0;
}
/*******************************************************************************************
 Syntax
 GetFirstLetter(CString strName, CString& strFirstLetter)
 Remarks:
 Get the first letter of pinyin according to specified Chinese character.
 Parameters:
 strName            - a CString object that is to be parsed.
 strFirstLetter     - a CString object that is to receive the string of the first letter.
 Return Values:
 None.
 Author:
 lixiaosan
 Create Date:
 05-26-2006
 *******************************************************************************************/
+(int)GetFirstLetter:(char *)szName
{
    if(strlen(szName) <= 0) return 0;
    if(szName[0] >= 'a' && szName[0] <= 'z') return (int)(szName[0] - 'a' + 1);
    else if(szName[0] >= 'A' && szName[0] <= 'Z') return (int)(szName[0] - 'A' + 1);
    else if(((unsigned char)szName[0]) < 0x80) return 0;
    if(strlen(szName) < 2) return 0;
    
	unsigned char ucHigh, ucLow;
    ucHigh = (unsigned char)szName[0];
    ucLow = (unsigned char)szName[1];
    if(ucHigh < 0xa1 || ucLow < 0xa1) return 0;
    else
    {
        // Treat code by section-position as an int type parameter,
        // so make following change to nCode.
        int nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
		return [HSAppData FirstLetter:nCode];
    }
}

+(NSString *)getNewLoginServerIP
{
   NSString * string =  [self getIPAddressByHostName:NewDomainForlogin];
    return string;
}


+(NSString*)getIPAddressByHostName:(NSString*)strHostName
{
    const char* szname = [strHostName UTF8String];
    struct hostent* phot ;
    @try
    {
        phot = gethostbyname(szname);
    }
    @catch (NSException * e)
    {
        return nil;
    }
    
    struct in_addr ip_addr;
    //h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    memcpy(&ip_addr,phot->h_addr_list[0],4);
    
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

@end

