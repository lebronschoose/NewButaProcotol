//
//  ViewControllerRegister3.h
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerRegister3 : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTIP1;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP2;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP3;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *btShowPassword;
@property (weak, nonatomic) IBOutlet UIButton *btRegister;
@property (weak, nonatomic) IBOutlet UIView *viewCert;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textSMS;
@property (weak, nonatomic) IBOutlet UIButton *btGetSMS;

- (IBAction)onGetSMS:(id)sender;
- (IBAction)onRegister:(id)sender;
- (IBAction)onShowPassword:(id)sender;
@end
