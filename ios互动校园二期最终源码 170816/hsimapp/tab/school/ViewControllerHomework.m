//
//  ViewControllerHomework.m
//  hsimapp
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerHomework.h"
#import "CLWeeklyCalendarView.h"
#import "CellHomework.h"

@interface ViewControllerHomework ()<CLWeeklyCalendarViewDelegate>
{
    NSArray *listClass;
    NSArray *listHomework;
}

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation ViewControllerHomework

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    
    if(![_Master isTeacher])
    {
        [self.btNewHomework setHidden:YES];
    }
    else
    {
        self.bottomConstraint.constant = 44;
        [self runAPI:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
            NSLog(@"getClassList is %@",dict);
            listClass = [dict objectForKey:@"classlist"];
//            if(self.transObj != nil)
//            {
//                int nIndex = 0;
//                for(NSDictionary *d in listClass)
//                {
//                    NSNumber *certainid = [self.transObj objectForKey:@"classid"];
//                    NSNumber *classid = [d objectForKey:@"id"];
//                    if(classid.intValue == certainid.intValue)
//                    {
//                        [self setSelectRow:nIndex InComponent:0];
//                        break;
//                    }
//                    nIndex++;
//                }
//            }
            [self reloadPicker];
            [self reloadData];
        }];
        [self.btNewHomework setHidden:NO];
        [self startBottomPicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }
    CareMsg(msgDataNeedRefresh);
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgDataNeedRefresh])
    {
        [self reloadData];
    }
}

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView)
    {
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
        if(self.transObj == nil)
        {
            [_calendarView setSelectedDate:[NSDate date]];
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
            NSDate *date = [dateFormatter dateFromString:[self.transObj objectForKey:@"date"]];
            if(date == nil)
            {
                [_calendarView setSelectedDate:[NSDate date]];
            }
            else [_calendarView setSelectedDate:date];
            [_calendarView redrawToDate:date];
        }
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
    NSLog(@"has selected date: %@", date);
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

- (void)reloadData
{
    NSDate *date = [self.calendarView selectedDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSNumber *classid = NN(0);
    if([_Master isTeacher])
    {
        if(listClass == nil || listClass.count <= 0) return;
        NSInteger sel = [self selectedRowInComponent:0];
        classid = [[listClass objectAtIndex:sel] objectForKey:@"id"];
    }
    else
    {
        classid = NN(0);// [NSNumber numberWithInt:[HSAppData getClassid]];
    }
    [self runAPI:@"getHomeworkByClass" andParams:@{@"checkcode": [HSAppData getCheckCode], @"date": dateString, @"classid": classid} success:^(NSDictionary * dict) {
        NSLog(@"getHomeworkByClass is %@",dict);
        
        listHomework = [dict objectForKey:@"homeworklist"];
        [self.tableView reloadData];
    }];
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
    return [[listClass objectAtIndex:row] objectForKey:@"name"];
}
#pragma mark --- END of picker view delegate ---

- (IBAction)onNewHomework:(id)sender
{
    [self showSegueWithObject:listClass Identifier:@"showNewHomework"];
}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listHomework.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [listHomework objectAtIndex:indexPath.row];
    CGSize size = [CellHomework sizeForText:[dict objectForKey:@"content"]];
     NSLog(@"dictcontnet is %@",[dict objectForKey:@"content"]);
    NSLog(@"size.hetiht is %lf",size.height);
    return 95.0 + size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellHomework";
    CellHomework *cell = (CellHomework *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellHomework alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [listHomework objectAtIndex:indexPath.row];
    NSString * tempauthor;
    NSString * tempauthorname;

    if ([NSString isBlankString:[dict objectForKey:@"authorname"]]) {
         tempauthorname = @"";
    }else
    {
        tempauthorname = [dict objectForKey:@"authorname"];
    }
    if ([NSString isBlankString:[dict objectForKey:@"author"]]) {
        tempauthor = @"";
    }else
    {
        tempauthor = [dict objectForKey:@"author"];
    }

    [cell loadImage:@"defaultlogo" andURL:[NSString stringWithFormat:@"http://www.bwxkj.com/uploads/headpic/%@_s.jpg", tempauthor]];
    [cell.labelAuthor setText:tempauthorname];
    [cell.labelCourse setText:[dict objectForKey:@"course"]];
    [cell.labelTime setText:[dict objectForKey:@"datetime"]];
   
    [cell.labelHomework setText:[dict objectForKey:@"content"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
