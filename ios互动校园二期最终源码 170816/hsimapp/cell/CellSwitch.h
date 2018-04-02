//
//  CellSwitch.h
//  hsimapp
//
//  Created by apple on 16/8/14.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSwitch : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (nonatomic, retain) NSNumber *ofChatID;
@property (nonatomic, assign) int cellTag;

- (IBAction)onSwitch:(id)sender;

@end
