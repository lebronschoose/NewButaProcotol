//
//  chatMsgCell.m
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "chatMsgCell.h"
#import "HSMessageObject.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation chatMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _showTime = NO;
        _showNickName = NO;
        // Initialization code
        _userHead = [[UIButton alloc] initWithFrame:CGRectZero];
        //_userHead = [[[UIImageView alloc]initWithFrame:CGRectZero];
        _sendingButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _bubbleBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _messageFrom = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageConent= [[UILabel alloc] initWithFrame:CGRectZero];
        //_headMask = [[UIImageView alloc] initWithFrame:CGRectZero];
        _chatImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [_userHead addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        [_sendingButton addTarget:self action:@selector(btnSendClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        
        [_messageFrom setBackgroundColor:[UIColor clearColor]];
        [_messageFrom setFont:[UIFont systemFontOfSize:12]];
        [_messageFrom setNumberOfLines:1];
        
        [_messageTime setBackgroundColor:[UIColor clearColor]];
        [_messageTime setTextColor:[UIColor grayColor]];
        [_messageTime setFont:[UIFont systemFontOfSize:12]];
        [_messageTime setNumberOfLines:1];
        [_messageTime setTextAlignment:NSTextAlignmentCenter];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_sendingButton];
        //[self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageFrom];
        [self.contentView addSubview:_messageTime];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        
        [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}

-(void)btnSendClicked:(id)sender event:(id)event
{
//    NSLog(@"resend button click");
    if(self.iSendState != 2) return;
    [_HSCore signMessageState:[self.ofMessage.messageTimeFlag intValue] ofState:0];
    [_HSCore pushUnSendMsg:self.ofMessage.messageTimeFlag ofChatID:self.ofMessage.messageChatID];
    [_Master reqSendChatMsg:[self ofMessage]];
}

-(void)btnClicked:(id)sender event:(id)event
{
//    NSLog(@"button click");
    if(self.fromWhom != nil)
    {
        PostMessage(hsNotificationNeedShowDetail, self.fromWhom);
    }
}

-(void)showNickName:(BOOL)bShow ofNick:(NSString *)nickName
{
    [self setNickName:nickName];
    _showNickName = bShow;
}

-(void)showTime:(BOOL)bShow ofTime:(NSDate *)date
{
    NSString *strTime = [HSCoreData stringByDate:date withYear:YES];
    [self setStrTime:strTime];
    _showTime = bShow;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *orgin = _messageConent.text;
    CGSize textSize = [orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_messageTime setHidden:YES];
    [_messageTime setFrame:CGRectMake(0, 0, CELL_WIDTH, 18)];
    switch (_msgStyle)
    {
        case kWCMessageCellStyleMe: // msg right, mine
            [_chatImage setHidden:YES];
            [_messageFrom setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            break;
        case kWCMessageCellStyleOther:
            [_chatImage setHidden:YES];
            [_messageFrom setFrame:CGRectMake(INSETS+HEAD_SIZE+INSETS+2*INSETS, 4, CELL_WIDTH, 18)];
            [_messageFrom setHidden:YES];
            [_messageConent setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS, HEAD_SIZE, HEAD_SIZE)];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            break;
        case kWCMessageCellStyleMeWithImage:
            [_chatImage setHidden:NO];
            [_sendingButton setHidden:YES];
            [_messageFrom setHidden:YES];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame = CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
            break;
        case kWCMessageCellStyleOtherWithImage:
            [_chatImage setHidden:NO];
            [_sendingButton setHidden:YES];
            [_messageFrom setFrame:CGRectMake(INSETS+HEAD_SIZE+INSETS+2*INSETS, 4, CELL_WIDTH, 18)];
            [_messageFrom setHidden:YES];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
            break;
        default:
            break;
    }
    if(_showNickName && (_msgStyle == kWCMessageCellStyleOther || _msgStyle == kWCMessageCellStyleOtherWithImage))
    {
        [_messageFrom setText:self.nickName];
        [_messageFrom setHidden:NO];
        if(YES)
        {
            CGRect rt = [_bubbleBg frame];
            rt.origin.y += NICK_MOVE;
            [_bubbleBg setFrame:rt];
        }
        if(YES)
        {
            CGRect rt = [_messageConent frame];
            rt.origin.y += NICK_MOVE;
            [_messageConent setFrame:rt];
        }
        if(YES)
        {
            CGRect rt = [_chatImage frame];
            rt.origin.y += NICK_MOVE;
            [_chatImage setFrame:rt];
        }
    }
    if(_showTime)
    {
        [_messageTime setText:self.strTime];
        [_messageTime setHidden:NO];
        
        int moveDown = 12;
        if(YES)
        {
            CGRect rt = [_messageFrom frame];
            rt.origin.y += moveDown;
            [_messageFrom setFrame:rt];
        }
        if(YES)
        {
            CGRect rt = [_bubbleBg frame];
            rt.origin.y += moveDown;
            [_bubbleBg setFrame:rt];
        }
        if(YES)
        {
            CGRect rt = [_messageConent frame];
            rt.origin.y += moveDown;
            [_messageConent setFrame:rt];
        }
        if(YES)
        {
            CGRect rt = [_chatImage frame];
            rt.origin.y += moveDown;
            [_chatImage setFrame:rt];
        }
    }
    if(_msgStyle == kWCMessageCellStyleMe || _msgStyle == kWCMessageCellStyleMeWithImage)
    {
        if(_iSendState == 1) [_sendingButton setHidden:YES];
        else
        {
            CGRect rt = [_messageConent frame];
            [_sendingButton setHidden:NO];
            [_sendingButton setFrame:CGRectMake(
                                                _bubbleBg.frame.origin.x - SENDICON,
                                                _bubbleBg.frame.origin.y + (_bubbleBg.frame.size.height - SENDICON) / 2.0f - 4,
                                                SENDICON, SENDICON)];
            [_sendingButton setFrame:CGRectMake(
                                                _bubbleBg.frame.origin.x - SENDICON,
                                                rt.origin.y + (rt.size.height - SENDICON) / 2.0f,
                                                SENDICON, SENDICON)];
            if(_iSendState == 0)
            {
                [_sendingButton setImage:[UIImage imageNamed:@"msgSending"] forState:UIControlStateNormal];
            }
            else
            {
                [_sendingButton setImage:[UIImage imageNamed:@"msgSendFailed"] forState:UIControlStateNormal];
            }
        }
    }
    roundIt(_userHead);
   // _headMask.frame = CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setContentText:(NSString *)content
{
    //NSString *newContent = [NSString stringWithFormat:@"%@\n%@", content, self.ofMessage.messageDate];
    [_messageConent setText:content];
}

-(void)setMessageObject:(HSMessageObject *)aMessage ofType:(BOOL)isNotify
{
    [self setOfMessage:aMessage];
    int msgType = [aMessage.messageType intValue];
    if(isNotify)
    {
        switch(msgType)
        {
            case kWCMessageTypeLocation:
            {
                BOOL bValid = YES;
                NSRange range = [aMessage.messageContent rangeOfString:@";"];
                if(range.location != NSNotFound)
                {
                    NSString *b1 = [aMessage.messageContent substringFromIndex:range.location + range.length];//开始截取
                    range = [b1 rangeOfString:@";"];
                    if(range.location != NSNotFound)
                    {
                        bValid = YES;
                        NSString *b2 = [b1 substringFromIndex:range.location + range.length];//开始截取
                        NSString *newContent = [NSString stringWithFormat:@"%@ (点击查看位置)", b2];
                        [self setContentText:newContent];
                        [_messageConent setTextColor:[UIColor blueColor]];
                    }
                    else bValid = NO;
                }
                else bValid = NO;
                if(bValid == NO)
                {
                    [self setContentText:aMessage.messageContent];
                }
                return;
                break;
            }
            case kWCMessageTypeSystemNotifyURL:
            {
                NSRange range = [aMessage.messageContent rangeOfString:@";"];
                if(range.location != NSNotFound)
                {
                    NSString *b = [aMessage.messageContent substringFromIndex:range.location + range.length];//开始截取
                    NSString *newContent = [NSString stringWithFormat:@"%@ (点击查看)", b];
                    [self setContentText:newContent];
                    [_messageConent setTextColor:[UIColor blueColor]];
                }
                else
                {
                    [self setContentText:aMessage.messageContent];
                }
                return;
                break;
            }
            default:
                break;
        }
        [self setContentText:aMessage.messageContent];
        return;
    }
    switch (msgType)
    {
        case kWCMessageTypeP2PRefuse:
            [self setContentText:@"发送消息被拒绝。或许您已不在对方通讯录中。"];
            return;
            break;
        case kWCMessageTypeP2PAuthration:
            [self setContentText:[NSString stringWithFormat:@"(已同意)请求添加到通讯录:%@", aMessage.messageContent]];
            return;
            break;
        case kWCMessageTypeP2PAuthrationOK:
            [self setContentText:@"我通过了你的请求，已成功添加到通讯录。"];
            return;
            break;
        case kWCMessageTypeP2PAuthrationReject:
            break;
        case kWCMessageTypeP2PDelete:
            break;
        default:
            break;
    }
    [self setContentText:aMessage.messageContent];
}

-(void)setHeadImage:(UIImage*)headImage
{
    //[_userHead setImage:headImage];
    [_userHead setBackgroundImage:headImage forState:UIControlStateNormal];
}

-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
}

@end
