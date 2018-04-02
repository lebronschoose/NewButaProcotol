//
//  ViewControllerNewHomework.m
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerNewHomework.h"

@interface ViewControllerNewHomework ()
{
    NSArray *listClass;
    NSArray *listCourse;
    int selectedClass;
    int selectedCourse;
}
@end

@implementation ViewControllerNewHomework

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    roundIt(self.btOK);
    
    listClass = self.transObj;
    selectedClass = 0;
    if(listClass.count <= 0)
    {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [self.textClass setText:[[listClass objectAtIndex:selectedClass] objectForKey:@"name"]];
    
    [self.btOK setEnabled:NO];
    [self.btOK setBackgroundColor:[UIColor grayColor]];
    //    listCourse = [[JsonObject jsonForAPI:@"getCourseList"] objectForKey:@"courselist"];
    [self runAPI:@"getCourseList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        NSLog(@"getCourseList is %@",dict);
        listCourse = [dict objectForKey:@"courselist"];
        [self reloadPicker];
        if(listCourse.count > 0)
        {
            [self.textCourse setText:[[listCourse objectAtIndex:0] objectForKey:@"name"]];
            [self.btOK setEnabled:YES];
            [self.btOK setBackgroundColor:MAINCOLOR];
        }
        else
        {
            [self.textCourse setText:@"没有任课班级"];
        }
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 100)
    {
        [self startMiddlePicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }
    else if(textField.tag == 101)
    {
        [self startMiddlePicker:@"course" ofTitle:@"点击选择课程" andFinish:@"点击确定"];
    }
    return NO;
}

- (IBAction)onInputContent:(id)sender
{
    [self.textContent becomeFirstResponder];
}

- (IBAction)onOK:(id)sender
{
    if(self.textContent.text.length <= 0)
    {
        [self showMessage:@"请填写作业内容."];
        return;
    }
    Waiting(TIMEOUT, @"waitingnewhomework");
    [_Master SubmitTo:@"postHomework" andParams:@{@"checkcode":[HSAppData getCheckCode], @"classid": [[listClass objectAtIndex:selectedClass] objectForKey:@"id"], @"courseid": [[listCourse objectAtIndex:selectedCourse] objectForKey:@"id"], @"content": self.textContent.text}  success:^(NSDictionary * dict) {
        NSLog(@"dict is %@",dict);
        StopWaiting;
        [self showCloseMessage:[dict objectForKey:@"str"] andDelay:1.5f];
        PostMessage(msgDataNeedRefresh, nil);
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"提交错误，请重新尝试."];
    }];
}

#pragma mark --- picker view delegate ---

- (void)endPickItem
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        NSLog(@"结果 %@", [[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
        [self.textClass setText:[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedClass = (int)[self selectedRowInComponent:0];
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        NSLog(@"结果 %@", [listCourse objectAtIndex:[self selectedRowInComponent:0]]);
        [self.textCourse setText:[[listCourse objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedCourse = (int)[self selectedRowInComponent:0];
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        return listClass.count;
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        return listCourse.count;
    }
    else return 0;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        return [[listClass objectAtIndex:row] objectForKey:@"name"];
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        return [[listCourse objectAtIndex:row] objectForKey:@"name"];
    }
    else return @"";
}
#pragma mark --- END of picker view delegate ---

@end
