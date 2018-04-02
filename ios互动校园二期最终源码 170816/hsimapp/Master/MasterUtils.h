//
//  MasterUtils.h
//  dyhAutoApp
//
//  Created by apple on 15/5/24.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterUtils : NSObject

+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(UIAlertView *)messageBox:(NSString *)pMsg withTitle:(NSString *)pTitle withOkText:(NSString *)okText from:(id)sender;

@end
