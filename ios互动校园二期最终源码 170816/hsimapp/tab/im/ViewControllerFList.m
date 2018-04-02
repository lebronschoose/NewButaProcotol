//
//  ViewControllerFList.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerFList.h"
#import "ViewControllerChat.h"
#import "CellMessage.h"

@interface ViewControllerFList ()

@end

@implementation ViewControllerFList

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
    
    CareMsg(hsNotificationUpdateFListUser);
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

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationUpdateFListUser])
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
    NSMutableArray *ns = [_HSCore userListForChatID:[NSNumber numberWithInt:0]];
    return [ns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellMessage";
    CellMessage *cell = (CellMessage *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSMutableArray *ns = [_HSCore userListForChatID:[NSNumber numberWithInt:0]];
    HSUserObject *aUser = [ns objectAtIndex:indexPath.row];
    if (aUser.nickName.length == 0) {
        [cell.labelName setText:aUser.DDNumber];
    }else
    {
        [cell.labelName setText:aUser.nickName];
    }
    
    [cell.labelText setText:aUser.signText];
    [cell.labelBadge setHidden:YES];
    [cell.labelTime setHidden:YES];
    [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];

    ///
    NSLog(@"*****Req cell for row: %ld", (long)indexPath.row);
    if(aUser.needUpdate)
    {
        // request full user profile
        NSLog(@"=====REQ user full data of: %@", aUser.DDNumber);
        [_Master reqUserData:aUser.DDNumber ofType:4 oldFlag:0 ofChatID:0];
    }
    return cell;
}

#pragma mark - Table View [optional method]
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *ns = [_HSCore userListForChatID:[NSNumber numberWithInt:0]];
    [_Master changeChatTarget:[ns objectAtIndex:indexPath.row]];
    [_Master lookUpBadge];
    Go2View(ViewControllerChat);
}

@end
