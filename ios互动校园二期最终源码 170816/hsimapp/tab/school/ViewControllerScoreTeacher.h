//
//  ViewControllerScoreTeacher.h
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerScoreTeacher : RootViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textClass;
@property (weak, nonatomic) IBOutlet UITextField *textExam;
@property (weak, nonatomic) IBOutlet UITextField *textCourse;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
