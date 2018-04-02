//
//  NSByte.m
//  hsimapp
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "NSByte.h"

@implementation NSByte

+ (NSByte *)byteWithInt:(int)value
{
    NSByte *b = [[NSByte alloc] init];
    [b setByteValue:(byte)value];
    return b;
}

@end
