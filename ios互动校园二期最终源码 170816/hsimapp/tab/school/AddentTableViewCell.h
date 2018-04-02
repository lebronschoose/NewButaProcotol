//
//  AddentTableViewCell.h
//  hsimapp
//
//  Created by dingding on 17/9/22.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *BeginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;


@property(nonatomic,strong)NSDictionary * dic;
@end
