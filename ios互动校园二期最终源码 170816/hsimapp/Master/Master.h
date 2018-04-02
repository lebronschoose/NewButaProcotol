//
//  Master.h
//  HSEduApp
//
//  Created by han on 14/1/6.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSMessageObject.h"
#import "HSUserObject.h"
#import "HSSocket.h"

#define PACKAGE_HEADER          3
#define DEF_MSGBUFFERSIZE       65536

#define MAX_LOGO_SIZE           65000
#define MAX_CHAT_SIZE           60000

enum EMSOUNDTYPE
{
    emSoundSendMsg      = 0,
    emSoundRecvMsg      = 1,
};

@interface Master : NSObject
{
    HSSocket *tcpMaster;
    
    NSMutableData *m_recvDataPool;
    NSTimer *m_waitingTimer; BOOL m_bTimerDone;
    
    BOOL m_bSlientMsg;
    BOOL m_bSingleChatMsg;
    char *m_pZipBatchData;
    
    CGSize m_scrSize;
}
@property (nonatomic, retain) HSUserObject *mySelf;
@property (nonatomic, retain) HSUserObject *currentChatUser;
@property(nonatomic, retain) NSMutableDictionary *lastRequestTime;
@property (assign, nonatomic) int m_nTick;
@property (assign, nonatomic) BOOL bPlaySound;
@property (assign, nonatomic) BOOL bNetwokOKing;
@property (assign, nonatomic) BOOL bNeedForce2Update;

+ (Master *)sharedInstance;
+ (char *)createBuffer:(int)length;
+ (long long)fileSizeAtPath:(NSString*)filePath;

-(void)disconnectIMServer;

- (NSString *)image2File:(UIImage *)image ofType:(NSNumber *)type;
//- (void)uploadFile:(UIImage *)image withUUID:(NSString *)uploadUUID andType:(int)type andP:(id)p;
- (void)uploadFile:(UIImage *)image withUUID:(NSString *)uploadUUID andType:(int)type andP:(id)p start:(void(^)(NSDictionary *dict))blockStart progress:(void(^)(NSDictionary *dict))blockProgress finish:(void(^)(NSDictionary *dict))blockFinish error:(void(^)(NSDictionary *dict))blockError;

+(void)removeLogoFor:(id)who;

- (void)getServerInfo;
+(BOOL)isMobileNumber:(NSString *)mobileNum;
- (void)reqJsonFor:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed;
- (void)SubmitTo:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed;

- (BOOL)isChattingUser:(NSString *)userID;
- (CGSize)getScrSize;
- (void)setScrSize:(CGSize)size;

- (void)reqLogin:(NSString *)account andPassword:(NSString *)password;
+ (void)messageBox:(NSString *)pMsg withTitle: (NSString *)pTitle withOkText: (NSString *)okText;
- (void)back2Login;
- (void)startSocketTimer;

- (void)getJsonFrom:(NSString *)url success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed;

-(void)reqLoginIM;
- (void)reqSendChatMsg:(HSMessageObject *)msg;
- (BOOL)reqAddFriend:(NSString *)userID ofMsg:(NSString *)msg;
- (void)reqReplyAddFriend:(BOOL)bAgree ofUser:(NSString *)account;
- (void)reqUploadDeviceToken;
- (void)reqResetBadgeOnServer;
- (void)reqLoginOut;
- (void)reqFriendList;
- (BOOL)reqAbsentFrom:(NSDate *)sDate toDate:(NSDate *) eDate ofMsg:(NSString *)absentMsg;
- (void)reloadOffline;

- (void)getSelfData;
- (BOOL)isTeacher;
- (BOOL)isClassMaster;
- (BOOL)isSchoolMaster;
// 0: get my profile,
// 1: search friend,
// 2: view identify get detail,
// 3: get group user,
// 4: get user in friendlist
- (BOOL)reqUserData:(NSString *)userID ofType:(int)reqType oldFlag:(int)flag ofChatID:(int)chatID;
- (void)reqUpdateUserText:(NSString *)newStr ofType:(int)type;
- (void)reqGroupUserList:(NSNumber *)groupID;
- (void)reqDeleteFriend:(NSString *)userID;
- (void)reqSwitPushDetail:(BOOL)isOn;

///

+ (BOOL)isP2PChat:(int)iChatID;
+ (BOOL)isPublicGroup:(int)iChatID;
+ (BOOL)isHyperLink:(int)iChatID;
+ (BOOL)isSysNotify:(int)iChatID;
+ (BOOL)isConfigItem:(int)iChatID;
+ (BOOL)isGroup:(int)iChatID;


- (void)makeASound:(enum EMSOUNDTYPE)type;
- (void)changeChatTarget:(HSUserObject *)aUser;
- (void)lookUpBadge;

@end
