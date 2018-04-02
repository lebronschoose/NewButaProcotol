//
//  CellHomework.m
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellHomework.h"

@implementation CellHomework

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    roundIt(self.backView);
    roundIt(self.labelHomework);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGSize)sizeForText:(NSString *)text
{
    CGRect rx = [UIScreen mainScreen ].bounds;
    
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                          constrainedToSize:CGSizeMake((rx.size.width - 80), rx.size.height)
                              lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL
{
    if(defaultLog != nil)
    {
        [self.imgAuthor setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    
    [self.imgAuthor setImageURL:[NSURL URLWithString:imgURL]];
}

@end
