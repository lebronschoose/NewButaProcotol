//
//  ViewControllerNewHomework.h
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerNewHomework : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *textClass;
@property (weak, nonatomic) IBOutlet UITextField *textCourse;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UIButton *btOK;

- (IBAction)onInputContent:(id)sender;
- (IBAction)onOK:(id)sender;
@end
