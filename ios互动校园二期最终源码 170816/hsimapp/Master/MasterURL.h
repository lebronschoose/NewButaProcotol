//
//  MasterURL.h
//  dyhAutoApp
//
//  Created by apple on 15/6/6.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterURL : NSObject

+(NSString *)mainURL;

// for picture
+(NSString *)urlOfUserLogo:(NSString *)account;
+(NSString *)urlOfUserHDLogo:(NSString *)account;

+(NSString *)urlOfGroupLogo:(NSNumber *)groupID;
+(NSString *)urlOfGroupHDLogo:(NSNumber *)groupID;

+(NSString *)urlOfItem:(NSInteger)index;

// for web api
+(NSString *)APIFor:(NSString *)type with:(id)p, ...;

+(NSString *)bindCheckcode:(NSString *)url;

@end
