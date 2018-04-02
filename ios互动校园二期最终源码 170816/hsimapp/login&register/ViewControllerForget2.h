//
//  ViewControllerForget2.h
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerForget2 : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTIP1;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP2;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP3;
@property (weak, nonatomic) IBOutlet UITextField *textSMS;
@property (weak, nonatomic) IBOutlet UIButton *btGetSMS;
@property (weak, nonatomic) IBOutlet UIButton *btNext;

- (IBAction)onNext:(id)sender;
- (IBAction)onGetSMS:(id)sender;
@end
