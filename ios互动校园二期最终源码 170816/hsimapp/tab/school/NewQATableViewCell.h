//
//  NewQATableViewCell.h
//  hsimapp
//
//  Created by dingding on 17/9/20.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAModel.h"
@protocol NewCellQADelegate <NSObject>

-(void)ComfrimActionBySelectedIndex:(UITableViewCell *)cell;

@end

@class QAModel;


@interface NewQATableViewCell : UITableViewCell
@property (nonatomic, strong) QAModel *model;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(weak,nonatomic) id<NewCellQADelegate>delegate;
@end
