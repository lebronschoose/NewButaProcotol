//
//  ViewControllerNotify.m
//  hsimapp
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerNotify.h"
#import "ViewControllerChat.h"
#import "CellMessage.h"

@interface ViewControllerNotify ()

@end

@implementation ViewControllerNotify

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
        }else
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
    NSMutableArray *ns = _HSCore.m_notifyMessageList;
    if(ns != nil) return [ns count];
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellMessage";
    CellMessage *cell = (CellMessage *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    HSIMessageObject *aIMessage = [_HSCore.m_notifyMessageList objectAtIndex:indexPath.row];
    HSPublicGroupObject *aGroup = aIMessage.group;
    HSMessageObject *aMessage = aIMessage.message;
    [cell.labelName setText:aGroup.groupName];
    
    if([Master isSysNotify:aMessage.messageChatID.intValue])
    {
        NSArray *pList = [aMessage.messageContent componentsSeparatedByString:@"##&##"];
        if(pList.count > 1)
        {
            NSString *clickType = [pList objectAtIndex:0];
            if([clickType isEqualToString:@"URL"])
            {
                [cell.labelText setText:[pList objectAtIndex:2]];
            }
            else if([clickType isEqualToString:@"FUN"])
            {
                [cell.labelName setText:[pList objectAtIndex:2]];
                [cell.labelText setText:[pList objectAtIndex:3]];
            }
        }
        else [cell.labelText setText:aMessage.messageContent];
    }
    else [cell.labelText setText:aMessage.messageContent];
    [cell.labelTime setText:[HSCoreData stringByDate:aMessage.messageDate withYear:NO]];
    [cell.image setImage:[UIImage imageNamed:@"iconnotify"]];
    
    int msgType = [aMessage.messageType intValue];
    switch (msgType)
    {
        case kWCMessageTypeLocation:
        {
            break;
        }
        case kWCMessageTypeSystemNotifyURL:
        {
            NSRange range = [aMessage.messageContent rangeOfString:@";"];
            if(range.location != NSNotFound)
            {
                NSString *bc = [aMessage.messageContent substringFromIndex:range.location + range.length];//开始截取
                [cell.labelText setText:bc];
                [cell.labelText setTextColor:[UIColor blueColor]];
            }
            break;
        }
    }
    int nBadgeCount = [_HSCore badgeCountByChatID:aGroup.chatID];
    SetCellBadge(nBadgeCount);
    
    return cell;
}

#pragma mark - Table View [optional method]
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

//TableView.allowsSelection=YES;
//cell.selectionStyle=UITableViewCellSelectionStyleBlue;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *ns = _HSCore.m_notifyMessageList;
    
    HSIMessageObject *aIMessage = [ns objectAtIndex:indexPath.row];
    HSPublicGroupObject *groupObj = aIMessage.group;
    if(groupObj != nil && [Master isSysNotify:[groupObj.chatID intValue]])
    {
        [_Master changeChatTarget:[HSUserObject userWithNickName:groupObj.groupName andChatID:groupObj.chatID]];
        [_Master lookUpBadge];
        Go2View(ViewControllerChat);
    }
}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//这个方法用来告诉表格 这一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [_HSCore.m_notifyMessageList objectAtIndex:fromRow];
    [_HSCore.m_notifyMessageList removeObjectAtIndex:fromRow];
    [_HSCore.m_notifyMessageList insertObject:object atIndex:toRow];
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSMutableArray *ns = _HSCore.m_notifyMessageList;
        HSIMessageObject *aIMessage = [ns objectAtIndex:indexPath.row];
        HSPublicGroupObject *groupObj = aIMessage.group;
        if(groupObj != nil)
        {
            if([Master isSysNotify:[groupObj.chatID intValue]])
            {
                [_HSCore showGroupInIM:NO ofChatID:groupObj.chatID];
            }
            else if([Master isGroup:[groupObj.chatID intValue]])
            {
                
            }
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
