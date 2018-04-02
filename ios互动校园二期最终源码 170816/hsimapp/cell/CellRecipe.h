//
//  CellRecipe.h
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellRecipe : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

+ (CGSize)sizeForText:(NSString *)text;

@end
