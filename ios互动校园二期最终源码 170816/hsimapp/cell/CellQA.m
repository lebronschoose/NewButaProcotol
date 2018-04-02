//
//  CellQA.m
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellQA.h"

@implementation CellQA

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        //设置主题
//        [self configTheme];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    roundIt(self.backView);
    
    [self.labelQ setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGSize)sizeForQ:(NSString *)text
{
    CGRect rx = [UIScreen mainScreen ].bounds;
    
    //    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
    //                       constrainedToSize:CGSizeMake((rx.size.width - 64 - 16), rx.size.height)
    //                           lineBreakMode:NSLineBreakByWordWrapping];
    //    textSize.height += 16;
    //    return textSize;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(rx.size.width - 24, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    rect.size.height += 16;
    return rect.size;
}

+ (CGSize)sizeForA:(NSString *)text
{
    CGRect rx = [UIScreen mainScreen ].bounds;
    
    //    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
    //                       constrainedToSize:CGSizeMake((rx.size.width - 64 - 16), rx.size.height)
    //                           lineBreakMode:NSLineBreakByWordWrapping];
    //    textSize.height += 16;
    //    return textSize;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(rx.size.width - 64, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    rect.size.height += 16;
    return rect.size;
}
- (IBAction)CellAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ComfrimActionBySelectedIndex:)]) {
        [_delegate ComfrimActionBySelectedIndex:self.selectedIndex];
    }
}

@end
