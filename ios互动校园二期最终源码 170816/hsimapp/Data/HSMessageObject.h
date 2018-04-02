//
//  HSMessageObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"
#define kMESSAGE_ID @"messageId"
#define kMESSAGE_CHATID @"messageChatID"
#define kMESSAGE_TIMEFLAG @"messageTimeFlag"

enum kWCMessageType
{
    kWCMessageTypePlain                 = 0,
    kWCMessageTypeImage                 = 1,
    kWCMessageTypeVoice                 = 2,
    kWCMessageTypeLocation              = 3,
    
    kWCMessageTypeGroupAuthration       = 10,
    kWCMessageTypeGroupAuthrationOK     = 11,
    kWCMessageTypeGroupAuthrationReject = 12,
    kWCMessageTypeGroupDelete           = 13,
    
    kWCMessageTypeP2PAuthration         = 14,
    kWCMessageTypeP2PAuthrationOK       = 15,
    kWCMessageTypeP2PAuthrationReject   = 16,
    kWCMessageTypeP2PDelete             = 17,
    
//	kWCMessageTypeGuardianSuccess		= 18, // remove guardian from user, and notify him
//	kWCMessageTypeGuardianRemoved		= 19, // remove guardian from user, and notify him
//	kWCMessageTypeBindSuccess			= 20,
//	kWCMessageTypeBindRemoved			= 21,
//	kWCMessageTypeReqBecomeFamily		= 22, // someone request to be a family of a student
//	kWCMessageTypeResBecomeFamily0		= 23, // response for it
//	kWCMessageTypeResBecomeFamily1		= 24, // response for it
    
	kWCMessageTypeSystemNotifyNormal	= 25,
	kWCMessageTypeSystemNotifyURL		= 26,
	kWCMessageTypeP2PRefuse             = 27,
};
enum kWCMessageState
{
    kWCMessageTextSending               = 0,
    kWCMessageTextSuccess               = 1,
    kWCMessageTextFailed                = 2,
    
    kWCMessageImageReady                = 10,
    kWCMessageImageSending              = 11,
    kWCMessageImageSuccess              = 12,
    kWCMessageImageFailed               = 13,
};

enum kWCMessageCellStyle
{
    kWCMessageCellStyleMe = 0,
    kWCMessageCellStyleOther = 1,
    kWCMessageCellStyleMeWithImage=2,
    kWCMessageCellStyleOtherWithImage=3
};

@interface HSMessageObject : NSObject
@property (nonatomic,retain) NSString *messageFrom;
@property (nonatomic,retain) NSString *messageTo;
@property (nonatomic,retain) NSString *messageContent;
@property (nonatomic,retain) NSDate *messageDate;
@property (nonatomic,retain) NSNumber *messageType;
@property (nonatomic,retain) NSNumber *messageId;
@property (nonatomic,retain) NSNumber *messageChatID;
@property (nonatomic,retain) NSNumber *messageTimeFlag;

// 0 : 刚刚发送，还没成功， 1 ： 发送成功了，服务器确认了， 2 ： 发送失败了，需要重发
// image
//          10  消息已经生成，准备提交upload
//          11  消息已经生成，并提交upload
//          12  消息upload完毕，upload finish的时候
//          13  消息upload错误，需要重发
@property (nonatomic,retain) NSNumber *messageState;
//@property (nonatomic,retain) NSNumber *hasSuccess;
@property (nonatomic,retain) NSNumber *hasOperate;

@property (nonatomic,retain) NSString *bindImagePath;
@property (nonatomic,retain) NSString *uploadUUID;

-(BOOL)isHasOperate;

+(HSMessageObject *)messageFromDataSet:(FMResultSet *)rs;
+(HSMessageObject *)messageWithType:(int)aType;

@end
