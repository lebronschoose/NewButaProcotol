//
//  NSString+Util.h
//  GoGo
//
//  Created by GuoChengHao on 14-4-21.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (PAUtility)
/**
 判断字符串是否为空
 */
+(BOOL) isBlankString:(NSString *)string;

/**
 判断是否为可用电话号码
 */
+ (BOOL)validatePhone:(NSString *)phone;
/**
 * 验证身份证号码
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;
/**
 * 验证是否为邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**
 * 验证是否包含数字
 */
+(BOOL)isIncludenumber: (NSString *)str;
/**
 * 验证是否包含特殊字符
 */
+(BOOL)isIncludeSpecialCharact: (NSString *)str;
/**
 * 验证是否包含英文字母
 */
+(BOOL)isIncludeEnglish: (NSString *)str;
/**
 * 正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;
/**
 *	@brief	验证登录密码
 *
 *	@param 	value 	值
 *  @param 	mobile 	账号
 *	@return	yes为通过
 */
+ (NSString *)validLoginPwd:(NSString *)value andMobile:(NSString *)mobile;

/**
 * @brief 验证支付密码
 * @param pwd 支付密码
 * @return 4、合法
 *
 *
 */
+ (NSInteger)appValidPaymentPwd:(NSString *)pwd;

//设置字体大小的接口 String 包含Name  可设置Name 字符串 字体特定大小 attributedText
+ (NSMutableAttributedString *)nameFont:(UIFont *)font name:(NSString *)name string:(NSString *)string;

//设置名字为制定颜色的接口  String 包含Name  可设置Name 字符串 字体特定颜色 attributedText
+ (NSMutableAttributedString *)nameColor:(UIColor *)color name:(NSString *)name string:(NSString *)string;

//既设置颜色还设置字体大小
+ (NSMutableAttributedString *)nameFont:(UIFont *)font namecolor:(UIColor *)color name:(NSString *)name string:(NSString *)string;


/* 判断字符串是否是数字 */
- (BOOL)isNumber ;

/* 去除非数字内容 */
+ (NSString *)trimNotNumber:(NSString *)string;

/* URL编码 */
- (NSString *)urlEncode;

/* 控制string不为nil */
+(NSString*)beNotEmpty:(id)str;

//自动计算文本宽度
+ (CGSize)sizeWidthWithString:(NSString *)string font:(UIFont *)font constraintHeight:(CGFloat)constraintHeight;

//自动计算文本高度
+ (CGSize)sizeHeightWithString:(NSString *)string font:(UIFont *)font constraintWidth:(CGFloat)constraintWidth;

/**
 * 手机号码四颗星脱敏处理
 */
+ (NSString *)fourStarMobilePhoneFromOrign:(NSString *)orignMobil;

/**
 * 判断是否为表情字符
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/**
 * 转换金额格式,
 */
+ (NSString *)countNumAndChangeformat:(double )num;

+(NSString *)SecretNameFromName:(NSString *)Name;



@end
