//
//  CellQA.h
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CellQADelegate <NSObject>

-(void)ComfrimActionBySelectedIndex:(NSIndexPath *)index;

@end
@interface CellQA : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *labelQ;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthorQ;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeQ;

@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UIButton *ComplyBtn;
@property(weak,nonatomic) id<CellQADelegate>delegate;
@property (strong,nonatomic) NSIndexPath * selectedIndex;


+ (CGSize)sizeForQ:(NSString *)text;
+ (CGSize)sizeForA:(NSString *)text;

@end
