//
//  DebugIFByIM.m
//  hsimapp
//
//  Created by dingding on 2018/3/27.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//
/*
 所有的请求都是基于IMNET
 使用的API 只有四个
 均由回调函数来 获取参数
 IMAccess  发送接入请求
 IMStart   连接IM服务器
 IMSendPackage  发送包内容
 IMStop     断开Socket连接
 */
#import "DebugIFByIM.h"

#define Debug_Access                     @"Debug_Access"
#define Debug_ConnectIM                  @"Debug_ConnectIM"
#define Debug_Login                      @"Debug_Login"
//#define Debug_                          @"myLoginPort"
//#define DYH_IMIP                        @"myIMAddr"
//#define DYH_IMPORT                      @"myIMPort"
//#define DYH_CHECKCODE                   @"myIMServerCheckCode"
//#define DYH_TOKEN                       @"myToken"
//#define DYH_CLASSID                     @"myclassid"
//#define DYH_helpdic                     @"myhelpdic"

@implementation DebugIFByIM

-(instancetype)init
{
    self = [super init];
    if (self) {
//        RegisterMsg(<#x#>, <#y#>)
    }
    return self;
}
/*
 接入请求
 */
-(void)ConnectAccec
{
  
}


@end
