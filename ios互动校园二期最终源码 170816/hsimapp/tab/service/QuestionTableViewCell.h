//
//  QuestionTableViewCell.h
//  hsimapp
//
//  Created by dingding on 2018/1/16.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuestionTableViewCellDelegate <NSObject>

-(void)ComfrimActionBySelectedIndex:(UITableViewCell *)cell;

@end

@interface QuestionTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary * postdic;
@property(weak,nonatomic) id<QuestionTableViewCellDelegate>delegate;
@end
