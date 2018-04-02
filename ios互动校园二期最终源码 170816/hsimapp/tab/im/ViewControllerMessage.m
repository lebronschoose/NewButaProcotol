//
//  ViewControllerMessage.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerMessage.h"
#import "ViewControllerChat.h"
#import "CellMessage.h"

@interface ViewControllerMessage ()

@end

@implementation ViewControllerMessage

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //解决tableView分割线左边不到边的情况
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    // 不显示多余的分割线
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    //给cell加长按手势
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration =1;
    [self.tableView addGestureRecognizer:gestureLongPress];
    
    [_HSCore reloadIMessage];
    CareMsg(hsNotificationNewMsg);
    CareMsg(hsNotificationMsgBadge);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.tableView];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil)
        {
            NSLog(@"not tableView");
        }
        else
        {
            NSInteger focusSection = [indexPath section];
            NSInteger focusRow = [indexPath row];
            
            NSLog(@"%ld",(long)focusSection);
            NSLog(@"%ld",(long)focusRow);
            
            [self.tableView setEditing:YES animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView setEditing:NO animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationNewMsg])
    {
        [_HSCore reloadIMessage];
        [self.tableView reloadData];
    }
    else if([msg isEqualToString:hsNotificationMsgBadge])
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_HSCore.m_privateIMessageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellMessage";
    CellMessage *cell = (CellMessage *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    HSIMessageObject *aIMessage = [_HSCore.m_privateIMessageList objectAtIndex:indexPath.row];
    HSMessageObject *aMessage = aIMessage.message;
    
    if ([Master isPublicGroup:aIMessage.message.messageChatID.intValue])
    {
        HSIMessageObject *aIMessage = [_HSCore.m_publicIMessageList objectAtIndex:indexPath.row];
        HSPublicGroupObject *aGroup = aIMessage.group;
        HSMessageObject *aMessage = aIMessage.message;
        [cell.labelName setText:aGroup.groupName];
        if(aMessage.messageType.intValue == kWCMessageTypeImage)
        {
            [cell.labelText setText:@"[图片]"];
        }
        else [cell.labelText setText:aMessage.messageContent];
        [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
        [cell.image setImage:[UIImage imageNamed:@"publicIM"]];
        
        int nBadgeCount = [_HSCore badgeCountByChatID:aGroup.chatID];
        SetCellBadge(nBadgeCount);
    }
    else
    {
        HSUserObject *aUser = [_HSCore userFromDB:aMessage.messageFrom ofChatID:[NSNumber numberWithInt:0]];
        
        int nBadgeCount = [_HSCore badgeCountByUserID:aMessage.messageFrom andChatType:aMessage.messageType];
        SetCellBadge(nBadgeCount);
        
        NSLog(@"gen PERSONAL IM.");
        int msgType = [aMessage.messageType intValue];
        switch (msgType)
        {
            case kWCMessageTypeP2PAuthration:
                [cell.labelName setText:@"申请添加验证"];
                [cell.labelText setText:[NSString stringWithFormat:@"%@ 申请添加您到通讯录.", aMessage.messageFrom]];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell.image setImage:[UIImage imageNamed:@"notifyP2P"]];
                break;
            case kWCMessageTypeP2PAuthrationOK:
                [cell.labelName setText:@"验证成功"];
                [cell.labelText setText:[NSString stringWithFormat:@"%@ 通过了您的请求.", aMessage.messageFrom]];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell.image setImage:[UIImage imageNamed:@"notifyP2P"]];
                break;
            case kWCMessageTypeP2PAuthrationReject:
                [cell.labelName setText:@"验证失败"];
                [cell.labelText setText:[NSString stringWithFormat:@"%@ 拒绝了您的请求.", aMessage.messageFrom]];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell.image setImage:[UIImage imageNamed:@"notifyP2P"]];
                break;
            case kWCMessageTypeP2PDelete:
                [cell.labelName setText:@"从通讯录中删除"];
                [cell.labelText setText:[NSString stringWithFormat:@"从通讯录中删除%@.", aMessage.messageFrom]];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell.image setImage:[UIImage imageNamed:@"notifyP2P"]];
                break;
            case kWCMessageTypeImage:
                [cell.labelName setText:aUser.nickName];
                [cell.labelText setText:@"[图片]"];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aMessage.messageFrom]];
                return cell;
                break;
            default:
                if (aUser.nickName.length == 0) {
                    [cell.labelName setText:aUser.DDNumber];
                }else
                {
                    [cell.labelName setText:aUser.nickName];
                }
                
                [cell.labelText setText:aMessage.messageContent];
                [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
                [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aMessage.messageFrom]];
                return cell;
                break;
        }
    }
    return cell;
}


