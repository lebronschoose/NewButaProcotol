//
//  ViewControllerNewNotice.h
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerNewNotice : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *textNoticeType;
@property (weak, nonatomic) IBOutlet UITextField *textNoticeTo;
@property (weak, nonatomic) IBOutlet UITextField *textNoticeTitle;
@property (weak, nonatomic) IBOutlet UITextView *textNoticeContent;
@property (weak, nonatomic) IBOutlet UIButton *btOK;

- (IBAction)onInputContent:(id)sender;
- (IBAction)onOK:(id)sender;
@end
