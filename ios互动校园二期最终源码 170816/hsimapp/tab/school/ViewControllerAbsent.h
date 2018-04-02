//
//  ViewControllerAbsent.h
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerAbsent : RootViewController

@property (retain, nonatomic) IBOutlet UITextView *absentMsg;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
@property (retain, nonatomic) IBOutlet UIDatePicker *endDate;
@property (retain, nonatomic) IBOutlet UIDatePicker *startDate;
@property (retain, nonatomic) IBOutlet UITextField *textStartDate;
@property (retain, nonatomic) IBOutlet UITextField *textEndDate;
- (IBAction)OnBtAbsent:(id)sender;
@end
