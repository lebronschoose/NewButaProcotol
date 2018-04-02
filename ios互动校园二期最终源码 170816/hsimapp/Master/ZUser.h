//
//  ZUser.h
//  数据库代码(FMDB)
//
//  Created by ie on 16/5/5.
//  Copyright © 2016年 Casanova.Z/朱静宁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUser : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, assign) NSInteger  UserId;

@property (nonatomic, copy) NSString *  TheCheckCode; //checkcode 唯一标识

@property (nonatomic, assign) NSInteger SchoolUnread; //公告

@property (nonatomic, assign) NSInteger HomeWorkUnread; //家庭作业

@property (nonatomic, assign) NSInteger ActionUnread; //行为记录

@property (nonatomic, assign) NSInteger ScoreUnread; //考试成绩

@property (nonatomic, assign) NSInteger TableUnread; //学生课程

@property (nonatomic, assign) NSInteger QueryUnread; //学校咨询

@property (nonatomic, assign) NSInteger AbendUnread; // 学生考情
/**
 *  初始化数据
 */
+ (id)userWithID:(NSInteger)_id name:(NSString *)name age:(NSInteger)age addr:(NSString *)addr;

- (id)initWithID:(NSInteger)_id name:(NSString *)name age:(NSInteger)age addr:(NSString *)addr;

+(id)UserWithUserID:(NSInteger )UserID school:(NSInteger)school homeWork:(NSInteger)homeWork action:(NSInteger)action score:(NSInteger)score table:(NSInteger)table query:(NSInteger)query abend:(NSInteger)abend checkCode:(NSString *)checkCode;

-(id)initWithUserID:(NSInteger )UserID school:(NSInteger)school homeWork:(NSInteger)homeWork action:(NSInteger)action score:(NSInteger)score table:(NSInteger)table query:(NSInteger)query abend:(NSInteger)abend checkCode:(NSString *)checkCode;

@end
