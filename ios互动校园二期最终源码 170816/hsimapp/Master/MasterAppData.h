//
//  MasterAppData.h
//  dyhAutoApp
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DYH_ACCOUNT                     @"saveAccount"
#define DYH_DOMAIN                      @"myWebDomain"
#define DYH_LOGINIP                     @"myLoginAddr"
#define DYH_LOGINPORT                   @"myLoginPort"
#define DYH_IMIP                        @"myIMAddr"
#define DYH_IMPORT                      @"myIMPort"
#define DYH_CHECKCODE                   @"myIMServerCheckCode"

@interface MasterAppData : NSObject

+(void)clearUserInfo;

+(void)setTestMode:(BOOL)isTest;
+(BOOL)getTestMode;

+(void)setMuteSound:(BOOL)isMute;
+(BOOL)getMuteSound;

+(void)setAccount:(NSString *)account;
+(NSString *)getAccount;

+(void)setDomain:(NSString *)domain;
+(NSString *)getDomain;

+(void)setLoginServerIP:(NSString *)ip;
+(NSString *)getLoginServerIP;
+(void)setLoginServerPort:(int)port;
+(int)getLoginServerPort;

+(void)setIMServerIP:(NSString *)ip;
+(NSString *)getIMServerIP;
+(void)setIMServerPort:(int)port;
+(int)getIMServerPort;

+(void)setCheckCode:(NSString *)code;
+(NSString *)getCheckCode;

@end
