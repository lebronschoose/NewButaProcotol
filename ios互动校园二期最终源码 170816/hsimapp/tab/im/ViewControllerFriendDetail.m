//
//  ViewControllerFriendDetail.m
//  hsimapp
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerFriendDetail.h"
#import "ViewControllerViewLogo.h"
#import "ViewControllerChat.h"
#import "CellUserLogo.h"
#import "CellButton.h"

@interface ViewControllerFriendDetail ()
{
    HSUserObject    *ofUser;
    BOOL            showButton;
    BOOL            bIsMyFriend;
    int             iChatID;
}

@end

@implementation ViewControllerFriendDetail

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
    
    iChatID = 0;
    showButton = NO;
    if([self.transObj isKindOfClass:[HSUserObject class]])
    {
        ofUser = self.transObj;
        if(ofUser == nil)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if([self.transObj isKindOfClass:[NSDictionary class]] || [self.transObj isKindOfClass:[NSMutableDictionary class]])
    {
        ofUser = [self.transObj objectForKey:@"user"];
        iChatID = [[self.transObj objectForKey:@"chatid"] intValue];
        if([[self.transObj objectForKey:@"showButton"] isEqualToString:@"yes"])
        {
            showButton = YES;
        }
    }
    
    bIsMyFriend = [_HSCore isMyFriend:ofUser.DDNumber];
    // for debug
    //bIsMyFriend = [ofUser.DDNumber isEqualToString:@"aaa"];
    /*if(bIsMyFriend == NO)
     {
     UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
     self.navigationItem.rightBarButtonItem = rightButton;
     }*/
    //if(bIsMyFriend)
    if(iChatID > -9999)
    {
        // request full user profile
        //[_Master reqUserData:ofUser.DDNumber ofType:4 oldFlag:[ofUser.dataFlag intValue] ofChatID:0];
        if([Master isP2PChat:iChatID])
        {
            [_Master reqUserData:ofUser.DDNumber ofType:4 oldFlag:0 ofChatID:iChatID];
        }
        else if([Master isPublicGroup:iChatID])
        {
            [_Master reqUserData:ofUser.DDNumber ofType:3 oldFlag:0 ofChatID:iChatID];
        }
    }
    CareMsg(hsNotificationUserReceived);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(showButton) return 3;
    else if(bIsMyFriend) return 3;
    else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 1;
    else if(section == 1) return [ofUser countOfDetails];
    else return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            static NSString *cellId = @"idCellUserLogo";
            CellUserLogo *cell = (CellUserLogo *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellUserLogo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            roundIt(cell.imageLogo);
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.labelName setText:ofUser.nickName];
            [cell.labelText setText:ofUser.signText];
            [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:ofUser.DDNumber]];
            return cell;
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
            if(indexPath.row == 2) // 用户身份
            {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.textLabel setText:[ofUser detailOfIndex:(int)indexPath.row]];
            return cell;
            break;
        }
        case 2:
        {
            static NSString *cellId = @"idCellButton";
            CellButton *cell = (CellButton *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.buttonOK.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            roundIt(cell.buttonOK);
            if(showButton)
            {
                if(bIsMyFriend)
                {
                    [cell.buttonOK setTitle:@"发消息" forState:UIControlStateNormal];
                }
                else
                {
                    [cell.buttonOK setTitle:@"添加到通讯录" forState:UIControlStateNormal];
                }
            }
            else // must is my friend and need to show clear chat history
            {
                [cell.buttonOK setTitle:@"删除聊天记录" forState:UIControlStateNormal];
            }
            ////
            // set button delegate
            [cell.buttonOK addTarget:self action:@selector(onCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (void)onCellButtonClicked:(id)sender
{
    if(showButton)
    {
        if(bIsMyFriend)
        {
            [_Master changeChatTarget:ofUser];
            [_Master lookUpBadge];
            Go2View(ViewControllerChat);
        }
        else
        {
            [self showSegueWithObject:ofUser Identifier:@"showViewIdentify"];
        }
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定删除与TA的聊天记录？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            NSLog(@"delete msg");
            [_HSCore clearAllChatMsg:[_Master.currentChatUser specialChatID] fromWho:[_Master.currentChatUser DDNumber] myName:[_Master.mySelf DDNumber]];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除聊天记录" description:@"聊天记录删除成功" type:TWMessageBarMessageTypeInfo];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return 100.0;
    else if(indexPath.section == 2) return 55.0f;
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

//TableView.allowsSelection=YES;
//cell.selectionStyle=UITableViewCellSelectionStyleBlue;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            // 从storyboard创建MainViewController
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewControllerViewLogo *mainViewController = (ViewControllerViewLogo *)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerViewLogo"];
            [mainViewController setTransObj:ofUser.DDNumber];
            
            [self.navigationController pushViewController:mainViewController animated:YES];
            break;
        }
        case 1:
        {
            if(indexPath.row == 2)
            {
            }
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
}

@end
