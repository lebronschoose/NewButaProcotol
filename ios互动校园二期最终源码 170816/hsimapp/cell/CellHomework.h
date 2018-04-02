//
//  CellHomework.h
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CellHomework : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet EGOImageView *imgAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelCourse;
@property (weak, nonatomic) IBOutlet UILabel *labelHomework;

+ (CGSize)sizeForText:(NSString *)text;

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL;

@end
