//
//  CellChatMessage.h
//  dyhAutoApp
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellRoot.h"
#import "EGOImageView.h"

#define INSETS              8
#define HEAD_SIZE           36

@interface CellChatMessage : CellRoot

@property (retain, nonatomic) HSMessageObject *ofMessage;
@property (retain, nonatomic) HSUserObject *ofUser;

@property (weak, nonatomic) IBOutlet EGOImageView *userLogo;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIImageView *bubble;
@property (weak, nonatomic) IBOutlet UIButton *btSendAgain;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;

@property (weak, nonatomic) IBOutlet EGOImageView *chatImage;
@property (weak, nonatomic) IBOutlet UIButton *btProgress;
- (IBAction)onBtProgress:(id)sender;

@property (retain, nonatomic) NSString *clickLinkURL;

@property (weak, nonatomic) UIViewController *parent;

@property (retain, nonatomic) NSString *uploadUUID; // 用来根upload的request对接， ‘0’:自己的头像， ‘11239’：groupid，‘r’开头，其他图片，
@property (retain, nonatomic) NSNumber *uploadType; // 1 : 用户头像 4 : 群logo  2 ： 聊天图片

- (IBAction)onSendAgain:(id)sender;
+(CGSize)sizeForText:(NSString *)message;
+(CGFloat)heightForMessage:(id)obj showNickName:(BOOL)isShowNickName;

@property (retain, nonatomic) NSString *imageNameString;
-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL;

@property (retain, nonatomic) NSString *chatImageString;
-(void)loadChatImage:(NSString *)defaultLog andURL:(NSString *)imgURL;

@end
