//
//  ViewControllerLogin.h
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"
#import "EGOImageView.h"

@interface ViewControllerLogin : RootViewController

@property (weak, nonatomic) IBOutlet EGOImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;
@property (weak, nonatomic) IBOutlet UIButton *btAgree;
- (IBAction)onBtLogin:(id)sender;
- (IBAction)onBtRegister:(id)sender;
- (IBAction)onBtForget:(id)sender;
- (IBAction)onBtAgree:(id)sender;
- (IBAction)onBtLegal:(id)sender;

@end
