//
//  ViewControllerRecipe.m
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerRecipe.h"
#import "CLWeeklyCalendarView.h"
#import "CellRecipe.h"

@interface ViewControllerRecipe ()<CLWeeklyCalendarViewDelegate>
{
    NSArray *listRecipe;
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation ViewControllerRecipe

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    
//    listRecipe = [[JsonObject jsonForAPI:@"getRecipe"] objectForKey:@"recipe"];
    
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
    NSLog(@"sel date");
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

#pragma mark - Table View Data Source

- (void)reloadData
{
    NSDate *date = [self.calendarView selectedDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self runAPI:@"getRecipe" andParams:@{@"checkcode": [HSAppData getCheckCode], @"date": dateString} success:^(NSDictionary * dict) {
        listRecipe = [dict objectForKey:@"recipe"];
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listRecipe.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[listRecipe objectAtIndex:section] objectForKey:@"type"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[listRecipe objectAtIndex:indexPath.section] objectForKey:@"content"];
    if(isNullData(str)) str = @"";
    CGSize size = [CellRecipe sizeForText:str];
    return size.height + 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellRecipe";
    CellRecipe *cell = (CellRecipe *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellRecipe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(indexPath.section % 2)
    {
        [cell.labelContent setTextColor:[UIColor redColor]];
    }
    [cell.labelContent setBackgroundColor:[UIColor clearColor]];
    NSDictionary *dict = [listRecipe objectAtIndex:indexPath.section];
    [cell.labelContent setText:[dict objectForKey:@"content"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
