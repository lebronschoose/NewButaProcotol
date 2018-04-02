//
//  ViewControllerCourseTable.h
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerCourseTable : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
