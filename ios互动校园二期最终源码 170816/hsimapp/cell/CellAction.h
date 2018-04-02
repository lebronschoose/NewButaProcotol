//
//  CellAction.h
//  hsimapp
//
//  Created by apple on 16/7/3.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAction : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAction;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property(strong,nonatomic) NSDictionary * dict;
@end
