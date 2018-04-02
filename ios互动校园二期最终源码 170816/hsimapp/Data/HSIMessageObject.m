//
//  HSIMessageObject.m
//  HSIMApp
//
//  Created by han on 14/1/22.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "HSIMessageObject.h"

@implementation HSIMessageObject

+(HSIMessageObject *)iMessageFrom:(HSMessageObject *)aMsg andUser:(HSUserObject *)aUser orGroup:(HSPublicGroupObject *)aGroup
{
    HSIMessageObject *aIMessage = [[HSIMessageObject alloc] init];
    [aIMessage setUser:aUser];
    [aIMessage setMessage:aMsg];
    [aIMessage setGroup:aGroup];
    return aIMessage;
}

@end
