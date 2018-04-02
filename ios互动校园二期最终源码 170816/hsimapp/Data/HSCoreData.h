//
//  HSCoreData.h
//  HSIMApp
//
//  Created by han on 14/1/14.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSPublicGroupObject.h"
#import "HSIMessageObject.h"
#import "HSMessageObject.h"

@interface HSCoreData : NSObject

@property(retain, nonatomic)NSMutableArray  *m_notifyMessageList;
@property(retain, nonatomic)NSMutableArray  *m_publicIMessageList;
@property(retain, nonatomic)NSMutableArray  *m_privateIMessageList;
@property(retain, nonatomic)NSMutableArray  *m_sysNotify;
@property(retain, nonatomic)NSMutableArray  *m_publicGroup;
@property(retain, nonatomic)NSMutableArray  *m_configItems;
@property(retain, nonatomic)NSMutableDictionary  *m_allUserList;
@property(assign, nonatomic)NSMutableDictionary  *m_serviceDataList;
@property(retain, nonatomic)NSMutableDictionary  *m_serviceWinTitle;

+(NSData *)compressData: (NSData*)uncompressedData;
+(NSData *)decompressData:(NSData *)compressedData;

+(HSCoreData *)sharedInstance;
+(NSString *)stringByDate:(NSDate *)date withYear:(BOOL)bWithYear;
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)dateNoYear:(NSString *)strDate;
+(NSString *)stringOfMinuteByDate:(NSDate *)date;

-(void)clearData;
-(BOOL)pushFriendListIntoDB:(char *)pData;
-(BOOL)addNewFriendIntoDB:(HSUserObject *)aUser ofChatID:(NSNumber *)chatID isFullData:(BOOL)fullData isReload:(BOOL)reload;;
-(NSMutableArray *)userListForChatID:(NSNumber *)chatID;
-(void)showFriendInIM:(BOOL)bShow ofWho:(NSString *)DDNumber;
-(void)showGroupInIM:(BOOL)bShow ofChatID:(NSNumber *)chatID;

-(void)removeUnSendMsg:(NSNumber *)timeFlag;
-(void)signMessageState:(int)timeFlag ofState:(int)state;
//数据库增删改查
-(BOOL)saveMessage2DB:(HSMessageObject*)aMessage ofRead:(BOOL)isRead isReloadIM:(BOOL)bReloadIM;
//+(BOOL)deleteMessageById:(NSNumber*)aMessageId;
//+(BOOL)merge:(HSMessageObject*)aMessage;
-(void)updateMessageContentForMessageOfTimeFlag:(NSNumber *)timeFlag and:(NSString *)content;

//获取某联系人聊天记录
-(NSMutableArray *)fetchMessageListWithUser:(NSString *)userId byPages:(int)pageCount ofChatID:(NSNumber *)chatID;

//获取最近联系人
//+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex;

- (BOOL)dumpGroup;
- (BOOL)dumpFriend;
- (BOOL)dumpMessage;
- (void)dumpChatID;

-(NSString *)flagForChatID:(NSNumber *)chatID;
-(NSNumber *)chatIDForChatID:(NSNumber *)chatID;
-(NSNumber *)genChatIDForPublicGroup:(NSNumber *)chatID andFlag:(NSString *)groupFlag;
-(NSNumber *)getChatIDForPublicGroup:(NSNumber *)chatID andFlag:(NSString *)groupFlag;

+ (UIImage *)buildLogo:(UIImage *)image;
+(void)genRandCode:(char *)szCode ofLength:(int)len;
+(BOOL)bIsValidUserID:(NSString *)userID;
-(BOOL)pushGroupListIntoDB:(char *)pData;
-(BOOL)addNewGroupItem:(HSPublicGroupObject *)aGroup;
-(BOOL)reloadGroup;
-(BOOL)removeFriend:(NSString *)userID;
-(HSPublicGroupObject *)groupFromDB:(NSNumber *)chatID;

-(BOOL)reloadIMessage;
-(BOOL)reloadFriendList:(NSNumber *)chatID;

-(void)updateUserFullData:(HSUserObject *)aUser ofChatID:(NSNumber *)chatID;
-(HSUserObject *)userFromDB:(NSString *)userID ofChatID:(NSNumber *)chatID;
-(BOOL)isMyFriend:(NSString *)userID;

-(void)constructBadge;
-(void)signMessageReadByUserID:(NSString *)userID;
-(void)signMessageReadByChatID:(NSNumber *)chatID;
-(void)signNotifyP2PMessageRead:(HSMessageObject *)aMessage;
-(void)removeMessageFromDB:(HSMessageObject *)aMessage;

-(int)badgeCountOfNotify;
-(int)badgeCountOfChat;
-(int)badgeCountByChatID:(NSNumber *)chatID;
-(int)badgeCountByUserID:(NSString *)userID andChatType:(NSNumber *)chatType;

-(BOOL)dumpAccount;
-(void)pushNewAccount:(HSUserObject *)aUser;
-(HSUserObject *)userForAccount:(NSString *)account;
-(NSString *)webURLForAccount:(NSString *)account;

-(void)disableMessageOperation:(HSMessageObject *)aMessage;

-(void)setPromptMsgOfChatID:(NSNumber *)chatID ofPrompt:(BOOL)bPrompt;
-(BOOL)isPromptMsgOfChatID:(NSNumber *)chatID;
-(void)setShowNickOfChatID:(NSNumber *)chatID ofShow:(BOOL)bShow;
-(BOOL)isShowNickOfChatID:(NSNumber *)chatID;

-(void)checkMessageSendTimeout:(NSNumber *)chatID;
-(BOOL)pushUnSendMsg:(NSNumber *)timeFlag ofChatID:(NSNumber *)chatID;

-(void)clearAllChatMsg:(NSNumber *)chatID fromWho:(NSString *)messageFrom myName:(NSString *)selfName;

@end
