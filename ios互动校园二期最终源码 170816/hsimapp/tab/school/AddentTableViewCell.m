//
//  AddentTableViewCell.m
//  hsimapp
//
//  Created by dingding on 17/9/22.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import "AddentTableViewCell.h"

@implementation AddentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [self.NameLabel setText:[_dic objectForKey:@"studentname"]];
    [self.BeginTime setText:[NSString stringWithFormat:@"开始时间:%@",[_dic objectForKey:@"from"]]];
    [self.endTime setText:[NSString stringWithFormat:@"截止时间:%@",[_dic objectForKey:@"to"]]];


    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
