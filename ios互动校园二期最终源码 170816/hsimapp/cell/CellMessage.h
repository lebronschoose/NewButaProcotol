//
//  CellMessage.h
//  hsimapp
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CellMessage : UITableViewCell
@property (weak, nonatomic) IBOutlet EGOImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *labelBadge;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (retain, nonatomic) NSString *imageNameString;

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL;
@end
