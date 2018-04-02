//
//  NewQATableViewCell.m
//  hsimapp
//
//  Created by dingding on 17/9/20.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import "NewQATableViewCell.h"
#import "UIView+SDAutoLayout.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";
#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

@implementation NewQATableViewCell
{
    UILabel * _questionContent;
     UIButton *_moreButton;
    UIImageView * _qImageView;
    UILabel * _nameLabel;
//    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
   
    UIButton * _CompleyButton;
    
    UILabel * _ansLabel;
    UIView * _backView;
    UILabel * _LineLabel;
    UILabel * _anameLabel;
    UILabel * _aTimeLabel;
    UIImageView * _aImageView;
//    SDTimeLineCellCommentView *_commentView;
//    SDTimeLineCellOperationMenu *_operationMenu;
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

- (void)setup
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    //    _iconView = [UIImageView new];
    

    
    _questionContent = [UILabel new];
    _questionContent.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _questionContent.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _questionContent.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor grayColor];
    
    _qImageView = [UIImageView new];
    _qImageView.image = [UIImage imageNamed:@"mh_defaultAvatar@2x.png"];
//    
//    _picContainerView = [SDWeiXinPhotoContainerView new];
//    
//    _commentView = [SDTimeLineCellCommentView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor grayColor];

    
    _CompleyButton = [UIButton new];
    [_CompleyButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_CompleyButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor colorFromHexString:@"#efeff4"];
    roundIt(_backView);
    
    _LineLabel = [UILabel new];
    _LineLabel.backgroundColor = [UIColor colorFromHexString:@"#D4D4D8"];
//    _LineLabel.backgroundColor = [UIColor redColor];
    
    _ansLabel = [UILabel new];
//    _ansLabel.backgroundColor = [UIColor colorFromHexString:@"#efeff4"];
    _ansLabel.font = [UIFont systemFontOfSize:14];
    _ansLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _ansLabel.font.lineHeight * 3;
    }
    
    _anameLabel = [UILabel new];
    _anameLabel.font = [UIFont systemFontOfSize:13];
    _anameLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];

    
    _aImageView = [UIImageView new];
    _aImageView.image = [UIImage imageNamed:@"mh_defaultAvatar@2x.png"];
    
    _aTimeLabel = [UILabel new];
    _aTimeLabel.font = [UIFont systemFontOfSize:13];
    _aTimeLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    NSArray *Subviews = @[_ansLabel, _LineLabel,_aImageView, _anameLabel, _aTimeLabel];

    [_backView sd_addSubviews:Subviews];
    
    
    NSArray *views = @[_questionContent, _moreButton,_qImageView, _nameLabel, _timeLabel, _CompleyButton, _backView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    //    _iconView.sd_layout
    //    .leftSpaceToView(contentView, margin)
    //    .topSpaceToView(contentView, margin + 5)
    //    .widthIs(40)
    //    .heightIs(40);
    

    
    _questionContent.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_questionContent)
    .topSpaceToView(_questionContent, 0)
    .widthIs(30);
    
    _qImageView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_moreButton, margin)
    .heightIs(18)
    .widthIs(18);

    
    _nameLabel.sd_layout
    .leftSpaceToView(_qImageView, margin)
    .topSpaceToView(_moreButton, margin)
    .heightIs(18);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _timeLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_qImageView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _CompleyButton.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    _backView.sd_layout
    .leftEqualToView(_questionContent)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
//    .heightIs(100);
    
    _ansLabel.sd_layout
    .leftSpaceToView(_backView,5)
    .rightSpaceToView(_backView, margin)
    .topSpaceToView(_backView, 6) // 已经在内部实现高度自适应所以不需要再设置高度
    .autoHeightRatio(0);
    
    _LineLabel.sd_layout
    .leftEqualToView(_backView)
//    .rightSpaceToView(_backView, margin)
    .topSpaceToView(_ansLabel, 6)
    .heightIs(1)
    .widthIs(ScreenWidth-2*margin);
    
    _aImageView.sd_layout
    .leftSpaceToView(_backView, 5)
    .topSpaceToView(_LineLabel, 5)
    .heightIs(18)
    .widthIs(18);
    
    _anameLabel.sd_layout
    .leftSpaceToView(_aImageView, 5)
    .topSpaceToView(_LineLabel, 5)
    .heightIs(18);
    [_anameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _aTimeLabel.sd_layout
    .rightSpaceToView(_backView, margin)
    .topSpaceToView(_LineLabel, 5)
    .heightIs(15);
    [_aTimeLabel setSingleLineAutoResizeWithMaxWidth:200];


    
}

-(void)setModel:(QAModel *)model
{
    _model = model;
    [_questionContent setText:model.question];
    [_nameLabel setText:model.qname];
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _questionContent.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _questionContent.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }

    [_timeLabel setText:model.qtime];
    if ([_Master isTeacher]) {
        if([NSString isBlankString:model.answer])
        {
            _CompleyButton.hidden = NO;
        }else
        {
            _CompleyButton.hidden = YES;
        }
    }else
    {
        _CompleyButton.hidden = YES;
        
    }
    NSString *a = model.answer;
     UIView *bottomView;
    if([NSString isBlankString:a])
    {
        _backView.hidden = YES;
        bottomView = _timeLabel;
    }else
    {
//        NSLog(@"_SDansLabel.height is %lf",_ansLabel.mas_height);
        _backView.hidden = NO;
        [_anameLabel setText:model.aname];
        [_aTimeLabel setText:model.atime];
        [_ansLabel setText:model.answer];
        
//        NSLog(@"_SDansLabel.height is %lf",_ansLabel.mas_height);

        [_backView setupAutoHeightWithBottomView:_ansLabel bottomMargin:35];
//        _backView.sd_layout.autoHeightRatio(0);

        bottomView = _backView;
        //        [cell.labelTimeA setHidden:NO];
    }
 
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)operationButtonClicked
{
//    [self postOperationButtonClickedNotification];
//    _operationMenu.show = !_operationMenu.isShowing;
    if (_delegate && [_delegate respondsToSelector:@selector(ComfrimActionBySelectedIndex:)]) {
        [_delegate ComfrimActionBySelectedIndex:self];
    }

}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
//    UIButton *btn = [notification object];
//    
//    if (btn != _operationButton && _operationMenu.isShowing) {
//        _operationMenu.show = NO;
//    }
}


@end
