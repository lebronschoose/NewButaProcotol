//
//  CellArticle.h
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellArticleDelegate <NSObject>

-(void)DeleteActionByCell:(NSString *)indexNid;

@end

@interface CellArticle : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelBadge;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (copy ,nonatomic) NSString * NowNid;
@property (weak, nonatomic) id <CellArticleDelegate> delegate;

@end
