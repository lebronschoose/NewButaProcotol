//
//  ViewControllerViewIdentify.h
//  hsimapp
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"
#import "EGOImageView.h"

@interface ViewControllerViewIdentify : RootViewController
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet EGOImageView *imageLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *textText;
@property (weak, nonatomic) IBOutlet UIButton *btAgree;
@property (weak, nonatomic) IBOutlet UIButton *btRefuse;
- (IBAction)onAgree:(id)sender;
- (IBAction)onRefuse:(id)sender;

@end
