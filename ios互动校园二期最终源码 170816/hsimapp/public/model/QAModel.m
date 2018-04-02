//
//  QAModel.m
//  hsimapp
//
//  Created by dingding on 17/9/17.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import "QAModel.h"
#import "NewQATableViewCell.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;


@implementation QAModel
{
    CGFloat _lastContentWidth;
}


@synthesize question = _question;



- (void)setquestion:(NSString *)question
{
    _question = question;
}
//
//
- (NSString *)question
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_question boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    
    return _question;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end
