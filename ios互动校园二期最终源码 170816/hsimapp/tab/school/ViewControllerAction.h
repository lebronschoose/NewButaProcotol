//
//  ViewControllerAction.h
//  hsimapp
//
//  Created by apple on 16/7/3.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerAction : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btSeg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
