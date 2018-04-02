//
//  QustionDmodel.h
//  hsimapp
//
//  Created by dingding on 2018/1/19.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QustionDmodel : NSObject
@property(nonatomic,copy) NSString * content; //回复内容
@property(nonatomic,copy) NSString * id;//
@property(nonatomic,copy) NSString * opid; //
@property(nonatomic,copy) NSString * time; //时间
@property(nonatomic,copy) NSString * type; //判断参数 0 是问 1 是答
@end
