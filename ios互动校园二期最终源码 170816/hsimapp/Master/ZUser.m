//
//  ZUser.m
//  数据库代码(FMDB)
//
//  Created by ie on 16/5/5.
//  Copyright © 2016年 Casanova.Z/朱静宁. All rights reserved.
//

#import "ZUser.h"

@implementation ZUser

/**
 *  初始化
 */
+ (id)userWithID:(NSInteger)_id name:(NSString *)name age:(NSInteger)age addr:(NSString *)addr {
    return [[self alloc] initWithID:_id name:name age:age addr:addr];
}

- (id)initWithID:(NSInteger)_id name:(NSString *)name age:(NSInteger)age addr:(NSString *)addr {
    if (self = [super init]) {
        self.ID = _id;
        self.name = name;
        self.age = age;
        self.addr = addr;
    }
    return self;
}

+(id)UserWithUserID:(NSInteger )UserID school:(NSInteger)school homeWork:(NSInteger)homeWork action:(NSInteger)action score:(NSInteger)score table:(NSInteger)table query:(NSInteger)query abend:(NSInteger)abend checkCode:(NSString *)checkCode
{
    return [[self alloc]initWithUserID:UserID school:school homeWork:homeWork action:action score:score table:table query:query abend:abend checkCode:checkCode];
}

-(id)initWithUserID:(NSInteger )UserID school:(NSInteger)school homeWork:(NSInteger)homeWork action:(NSInteger)action score:(NSInteger)score table:(NSInteger)table query:(NSInteger)query abend:(NSInteger)abend checkCode:(NSString *)checkCode
{
    if (self = [super init]) {
        self.UserId = UserID;
        self.SchoolUnread = school;
        self.HomeWorkUnread = homeWork;
        self.ActionUnread = action;
        self.ScoreUnread = score;
        self.TableUnread = table;
        self.QueryUnread = query;
        self.AbendUnread = abend;
        self.TheCheckCode = checkCode;
    }
    return self;
}

@end
