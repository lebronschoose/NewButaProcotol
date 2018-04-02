//
//  CellRecipe.m
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellRecipe.h"

@implementation CellRecipe

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    roundIt(self.backView);
    roundIt(self.backView2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGSize)sizeForText:(NSString *)text
{
    CGRect rx = [UIScreen mainScreen ].bounds;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(rx.size.width - 24, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    rect.size.height += 16;
    return rect.size;
}

@end
