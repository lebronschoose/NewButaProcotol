//
//  NSWord.h
//  hsimapp
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSWord : NSObject

@property (nonatomic, assign) WORD wordValue;

+ (NSWord *)wordWithInt:(int)value;

@end
