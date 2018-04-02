
//
//  ViewControllerAttendance.m
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerAttendance.h"
#import "CLWeeklyCalendarView.h"
#import "CellAttendance.h"
#import "CellAbsent.h"
#import "AddentTableViewCell.h"

#define TakePhotoCellIdentify   @"TakePhotoCellIdentify"
@interface ViewControllerAttendance ()<CLWeeklyCalendarViewDelegate>
{
    NSArray *listAttendance;
    NSArray *listAbsent;
    
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
//@property (nonatomic,strong) AddentTableViewCell  * abdentcell;
@end

@implementation ViewControllerAttendance

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calendarView];
    
//    listAttendance = [[JsonObject jsonForAPI:@"getAttendance"] objectForKey:@"attendance"];
    
    //解决tableView分割线左边不到边的情况
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"AddentTableViewCell" bundle:nil] forCellReuseIdentifier:TakePhotoCellIdentify];
//    _abdentcell = [self.tableView dequeueReusableCellWithIdentifier:TakePhotoCellIdentify];
    // 不显示多余的分割线
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];

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

- (void)reloadData
{
    NSDate *date = [self.calendarView selectedDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self runAPI:@"getAttendance" andParams:@{@"checkcode": [HSAppData getCheckCode], @"date": dateString} success:^(NSDictionary * Fisdict) {
        NSLog(@"FisDict is %@",Fisdict);
        listAttendance = [Fisdict objectForKey:@"attendance"];
        NSDictionary * pasDic = listAttendance.firstObject;
        [self runAPI:@"getAbsentList" andParams:@{@"checkcode": [HSAppData getCheckCode], @"date": dateString, @"classid":[pasDic objectForKey:@"classid"]} success:^(NSDictionary * dict) {
            NSLog(@"dict is %@",dict);
            listAbsent = [dict objectForKey:@"absentlist"];
            [self.tableView reloadData];
        }];
        }];

}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (listAttendance.count>1) {
        return 1;
    }else
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return listAttendance.count;
    }else
    {
        return listAbsent.count;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.0;

    }else
    {
        return 54;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        static NSString *cellId = @"idCellAttendance";
        CellAttendance *cell = (CellAttendance *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[CellAttendance alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        if(indexPath.row % 2)
        {
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        NSDictionary *dict = [listAttendance objectAtIndex:indexPath.row];
        int ab = [[dict objectForKey:@"absent"] intValue];
        int total = [[dict objectForKey:@"total"] intValue];
        NSString *strName = [NSString stringWithFormat:@"(%.1f%%)%@", (ab) / (float)total * 100, [dict objectForKey:@"classname"]];
        [cell.labelClass setText:strName];
        [cell.labelCount setText:[NSString stringWithFormat:@"%d/%d", (ab), total]];
         return cell;

    }else
    {
     
        static NSString *cellIdentifier = @"cell4";
        AddentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddentTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row % 2)
        {
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        NSDictionary *dict = [listAbsent objectAtIndex:indexPath.row];
        cell.dic = dict;
        return cell;
    }
//            return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (listAttendance.count>1) {
            NSDictionary *dict = [listAttendance objectAtIndex:indexPath.row];
            [self showSegueWithObject:dict Identifier:@"showViewAbsent"];

    }
}

@end
