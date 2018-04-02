//
//  HSPublicGroupObject.h
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPublicGroupObject : NSObject
@property(retain, nonatomic) NSNumber *chatID;
@property(retain, nonatomic) NSString *groupName;
@property(retain, nonatomic) NSString *descText;
@property(retain, nonatomic) NSString *addData;

+(HSPublicGroupObject *)groupFromDataset:(FMResultSet *)rs;
+(HSPublicGroupObject *)groupFromCP:(char **)pCP;

@end
