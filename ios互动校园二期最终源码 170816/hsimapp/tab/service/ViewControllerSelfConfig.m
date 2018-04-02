//
//  ViewControllerSelfConfig.m
//  hsimapp
//
//  Created by apple on 16/8/14.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerSelfConfig.h"
#import "CellMessage.h"
#import "CellButton.h"
#import "CellHeadLogo.h"

@interface ViewControllerSelfConfig () <UIAlertViewDelegate, UINavigationControllerDelegate>
{
    UIImage *myLogo;
}
@end

@implementation ViewControllerSelfConfig

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
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    CareMsg(msgTest);
    CareMsg(hsNotificationLogoutRes);
    CareMsg(hsNotificationSelfDataReceived);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationSelfDataReceived])
    {
        [self.tableView reloadData];
    }
    else if([msg isEqualToString:hsNotificationLogoutRes])
    {
        StopWaiting;
        [_Master back2Login];
    }
    if([msg isEqualToString:msgTest])
    {
        NSLog(@"msgTest arrival... %@", self);
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
            return 1;
            break;
        case 1:
            return [_Master.mySelf selfCountOfDetails];
            break;
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSUserObject *aUser = _Master.mySelf;
    switch(indexPath.section)
    {
        case 0:
        {
            static NSString *cellId = @"idCellHeadLogo";
            CellHeadLogo *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellHeadLogo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            // Config your cell
            [cell setParent:self];
            [cell setUploadType:NN(1)];
            [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];
            [cell setParam:aUser];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            userHead = cell;
            return cell;
            break;
        }
//        case 0:
//        {
//            static NSString *cellId = @"idCellMessage";
//            CellMessage *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//            if (cell == nil)
//            {
//                cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//            }
//            [cell.labelBadge setHidden:YES];
//            [cell.labelTime setHidden:YES];
//            roundIt(cell.image);
//            [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            [cell.labelName setText:aUser.nickName];
//            [cell.labelText setText:@"点击更换头像"];
//            return cell;
//            break;
//        }
        case 1:
        {
            static NSString *cellId = @"originalCells";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell.textLabel setText:[aUser selfDetailOfIndex:(int)indexPath.row]];
            cell.accessoryType = [aUser accessoryType:(int)indexPath.row];
            if(indexPath.row == 5)
            {
                [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            }
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
            [cell.buttonOK setTitle:@"退出登录" forState:UIControlStateNormal];
            ////
            // set button delegate
            [cell.buttonOK addTarget:self action:@selector(onCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            break;
        }
    }
    return nil;
}

- (void)onCellButtonClicked:(id)sender
{
    [_Master reqLoginOut];
    [_Master getJsonFrom:@"http://www.butaschool.com/mall/mobile/user.php?act=logout" success:^(NSDictionary * dict) {
        NSLog(@"网页登录清除缓存成功");
    } failed:^{
        NSLog(@"网页登录清除缓存失败");
    }];
    Waiting(5.0, @"waitinglogout");
    
    for(id temp in self.navigationController.viewControllers)
    {
        NSLog(@" - vc -- %@", temp);
    }
}

- (IBAction)waitingEnd:(id)sender
{
    NSLog(@"Timer: %@ - Waiting time out for tag:'%@'", self, self.waitingTag);
    [_Master back2Login];
    StopWaiting;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return 120;
    if(indexPath.section == 2) return 55;
    return 40;
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
            [self.tableView reloadData];
            break;
        }
        case 1:
        {
            if(UITableViewCellAccessoryDisclosureIndicator == [_Master.mySelf accessoryType:(int)indexPath.row])
            {
                if(indexPath.row == 2)
                {
                    //                    NSString *strURL = [NSString stringWithFormat:@"%@?action=3&target=%@", [HSAppData getWebURL], _Master.mySelf.DDNumber];
                    //                    TakeLook(@"身份信息", strURL);
                }
                else if(indexPath.row == 5)
                {
                }
                else
                {
                    [self showSegueWithObject:NN((int)indexPath.row) Identifier:@"showInput"];
                }
            }
            break;
        }
    }
}

@end
