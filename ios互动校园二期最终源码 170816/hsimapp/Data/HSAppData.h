//
//  HSAppData.h
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

#define DYH_ACCOUNT                     @"saveAccount"
#define DYH_DOMAIN                      @"myWebDomain"
#define DYH_LOGINIP                     @"myLoginAddr"
#define DYH_LOGINPORT                   @"myLoginPort"
#define DYH_IMIP                        @"myIMAddr"
#define DYH_IMPORT                      @"myIMPort"
#define DYH_CHECKCODE                   @"myIMServerCheckCode"
#define DYH_TOKEN                       @"myToken"
#define DYH_CLASSID                     @"myclassid"
#define DYH_helpdic                     @"myhelpdic"

#define NewDomainForlogin                   @"appim.butaschool.com"


@interface HSAppData : NSObject

+(void)clearUserInfo;

+(void)setChatImageSize:(int)s;
+(int)getChatImageSize;

+ (void)setClassid:(int)classid;
+ (int)getClassid;

+(void)setTestMode:(BOOL)isTest;
+(BOOL)getTestMode;

+(void)setMuteSound:(BOOL)isMute;
+(BOOL)getMuteSound;

+(void)setAccount:(NSString *)account;
+(NSString *)getAccount;

+(void)setDomain:(NSString *)domain;
+(NSString *)getDomain;

+(void)setHelpDic:(NSDictionary *)helpDic;
+(NSDictionary *)gethelpDic;

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

+(void)setToken:(NSString *)token;
+(NSString *)getToken;

+(NSString *)getNewLoginServerIP;
@end
