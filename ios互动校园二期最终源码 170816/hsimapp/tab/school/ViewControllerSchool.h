//
//  ViewControllerSchool.h
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "HSImageScrollView.h"
#import "HSGridView.h"

@interface ViewControllerSchool : RootViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HSImageScrollView *hsImageScrollView;
@property (weak, nonatomic) IBOutlet HSGridView *hsGridView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onRefresh:(id)sender;
@end
