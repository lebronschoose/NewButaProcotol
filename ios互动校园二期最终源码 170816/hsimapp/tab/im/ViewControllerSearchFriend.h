//
//  ViewControllerSearchFriend.h
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerSearchFriend : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UIButton *btSearch;
- (IBAction)onSearch:(id)sender;

@end