#pragma mark - Table View [optional method]
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//TableView.allowsSelection=YES;
//cell.selectionStyle=UITableViewCellSelectionStyleBlue;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSIMessageObject *aIMessage = [_HSCore.m_privateIMessageList objectAtIndex:indexPath.row];
    if ([Master isPublicGroup:aIMessage.message.messageChatID.intValue])
    {
        HSPublicGroupObject *groupObj = aIMessage.group;
        //HSUserObject *aUser = aIMessage.user;
        if(groupObj != nil)
        {
            if([Master isPublicGroup:[groupObj.chatID intValue]])
            {
                [_Master changeChatTarget:[HSUserObject userWithNickName:groupObj.groupName andChatID:groupObj.chatID]];
            }
            else if([Master isGroup:[groupObj.chatID intValue]])
            {
                
            }
        }
        [_Master lookUpBadge];
        Go2View(ViewControllerChat);
    }
    else
    {
        HSUserObject *aUser = aIMessage.user;
        HSMessageObject *aMessage = aIMessage.message;
        
        int msgType = [aMessage.messageType intValue];
        switch (msgType)
        {
            case kWCMessageTypeP2PAuthration:
            {
                [self showSegueWithObject:aIMessage.message Identifier:@"showIdentifyView"];
//                CallView(ViewControllerViewIdentify);
//                [sendView setOfUserID:aMessage.messageFrom];
//                [sendView setIdentifyText:aMessage.messageContent];
//                [sendView setOfMessage:aMessage];
//                ShowView;
                break;
            }
            case kWCMessageTypeP2PAuthrationOK:
            {
                HSUserObject *theUser = [_HSCore userFromDB:aMessage.messageFrom ofChatID:[NSNumber numberWithInt:0]];
                if(theUser == nil) break;
                [_Master changeChatTarget:theUser];
                [_Master lookUpBadge];
                Go2View(ViewControllerChat);
                break;
            }
            case kWCMessageTypeP2PAuthrationReject:
                break;
            case kWCMessageTypeP2PDelete:
                break;
            default:
            {
                [_Master changeChatTarget:aUser];
                [_Master lookUpBadge];
                Go2View(ViewControllerChat);
                break;
            }
        }
        switch (msgType)
        {
            case kWCMessageTypeP2PAuthration:
            case kWCMessageTypeP2PAuthrationOK:
            case kWCMessageTypeP2PAuthrationReject:
            case kWCMessageTypeP2PDelete:
                [_HSCore signNotifyP2PMessageRead:aMessage];
                [_HSCore constructBadge];
                break;
        }
    }
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{/*
  NSUInteger row = [indexPath row];
  [bookInforemoveObjectAtIndex:row];//bookInfo为当前table中显示的array
  [tableView deleteRowsAtIndexPaths:[NSArrayarrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];*/
    
    if (indexPath.section == 0)
    {
        HSIMessageObject *aIMessage = [_HSCore.m_privateIMessageList objectAtIndex:indexPath.row];
        HSMessageObject *aMessage = aIMessage.message;
        
        
        int msgType = [aMessage.messageType intValue];
        switch (msgType)
        {
            case kWCMessageTypeP2PAuthration:
            case kWCMessageTypeP2PAuthrationOK:
            case kWCMessageTypeP2PAuthrationReject:
            case kWCMessageTypeP2PDelete:
                [_HSCore removeMessageFromDB:aMessage];
                PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
                break;
            default:
                [_HSCore showFriendInIM:NO ofWho:aMessage.messageFrom];
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        HSIMessageObject *aIMessage = [_HSCore.m_privateIMessageList objectAtIndex:indexPath.row];
        HSMessageObject *aMessage = aIMessage.message;
        
        
        int msgType = [aMessage.messageType intValue];
        switch (msgType)
        {
            case kWCMessageTypeP2PAuthration:
            case kWCMessageTypeP2PAuthrationOK:
            case kWCMessageTypeP2PAuthrationReject:
            case kWCMessageTypeP2PDelete:
                [_HSCore removeMessageFromDB:aMessage];
                PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
                break;
            default:
                [_HSCore showFriendInIM:NO ofWho:aMessage.messageFrom];
                break;
        }
    }
    else
    {
        return ;
    }
    [_HSCore reloadIMessage];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
