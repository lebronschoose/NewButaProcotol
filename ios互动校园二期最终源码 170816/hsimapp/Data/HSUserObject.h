//
//  HSUserObject.h
//  HSIMApp
//
//  Created by han on 14/1/7.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

enum USERTYPE
{
    emUserStudent           = 1,
    emUserParent            = 2,
    emUserTeacher           = 3,
    emUserClassMaster       = 4,
    emUserSchoolMaster      = 6,
};

@interface HSUserObject : NSObject

@property(retain, nonatomic) NSNumber       *userType; // 1 学生，2 家长， 3 普通老师（不能发公告）， 4 班主任（能发公告）， 9 学校管理员
@property(retain, nonatomic) NSNumber       *specialChatID; // 0 : p2p, 100 : group 0
@property(retain, nonatomic) NSString       *DDNumber;  // 相当于Uid
@property(retain, nonatomic) NSString       *nickName;
@property(retain, nonatomic) NSString       *bindText;
@property(retain, nonatomic) NSString       *realName;
@property(retain, nonatomic) NSString       *emailAddr;
@property(retain, nonatomic) NSString       *mobileNo;
@property(retain, nonatomic) NSString       *signText;
@property(retain, nonatomic) NSNumber       *dataFlag;
//@property(retain, nonatomic) NSData         *logo;
@property(assign)           BOOL            needUpdate;

+(HSUserObject *)userWithNickName:(NSString *)nickName andChatID:(NSNumber *)chatID;
+(HSUserObject *)userWithDDNumber:(NSString *)DDNumber andDataFlag:(NSNumber *)dataFlag;
+(HSUserObject *)userFromDataSet:(FMResultSet *)rs;
+(HSUserObject *)userFromCP:(char *)cp;

+(HSUserObject *)userFromDic:(NSDictionary *)dic;

-(int)countOfDetails;
-(NSString *)detailOfIndex:(int)index;

-(int)selfCountOfDetails;
-(NSString *)selfDetailOfIndex:(int)index;
-(UITableViewCellAccessoryType)accessoryType:(int)index;

-(void)dump;
-(BOOL)checkUpdate:(int)requestType;
-(BOOL)isNeedUpdateWithFlag:(int)dataFlag;

@end
