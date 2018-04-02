//
//  ViewControllerForget1.h
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerForget1 : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTIP1;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP2;
@property (weak, nonatomic) IBOutlet UILabel *labelTIP3;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UIButton *btNext;
@property (weak, nonatomic) IBOutlet UIButton *btBack;

@property (copy,nonatomic) NSString * PushType;

- (IBAction)onNext:(id)sender;
- (IBAction)btBack:(id)sender;

@end
