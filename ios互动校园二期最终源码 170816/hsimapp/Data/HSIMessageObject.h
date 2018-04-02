//
//  HSIMessageObject.h
//  HSIMApp
//
//  Created by han on 14/1/22.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSUserObject.h"
#import "HSMessageObject.h"
#import "HSPublicGroupObject.h"

@interface HSIMessageObject : NSObject

@property (retain, nonatomic) HSUserObject          *user;
@property (retain, nonatomic) HSPublicGroupObject   *group;
@property (retain, nonatomic) HSMessageObject       *message;

+(HSIMessageObject *)iMessageFrom:(HSMessageObject *)aMsg andUser:(HSUserObject *)aUser orGroup:(HSPublicGroupObject *)aGroup;

@end
