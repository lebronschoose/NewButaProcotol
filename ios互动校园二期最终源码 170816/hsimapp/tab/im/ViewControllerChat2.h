//
//  ViewControllerChat2.h
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "RootViewController.h"
#import "PullTableView.h"
#import "HSUserObject.h"

@interface ViewControllerChat2 : RootViewController <UIAlertViewDelegate, PullTableViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *msgRecords;
    UIImage *_myHeadImage, *_userHeadImage;
    NSTimer *m_sendingMsgTier;
    int     m_iChatID;
    BOOL    m_isShowNotifyMode;
    BOOL    m_bLastShowNick;
    BOOL    m_bNeedScrollToBottom;
    int     m_showPages;
}

@property (retain, nonatomic) NSString *resTo;
@property (retain, nonatomic) NSString *resContent;
@property (retain, nonatomic) NSString  *chatTimeLook;
@property (retain, nonatomic) IBOutlet UITextField *messageText;
@property (retain, nonatomic) IBOutlet UIView *inputBar;
@property (retain, nonatomic) IBOutlet UIView *inputMsgView;
@property (retain, nonatomic) IBOutlet PullTableView *msgRecordTable;

- (IBAction)onAddMedia:(id)sender;

@end
