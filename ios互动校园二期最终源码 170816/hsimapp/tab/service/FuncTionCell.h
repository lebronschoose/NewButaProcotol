//
//  FuncTionCell.h
//  TextCollectionView
//
//  Created by dingdingsmac on 15/11/23.
//  Copyright (c) 2015年 ynrcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncTionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
-(void)refreshImage:(UIImage *)newImage title:(NSString *)newTitle;
@end
