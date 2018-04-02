//
//  ViewControllerNotice.h
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"
#import "PullTableView.h"

@interface ViewControllerNotice : RootViewController

@property (weak, nonatomic) IBOutlet UIButton *btNewNotice;
@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@end
