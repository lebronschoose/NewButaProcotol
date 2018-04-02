//
//  FMDBHelper.h
//  数据库代码(FMDB)
//
//  Created by ie on 16/5/4.
//  Copyright © 2016年 Casanova.Z/朱静宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ZUser.h"
#import "TableAbout.h"



@interface FMDBHelper : NSObject

@property (nonatomic, copy) NSString *dbPath;

@property (nonatomic, strong) FMDatabase *db;

+ (FMDBHelper *)getInstance:(NSString *)dbPath;

#pragma mark - 数据库的操作

/*
 * 打开数据库
 */
- (BOOL)open;
/*
 * 建表
 */
- (BOOL)createTable:(NSString *)tableName items:(NSArray *)items itemsAttr:(NSArray *)itemsAttr;

/**
 *  插入数据
 */
- (BOOL)insertDataToTable:(NSString *)tableName items:(NSArray *)items values:(NSArray *)values;

/**
 *  删除数据
 */
- (BOOL)deleteDataFromTable:(NSString *)tableName where:(NSString *)whereArgs;

/**
 *  修改数据
 */
- (BOOL)updateDataToTable:(NSString *)tableName items:(NSArray *)items values:(NSArray *)values where:(NSString *)whereArgs;

/**
 *  查询数据
 */
- (NSMutableArray *)queryFromTable:(NSString *)tableName items:(NSArray *)items where:(NSString *)whereArgs;


/**
 *  关闭数据库db
 */
- (void)closeDB;


@end
