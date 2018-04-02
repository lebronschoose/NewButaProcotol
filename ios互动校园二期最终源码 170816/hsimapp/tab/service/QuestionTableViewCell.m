//
//  QuestionTableViewCell.m
//  hsimapp
//
//  Created by dingding on 2018/1/16.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "QuestionTableViewCell.h"
@implementation QuestionTableViewCell
{
    UIImageView * AnserIma;
    UILabel * anserLabel;
    UIImageView * QusetionIma;
    UILabel * QusetionLabel;
    UILabel * QtimeLabel;
    UIButton * QuersBtn;
    
    NSString * qstring;
    NSString * astrng;
    NSString * tstrng;
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

    QusetionIma = [UIImageView new];
    QusetionIma.image = [UIImage imageNamed:@"qusetion"];
    [self addSubview:QusetionIma];
    [QusetionIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.top.left.equalTo(self).offset(20);
        
    }];
    
    QusetionLabel = [UILabel new];
    NSLog(@"qsting is %@",qstring);
//    QusetionLabel.text = qstring;
    QusetionLabel.preferredMaxLayoutWidth = ScreenWidth -15;
    [QusetionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    QusetionLabel.numberOfLines = 0;
    [QusetionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [self addSubview:QusetionLabel];
    [QusetionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(22);
//        make.height.equalTo(@35);
        make.left.equalTo(QusetionIma.mas_right).offset(5);
        make.right.mas_equalTo(-10.0);
    }];
    
    
        AnserIma = [UIImageView new];
        AnserIma.image = [UIImage imageNamed:@"ansnser"];
        [self addSubview:AnserIma];
        [AnserIma mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.top.equalTo(QusetionLabel.mas_bottom).offset(15);
            make.left.equalTo(self).offset(20);
            
        }];
        
        anserLabel = [UILabel new];
//        anserLabel.text = astrng;
        anserLabel.preferredMaxLayoutWidth = ScreenWidth -10 *2;
        [anserLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        anserLabel.numberOfLines = 0;
        anserLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:anserLabel];
        [anserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(QusetionLabel.mas_bottom).offset(18);
            //        make.height.equalTo(@35);
            make.left.equalTo(AnserIma.mas_right).offset(10);
            make.right.mas_equalTo(-10.0);
        }];
    
   
    QtimeLabel = [UILabel new];
    QtimeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:QtimeLabel];
    QtimeLabel.text = tstrng;
    QtimeLabel.font = [UIFont systemFontOfSize:12];
    [QtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-30);
        //        make.height.equalTo(@35);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10.0);
    }];

    QuersBtn = [UIButton new];
    QuersBtn.layer.cornerRadius = 2;
    [self addSubview:QuersBtn];
   
    [QuersBtn setBackgroundColor:[UIColor colorFromHexString:@"#00bb54"]];
    QuersBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [QuersBtn addTarget:self action:@selector(TouchAction) forControlEvents:UIControlEventTouchUpInside];
    [QuersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QuersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.right.mas_equalTo(-10.0);
    }];

}

-(void)TouchAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(ComfrimActionBySelectedIndex:)]) {
        [_delegate ComfrimActionBySelectedIndex:self];
    }
}

-(void)setPostdic:(NSDictionary *)postdic
{
    NSLog(@"dic is %@",postdic);

    _postdic = postdic;
        NSArray * detailarr = _postdic[@"detailed"];
        if (detailarr.count == 1) {
            AnserIma.hidden = YES;
            anserLabel.hidden = YES;
            QuersBtn.hidden = YES;
            NSDictionary * questiondic = detailarr[0];
            qstring = questiondic[@"content"];
            tstrng = questiondic[@"time"];
        }else
        {
            AnserIma.hidden = NO;
            anserLabel.hidden = NO;
            QuersBtn.hidden = NO;
            NSDictionary * dict = [NSDictionary dictionary];
            NSDictionary * dict1 = [NSDictionary dictionary];
            dict = detailarr[0];
            dict1 = detailarr[1];
            qstring = dict[@"content"];
            astrng = dict1[@"content"];
            tstrng = dict1[@"time"];

        }
    
    QusetionLabel.text = qstring;
    QtimeLabel.text = tstrng;
     [QuersBtn setTitle:[NSString stringWithFormat:@"全部%@个回答",_postdic[@"count"]] forState:UIControlStateNormal];
    anserLabel.text = astrng;
    
    
}


@end
