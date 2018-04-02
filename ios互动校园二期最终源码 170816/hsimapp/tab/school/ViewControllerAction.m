//
//  ViewControllerAction.m
//  hsimapp
//
//  Created by apple on 16/7/3.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerAction.h"
#import "CLWeeklyCalendarView.h"
#import "CellAction.h"
#import "CellTotalAction.h"

@interface ViewControllerAction ()<CLWeeklyCalendarViewDelegate>
{
    int viewType;
    NSMutableArray *listAction;
    NSMutableArray * dataArr;
    NSMutableArray * inArray;
    NSMutableArray * OutArray;
    NSMutableArray * Unknowrray;
    NSArray *listClass;
    NSDictionary *dictAction;
    BOOL IsReload;
}

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property(strong,nonatomic)UILabel * emptyLabel;

@end

@implementation ViewControllerAction


-(UILabel *)emptyLabel
{
    if (_emptyLabel == nil) {
        self.emptyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 40)];
        [_emptyLabel setTextColor:[UIColor colorFromHexString:@"#ff01bafe"]];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:20];
        _emptyLabel.text = @"今天无人打卡";
    }
    return _emptyLabel;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"行为记录";
    self.btSeg.hidden = YES;
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
    IsReload = NO;
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calendarView];
    // [[JsonObject jsonForAPI:@"getActionByStudent"] objectForKey:@"actionlist"];
    listAction = [NSMutableArray array];
    inArray = [NSMutableArray array];
    OutArray = [NSMutableArray array];
    Unknowrray = [NSMutableArray array];
//    listClass = [[JsonObject jsonForAPI:@"getClassList"] objectForKey:@"classlist"];
    
    if([_Master isTeacher])
    {
        viewType = 1;
        
        self.bottomConstraint.constant = 44;
//        [_Master SubmitTo:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dic) {
//            NSLog(@"dic is%@",dic);
//        } failed:^{
//            
//        }];
        [self runAPI:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
            StopWaiting;
            listClass = [dict objectForKey:@"classlist"];
            [self reloadPicker];
            [self reloadData];
        }];
        [self startBottomPicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }
    else
    {
        viewType = 0;
        self.bottomConstraint.constant = 0;
        [self.btSeg setHidden:YES];
    }
    CareMsg(msgDataNeedRefresh);
}

//- (IBAction)onSegChanged:(id)sender
//{
//    UISegmentedControl *seg = (UISegmentedControl *)sender;
//    viewType = (int)seg.selectedSegmentIndex;
//    [self reloadData];
//}
//
- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgDataNeedRefresh])
    {
        [self.tableView reloadData];
    }
}

- (void)reloadData
{
    NSDate *date = [self.calendarView selectedDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if(dateString == nil) return;
    
    Waiting(TIMEOUT, @"waitingaction");
    if([_Master isTeacher])
    {
        if(listClass == nil || listClass.count <= 0) return;
        
        NSString *api = @"getActionByClass2";
//        if(viewType == 1)
//        {
//            api = @"getActionByClass";
//        }
        NSInteger sel = [self selectedRowInComponent:0];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:[HSAppData getCheckCode] forKey:@"checkcode"];
        [dic setValue:dateString forKey:@"date"];
        [dic setValue:[[listClass objectAtIndex:sel] objectForKey:@"id"] forKey:@"classid"];
        [_Master SubmitTo:api andParams:dic  success:^(NSDictionary * dict) {
            StopWaiting;
//            if(viewType == 1)
//            {
            NSLog(@"getActionByClass2 is %@",dict);
                dataArr = [dict objectForKey:@"actionlist"];
            for (NSDictionary * dic in dataArr) {
                if ([dic[@"action"] integerValue] == 1) {
                    [inArray addObject:dic];
                }else if ([dic[@"action"] integerValue] == 2)
                {
                    [OutArray addObject:dic];
                }else
                {
                    [Unknowrray addObject:dic];
                }
            }
                listAction = dataArr;
                dictAction = dict;
                IsReload = YES;
            [self.tableView reloadData];
        } failed:^{
            NSLog(@"failed.");
            [self showMessage:@"请求失败，请重新尝试."];
        }];
    }
    else
    {
        [_Master SubmitTo:@"getActionByStudent" andParams:@{@"checkcode":[HSAppData getCheckCode], @"date": dateString, @"uid": NN(0)}  success:^(NSDictionary * dict) {
            StopWaiting;
            listAction = [dict objectForKey:@"actionlist"];
            IsReload = YES;
            [self.tableView reloadData];
        } failed:^{
            NSLog(@"failed.");
            [self showMessage:@"请求失败，请重新尝试."];
        }];
    }
}

