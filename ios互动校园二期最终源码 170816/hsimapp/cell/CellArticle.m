//
//  CellArticle.m
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellArticle.h"

@implementation CellArticle

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    roundcycle(self.labelBadge);
    self.labelBadge.backgroundColor = [UIColor clearColor];
    self.labelBadge.layer.backgroundColor = [UIColor redColor].CGColor;
    
    self.labelBadge.layer.zPosition = 1000;
    [self.labelBadge setText:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deletebtnaction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(DeleteActionByCell:)]) {
        [_delegate DeleteActionByCell:_NowNid];
    }
}

@end
