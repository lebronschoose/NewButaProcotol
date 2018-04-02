//
//  NSWord.m
//  hsimapp
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "NSWord.h"

@implementation NSWord

+ (NSWord *)wordWithInt:(int)value
{
    NSWord *w = [[NSWord alloc] init];
    [w setWordValue:(WORD)value];
    return w;
}

@end
