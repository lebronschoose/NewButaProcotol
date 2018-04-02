//
//  ViewControllerCourseTable.m
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerCourseTable.h"
#import "CLWeeklyCalendarView.h"
#import "CellCourse.h"

@interface ViewControllerCourseTable ()<CLWeeklyCalendarViewDelegate>
{
    NSArray *listCourseTable;
    NSArray *listClass;
}

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation ViewControllerCourseTable

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    self.tableView.tableFooterView = nil;
    
//    listClass = [[JsonObject jsonForAPI:@"getClassList"] objectForKey:@"classlist"];
//    listCourseTable = [[JsonObject jsonForAPI:@"getCourseTable"] objectForKey:@"coursetable"];
    
    if([_Master isTeacher])
    {
        self.bottomConstraint.constant = 44;
        [self runAPI:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
            NSLog(@"getClassList is %@",dict);
            listClass = [dict objectForKey:@"classlist"];
            [self reloadPicker];
            [self reloadData];
        }];
        
        [self startBottomPicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }else
    {
        self.bottomConstraint.constant = 44;
        [self PostAPI:@"getFamilyClassIdByCheckcode" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
            NSLog(@"getFamilyClassIdByCheckcode is %@",dict);
            if (dict.count == 0) {
                NSLog(@"为空");
                return;
            }
            listClass = [dict objectForKey:@"familystus"];
            [self reloadPicker];
            [self reloadData];
        }];
        
        [self startBottomPicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView)
    {
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}

-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    [self reloadData];
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

- (void)reloadData
{
    NSDate *date = [self.calendarView selectedDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSInteger sel = [self selectedRowInComponent:0];

    if([_Master isTeacher])
    {
        if(listClass == nil || listClass.count <= 0) return;
        [self runAPI:@"getCourseTable" andParams:@{@"date": dateString, @"classid": [[listClass objectAtIndex:sel] objectForKey:@"id"]} success:^(NSDictionary * dict) {
            NSLog(@"dict is %@",dict);
            listCourseTable = [dict objectForKey:@"coursetable"];
            [self.tableView reloadData];
        }];
    }
    else
    {
        if(listClass == nil || listClass.count <= 0) return;
        NSString * tempMyClass;
        if ([NSString isBlankString:[[listClass objectAtIndex:sel] objectForKey:@"myclassid"]]) {
            tempMyClass = @"";
        }else
        {
            tempMyClass = [[listClass objectAtIndex:sel] objectForKey:@"myclassid"];
        }
        NSLog(@"classid is %@",[[listClass objectAtIndex:sel] objectForKey:@"myclassid"]);
        [self PostAPI:@"getCourseTable" andParams:@{@"date": dateString, @"myclassid":tempMyClass} success:^(NSDictionary * dict) {
            NSLog(@"getCourseTable is %@",dict);
            listCourseTable = [dict objectForKey:@"coursetable"];
            if (listCourseTable.count == 0) {
                [self showMessage:@"今天没有课程了。"];
            }
            [self.tableView reloadData];
        }];
    }
}

- (void)endPickItem
{
    NSLog(@"picker selected at: %ld", (long)[self selectedRowInComponent:0]);
    
    [self reloadData];
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [listClass count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
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

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listCourseTable.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[listCourseTable objectAtIndex:section] objectForKey:@"list"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [[listCourseTable objectAtIndex:section] objectForKey:@"when"];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textAlignment= NSTextAlignmentLeft;
    header.contentView.backgroundColor = RGBColor(240, 240, 240);
    header.textLabel.font = [UIFont systemFontOfSize:16];
    [header.textLabel setTextColor:[UIColor blackColor]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8.0f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    [view setBackgroundColor:[UIColor redColor]];
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellCourse";
    CellCourse *cell = (CellCourse *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellCourse alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dict = [[[listCourseTable objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    if ([NSString isBlankString:[dict objectForKey:@"course"]]) {
        [cell.labelCourse setText:@""];

    }else
    {
        [cell.labelCourse setText:[dict objectForKey:@"course"]];

    }
    [cell.labelTime setText:[dict objectForKey:@"time"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
