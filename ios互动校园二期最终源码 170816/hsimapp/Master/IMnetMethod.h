//
//  IMnetMethod.h
//  hsimapp
//
//  Created by dingding on 2018/3/15.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMNet.h"


@interface IMnetMethod : NSObject
@property(copy,nonatomic) NSString * tokenString;



+(IMnetMethod *)ShareInstance;

-(BOOL)LoginByWithServer:(NSArray * )Server;

- (void)getReturnPackFrom:(NSString *)PackString BY:(E_CMD  )cmd;

- (void)ConnectAccess:(NSString *)PackString;

@end
