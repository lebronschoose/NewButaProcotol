//
//  ViewControllerViewAbsent.m
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerViewAbsent.h"
#import "CLWeeklyCalendarView.h"
#import "CellAbsent.h"
#import "AddentTableViewCell.h"

@interface ViewControllerViewAbsent ()<CLWeeklyCalendarViewDelegate>
{
    NSArray *listAbsent;
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end


@implementation ViewControllerViewAbsent

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    
//    listAbsent = [[JsonObject jsonForAPI:@"getAbsentList"] objectForKey:@"absentlist"];
    
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

- (void)didReceiveMemoryWarning {
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
    [self runAPI:@"getAbsentList" andParams:@{@"checkcode": [HSAppData getCheckCode], @"date": dateString, @"classid":[self.transObj objectForKey:@"classid"]} success:^(NSDictionary * dict) {
        listAbsent = [dict objectForKey:@"absentlist"];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listAbsent.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
