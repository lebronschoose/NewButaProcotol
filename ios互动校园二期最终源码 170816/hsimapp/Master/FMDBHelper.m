//
//  FMDBHelper.m
//  数据库代码(FMDB)
//
//  Created by ie on 16/5/4.
//  Copyright © 2016年 Casanova.Z/朱静宁. All rights reserved.
//

#import "FMDBHelper.h"


static FMDBHelper *dbHelper;


@implementation FMDBHelper

/**
 *  FMDatabase懒加载
 */
- (FMDatabase *)db {
    if (_db == nil) {
        _db = [FMDatabase databaseWithPath:self.dbPath];
    }
    return _db;
}

/**
 *单例模式，获取帮助类的实例
 */
+ (FMDBHelper *)getInstance:(NSString *)dbPath {
    if (dbHelper == nil) {
        dbHelper = [[FMDBHelper alloc] init];
        // 断言：如果初始化 FMDBHelper时没有传入数据库的路径，则直接报错退出
        NSAssert(dbPath!=nil && ![dbPath isEqualToString:@""], @"error：必须传入数据库路径");
        // 设置数据库的路径
        [dbHelper setDbPath:dbPath];
    }
    return dbHelper;
}

#pragma mark - 数据库的操作
/**
 *  打开数据库
 */
- (BOOL)open {
    
    return [self.db open];
}
/**
 *  创建表格
 *  1.tableName:表名称
 *  2.items:表字段数组
 *  3.itemsAttr:表字段的属性(如:text)
 */
- (BOOL)createTable:(NSString *)tableName items:(NSArray *)items itemsAttr:(NSArray *)itemsAttr {
    if (tableName == nil || [tableName isEqualToString:@""] || items == nil || items.count == 0 || itemsAttr == nil || itemsAttr.count == 0 || items.count != itemsAttr.count) {
        return NO;
    }
    if ([self open]) {
        NSMutableString *createTableSql = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName];
        for (int i = 0; i < items.count; i++) {
            [createTableSql appendFormat:@"%@ %@,",items[i],itemsAttr[i]];
        }
        [createTableSql deleteCharactersInRange:NSMakeRange([createTableSql length] -1, 1)];
        [createTableSql appendString:@")"];
        BOOL resultFlag = [self.db executeUpdate:createTableSql];
        [self closeDB];
        return resultFlag;
    }
    return NO;
}

/**
 *  插入数据
 */
- (BOOL)insertDataToTable:(NSString *)tableName items:(NSArray *)items values:(NSArray *)values {
    // 判断传入的值是否合法
    if (tableName == nil || [tableName isEqualToString:@""] || items == nil || items.count == 0 || values == nil || values.count == 0 || items.count != values.count) {
        return NO;
    }
    if ([self open]) {
        NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (",tableName];
        for (int i = 0; i < items.count; i++) {
            [insertSql appendFormat:@"%@,",items[i]];
        }
        [insertSql deleteCharactersInRange:NSMakeRange([insertSql length] -1, 1)];
        [insertSql appendString:@") values ("];
        for (int j = 0; j < values.count; j++) {
            [insertSql appendFormat:@"?,"];
        }
        [insertSql deleteCharactersInRange:NSMakeRange([insertSql length] -1, 1)];
        [insertSql appendString:@")"];
        NSLog(@"sql:%@",insertSql);
        BOOL flag = [self.db executeUpdate:insertSql withArgumentsInArray:values];
        NSLog(@"flag:%d",flag);
        [self closeDB];
        return  flag;
    }
    return NO;
}

/**
 *  删除数据
 */
- (BOOL)deleteDataFromTable:(NSString *)tableName where:(NSString *)whereArgs {
    
    if (tableName == nil || [tableName isEqualToString:@""] || whereArgs == nil || [whereArgs isEqualToString:@""]) {
        return NO;
    }
    if ([self open]) {
        NSString *delectSql = [[NSString alloc] initWithFormat:@"delete from %@ %@",tableName,whereArgs];
        return [self.db executeUpdate:delectSql];
    }else{
        return NO;
    }
}

/**
 *  修改数据
 */
- (BOOL)updateDataToTable:(NSString *)tableName items:(NSArray *)items values:(NSArray *)values where:(NSString *)whereArgs {
    if(tableName == nil || [tableName isEqualToString:@""] || items == nil || items.count == 0 || values == nil || values.count == 0 || values.count != items.count){
        return NO;
    }
    if (whereArgs == nil || [whereArgs isEqualToString:@""]) {
        return NO;
    }
    if ([self open]) {
        NSMutableString *updateSql = [[NSMutableString alloc] initWithFormat:@"update %@ set ",tableName];
        for (int i = 0; i < items.count; i++) {
            [updateSql appendFormat:@"%@ = '%@',",items[i],values[i]];
        }
        [updateSql deleteCharactersInRange:NSMakeRange(updateSql.length - 1, 1)];
        [updateSql appendFormat:@" %@ ",whereArgs];
        NSLog(@"updateSql%@",updateSql);
        return [self.db executeUpdate:updateSql];
    }
    return NO;
}


/**
 *  查询数据
 */
- (NSMutableArray *)queryFromTable:(NSString *)tableName items:(NSArray *)items where:(NSString *)whereArgs {
    if(tableName == nil || [tableName isEqualToString:@""] || items == nil || items.count == 0){
        return nil;
    }
    
    NSMutableString *querySql = [[NSMutableString alloc] initWithFormat:@"select "];
    for (int i = 0; i < items.count; i++) {
        [querySql appendFormat:@" %@,",items[i]];
    }
    [querySql deleteCharactersInRange:NSMakeRange(querySql.length -1, 1)];
    [querySql appendFormat:@" from %@ ",tableName];
    if (whereArgs != nil) {
        [querySql appendString:whereArgs];
    }
    if ([self open]) {
        FMResultSet *resultSet = [self.db executeQuery:querySql];
        if (resultSet != nil) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            while ([resultSet next]) {
                
                int userid = [resultSet intForColumn:Unread_User_ID];
                int school = [resultSet intForColumn:UNread_School];
                int homework = [resultSet intForColumn:UNread_HomeWork];
                int action = [resultSet intForColumn:UNread_Action];
                int Score = [resultSet intForColumn:UNread_Score];
                int Table = [resultSet intForColumn:UNread_Table];
                int Query = [resultSet intForColumn:UNread_Query];
                int Abend = [resultSet intForColumn:UNread_Abend];
                NSString * checkcode = [resultSet stringForColumn:Unread_checkCode];
               
                
                ZUser *user = [ZUser UserWithUserID:userid school:school homeWork:homework action:action score:Score table:Table query:Query abend:Abend checkCode:checkcode];
                [arr addObject:user];
            }
            return arr;
        }else{
            return nil;
        }

    }
    return nil;
}

/**
 *  关闭数据库
 */
- (void)closeDB {
    [self.db close];
    self.db = nil;
}


@end
