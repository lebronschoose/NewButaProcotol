//
//  TableAbout.h
//  数据库代码(FMDB)
//
//  Created by ie on 16/5/4.
//  Copyright © 2016年 Casanova.Z/朱静宁. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  表字段
 */
#define USER_TABLE_NAME    @"USERS"
#define USER_ID            @"USER_ID"
#define USER_NAME          @"USER_NAME"
#define USER_AGE           @"USER_AGE"
#define USER_ADDR          @"USER_ADDR"




#define Unread_TABLE_NAME    @"Unread"
#define Unread_User_ID       @"Unread_User_ID"
#define Unread_checkCode     @"Unread_checkCode"
#define UNread_School        @"UNread_School"
#define UNread_HomeWork      @"UNread_HomeWork"
#define UNread_Action        @"UNread_Action"
#define UNread_Score         @"UNread_Score"
#define UNread_Table         @"UNread_Table"
#define UNread_Query         @"UNread_Query"
#define UNread_Abend         @"UNread_Abend"
/**
 *  表字段的类型
 */
#define TableItemAttrTypeText                   @" TEXT "
#define TableItemAttrTypeInteger                @" INTEGER "
#define TableItemAttrTypeIntegerAndPrimaryKey   @" INTEGER PRIMARY KEY AUTOINCREMENT "
#define dbFullPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"myfmdb.db"]


@interface TableAbout : NSObject

@end
