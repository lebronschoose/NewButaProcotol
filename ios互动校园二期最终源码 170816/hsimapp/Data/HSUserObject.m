//
//  HSAppData.m
//  HSIMApp
//
//  Created by han on 14/1/7.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "HSUserObject.h"

@implementation HSUserObject

+(HSUserObject *)userFromDic:(NSDictionary *)dic
{
    HSUserObject *aUser = [[HSUserObject alloc] init];
    NSLog(@"userdic is %@",dic);
    [aUser setUserType:dic[@"role"]];
    [aUser setDDNumber:dic[@"id"]];
    [aUser setNickName:dic[@"name"]];
//    [aUser setSpecialChatID:chatID];
    [aUser setEmailAddr:@""];
    [aUser setMobileNo:dic[@"phone"]];
    [aUser setSignText:@""];
    [aUser setBindText:@""];
    [aUser setDataFlag:[NSNumber numberWithInt:0]];
    [aUser setNeedUpdate:YES];
    return aUser;
}

+(HSUserObject *)userWithNickName:(NSString *)nickName andChatID:(NSNumber *)chatID
{
    HSUserObject *aUser = [[HSUserObject alloc] init];
    [aUser setUserType:NN(0)];
    [aUser setDDNumber:@""];
    [aUser setNickName:nickName];
    [aUser setSpecialChatID:chatID];
    [aUser setEmailAddr:@""];
    [aUser setMobileNo:@""];
    [aUser setSignText:@""];
    [aUser setBindText:@""];
    [aUser setDataFlag:[NSNumber numberWithInt:0]];
    [aUser setNeedUpdate:YES];
    return aUser;
}

+(HSUserObject *)userWithDDNumber:(NSString *)DDNumber andDataFlag:(NSNumber *)dataFlag
{
    HSUserObject *aUser = [[HSUserObject alloc] init];
    [aUser setUserType:NN(0)];
    [aUser setDDNumber:DDNumber];
    [aUser setNickName:@""];
    [aUser setRealName:@""];
    [aUser setEmailAddr:@""];
    [aUser setMobileNo:@""];
    [aUser setSignText:@""];
    [aUser setBindText:@""];
    [aUser setDataFlag:dataFlag];
    [aUser setNeedUpdate:YES];
    return aUser;
}

+(HSUserObject *)userFromDataSet:(FMResultSet *)rs
{
    HSUserObject *aUser = [[HSUserObject alloc] init];
    [aUser setUserType:[rs objectForColumnName:@"userType"]];
    [aUser setDDNumber:[rs stringForColumn:@"DDNumber"]];
    [aUser setNickName:[rs stringForColumn:@"nickName"]];
    [aUser setRealName:[rs stringForColumn:@"realName"]];
    [aUser setEmailAddr:[rs stringForColumn:@"EmailAddr"]];
    [aUser setMobileNo:[rs stringForColumn:@"MobileNo"]];
    [aUser setSignText:[rs stringForColumn:@"signText"]];
    [aUser setBindText:[rs stringForColumn:@"bindText"]];
    [aUser setDataFlag:[rs objectForColumnName:@"dataFlag"]];
    if([[rs objectForColumnName:@"oldData"] intValue] != 0)
    {
        [aUser setNeedUpdate:YES];
    }
    else
    {
        [aUser setNeedUpdate:NO];
    }
    return aUser;
}

+(HSUserObject *)userFromCP:(char *)cp
{
    cp2NewInt(iUserType);
    cp2NewInt(iDataFlag);
    cp2NewString(szNickName, LEN_NICKNAME);
    cp2NewString(szDDNumber, LEN_ACCOUNT);
    cp2NewString(szRealName, LEN_ACCOUNT);
    cp2NewString(szBindText, LEN_BINDTEXT);
    cp2NewString(szEmail, LEN_EMAIL);
    cp2NewString(szMobile, LEN_MOBILE);
    cp2NewString(szSignText, LEN_SIGNTEXT);
    cp2NewInt(logoLen);
    HSUserObject *aUser = [[HSUserObject alloc] init];
    
    [aUser setUserType:[NSNumber numberWithInt:iUserType]];
    if(iUserType < 0) return aUser;
//    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [aUser setDataFlag:[NSNumber numberWithInt:iDataFlag]];
    [aUser setNickName:[[NSString alloc] initWithCString:szNickName encoding:En2CHN]];
    [aUser setDDNumber:[[NSString alloc] initWithCString:szDDNumber encoding:En2CHN]];
    [aUser setRealName:[[NSString alloc] initWithCString:szRealName encoding:En2CHN]];
    [aUser setBindText:[[NSString alloc] initWithCString:szBindText encoding:En2CHN]];
    [aUser setEmailAddr:[[NSString alloc] initWithCString:szEmail encoding:NSASCIIStringEncoding]];
    [aUser setMobileNo:[[NSString alloc] initWithCString:szMobile encoding:NSASCIIStringEncoding]];
    [aUser setSignText:[[NSString alloc] initWithCString:szSignText encoding:En2CHN]];
    [aUser setNeedUpdate:NO];
    cp += logoLen;
    return aUser;
}

