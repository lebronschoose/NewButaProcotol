//
//  ViewControllerGroup.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerGroup.h"
#import "ViewControllerChat.h"
#import "CellMessage.h"

@interface ViewControllerGroup ()

@end

@implementation ViewControllerGroup

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
    if([msg isEqualToString:hsNotificationReloadGList])
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
    return _HSCore.m_publicGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellMessage";
    CellMessage *cell = (CellMessage *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.labelBadge setHidden:YES];
    [cell.labelTime setHidden:YES];
    
    NSMutableArray *ns = _HSCore.m_publicGroup;
    HSPublicGroupObject *groupObj = [ns objectAtIndex:indexPath.row];
    [cell.labelName setText:groupObj.groupName];
    [cell.labelText setText:groupObj.descText];
    [cell.image setImage:[UIImage imageNamed:@"icongroup"]];
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
    
    HSPublicGroupObject *groupObj = [_HSCore.m_publicGroup objectAtIndex:indexPath.row];
    if([Master isHyperLink:[groupObj.chatID intValue]])
    {
//        NSLog(@"LINK TO URL: %@", groupObj.addData);
//        TakeLook(groupObj.groupName, groupObj.addData);
    }
    else
    {
        [_Master changeChatTarget:[HSUserObject userWithNickName:groupObj.groupName andChatID:groupObj.chatID]];
        [_Master lookUpBadge];
        Go2View(ViewControllerChat);
    }
}

@end
