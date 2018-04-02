//
//  ViewControllerInput.h
//  hsimapp
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"


enum EMINPUTTYPE
{
    emInputNone                 =   0,
    emChangeRealName            =   1,
    emChangeID                  =   2,
    emChangeNickName            =   3,
    emChangeEmail               =   4,
    emChangeMobile              =   5,
    emChangeSignText            =   6,
};

@interface ViewControllerInput : RootViewController
@property (weak, nonatomic) IBOutlet UITextView *textInput;
@property (weak, nonatomic) IBOutlet UIButton *btOK;

- (IBAction)onOK:(id)sender;
@end
