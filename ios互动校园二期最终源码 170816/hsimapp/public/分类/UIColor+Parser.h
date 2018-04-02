//
//  UIColor+Parser.h
//  ZHIMA
//
//  Created by charmenli on 14-8-6.
//  Copyright (c) 2014年 kluermn.yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface UIColor (Parser)

//+ (UIColor *)colorWithHex:(NSString *)colorHex;
+ (instancetype)colorFromHexString:(NSString *)hexString;

@end
