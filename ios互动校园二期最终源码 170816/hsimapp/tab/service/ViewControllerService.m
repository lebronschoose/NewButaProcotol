//
//  ViewControllerService.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerService.h"
#import "ViewControllerIntro.h"
#import "ViewControllerForget1.h"
#import "CellSwitch.h"
#import "CellMessage.h"
#import "NCLoginPassWordModifyViewController.h"
#import "MyQuestionViewController.h"
#import "HDServiceViewController.h"
#import "ServiceModel.h"

@interface ViewControllerService () <UIAlertViewDelegate, UITextFieldDelegate>
{
    NSArray *listStudent;
    NSArray *listTies;
    NSNumber *tieType;
    NSString *tieName;
    NSString *mobileNo;
    NSMutableArray * OtherArr;
}
@end

@implementation ViewControllerService


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //解决tableView分割线左边不到边的情况
    OtherArr = [NSMutableArray array];
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
    
    listStudent = @[];
    listTies = @[];
    
    [self runAPI:@"getBindStudent" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        NSLog(@"getBindStudent is %@",dict);
        listStudent = [dict objectForKey:@"bindstudent"];
        [self reloadPicker];
        if(listStudent != nil && listStudent.count > 0)
        {
            [self.tableView reloadData];
        }
    }];
    
    [_Master SubmitTo:@"getTieTypeList" andParams:@{@"checkcode":[HSAppData getCheckCode]}  success:^(NSDictionary * dict) {
        StopWaiting;
        listTies = [dict objectForKey:@"tietype"];
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
    [_Master SubmitTo:@"getExtraFunctionList" andParams:@{}  success:^(NSDictionary * dict) {
        NSLog(@"getExtraFunctionList is %@",dict);
//        StopWaiting;
//        listTies = [dict objectForKey:@"tietype"];
        NSArray * arr = dict[@"lists"];
        for (NSDictionary * odict in arr) {
            ServiceModel * model = [ServiceModel mj_objectWithKeyValues:odict];
            [OtherArr addObject:model];
        }
        if(OtherArr != nil && OtherArr.count > 0)
        {
            [self.tableView reloadData];
        }

        
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
//    [self GetOtherMethods];
    self.automaticallyAdjustsScrollViewInsets = false;
    CareMsg(msgTest);
    CareMsg(hsNotificationSelfDataReceived);
    CareMsg(hsNotificationLogoutRes);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    double delay = 3; // 延迟多少秒
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
//        // 3秒后需要执行的任务
//        [self runAPI:@"longinOut" andParams:@{@"action": @"1" ,@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
//            NSLog(@"dict is %@",dict);
//        }];
//    });

}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationSelfDataReceived])
    {
        [self.tableView reloadData];
    }
    else if([msg isEqualToString:msgTest])
    {
        NSLog(@"msgTest arrival... %@", self);
    }
    else if([msg isEqualToString:hsNotificationLogoutRes])
    {
        StopWaiting;
        [_Master back2Login];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[_HSCore m_configItems].count is %ld",[_HSCore m_configItems].count);
    if(section == 0)
    {
        if([_Master isTeacher])
        {
            return 7;
        }
        else
        {
            if(listStudent.count > 1) return 9;
            else return 8;
        }
    }
    else return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) return @"个人设置";
    else return @"其他服务";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSUserObject *aUser = _Master.mySelf;
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    static NSString *cellId = @"idCellMessage";
                    CellMessage *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[CellMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell.labelBadge setHidden:YES];
                    [cell.labelTime setHidden:YES];
                    roundIt(cell.image);
                    [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];
                    if (_Master.mySelf.nickName.length == 0) {
                        [cell.labelName setText:_Master.mySelf.DDNumber];
                    }else
                    {
                        [cell.labelName setText:_Master.mySelf.nickName];
                    }
                    
                    [cell.labelText setText:_Master.mySelf.signText];
                    [cell.labelTime setText:@"点击查看"];
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
                    [cell.textLabel setText:@"清除缓存(聊天记录,系统消息等)"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 2:
                {
                    static NSString *cellId = @"idCellSwitch";
                    CellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[CellSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell setCellTag:-1];
                    [cell.labelText setText:@"消息提示音"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.switchButton setOn:[_HSCore isPromptMsgOfChatID:[NSNumber numberWithInt:notPubChat]]];
                    [cell setOfChatID:[NSNumber numberWithInt:notPubChat]];
                    [cell.switchButton addTarget:cell action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
                    return cell;
                    break;
                }
                case 3:
                {
                    static NSString *cellId = @"idCellSwitch";
                    CellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[CellSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell setCellTag:-2];
                    [cell.labelText setText:@"推送消息详细内容"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.switchButton setOn:[glState pushDetail]];
                    [cell.switchButton addTarget:cell action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
                    return cell;
                    break;
                }
                case 4:
                {
                    static NSString *cellId = @"originalCells";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell.textLabel setText:@"引导页"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 5:
                {
                    static NSString *cellId = @"originalCells";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell.textLabel setText:@"修改密码"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }

                case 6:
                {
                    static NSString *cellId = @"originalCells";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    if ([_Master isTeacher]) {
                        [cell.textLabel setText:@"问题反馈"];
                    }else
                    {
                        [cell.textLabel setText:@"新增家属"];
                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 7:
                {
                    static NSString *cellId = @"originalCells";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    if (listStudent.count>1) {
                        [cell.textLabel setText:@"切换学生"];
                    }else
                    {
                        [cell.textLabel setText:@"问题反馈"];
                    }
                        
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 8:
                {
                    static NSString *cellId = @"originalCells";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    [cell.textLabel setText:@"问题反馈"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            if (OtherArr.count >1)
            {
        
            ServiceModel  * model = OtherArr[indexPath.row];
                
            [cell.textLabel setText:model.fun_name];
            }
//            if (indexPath.row == 0) {
//                [cell.textLabel setText:@"互动服务中心"];
//            }else
//            {
////            HSPublicGroupObject *aGroup = [_HSCore.m_configItems objectAtIndex:indexPath.row];
////            [cell.textLabel setText:[aGroup groupName]];
//            [cell.textLabel setText:[[HSAppData gethelpDic] objectForKey:@"name"]];
//            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

-(void)GetOtherMethods
{
    [self runAPI:@"getExtraFunctionList" andParams:@{} success:^(NSDictionary * dict) {
        NSLog(@"getExtraFunctionList is %@",dict);
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0) return 60;
        else return 40;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) return 30;
    return 20;
}

//TableView.allowsSelection=YES;
//cell.selectionStyle=UITableViewCellSelectionStyleBlue;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self showSegueWithObject:nil Identifier:@"showSelfConfig"];
                    break;
                }
                case 1:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"确定要清除所有的聊天记录和系统消息吗？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定",nil];
                    alert.tag = 99;
                    [alert show];
                    break;
                }
                case 4:
                {
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ViewControllerIntro * vc = [story instantiateViewControllerWithIdentifier:@"ViewControllerIntro"];
                    [vc setBAutoMode:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 5:
                {
//                    [self showSegueWithObject:nil Identifier:@"ViewControllerForget1"];
                    NCLoginPassWordModifyViewController * loginmodify = [[NCLoginPassWordModifyViewController alloc]init];
//        
//                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    ViewControllerForget1 * vc = [story  instantiateViewControllerWithIdentifier:@"ViewControllerForget1"];
////                    [vc setBAutoMode:NO];
//                    vc.PushType = @"Service";
                    [self.navigationController pushViewController:loginmodify animated:YES];
                    break;
                }

                case 6:
                {
                    if ([_Master isTeacher]) {
                        NSLog(@"问题反馈");
                        MyQuestionViewController * want = [[MyQuestionViewController alloc]init];
                        [self.navigationController pushViewController:want animated:YES];
                    }else
                    {
                         [self startMiddlePicker:@"addparent" ofTitle:@"点击确定" andFinish:@"点击确定"];
                       

                    }
                    
                    break;
                }
                case 7:
                {
                    if (listStudent.count>1) {
                        [self startMiddlePicker:@"switchbind" ofTitle:@"点击切换学生" andFinish:@"点击切换学生"];
                    }else
                    {
                        NSLog(@"问题反馈");
                        MyQuestionViewController * want = [[MyQuestionViewController alloc]init];
                        [self.navigationController pushViewController:want animated:YES];

                    }
                    break;
                }
                case 8:
                {
                    NSLog(@"问题反馈");
                    MyQuestionViewController * want = [[MyQuestionViewController alloc]init];
                    [self.navigationController pushViewController:want animated:YES];

                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            ServiceModel * model = OtherArr[indexPath.row];
            if (model.fun_url.length == 0) {
                NSLog(@"进入互动服务中心");
                HDServiceViewController * want = [[HDServiceViewController alloc]init];
                [self.navigationController pushViewController:want animated:YES];

            }else
            {
//            HSPublicGroupObject *aGroup = [_HSCore.m_configItems objectAtIndex:indexPath.row];
//            //            TakeLook(aGroup.groupName, aGroup.addData);
//            NSLog(@" [self insertCheckCode:aGroup.addData] is %@", [self insertCheckCode:aGroup.addData]);
            [self showSegueWithObject:@{@"title": model.fun_name, @"url": model.fun_url} Identifier:@"showServiceWeb"];
            }
                break;
        }
        default:
            break;
    }
}

- (NSString *)insertCheckCode:(NSString *)url
{
    NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *newurl = [NSString stringWithFormat:@"%@/checkcode/%@%@", [url substringToIndex:range.location], [HSAppData getCheckCode], [url substringFromIndex:range.location]];
    return newurl;
}


#pragma mark --- picker view delegate ---

- (void)endPickItem
{
    if([self.pickerFlag isEqualToString:@"switchbind"])
    {
        NSLog(@"结果 %@", [listStudent objectAtIndex:[self selectedRowInComponent:0]]);
        NSDictionary *dict = [listStudent objectAtIndex:[self selectedRowInComponent:0]];
        if([[dict objectForKey:@"isbind"] intValue] != 0) return;
        
        [self runAPI:@"switchBindStudent" andParams:@{@"checkcode": [HSAppData getCheckCode], @"id": [dict objectForKey:@"id"]} success:^(NSDictionary * dict) {
            NSString *str = [dict objectForKey:@"str"];
            NSNumber *ret = [dict objectForKey:@"ret"];
            if(ret.intValue != 0)
            {
                [self showMessage:str];
            }
            else
            {
                [self showBlockMessage:@"切换成功，请重新登录后生效." delay:1.0f andThen:^{
                    [_Master reqLoginOut];
                    Waiting(5.0, @"waitinglogout");
                    for(id temp in self.navigationController.viewControllers)
                    {
                        NSLog(@" - vc -- %@", temp);
                    }
                }];
            }
        }];
    }
    else if([self.pickerFlag isEqualToString:@"addparent"])
    {
        NSLog(@"结果 %@", [listTies objectAtIndex:[self selectedRowInComponent:0]]);
        NSDictionary *dict = [listTies objectAtIndex:[self selectedRowInComponent:0]];
        tieType = [dict objectForKey:@"type"];
        tieName = [dict objectForKey:@"name"];
        
        NSString *title = @"";
        if([tieName isEqualToString:@"其他"])
        {
            title = @"新增家长的手机号码";
        }
        else
        {
            title = [NSString stringWithFormat:@"%@的手机号码", tieName];
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:@"取消", nil];
        alert.tag = 2;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypePhonePad;
        alertTextField.returnKeyType = UIReturnKeyDone;
        alertTextField.tag = 2;
        alertTextField.delegate = self;
        alertTextField.text = @"";
        alertTextField.placeholder = @"手机号码";
        [alert show];
    }
}

- (void)addParent:(NSString *)mobile
{
    [_Master SubmitTo:@"getAddParentSmscode" andParams:@{@"checkcode":[HSAppData getCheckCode], @"mobileno":mobile}  success:^(NSDictionary * dict) {
        StopWaiting;
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue == 0)
        {
            [self showBlockMessage:str delay:3.0f andThen:^{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"短信验证"
                                                                 message:@"请输入收到的短信验证码"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:@"取消", nil];
                alert.tag = 10;
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                alertTextField.keyboardType = UIKeyboardTypePhonePad;
                alertTextField.returnKeyType = UIReturnKeyDone;
                alertTextField.tag = 10;
                alertTextField.delegate = self;
                alertTextField.text = @"";
                alertTextField.placeholder = @"短信验证码";
                [alert show];
            }];
        }
        else
        {
            [self showMessage:str];
        }
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
}

- (void)doAddParent:(NSString *)mobile andSMS:(NSString *)sms
{
    [_Master SubmitTo:@"doAddParent" andParams:@{@"checkcode":[HSAppData getCheckCode], @"mobileno":mobile, @"smscode":sms, @"tietype":tieType}  success:^(NSDictionary * dict) {
        StopWaiting;
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue == 0)
        {
            [self showBlockMessage:str delay:2.0f andThen:^{
            }];
        }
        else
        {
            [self showMessage:str];
        }
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
    if(alertView.tag == 99)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"delete msg");
            [_HSCore clearAllChatMsg:[NSNumber numberWithInt:-1] fromWho:nil myName:nil];
            PostMessage(hsNotificationNewMsg, nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                            message:@"聊天记录已删除."
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            mobileNo = [[alertView textFieldAtIndex:0] text];
            NSLog(@"Entered: %@", mobileNo);
            [self addParent:mobileNo];
        }
    }
    else if(alertView.tag == 10)
    {
        if(buttonIndex == 0)
        {
            NSString *sms = [[alertView textFieldAtIndex:0] text];
            NSLog(@"Entered: %@", sms);
            [self doAddParent:mobileNo andSMS:sms];
        }
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"switchbind"])
    {
        return listStudent.count;
    }
    else if([self.pickerFlag isEqualToString:@"addparent"])
    {
        return listTies.count;
    }
    return 0;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"switchbind"])
    {
        NSDictionary *dict = [listStudent objectAtIndex:row];
        NSNumber *isBind = [dict objectForKey:@"isbind"];
        if(isBind.intValue != 0)
        {
            NSString *title = [NSString stringWithFormat:@"%@ - %@  (已绑定)", [dict objectForKey:@"realname"], [dict objectForKey:@"classname"]];
            return title;
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:@"realname"], [dict objectForKey:@"classname"]];
            return title;
        }
    }
    else if([self.pickerFlag isEqualToString:@"addparent"])
    {
        NSDictionary *dict = [listTies objectAtIndex:row];
        return [dict objectForKey:@"name"];
    }
    return @"";
}
#pragma mark --- END of picker view delegate ---

@end
