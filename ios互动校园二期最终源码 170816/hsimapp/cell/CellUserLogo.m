//
//  CellUserLogo.m
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellUserLogo.h"

@implementation CellUserLogo

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    roundIt(self.imageLogo);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL
{
    if(defaultLog != nil)
    {
        [self.imageLogo setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    [self setImageNameString:imgURL]; // save it for fether use, click to view detail image etc.
    
    [self.imageLogo setImageURL:[NSURL URLWithString:imgURL]];
}

@end
