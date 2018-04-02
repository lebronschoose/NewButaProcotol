//
//  NSByte.h
//  hsimapp
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSByte : NSObject

@property (nonatomic, assign) byte byteValue;

+ (NSByte *)byteWithInt:(int)value;

@end
