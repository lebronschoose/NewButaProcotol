//
//  HSPublicGroupObject.m
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//
#import "HSPublicGroupObject.h"

@implementation HSPublicGroupObject
@synthesize chatID, groupName, descText, addData;

+(HSPublicGroupObject *)groupFromDataset:(FMResultSet *)rs
{
    HSPublicGroupObject *aGroup = [[HSPublicGroupObject alloc] init];
    [aGroup setChatID:[rs objectForColumnName:@"chatID"]];
    [aGroup setGroupName:[rs stringForColumn:@"groupName"]];
    [aGroup setDescText:[rs stringForColumn:@"descText"]];
    [aGroup setAddData:[rs stringForColumn:@"addData"]];
    return aGroup;
}

+(HSPublicGroupObject *)groupFromCP:(char **)pCP
{
    char *c = *pCP;
    char *cp = *pCP;
    if(cp == NULL) return nil;
    HSPublicGroupObject *aGroup = [[HSPublicGroupObject alloc] init];
    int iChatID;
    cp2Int(iChatID);
    [aGroup setChatID:[NSNumber numberWithInt:iChatID]];
    
    char szData[512];
    memset(szData, 0x00, 512);
    cp2String(szData, 512);
    [aGroup setGroupName:[NSString stringWithCString:szData encoding:En2CHN]];
    memset(szData, 0x00, 512);
    cp2String(szData, 512);
    [aGroup setDescText:[NSString stringWithCString:szData encoding:En2CHN]];
    
    memset(szData, 0x00, 512);
    cp2String(szData, 512);
    if([Master isPublicGroup:iChatID] && strlen(szData) > 0)
    {
        NSNumber *newChatID = [_HSCore genChatIDForPublicGroup:[NSNumber numberWithInt:iChatID] andFlag:[NSString stringWithCString:szData encoding:NSASCIIStringEncoding]];
        if([newChatID intValue] < 0)
        {
            [aGroup setChatID:newChatID];
        }
    }
    //[aGroup setGroupFlag:[NSString stringWithCString:szData encoding:NSASCIIStringEncoding]];
    
    if([Master isHyperLink:iChatID] || [Master isConfigItem:iChatID])
    {
        memset(szData, 0x00, 512);
        cp2String(szData, 512);
        [aGroup setAddData:[NSString stringWithFormat:@"%s", szData]];
    }
    else
    {
        [aGroup setAddData:[NSString stringWithFormat:@""]];
    }
    *pCP += (cp - c);
    return aGroup;
}

@end
