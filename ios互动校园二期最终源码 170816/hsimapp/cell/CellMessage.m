//
//  CellMessage.m
//  hsimapp
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellMessage.h"

@implementation CellMessage

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
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
        [self.image setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    [self setImageNameString:imgURL]; // save it for fether use, click to view detail image etc.
    
    [self.image setImageURL:[NSURL URLWithString:imgURL]];
}

@end
