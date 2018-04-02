//
//  IMnetMethod.m
//  hsimapp
//
//  Created by dingding on 2018/3/15.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "IMnetMethod.h"
#import "IMNet.h"

void * voidtoken = nil;

@implementation IMnetMethod
{
    NSString * string;
}


+(IMnetMethod *)ShareInstance
{
    static dispatch_once_t predict;
    static IMnetMethod * shareMethods;
    
    dispatch_once(&predict, ^{
        shareMethods = [[IMnetMethod alloc]init];
    });
    return shareMethods;
    
}

- (void)getReturnPackFrom:(NSString *)PackString BY:(E_CMD )cmd
{

    UInt8 buff_str[1024 * 64];
    memcpy(buff_str,[PackString UTF8String], [PackString length]+1);
    int i = 0;
    i++;
    IMSendPackage(voidtoken, eTypeJSON, i, cmd, buff_str, PackString.length);
}


- (void)ConnectAccess:(NSString *)PackString
{
    UInt8 buff_str[1024];
    memcpy(buff_str,[PackString UTF8String], [PackString length]+1);
    NSString * ip = @"119.23.63.93";
    uint16_t port = 3331;
    IMAccess(buff_str, [PackString length], [ip UTF8String], port, &OnRcvPack);
}



-(BOOL)LoginByWithServer:(NSArray * )Server;
{
    for (int i = 0; i<Server.count; i++) {
        NSDictionary * dic = Server[i];
        NSString * ipstring = dic[@"addr"];
        NSNumber * port =  dic[@"port"];
        void * token = nil;
        token = IMStart([ipstring UTF8String], [port intValue], &OnRcvPack);
        if (token == nil) {
            NSLog(@"继续运行");
        }else
        {
            voidtoken = token;
            break;
        }
    }
    if (voidtoken == nil) {
        return NO;
    }
    return YES;
}

bool OnRcvPack(    // 返回 false时，终止流程，pvIMNet 就无效了。
               void*    pvIMNet,            // IMStart所返回的连接对象指针（接入服务的为NULL）
               E_Type    type,                // 包类型
               UINT16    sn,                    // 发送序号（用于诊错），由发送端生成
               E_CMD    cmd,                // 命令ID
               BODY    pBody,                // 消息体
               UINT16    uSize)
{
     switch (cmd) {
        case ImpAccessRsp:
        {
            NSString *str_From_buff = [NSString stringWithCString:(char*)pBody encoding:NSUTF8StringEncoding];
           
            NSDictionary * dic = [NSString dictionaryWithJsonString:str_From_buff];
           NSLog(@"接入请求返回内容 %@",dic);
            [HSAppData setCheckCode:dic[@"token"]];
            [HSAppData setAccount:dic[@"uid"]];
//            NSString * TokenStrig = dic[@"token"];
            
            NSArray * serverArr = dic[@"servers"];
            if ([[IMnetMethod ShareInstance] LoginByWithServer:serverArr]) {
                 PostMessage(@"GETACCECSOBJ", dic);
            }else
            {
                NSLog(@"接入错误");
            }
        }
             break;
         case ImpLoginRsp:
         {
             NSString *str_From_buff = [NSString stringWithCString:(char*)pBody encoding:NSUTF8StringEncoding];
             
             NSDictionary * dic = [NSString dictionaryWithJsonString:str_From_buff];
             NSLog(@"登陆成功返回内容 %@",dic);
//             NSLog(@"");
             [[IMnetMethod ShareInstance] BeginHeathBeatReq];
             // type ->0 基本不用 type 1->uid //可能为一个数组 可以请求多个人的数据 type 2 ->部门ID  3 -> 登录账号
//             NSArray * arr =
             NSString * jsonString = [NSString stringWithFormat:@"{\"type\":%d,\"account\":\"%@\"}",3,@"test_account9"];
             NSLog(@"accountUserJson is %@",jsonString);
             [[IMnetMethod ShareInstance] getReturnPackFrom:jsonString BY:ImpGetUserInfoReq];
             PostMessage(@"LoginSucessce", dic);
         }
            break;
             case ImpHeartbeatRsp:
         {
             NSString *str_From_buff = [NSString stringWithCString:(char*)pBody encoding:NSUTF8StringEncoding];
             NSLog(@"心跳连接str_From_buff is %@",str_From_buff);
             NSDictionary * dic = [NSString dictionaryWithJsonString:str_From_buff];
             NSLog(@"心跳连接返回内容 %@",dic);
             
         }
             break;
             case ImpGetUserInfoRsp:
         {
             NSString *str_From_buff = [NSString stringWithCString:(char*)pBody encoding:NSUTF8StringEncoding];
//             NSLog(@"心跳连接str_From_buff is %@",str_From_buff);
             NSDictionary * dic = [NSString dictionaryWithJsonString:str_From_buff];
             HSUserObject * user = [HSUserObject userFromDic:dic];
             PostMessage(@"UpdateUserInfo", user);
             NSLog(@"用户信息连接返回内容 %@",dic);

         }
             break;
        default:
            break;
    }
    
    return  true;
}

-(void)BeginHeathBeatReq
{
    int i = 100001;
    i++;
    NSString * dateString = [NSString stringWithFormat:@"{\"t\":%@}",[self getNowTimeTimestamp]];
     NSLog(@"datestring is %@",dateString);
    UInt8 buff_str[1024 * 64];
    memcpy(buff_str,[dateString UTF8String], [dateString length]+1);
    IMSendPackage(voidtoken, eTypeJSON, i, ImpHeartbeatReq, buff_str, dateString.length);
}

-(void)BeaginHeath:(id)sender
{
    int i = 100001;
    i++;
    NSString * dateString = [NSString stringWithFormat:@"{\"t\":%@}",[self getNowTimeTimestamp]];
   
    
    UInt8 buff_str[1024 * 64];
    memcpy(buff_str,[dateString UTF8String], [dateString length]+1);
    IMSendPackage(voidtoken, eTypeJSON, i, ImpHeartbeatReq, buff_str, dateString.length);
}

-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

@end
