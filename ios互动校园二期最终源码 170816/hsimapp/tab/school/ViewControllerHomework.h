//
//  ViewControllerHomework.h
//  hsimapp
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"
#import "CLWeeklyCalendarView.h"

@interface ViewControllerHomework : RootViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btNewHomework;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onNewHomework:(id)sender;
- (IBAction)onTest:(id)sender;
@end
