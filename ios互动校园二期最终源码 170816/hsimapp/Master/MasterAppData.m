//
//  MasterAppData.m
//  dyhAutoApp
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "MasterAppData.h"

@implementation MasterAppData


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
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_DOMAIN];
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
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_CHECKCODE];
    return result;
}

+(void)setIMServerPort:(int)port
{
    [[NSUserDefaults standardUserDefaults] setInteger:port forKey:DYH_IMPORT];
    //立刻保存信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getLoginServerIP
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:DYH_LOGINIP];
    return result;
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

@end
