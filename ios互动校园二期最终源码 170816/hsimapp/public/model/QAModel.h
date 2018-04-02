//
//  QAModel.h
//  hsimapp
//
//  Created by dingding on 17/9/17.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAModel : NSObject
@property(nonatomic,copy) NSString * aname; //回复名字
@property(nonatomic,copy) NSString * answer;//回复内容
@property(nonatomic,copy) NSString * atime; //回复时间
@property(nonatomic,copy) NSString * auid; //回复人的ID
@property(nonatomic,copy) NSString * cid; //传递参数
@property(nonatomic,copy) NSString * classid; //班级号
@property(nonatomic,copy) NSString * qname; //提问人名字
@property(nonatomic,copy) NSString * question; // 提问问题
@property(nonatomic,copy) NSString * qtime; //提问时间
@property(nonatomic,copy) NSString * quid; // 提问人ID
@property(nonatomic,copy) NSString * schid; // 
@property(nonatomic,copy) NSString * status; //
@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end
