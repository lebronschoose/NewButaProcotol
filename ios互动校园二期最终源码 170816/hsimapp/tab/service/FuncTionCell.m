//
//  FuncTionCell.m
//  TextCollectionView
//
//  Created by dingdingsmac on 15/11/23.
//  Copyright (c) 2015年 ynrcc. All rights reserved.
//

#import "FuncTionCell.h"

@implementation FuncTionCell

-(void)refreshImage:(UIImage *)newImage title:(NSString *)newTitle
{
    self.ImageView.image = newImage;
    [_ImageView sizeToFit];
    self.TitleLabel.text = newTitle;
    _TitleLabel.textAlignment = NSTextAlignmentCenter;
    _TitleLabel.font = [UIFont systemFontOfSize:14];
    [_TitleLabel sizeToFit];
}
- (void)awakeFromNib {
    // Initialization code
}

@end
