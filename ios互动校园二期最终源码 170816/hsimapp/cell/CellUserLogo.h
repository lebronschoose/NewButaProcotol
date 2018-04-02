//
//  CellUserLogo.h
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CellUserLogo : UITableViewCell
@property (weak, nonatomic) IBOutlet EGOImageView *imageLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (retain, nonatomic) NSString *imageNameString;

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL;

@end
