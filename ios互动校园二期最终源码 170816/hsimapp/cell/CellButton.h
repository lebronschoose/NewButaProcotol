//
//  CellButton.h
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonOK;
- (IBAction)onButtonOK:(id)sender;

@end
