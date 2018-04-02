//
//  ViewControllerAbsent.m
//  hsimapp
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerAbsent.h"

@interface ViewControllerAbsent ()

@end

@implementation ViewControllerAbsent

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)setAbsetNowDate:(NSDate *)date
{
    [self.startDate setDate:date];
    if([self.endDate.date timeIntervalSinceDate:date] < 30 * 60)
    {
        [self.endDate setDate:[date dateByAddingTimeInterval:30 * 60]];
    }
}

-(void)setAbsentStartDate:(NSDate *)date
{
    [self.startDate setMinimumDate:[date dateByAddingTimeInterval:0]];
    [self.startDate setMaximumDate:[date dateByAddingTimeInterval:7 * 24 * 60 * 60]];
    [self.endDate setMinimumDate:[date dateByAddingTimeInterval:30 * 60]];
    [self.endDate setMaximumDate:[date dateByAddingTimeInterval:7 * 24 * 60 * 60 + 30 * 60]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    roundIt(self.absentMsg);
    roundIt(self.sendButton);
    /*
     [_absentDate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
     _absentDate.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];//（北京时间）
     [self.endDate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
     self.endDate.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];//（北京时间）
     */
    NSDate *_date = [NSDate date];
    [self setAbsentStartDate:[NSDate date]];
    [self setAbsetNowDate:[NSDate date]];
    
    [self.textStartDate setText:[HSCoreData stringOfMinuteByDate:[_date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]]]];
    [self.textEndDate setText:[HSCoreData stringOfMinuteByDate:[_date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]] + 30 * 60]]];
    
    [self.startDate addTarget:self action:@selector(startdateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.endDate addTarget:self action:@selector(enddateChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark   ----触摸取消输入----
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.endDate setHidden:YES];
    [self.startDate setHidden:YES];
    [self.view endEditing:YES];
}

-(void)startdateChanged:(id)sender
{
    UIDatePicker * control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    if(_date < [NSDate date])
    {
        //[_absentDate setDate:[NSDate date]];
    }
    [self setAbsetNowDate:_date];
    NSLog(@"%@, %@, %@, %@", [[NSDate date] dateByAddingTimeInterval:8 * 60 * 60], [_date dateByAddingTimeInterval:8 * 60 * 60], [self.startDate date], [self.endDate date]);
    
    [self.textStartDate setText:[HSCoreData stringOfMinuteByDate:[_date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]]]];
    [self.textStartDate setText:[HSCoreData stringOfMinuteByDate:_date]];
}

-(void)enddateChanged:(id)sender
{
    UIDatePicker * control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    if(_date < [NSDate date])
    {
        //[_absentDate setDate:[NSDate date]];
    }
    NSLog(@"%@, %@, %@", _date, [self.startDate date], [self.endDate date]);
    
    [self.textEndDate setText:[HSCoreData stringOfMinuteByDate:[_date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]]]];
    [self.textEndDate setText:[HSCoreData stringOfMinuteByDate:_date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    if(textField == self.textStartDate)
    {
        [self.endDate setHidden:YES];
        [self.startDate setHidden:NO];
        return NO;
    }
    else if(textField == self.textEndDate)
    {
        [self.endDate setHidden:NO];
        [self.startDate setHidden:YES];
        NSLog(@"%@, %@", [self.startDate date], [[self.startDate date] dateByAddingTimeInterval:30 * 60]);
        [self.endDate setMinimumDate:[[self.startDate date] dateByAddingTimeInterval:30 * 60]];
        return NO;
    }
    
    return TRUE;
}

- (IBAction)OnBtAbsent:(id)sender
{
    if([self.textStartDate.text length] == 0 || [self.textEndDate.text length] == 0)
    {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"日期输入错误" description:@"请重新输入" type:TWMessageBarMessageTypeInfo];
        return;
    }
//    NSDate *date = [self.calendarView selectedDate];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
//    NSString *fromtime = [dateFormatter stringFromDate:date];
    
    //    checkcode：用户识别code
    //fromtime:请假开始时间  格式：2016-07-19 09:00
    //totime:请假结束时间  格式：2016-07-20 09:00
    //content: 咨询内容
    //
    Waiting(TIMEOUT, @"waitingabsent");
    NSString *reson = self.absentMsg.text;
    [_Master SubmitTo:@"postAskleave" andParams:@{@"checkcode":[HSAppData getCheckCode], @"fromtime": self.textStartDate.text, @"totime": self.textEndDate.text, @"content": reson}  success:^(NSDictionary * dict) {
        StopWaiting;
        [self showCloseMessage:[dict objectForKey:@"str"] andDelay:1.5f];
        PostMessage(msgDataNeedRefresh, nil);
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"提交错误，请重新尝试."];
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"dlkjf:%@", pickerView);
}

@end
