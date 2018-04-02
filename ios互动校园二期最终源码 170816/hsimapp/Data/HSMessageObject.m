//
//  HSMessageObject.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "HSMessageObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@implementation HSMessageObject
@synthesize messageContent,messageDate,messageFrom,messageTo,messageType,messageId,messageChatID,messageTimeFlag,messageState,hasOperate;

+(HSMessageObject *)messageFromDataSet:(FMResultSet *)rs
{
    HSMessageObject *aMessage = [[HSMessageObject alloc] init];
    [aMessage setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
    [aMessage setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
    [aMessage setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
    [aMessage setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
    [aMessage setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
    [aMessage setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
    [aMessage setMessageChatID:[rs objectForColumnName:kMESSAGE_CHATID]];
    [aMessage setMessageTimeFlag:[rs objectForColumnName:kMESSAGE_TIMEFLAG]];
    [aMessage setHasOperate:[rs objectForColumnName:@"hasOperate"]];
    [aMessage setMessageState:[rs objectForColumnName:@"messageState"]];
    
    [aMessage setBindImagePath:[rs stringForColumn:@"bindImagePath"]];
    [aMessage setUploadUUID:[rs stringForColumn:@"uploadUUID"]];
    return aMessage;
}

+(HSMessageObject *)messageWithType:(int)aType
{
    HSMessageObject *msg = [[HSMessageObject alloc] init];
    [msg setMessageType:[NSNumber numberWithInt:aType]];
    return  msg;
}

-(BOOL)isHasOperate
{
    if([self.hasOperate intValue] != 0) return YES;
    return NO;
}

@end
