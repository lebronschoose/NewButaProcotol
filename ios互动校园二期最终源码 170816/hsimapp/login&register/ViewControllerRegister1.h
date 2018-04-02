//
//  ViewControllerRegister1.h
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerRegister1 : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTIP1;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP2;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP3;
@property (weak, nonatomic) IBOutlet UIButton *btNext;
@property (weak, nonatomic) IBOutlet UIButton *btBack;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;

- (IBAction)onNext:(id)sender;
- (IBAction)btBack:(id)sender;
@end
