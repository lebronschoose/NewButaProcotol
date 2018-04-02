//
//  ViewControllerGroupDetail.m
//  hsimapp
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerGroupDetail.h"
#import "ViewControllerFriendDetail.h"
#import "CellSwitch.h"
#import "CellMessage.h"

@interface ViewControllerGroupDetail ()
{
    HSPublicGroupObject *ofGroup;
    NSNumber *ofGroupID;
}
@end

@implementation ViewControllerGroupDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.transObj == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    ofGroup = self.transObj;
    ofGroupID = ofGroup.chatID;
    
    fitIOS7;
    self.navigationItem.title = ofGroup.groupName;
    [_Master reqGroupUserList:ofGroupID];
    CareMsg(hsNotificationReloadFList);
    CareMsg(hsNotificationUpdateGListUser);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationReloadFList])
    {
        NSNumber *chatID = notification.object;
        if(chatID != nil && [chatID intValue] == [ofGroupID intValue])
        {
            NSLog(@"still reload all group user list.");
            [self.tableView reloadData];
        }
    }
    if([msg isEqualToString:hsNotificationUpdateGListUser])
    {
        HSUserObject *aUser = notification.object;
        if(aUser == nil) return;
        
        NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
        int index = -1;
        for(int i = 0; i < ns.count; i++)
        {
            HSUserObject *user = [ns objectAtIndex:i];
            if([aUser.DDNumber isEqualToString:user.DDNumber])
            {
                index = i;
                break;
            }
        }
        if(index == -1)
        {
            NSLog(@"can not see the user [%@] in the list of id:%@", aUser.DDNumber, ofGroupID);
            return;
        }
        NSLog(@"See the user [%@] in the list of id:%@ at index:%d", aUser.DDNumber, ofGroupID, index);
        
        NSIndexPath *pos = [NSIndexPath indexPathForRow:index inSection:2];
        NSArray *poses = [NSArray arrayWithObject:pos];
        [self.tableView reloadRowsAtIndexPaths:poses withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
        {
            NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
            return [ns count];
            break;
        }
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"";
            break;
        case 1:
            return @"";
            break;
        case 2:
        {
            NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
            return [NSString stringWithFormat:@"成员(%lu人)", (unsigned long)[ns count]];
            //return @"成员";
            break;
        }
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2) return 30;
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) return 60;
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                case 1:
                {
                    static NSString *cellId = @"idCellSwitch";
                    CellSwitch *cell = (CellSwitch *)[tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[CellSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    if(indexPath.row == 0)
                    {
                        [cell.labelText setText:@"新消息通知"];
                        [cell.switchButton setOn:[_HSCore isPromptMsgOfChatID:ofGroupID]];
                    }
                    else if(indexPath.row == 1)
                    {
                        [cell.labelText setText:@"显示成员昵称"];
                        [cell.switchButton setOn:[_HSCore isShowNickOfChatID:ofGroupID]];
                    }
                    [cell setCellTag:(int)indexPath.row];
                    [cell setOfChatID:ofGroupID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.switchButton addTarget:cell action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
                    return cell;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            static NSString *cellId = @"originalCells";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell.textLabel setText:@"清除聊天记录"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            break;
            return cell;
            break;
        }
        case 2:
        {
            static NSString *cellId = @"idCellMessage";
            CellMessage *cell = (CellMessage *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
            HSUserObject *aUser = [ns objectAtIndex:indexPath.row];
            if ([NSString isBlankString:aUser.nickName]) {
                [cell.labelName setText:aUser.DDNumber];
            }else
            {
                [cell.labelName setText:aUser.nickName];
            }
            
            [cell.labelText setText:aUser.signText];
            [cell.labelBadge setHidden:YES];
            [cell.labelTime setHidden:YES];
            [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            ///
            if(aUser.needUpdate)
            {
                NSLog(@"Req full user data of %@ in group:%@", aUser.DDNumber, ofGroupID);
                [_Master reqUserData:aUser.DDNumber ofType:3 oldFlag:0 ofChatID:[ofGroupID intValue]];
            }
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            NSLog(@"delete msg");
            [_HSCore clearAllChatMsg:ofGroupID fromWho:nil myName:nil];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除聊天记录" description:@"聊天记录删除成功" type:TWMessageBarMessageTypeInfo];
            break;
        default:
            break;
    }
}

/*
 -(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if(indexPath.section == 1 && [indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
 {
 //end of loading
 //for example [activityIndicator stopAnimating];
 NSLog(@"**************End of loading a page...");
 
 NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
 NSArray *indexArray = [tableView indexPathsForVisibleRows];
 int nCount = [indexArray count];
 for(int i = 0; i < nCount; i++)
 {
 NSIndexPath *index = [indexArray objectAtIndex:i];
 HSUserObject *aUser = [ns objectAtIndex:index.row];
 if(aUser != nil && aUser.dataNeedUpdate)
 {
 NSLog(@"Req full user data of %@ in group:%@", aUser.DDNumber, ofGroupID);
 [_Master reqUserData:aUser.DDNumber ofType:3 oldFlag:0 ofChatID:[ofGroupID intValue]];
 }
 }
 }
 }*/
//这里的链接中给出了对UITableView进行子类化，
//以获得数据加载完成通知 http://stackoverflow.com/questions/1483581/get-notified-when-uitableview-has-finished-asking-for-data

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"确定删除该群组的所有聊天记录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
            break;
        }
        case 2:
        {
            NSMutableArray *ns = [_HSCore userListForChatID:ofGroupID];
            HSUserObject *aUser = [ns objectAtIndex:indexPath.row];
            // 从storyboard创建MainViewController
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewControllerFriendDetail *mainViewController = (ViewControllerFriendDetail*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerFriendDetail"];
            [mainViewController setTransObj:@{@"user": aUser, @"chatid":NN(99), @"showButton": @"yes"}];
//            [self showSegueWithObject:@{@"user":aUser, @"chatid": NN(-9999), @"showButton": @"yes"} Identifier:@"showFriendDetail"];
            [self.navigationController pushViewController:mainViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
