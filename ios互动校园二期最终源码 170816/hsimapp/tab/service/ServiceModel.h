//
//  ServiceModel.h
//  hsimapp
//
//  Created by dingding on 2018/2/1.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property (nonatomic,assign) NSInteger  extra_id;
@property (nonatomic,assign) NSInteger  id;
@property (nonatomic,copy) NSString * info_code;
@property (nonatomic,copy) NSString * info_img;
@property (nonatomic,copy) NSString * info_name;
@property (nonatomic,copy) NSString * info_sort;
@property (nonatomic,copy) NSString * info_url;
@property (nonatomic,assign) NSInteger  info_status;
@property (nonatomic,assign) NSInteger  info_type;
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,strong) NSArray * child;

//@property (nonatomic,copy) NSString * info_img;
//@property (nonatomic,copy) NSString * info_name;
@property (nonatomic,copy) NSString * fun_url;
@property (nonatomic,copy) NSString * fun_name;


@end
