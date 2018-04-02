//
//  QuestionDetailTableViewCell.m
//  hsimapp
//
//  Created by dingding on 2018/1/19.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "QuestionDetailTableViewCell.h"

@implementation QuestionDetailTableViewCell
{
    UIImageView * titleImage;
    UILabel * ContentLabel;
    UILabel * timeLabel;
    UILabel * NameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setup
{
    titleImage = [UIImageView new];
    [self addSubview:titleImage];
//    titleImage.image = [UIImage imageNamed:@"ansnser"];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(25);
        make.top.left.equalTo(@20);
    }];
    ContentLabel = [UILabel new];
    ContentLabel.text = @"一二三四五六七八九一二三四五六七八九";
    ContentLabel.preferredMaxLayoutWidth = ScreenWidth -15;
    [ContentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    ContentLabel.numberOfLines = 0;
    [ContentLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [self addSubview:ContentLabel];

    [ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(22);
        make.left.equalTo(titleImage.mas_right).offset(5);
        make.right.mas_equalTo(-10.0);
    }];
    
    timeLabel = [UILabel new];
    timeLabel.text = @"2017/1/19 15:33";
    timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLabel];
//    timeLabel.text = tstrng;
    timeLabel.font = [UIFont systemFontOfSize:12];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-30);
        //        make.height.equalTo(@35);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10.0);
    }];
    
    NameLabel = [UILabel new];
    NameLabel.textAlignment = NSTextAlignmentRight;
    NameLabel.text = @"互动校园客服妹妹";
    [self addSubview:NameLabel];
    NameLabel.textColor = MAINCOLOR;
    NameLabel.font = [UIFont systemFontOfSize:13];
    [NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(120);
        make.right.mas_equalTo(-10.0);
    }];

}

-(void)setModel:(QustionDmodel *)model
{
    _model  = model;
    ContentLabel.text = model.content;
    if ([model.type isEqualToString:@"0"]) {
        titleImage.image = [UIImage imageNamed:@"qusetion"];
        NameLabel.text = _Master.mySelf.realName;
    }else
    {
        titleImage.image = [UIImage imageNamed:@"ansnser"];
        NameLabel.text = @"互动校园客服妹妹";
    }
    timeLabel.text = model.time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
