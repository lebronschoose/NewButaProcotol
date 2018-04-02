//
//  ViewControllerChat2.m
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "ViewControllerChat2.h"
#import "ViewControllerFriendDetail.h"
#import "ViewControllerGroupDetail.h"
#import "ViewControllerWeb.h"
//#import "ViewControllerShowMap.h"
#import "chatMsgCell.h"
#import "HSMessageObject.h"

@interface ViewControllerChat2 () <UITextFieldDelegate>

@end

@implementation ViewControllerChat2

#pragma mark - Refresh and load more methods

-(void)refreshList
{
    m_showPages++;
    [self refresh:YES];
}

- (void) refreshTable
{
    /*
     Code to actually refresh goes here.  刷新代码放在这
     */
    self.msgRecordTable.pullLastRefreshDate = [NSDate date];
    self.msgRecordTable.pullTableIsRefreshing = NO;
    if(self.msgRecordTable.pullRefreshEnabled == NO) return;
    [self refreshList];
}

- (void) loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.  加载更多实现代码放在在这
     */
    self.msgRecordTable.pullTableIsLoadingMore = NO;
    if(self.msgRecordTable.pullLoadMoreEnabled == NO) return;
    [self refreshList];
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.5f];
}

#pragma mark - Normals


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _Master.currentChatUser.nickName;
    
    [self.msgRecordTable setPullMode:1];
    [self.msgRecordTable EnableRefresh:YES];
    [self.msgRecordTable EnableLoadMore:NO];
    
    m_showPages = 1;
    m_isShowNotifyMode = NO;
    m_iChatID = [_Master.currentChatUser.specialChatID intValue];
    if([Master isSysNotify:m_iChatID])
    {
        m_isShowNotifyMode = YES;
        [_inputMsgView setHidden:YES];
        _myHeadImage = [UIImage imageNamed:@"DefaultHead"];
        _userHeadImage = [UIImage imageNamed:@"iconNotify"];
    }
    else if([Master isP2PChat:m_iChatID])
    {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_1detail"] style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        _myHeadImage = [UIImage imageNamed:@"DefaultHead"];
        _userHeadImage = [UIImage imageNamed:@"DefaultHeadOther"];
    }
    else if([Master isPublicGroup:m_iChatID] || [Master isGroup:m_iChatID])
    {
        m_bLastShowNick = [_HSCore isShowNickOfChatID:[_Master.currentChatUser specialChatID]];
        _myHeadImage = [UIImage imageNamed:@"DefaultHead"];
        _userHeadImage = [UIImage imageNamed:@"DefaultHeadOther"];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_groupdetail"] style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else
    {
        _myHeadImage = [UIImage imageNamed:@"DefaultHead"];
        _userHeadImage = [UIImage imageNamed:@"iconNotify"];
    }
    
    msgRecords = [[NSMutableArray alloc] initWithCapacity:100];
    
    NSLog(@"name:%@", [[UIDevice currentDevice] name]);
    NSLog(@"name:%@", [[UIDevice currentDevice] systemName]);
    NSLog(@"name:%@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"name:%@", [[UIDevice currentDevice] model]);
    NSLog(@"name:%@", [[UIDevice currentDevice] localizedModel]);
    NSLog(@"name:%@", [[UIDevice currentDevice] identifierForVendor]);
    
    if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && [[[UIDevice currentDevice] systemVersion] doubleValue] <= 7.0)
    {
        RegisterMsg(UIKeyboardWillChangeFrameNotification, changeKeyBoard);
        RegisterMsg(UIKeyboardDidChangeFrameNotification, changedKeyBoard);
    }
    else
    {
        RegisterMsg(UIKeyboardWillShowNotification, keyBoardWillShow);
        RegisterMsg(UIKeyboardWillHideNotification, keyBoardWillHide);
    }
    RegisterMsg(hsNotificationNewMsg, OnNotify_newMsgComing);
    RegisterMsg(hsNotificationUserReceived, On_UserDataReceived);
    RegisterMsg(hsNotificationNeedShowDetail, On_NotifyShowDetail);
    RegisterMsg(hsNotificationMsgUpdateChatList, On_NotifyUpdateChatList);
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //[_msgRecordTable addGestureRecognizer:tap];
    [self refresh:NO];
    m_bNeedScrollToBottom = YES;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"touch: %@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        [_messageText endEditing:YES];
        NSLog(@"click in cell");
        // to let the didselectrowatindexpath run
        return NO;
    }
    else if([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    else if([NSStringFromClass([touch.view class]) isEqualToString:@"UITextField"])
    {
        return NO;
    }
    NSLog(@"click no cell.");
    [_messageText endEditing:YES];
    return  YES;
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (IBAction)timerFired:(id)sender
{
    [_HSCore checkMessageSendTimeout:[NSNumber numberWithInt:m_iChatID]];
}

-(void)viewDidAppear:(BOOL)animated
{
    m_sendingMsgTier = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    if([Master isPublicGroup:m_iChatID] || [Master isGroup:m_iChatID])
    {
        BOOL bNow = [_HSCore isShowNickOfChatID:[_Master.currentChatUser specialChatID]];
        if(bNow != m_bLastShowNick)
        {
            m_bLastShowNick = bNow;
            [self refresh:NO];
        }
    }
    [super viewDidAppear:animated];
    if(m_bNeedScrollToBottom == YES && msgRecords.count > 0)
    {
        m_bNeedScrollToBottom = NO;
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecords.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        NSLog(@"-----666--scroll to %lu", (unsigned long)msgRecords.count);
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [m_sendingMsgTier invalidate];
}

-(void)selectRightAction:(id)sender
{
    [self showSegueWithObject:@{@"user": _Master.currentChatUser, @"show": @"operation"} Identifier:@"showFriendDetail"];
//    if([_Master.currentChatUser.specialChatID intValue] == 0)
//    {
//        CallView(ViewControllerFriendDetail);
//        [sendView setShowButton:NO];
//        [sendView setIChatID:[_Master.currentChatUser.specialChatID intValue]];
//        [sendView setOfPerson:_Master.currentChatUser];
//        ShowView;
//    }
//    else
//    {
//        CallView(ViewControllerGroupList);
//        [sendView setOfGroupID:_Master.currentChatUser.specialChatID];
//        [sendView setOfGroupName:_Master.currentChatUser.nickName];
//        ShowView;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)On_NotifyShowDetail:(NSNotification *)notifacation
{
    HSUserObject *aUser = notifacation.object;
    if(aUser == nil) return;
    if([aUser.DDNumber isEqualToString:_Master.mySelf.DDNumber]) return;
//    if([_Master.currentChatUser.specialChatID intValue] == 0)
//    {
//        CallView(ViewControllerFriendDetail);
//        [sendView setShowButton:NO];
//        [sendView setIChatID:[_Master.currentChatUser.specialChatID intValue]];
//        [sendView setOfPerson:aUser];
//        ShowView;
//    }
//    else
//    {
//        CallView(ViewControllerFriendDetail);
//        [sendView setShowButton:YES];
//        [sendView setIChatID:[_Master.currentChatUser.specialChatID intValue]];
//        [sendView setOfPerson:aUser];
//        ShowView;
//    }
}

-(void)On_NotifyUpdateChatList:(NSNotification *)notifacation
{
    [self refresh:YES];
}

-(void)On_UserDataReceived:(NSNotification *)notifacation
{
    HSUserObject *aUser = notifacation.object;
    NSLog(@"full user data recv: %@", aUser.DDNumber);
    [self refresh:NO];
}

-(void)OnNotify_newMsgComing:(NSNotification *)notifacation
{
    HSMessageObject* aMessage = notifacation.object;
    if(aMessage == nil || aMessage.messageFrom == nil) return;
    
    int chatID = [aMessage.messageChatID intValue];
    if([Master isP2PChat:chatID])
    {
        NSLog(@"from %@, cur:%@, user: %@", aMessage.messageFrom, _Master.currentChatUser.DDNumber, _Master.mySelf.DDNumber);
        if([aMessage.messageFrom isEqualToString:_Master.currentChatUser.DDNumber] ||
           [aMessage.messageFrom isEqualToString:_Master.mySelf.DDNumber])
        {
            [_HSCore signMessageReadByUserID:aMessage.messageFrom];
            [_HSCore constructBadge];
            [self refresh:YES];
            NSLog(@"new msg coming... reload. chatID = %d", chatID);
        }
    }
    else if([Master isPublicGroup:chatID] || [Master isGroup:chatID])
    {
        if(chatID == [_Master.currentChatUser.specialChatID intValue])
        {
            [_HSCore signMessageReadByChatID:[NSNumber numberWithInt:chatID]];
            [_HSCore constructBadge];
            [self refresh:YES];
            NSLog(@"new msg coming... reload. chatID = %d", chatID);
        }
    }
}

- (void)dealloc
{
    m_sendingMsgTier = nil;
    NSLog(@"close chat OK.");
    [_Master changeChatTarget:nil];
    
    RemoveMsg(hsNotificationNewMsg);
    RemoveMsg(hsNotificationUserReceived);
    
    if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && [[[UIDevice currentDevice] systemVersion] doubleValue] <= 6.0)
    {
        RemoveMsg(UIKeyboardWillChangeFrameNotification);
        RemoveMsg(UIKeyboardDidChangeFrameNotification);
    }
    else
    {
        RemoveMsg(UIKeyboardWillShowNotification);
        RemoveMsg(UIKeyboardWillHideNotification);
    }
    RemoveMsg(hsNotificationNeedShowDetail);
    RemoveMsg(hsNotificationMsgUpdateChatList);
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark ----键盘高度变化------

#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    return;
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    NSLog(@"deltaY:%f",deltaY);
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [_msgRecordTable setContentInset:UIEdgeInsetsMake(_msgRecordTable.contentInset.top-deltaY, 0, 0, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}

-(void)changedKeyBoard:(NSNotification *)aNotifacation
{
    /*
    NSDictionary *info = [aNotifacation userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    CGRect inputFieldRect = self.inputTextField.frame;
    CGRect moreBtnRect = self.moreInputTypeBtn.frame;
    
    inputFieldRect.origin.y += yOffset;
    moreBtnRect.origin.y += yOffset;
    
    [UIView animateWithDuration:duration animations:^{
        self.inputTextField.frame = inputFieldRect;
        self.moreInputTypeBtn.frame = moreBtnRect;
    }];
    */
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [_msgRecordTable setContentInset:UIEdgeInsetsMake(_msgRecordTable.contentInset.top-deltaY, 0, 0, 0)];
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgRecords.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"myChatMessageCells";
    chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[chatMsgCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    HSIMessageObject *aIMessage = [msgRecords objectAtIndex:[msgRecords count] - indexPath.row - 1];
    HSMessageObject *aMessage = aIMessage.message;
    HSUserObject *aUser = aIMessage.user;
    int iChatID = [aMessage.messageChatID intValue];
    if(aUser == nil)
    {
        if([Master isP2PChat:iChatID])
        {
            [_Master reqUserData:aMessage.messageFrom ofType:4 oldFlag:0 ofChatID:[aMessage.messageChatID intValue]];
        }
        else if([Master isPublicGroup:iChatID] || [Master isGroup:iChatID])
        {
            [_Master reqUserData:aMessage.messageFrom ofType:3 oldFlag:0 ofChatID:[aMessage.messageChatID intValue]];
        }
    }
    NSString *strMinute = [HSCoreData stringOfMinuteByDate:aMessage.messageDate];
    if([strMinute isEqualToString:self.chatTimeLook] == NO)
    {
        [self setChatTimeLook:strMinute];
        [cell showTime:YES ofTime:aMessage.messageDate];
    }
    else
    {
        [cell showTime:NO ofTime:aMessage.messageDate];
    }
    [cell showNickName:NO ofNick:@""];
    [cell setISendState:[aMessage.hasSuccess intValue]];
    [cell setFromWhom:aUser];
    [cell setMessageObject:aMessage ofType:m_isShowNotifyMode];
    NSString *selfName = _Master.mySelf.DDNumber;
    enum kWCMessageCellStyle style = [aMessage.messageFrom isEqualToString:selfName] ? kWCMessageCellStyleMe : kWCMessageCellStyleOther;
    switch (style)
    {
        case kWCMessageCellStyleMe:
        case kWCMessageCellStyleMeWithImage:
            [cell setHeadImage:_myHeadImage];
            break;
        case kWCMessageCellStyleOther:
        case kWCMessageCellStyleOtherWithImage:
            if([Master isPublicGroup:iChatID] || [Master isGroup:iChatID])
            {
                // is need to show nick name
                if([_HSCore isShowNickOfChatID:[NSNumber numberWithInt:iChatID]])
                {
                    [cell showNickName:YES ofNick:aUser.nickName];
                }
            }
            [cell setHeadImage:_userHeadImage];
            break;
        default:
            break;
    }
    if(m_isShowNotifyMode == NO && aMessage.messageType != nil && [aMessage.messageType intValue] == kWCMessageTypeImage)
    {
        style = (style == kWCMessageCellStyleMe) ? kWCMessageCellStyleMeWithImage : kWCMessageCellStyleOtherWithImage;
        //[cell setChatImage:[Photo string2Image:aMessage.messageContent ]];
    }
    [cell setMsgStyle:style];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSIMessageObject *aIMessage = msgRecords[[msgRecords count] - indexPath.row - 1];
    HSMessageObject *aMessage = aIMessage.message;
    int iChatID = [aMessage.messageChatID intValue];
    NSString *selfName = _Master.mySelf.DDNumber;
    enum kWCMessageCellStyle style = [aMessage.messageFrom isEqualToString:selfName] ? kWCMessageCellStyleMe : kWCMessageCellStyleOther;
    int nAdded = 0;
    switch (style)
    {
        case kWCMessageCellStyleOther:
        case kWCMessageCellStyleOtherWithImage:
            if([Master isPublicGroup:iChatID] || [Master isGroup:iChatID])
            {
                if([_HSCore isShowNickOfChatID:[NSNumber numberWithInt:iChatID]])
                {
                    nAdded += NICK_MOVE;
                }
            }
        default:
            break;
    }
    //chatMsgCell *cell = (chatMsgCell *)([_msgRecordTable cellForRowAtIndexPath:indexPath]);
    //if(cell.showTime)
    {
        //nAdded += 20;
    }
        
    if(m_isShowNotifyMode == NO && [aIMessage.message.messageType intValue] == kWCMessageTypeImage)
        return 55 + 100 + nAdded;
    else
    {
        NSString *orgin = [aIMessage.message messageContent];
        CGSize textSize = [orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        return 55 + textSize.height + nAdded;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"chat message cliclk.");
    
    //[self.view endEditing:YES];
    HSIMessageObject *aIMessage = [msgRecords objectAtIndex:[msgRecords count] - indexPath.row - 1];
    HSMessageObject *aMessage = aIMessage.message;
    if(m_isShowNotifyMode)
    {
        int msgType = [aMessage.messageType intValue];
        
        switch(msgType)
        {
            case kWCMessageTypeLocation:
            {
                NSRange range = [aMessage.messageContent rangeOfString:@";"];
                if(range.location != NSNotFound)
                {
                    NSString *longitude = [aMessage.messageContent substringToIndex:range.location];
                    NSString *b1 = [aMessage.messageContent substringFromIndex:range.location + range.length];//开始截取
                    range = [b1 rangeOfString:@";"];
                    if(range.location != NSNotFound)
                    {
                        NSString *latitude = [b1 substringToIndex:range.location];
                        //LookMap(YES, @"", [b1 substringFromIndex:range.location + range.length], @"", longitude, latitude);
                    }
                }
                return;
                break;
            }
            case kWCMessageTypeSystemNotifyURL:
            {
                NSRange range = [aMessage.messageContent rangeOfString:@";"];
                if(range.location == NSNotFound) return;
                NSString *url = [aMessage.messageContent substringToIndex:range.location + range.length - 1];//开始截取
                //TakeLook(@"", url);
                return;
                break;
            }
                
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)refresh:(BOOL)bScroll
{
    [self setChatTimeLook:[NSString stringWithFormat:@""]];
    //[_messageText setInputView:nil];
    //[_messageText resignFirstResponder];
    msgRecords = [_HSCore fetchMessageListWithUser:_Master.currentChatUser.DDNumber byPages:m_showPages ofChatID:_Master.currentChatUser.specialChatID];
    [_msgRecordTable reloadData];
    if(bScroll == YES && msgRecords.count > 0)
    {
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecords.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        NSLog(@"-------scroll to %lu", (unsigned long)msgRecords.count);
    }
}

- (IBAction)onAddMedia:(id)sender
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_messageText.text length] == 0) return NO;
    
    HSMessageObject *aMessage = [[HSMessageObject alloc] init];
    [aMessage setHasSuccess:[NSNumber numberWithInt:0]];
    [aMessage setMessageChatID:_Master.currentChatUser.specialChatID];
    [aMessage setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    [aMessage setMessageFrom:_Master.mySelf.DDNumber];
    [aMessage setMessageTo:(_Master.currentChatUser.DDNumber == nil) ? [NSString stringWithFormat:@""] : _Master.currentChatUser.DDNumber];
    [aMessage setMessageDate:[NSDate date]];
    [aMessage setMessageContent:_messageText.text];
    [aMessage setHasSuccess:[NSNumber numberWithInt:0]];
    [aMessage setMessageTimeFlag:[NSNumber numberWithInt:arc4random()]];
    [_HSCore saveMessage2DB:aMessage ofRead:YES isReloadIM:YES];
    [_HSCore pushUnSendMsg:aMessage.messageTimeFlag ofChatID:aMessage.messageChatID];
    
    [_Master reqSendChatMsg:aMessage];

    _messageText.text = @"";

    return YES;
}

@end
