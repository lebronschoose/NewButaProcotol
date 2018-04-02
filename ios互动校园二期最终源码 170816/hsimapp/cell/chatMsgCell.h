//
//  chatMsgCell.h
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMessageObject.h"

//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f
#define SENDICON 24.0f

#define NICK_MOVE       4

@interface chatMsgCell : UITableViewCell
{
    //UIImageView *_userHead;
    UIButton *_userHead;
    UIButton *_sendingButton;
    UIImageView *_bubbleBg;
    //UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageFrom;
    UILabel *_messageConent;
    UILabel *_messageTime;
}
@property (nonatomic) enum kWCMessageCellStyle msgStyle;
@property (nonatomic) int height;
@property (nonatomic) int iSendState; // 0 : sending 1 : ok 2 : failed.
@property (assign, nonatomic) BOOL showNickName;
@property (assign, nonatomic) BOOL showTime;
@property (retain, nonatomic) HSUserObject *fromWhom;
@property (retain, nonatomic) NSString *nickName;
@property (retain, nonatomic) NSString *strTime;
@property (retain, nonatomic) HSMessageObject *ofMessage;
-(void)setMessageObject:(HSMessageObject*)aMessage ofType:(BOOL)isNotify;
-(void)setHeadImage:(UIImage*)headImage;
-(void)setChatImage:(UIImage *)chatImage;
-(void)showNickName:(BOOL)bShow ofNick:(NSString *)nickName;
-(void)showTime:(BOOL)bShow ofTime:(NSDate *)date;

@end
