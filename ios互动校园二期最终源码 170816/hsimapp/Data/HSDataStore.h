//
//  HSDataStore.h
//  dyhAutoApp
//
//  Created by apple on 15/10/11.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSKeyValueItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;

@end


@interface HSDataStore : NSObject

+(HSDataStore *)sharedInstance;

- (id)initDBWithName:(NSString *)dbName;
- (id)initWithDBWithPath:(NSString *)dbPath;
- (void)createTableWithName:(NSString *)tableName;
- (BOOL)isTableExists:(NSString *)tableName;
- (void)clearTable:(NSString *)tableName;
- (void)close;

-(void)clearCache;
///************************ Put&Get methods *****************************************

- (void)putObject:(id)object withId:(NSString *)objectId;
- (id)getObjectById:(NSString *)objectId;
- (void)deleteObjectById:(NSString *)objectId;

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;
- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (HSKeyValueItem *)getHSKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;
- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;
- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

- (NSArray *)getAllItemsFromTable:(NSString *)tableName;
- (NSUInteger)getCountFromTable:(NSString *)tableName;

- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;


@end