//Initialize
- (CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView)
    {
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

#pragma mark - CLWeeklyCalendarViewDelegate
- (NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}

- (void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    listAction = [NSMutableArray array];
    inArray = [NSMutableArray array];
    OutArray = [NSMutableArray array];
    Unknowrray = [NSMutableArray array];

    [self reloadData];
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


#pragma mark --- picker view delegate ---

- (void)endPickItem
{
    [self reloadData];
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [listClass count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * tempName;
    if ([NSString isBlankString:[[listClass objectAtIndex:row] objectForKey:@"name"]]) {
        tempName = @"";
    }else
    {
        tempName = [[listClass objectAtIndex:row] objectForKey:@"name"];
    }
    return tempName;
}
#pragma mark --- END of picker view delegate ---

- (IBAction)onTest:(id)sender
{
    //    [UIView setAnimationDelegate:self];
    //    [UIView beginAnimations:@"move" context:nil];
    //    //设定动画持续时间
    //    [UIView setAnimationDuration:0.3];
    //    //动画的内容
    //    CGRect frame = self.pickerClass.frame;
    //    frame.origin.y -= 150;
    //    [self.pickerClass setFrame:frame];
    //    //动画结束
    //    [UIView commitAnimations];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(viewType == 0)
    {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listAction.count == 0 && inArray.count == 0 && OutArray.count == 0 && Unknowrray.count == 0 && IsReload == YES) {
        [self.tableView addSubview:self.emptyLabel];
        return 0;
    }else
    {
        [_emptyLabel removeFromSuperview];
        if(viewType == 0)
        {
            return listAction.count;
        }
        else
        {
            if (section == 0) {
                return 1;
            }else
            {
                return listAction.count;
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(viewType == 0)
    {
        return 20.0;
    }
    else
        return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(viewType == 0)
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
        [cell.imgAction setHidden:NO];
        [cell.labelTime setHidden:NO];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        NSDictionary *dict = [listAction objectAtIndex:indexPath.row];
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

    }else
    {
    if (indexPath.section == 0) {
        static NSString *cellId = @"idCellTotalAction";
        CellTotalAction *cell = (CellTotalAction *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[CellTotalAction alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        {
            NSNumber *count = [dictAction objectForKey:@"total"];
            [cell.btTotal setTitle:[NSString stringWithFormat:@"总共:%@", count] forState:UIControlStateNormal];
        }
        {
//            NSDictionary *dict = [dictAction objectForKey:@"in_total"];
            NSNumber *count = [dictAction objectForKey:@"in_total"];
            [cell.btIn setTitle:[NSString stringWithFormat:@"进校:%@", count] forState:UIControlStateNormal];
        }
        {
//            NSDictionary *dict = [dictAction objectForKey:@"out_total"];
            NSNumber *count = [dictAction objectForKey:@"out_total"];
            [cell.btOut setTitle:[NSString stringWithFormat:@"离校:%@", count] forState:UIControlStateNormal];
        }
        {
//            NSDictionary *dict = [dictAction objectForKey:@"unknown_total"];
            NSNumber *count = [dictAction objectForKey:@"unknown_total"];;
            [cell.btUnkown setTitle:[NSString stringWithFormat:@"未读:%@", count] forState:UIControlStateNormal];
            if(count.intValue == 0)
            {
                [cell.btUnkown setHidden:YES];
            }
            else
            {
                [cell.btUnkown setHidden:NO];
            }
        }
        [cell.btTotal addTarget:self action:@selector(onBtTotal:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btIn addTarget:self action:@selector(onBtIN:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btOut addTarget:self action:@selector(onBtOut:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btUnkown addTarget:self action:@selector(onBtUnknown:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else
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
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        NSDictionary *dict = [listAction objectAtIndex:indexPath.row];
        NSNumber *actionType = [dict objectForKey:@"action"];
        [cell.imgAction setHidden:NO];
        [cell.labelTime setHidden:NO];
//        CGRect temp = cell.labelName.frame;
        if(actionType.intValue == 1)
        {
//            temp.size.width = 10;
            [cell.imgAction setImage:[UIImage imageNamed:@"jinmen"]];
            [cell.labelName setTextColor:MAINDEEPCOLOR];
            [cell.labelTime setTextColor:MAINDEEPCOLOR];
            [cell.labelTime setText:[dict objectForKey:@"datetime"]];
        }
        else if (actionType.intValue == 2)
        {
            [cell.imgAction setImage:[UIImage imageNamed:@"chumen"]];
            [cell.labelName setTextColor:[UIColor redColor]];
            [cell.labelTime setTextColor:[UIColor redColor]];
            [cell.labelTime setText:[dict objectForKey:@"datetime"]];
        }else
        {
            NSLog(@"未知");
            [cell.imgAction setImage:[UIImage imageNamed:@"weizhi"]];
//            [cell.imgAction setHidden:YES];
            [cell.labelTime setHidden:YES];
            [cell.labelName setTextColor:[UIColor blackColor]];
            
            
        }
        [cell.labelName setText:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]];
        
        return cell;
    }
    }
}

- (IBAction)onBtTotal:(id)sender
{
    listAction = dataArr;
    [self.tableView reloadData];
}

- (IBAction)onBtIN:(id)sender
{
    listAction = inArray;
    [self.tableView reloadData];
}

- (IBAction)onBtOut:(id)sender
{
    listAction = OutArray;
    [self.tableView reloadData];
}

- (IBAction)onBtUnknown:(id)sender
{
    listAction = Unknowrray;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(viewType == 0)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                break;
            }
            case 1:
            case 2:
            {
                NSString *theKey = @"in";
                if(indexPath.section == 2)
                {
                    theKey = @"out";
                }
                NSDictionary *dictIn = [dictAction objectForKey:theKey];
                NSArray *actions = [dictIn objectForKey:@"actionlist"];
                NSDictionary *dict = [actions objectAtIndex:indexPath.row];
                NSNumber *uid = [dict objectForKey:@"uid"];
                NSString * tempName;
                if ([NSString isBlankString:[dict objectForKey:@"name"]]) {
                    tempName = @"";
                }else
                {
                    tempName = [dict objectForKey:@"name"];
                }
                [self showSegueWithObject:@{@"name": tempName, @"uid": uid} Identifier:@"showStudentAction"];
                break;
            }
            case 3:
            {
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            return;
        }
        NSDictionary *dict = [listAction objectAtIndex:indexPath.row];
        NSNumber *uid = [dict objectForKey:@"uid"];
        NSString * tempName;
        if ([NSString isBlankString:[dict objectForKey:@"name"]]) {
            tempName = @"";
        }else
        {
            tempName = [dict objectForKey:@"name"];
        }

        [self showSegueWithObject:@{@"name": tempName, @"uid": uid} Identifier:@"showStudentAction"];
    }
}

@end
