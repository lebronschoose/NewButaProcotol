//
//  ViewControllerStudentAction.m
//  hsimapp
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerStudentAction.h"
#import "CellStudent.h"
#import "CellParent.h"
#import "CellAction.h"

@interface ViewControllerStudentAction ()
{
    NSDictionary *dictInfo;
}
@end

@implementation ViewControllerStudentAction

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [self.transObj objectForKey:@"name"];
    NSNumber *uid = [self.transObj objectForKey:@"uid"];
    [_Master SubmitTo:@"getStudentAction" andParams:@{@"checkcode":[HSAppData getCheckCode], @"uid":uid}  success:^(NSDictionary * dict) {
        NSLog(@"getStudentAction is %@",dict);
        dictInfo = dict;
        [self.tableView reloadData];
        StopWaiting;
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: // total
        {
            return 1;
            break;
        }
        case 1: // in
        {
            NSArray *list = [dictInfo objectForKey:@"familylist"];
            return list.count;
            break;
        }
        case 2: // out
        {
            NSArray *list = [dictInfo objectForKey:@"actionlist"];
            return list.count;
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
        {
            return @"";
            break;
        }
        case 1:
        {
            return @"家属";
            break;
        }
        case 2:
        {
            return @"行为记录";
            break;
        }
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) return 56;
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            static NSString *cellId = @"idCellStudent";
            CellStudent *cell = (CellStudent *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellStudent alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            NSDictionary *dict = [dictInfo objectForKey:@"student"];
            if (dict.count == 0) {
                NSLog(@"为空");
            }else
            {
            [cell.labelName setText:[NSString stringWithFormat:@"学生姓名: %@", [dict objectForKey:@"realname"]]];
            [cell.labelMobile setText:[NSString stringWithFormat:@"手机号码: %@", [dict objectForKey:@"mobile"]]];
            }
            return cell;
            break;
        }
        case 1:
        {
            static NSString *cellId = @"idCellParent";
            CellParent *cell = (CellParent *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellParent alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            NSArray *list = [dictInfo objectForKey:@"familylist"];
            NSDictionary *dict = [list objectAtIndex:indexPath.row];
            [cell.labelName setText:[dict objectForKey:@"realname"]];
            [cell.labelMobile setText:[NSString stringWithFormat:@"手机号码: %@", [dict objectForKey:@"mobile"]]];
            [cell.labelTie setText:[dict objectForKey:@"tiename"]];
            return cell;
            break;
        }
        case 2:
        {
            static NSString *cellId = @"idCellAction";
            CellAction *cell = (CellAction *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CellAction alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            if(indexPath.row % 2 == 0)
            {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            else
            {
                [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            }
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.imgAction setHidden:NO];
            [cell.labelTime setHidden:NO];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSArray *actions = [dictInfo objectForKey:@"actionlist"];
            NSDictionary *dict = [actions objectAtIndex:indexPath.row];
            NSNumber *actionType = [dict objectForKey:@"action"];
            if(actionType.intValue == 1)
            {
                [cell.imgAction setImage:[UIImage imageNamed:@"jinmen"]];
                [cell.labelName setTextColor:MAINDEEPCOLOR];
                [cell.labelTime setTextColor:MAINDEEPCOLOR];
            }
            else
            {
                [cell.imgAction setImage:[UIImage imageNamed:@"chumen"]];
                [cell.labelName setTextColor:[UIColor redColor]];
                [cell.labelTime setTextColor:[UIColor redColor]];
            }
            [cell.labelName setText:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]];
            [cell.labelTime setText:[dict objectForKey:@"datetime"]];
            return cell;
            break;
        }
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if ([[dictInfo objectForKey:@"student"] isKindOfClass:[NSArray class]]) {
            NSLog(@"Is ClassArr");
            return;

        }
        NSDictionary *dict = [dictInfo objectForKey:@"student"];
        NSString *mobile = [dict objectForKey:@"mobile"];
        if(mobile != nil && mobile.length > 6)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", mobile]]];
        }
    }
    else if(indexPath.section == 1)
    {
        NSArray *list = [dictInfo objectForKey:@"familylist"];
        NSDictionary *dict = [list objectAtIndex:indexPath.row];
        NSString *mobile = [dict objectForKey:@"mobile"];
        if(mobile != nil && mobile.length > 6)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", mobile]]];
        }
    }
}

@end
