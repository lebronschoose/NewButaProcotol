//
//  CellTotalAction.m
//  hsimapp
//
//  Created by apple on 16/12/20.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellTotalAction.h"

@implementation CellTotalAction

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    roundIt(self.btTotal);
    roundIt(self.btIn);
    roundIt(self.btOut);
    roundIt(self.btUnkown);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
