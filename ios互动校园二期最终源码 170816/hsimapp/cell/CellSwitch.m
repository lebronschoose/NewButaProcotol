//
//  CellSwitch.m
//  hsimapp
//
//  Created by apple on 16/8/14.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellSwitch.h"

@implementation CellSwitch

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSwitch:(id)sender
{
    //
    switch (self.cellTag)
    {
        case 0:
            if(self.switchButton.isOn == YES)
            {
//                NSLog(@"SWitch new msg prompt to YES.");
            }
            else
            {
//                NSLog(@"SWitch new msg prompt to NO.");
            }
            [_HSCore setPromptMsgOfChatID:self.ofChatID ofPrompt:self.switchButton.isOn];
            break;
        case 1:
            if(self.switchButton.isOn == YES)
            {
//                NSLog(@"SWitch show name to YES.");
            }
            else
            {
//                NSLog(@"SWitch show name to NO.");
            }
            [_HSCore setShowNickOfChatID:self.ofChatID ofShow:self.switchButton.isOn];
            break;
            
        case -1:
//            NSLog(@"swiddd");
            [_HSCore setPromptMsgOfChatID:self.ofChatID ofPrompt:self.switchButton.isOn];
            break;
        case -2:
//            NSLog(@"swidnns");
            [_Master reqSwitPushDetail:self.switchButton.isOn];
            break;
        default:
            break;
    }
}
@end
