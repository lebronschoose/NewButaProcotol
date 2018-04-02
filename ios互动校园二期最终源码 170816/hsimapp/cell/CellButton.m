//
//  CellButton.m
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellButton.h"

@implementation CellButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    roundIt(self.buttonOK);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onButtonOK:(id)sender {
}
@end