-(int)countOfDetails
{
    return 6;
}

-(void)dump
{
    NSString *text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
                      NB(self.needUpdate),
                      self.specialChatID,
                      self.DDNumber,
                      self.nickName,
                      self.bindText,
                      self.realName,
                      self.emailAddr,
                      self.mobileNo,
                      self.realName,
                      self.nickName,
                      self.emailAddr,
                      self.mobileNo,
                      self.signText,
                      self.dataFlag];
    NSLog(@"%@", text);
}

-(NSString *)detailOfIndex:(int)index
{
    switch (index)
    {
        case 0:
            if(self.DDNumber == nil) return @"登录帐号:";
            return [NSString stringWithFormat:@"登录帐号:   %@", self.DDNumber];
            break;
        case 1:
            if(self.realName == nil) return @"真实姓名:";
            return [NSString stringWithFormat:@"真实姓名:   %@", self.realName];
            break;
        case 2:
            if(self.bindText == nil) return @"用户身份:";
            return [NSString stringWithFormat:@"用户身份:   %@", self.bindText];
            break;
        case 3:
            if(self.emailAddr == nil) return @"电子邮箱:";
            return [NSString stringWithFormat:@"电子邮箱:   %@", self.emailAddr];
            break;
        case 4:
            if(self.mobileNo == nil) return @"手机号码:";
            return [NSString stringWithFormat:@"手机号码:   %@", self.mobileNo];
            break;
        case 5:
            if(self.signText == nil) return @"个性签名:";
            return [NSString stringWithFormat:@"个性签名:   %@", self.signText];
            break;
        default:
            break;
    }
    return nil;
}

-(int)selfCountOfDetails
{
    return 7;
}

-(UITableViewCellAccessoryType)accessoryType:(int)index
{
    switch (index)
    {
        case 0:
        case 5:
            return UITableViewCellAccessoryNone;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 6:
            return UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return UITableViewCellAccessoryNone;
}

-(NSString *)selfDetailOfIndex:(int)index
{
    switch (index)
    {
        case 0:
            if(self.DDNumber == nil) return @"登录帐号:";
            NSLog(@"self.DDNumber is %@",self.DDNumber);
            return [NSString stringWithFormat:@"登录帐号:   %@", self.DDNumber];
            break;
        case 1:
            if(self.realName == nil) return @"真实姓名:";
            return [NSString stringWithFormat:@"真实姓名:   %@", self.realName];
            break;
        case 2:
            if(self.bindText == nil) return @"用户身份:";
            return [NSString stringWithFormat:@"用户身份:   %@", self.bindText];
            break;
        case 3:
            if(self.bindText == nil) return @"用户昵称:";
            return [NSString stringWithFormat:@"用户昵称:   %@", self.nickName];
            break;
        case 4:
            if(self.emailAddr == nil) return @"电子邮箱:";
            return [NSString stringWithFormat:@"电子邮箱:   %@", self.emailAddr];
            break;
        case 5:
            if(self.mobileNo == nil) return @"手机号码:";
            return [NSString stringWithFormat:@"手机号码:   %@", self.mobileNo];
            break;
        case 6:
            if(self.signText == nil) return @"个性签名:";
            return [NSString stringWithFormat:@"个性签名:   %@", self.signText];
            break;
        default:
            break;
    }
    return nil;
}

-(BOOL)isNeedUpdateWithFlag:(int)dataFlag
{
    if(self.needUpdate || [self.dataFlag intValue] != dataFlag)
    {
        [self setNeedUpdate:YES];
        [self checkUpdate:0];
        return YES;
    }
    return NO;
}

// request type
// 0: default
// 1: my friend list request the full data

-(BOOL)checkUpdate:(int)requestType
{
    if(self.nickName == nil || [self.nickName length] == 0 || [self.nickName isEqualToString:@""])
    {
        // 不允许用户昵称为空
    }
    else
    {
        if(self.needUpdate == NO) return NO;
    }
    
    BOOL bRequest = NO;
    NSDate *lastReqDataTime = [_Master.lastRequestTime objectForKey:self.DDNumber];
    if(lastReqDataTime == nil)
    {
        bRequest = YES;
    }
    else
    {
        NSTimeInterval timeSince = [lastReqDataTime timeIntervalSinceNow];
        timeSince *= -1;
        if(timeSince > 5) // 距离上次申请数据已经过去5秒，上次请求超时
        {
            bRequest = YES;
        }
        else return NO;
    }
    if(bRequest == YES)
    {
        [_Master.lastRequestTime setObject:[NSDate date] forKey:self.DDNumber];
        [_Master reqUserData:self.DDNumber ofType:requestType oldFlag:self.dataFlag.intValue ofChatID:self.specialChatID.intValue];
//        [_Master reqUserData:self.DDNumber :self.specialChatID ofType:requestType];
        return YES;
    }
    return NO;
}

@end
