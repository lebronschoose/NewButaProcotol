//
//  ViewControllerIdentify.h
//  hsimapp
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"
#import "EGOImageView.h"

@interface ViewControllerIdentify : RootViewController
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet EGOImageView *imageLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UITextField *textIdentify;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
- (IBAction)onAdd:(id)sender;

@end
