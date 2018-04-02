//
//  ViewControllerNewNotice.m
//  hsimapp
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerNewNotice.h"

@interface ViewControllerNewNotice ()
{
    NSArray *listNoticeType;
    NSMutableArray *listClass;
    NSMutableArray * ClassArr;
    NSMutableArray * GradeArr;
    
    NSString * selectedNoticeType;
    int selectedClass;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopConstraint;
@end

@implementation ViewControllerNewNotice


-(void)modifyConstant
{
    
    if([_Master isSchoolMaster])
    {
        listNoticeType = @[@"学校公告",@"年级公告", @"班级公告"];
        self.textNoticeType.y = 35;
        self.textNoticeTo.hidden = YES;
        selectedNoticeType = @"1";
    }
    else if([_Master isClassMaster])
    {
        listNoticeType = @[@"班级公告"];
        self.textNoticeType.y = 10;
        self.textNoticeTo.hidden = NO;
        self.textNoticeTo.y = CGRectGetMaxY(self.textNoticeType.frame)+15;
        selectedNoticeType = @"3";
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    roundIt(self.btOK);
    
    [self.textNoticeType setText:[listNoticeType objectAtIndex:0]];;
    [self.btOK setEnabled:NO];
    [self.btOK setBackgroundColor:[UIColor grayColor]];
    [self runAPI:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
//        NSLog(@"getClassList is %@",dict);
      NSArray * mutarr    = [dict objectForKey:@"classlist"];
        [self reloadPicker];
        if(mutarr.count > 0)
        {
            [self.btOK setEnabled:YES];
            [self.btOK setBackgroundColor:MAINCOLOR];
            for (NSDictionary * dic in mutarr) {
                NSString * selfstring = dic[@"master"];
                if ([NSString isBlankString:selfstring]) {
                    selfstring = @"";
                }
                if ([_Master isSchoolMaster]) {
                    ClassArr = [mutarr mutableCopy];
                }else
                {
                if ([selfstring isEqualToString:_Master.mySelf.DDNumber]) {
                    [ClassArr addObject:dic];
                    NSLog(@"listClass is %@",listClass);
                    selectedClass = [[[ClassArr objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"id"] intValue];
                    [self.textNoticeTo setText:[[ClassArr objectAtIndex:0] objectForKey:@"name"]];
                }
                }
            }
        }
    }];
    [self PostAPI:@"getGradeList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        NSLog(@"getGradeList is %@",dict);
        NSArray * mutarr    = [dict objectForKey:@"gradelist"];
        [self reloadPicker];
        if(mutarr.count > 0)
        {
            [self.btOK setEnabled:YES];
            [self.btOK setBackgroundColor:MAINCOLOR];
            for (NSDictionary * dic in mutarr) {
                [GradeArr addObject:dic];
                selectedClass = [[[GradeArr objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"id"] intValue];
                [self.textNoticeTo setText:[[GradeArr objectAtIndex:0] objectForKey:@"name"]];

            }
        }

    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GradeArr = [NSMutableArray array];
    ClassArr = [NSMutableArray array];
    listClass = [NSMutableArray array];
    [self performSelector:@selector(modifyConstant) withObject:nil afterDelay:0.1];
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
    if(textField == self.textNoticeType)
    {
        [self startMiddlePicker:@"notice" ofTitle:@"点击选择公告类别" andFinish:@"点击确定"];
    }
    else if(textField == self.textNoticeTo)
    {
        [self startMiddlePicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }
    return NO;
}

- (IBAction)onInputContent:(id)sender
{
    [_textNoticeContent becomeFirstResponder];
}

- (IBAction)onOK:(id)sender
{
    if(self.textNoticeTitle.text.length <= 0)
    {
        [MasterUtils messageBox:@"公告标题不能为空" withTitle:@"错误" withOkText:@"确定" from:self];
        return;
    }
    if(self.textNoticeContent.text.length <= 0)
    {
        [MasterUtils messageBox:@"公告内容不能为空" withTitle:@"错误" withOkText:@"确定" from:self];
        return;
    }
    Waiting(TIMEOUT, @"waitingnewhomework");
    NSMutableDictionary * Postdic = [NSMutableDictionary dictionary];
    [Postdic setObject:[HSAppData getCheckCode] forKey:@"checkcode"];
    [Postdic setObject:self.textNoticeTitle.text forKey:@"title"];
    [Postdic setObject:self.textNoticeContent.text forKey:@"content"];
    [Postdic setObject:selectedNoticeType forKey:@"type"];
    if ([selectedNoticeType isEqualToString:@"2"]) {
        [Postdic setObject:NN(selectedClass) forKey:@"gradeid"];
    }else
    {
        [Postdic setObject:NN(selectedClass) forKey:@"classid"];
    }
    [_Master SubmitTo:@"postNotice" andParams:Postdic  success:^(NSDictionary * dict) {
        StopWaiting;
        NSLog(@"succedict is %@",dict);
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
    if([self.pickerFlag isEqualToString:@"notice"])
    {
        NSLog(@"结果 %@", [listNoticeType objectAtIndex:[self selectedRowInComponent:0]]);
       
        [self.textNoticeType setText:[listNoticeType objectAtIndex:[self selectedRowInComponent:0]]];
        if([self selectedRowInComponent:0] == 0 && [_Master isSchoolMaster])
        {
          
//            self.textNoticeTo.y = 25;
            self.textNoticeType.y = 35;
            self.textNoticeTo.hidden = YES;
            selectedNoticeType = @"1";
        }else if ([self selectedRowInComponent:0] == 1 && [_Master isSchoolMaster])
        {
            self.textNoticeType.y = 10;
            listClass = GradeArr;
            if (listClass.count >0) {
                [self.textNoticeTo setText:[[listClass objectAtIndex:0] objectForKey:@"name"]];
            }else
            {
                [self.textNoticeTo setText:@"年级公告"];
            }
            

            self.textNoticeTo.hidden = NO;
            self.textNoticeTo.y = CGRectGetMaxY(self.textNoticeType.frame)+15;
            selectedNoticeType = @"2";
            selectedClass = [[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"id"] intValue];
        }
        else
        {
            self.textNoticeType.y = 10;
            listClass = ClassArr;
            if (listClass.count >0) {
                [self.textNoticeTo setText:[[listClass objectAtIndex:0] objectForKey:@"name"]];
            }else
            {
                [self.textNoticeTo setText:@"班级公告"];
            }            self.textNoticeTo.hidden = NO;
            self.textNoticeTo.y = CGRectGetMaxY(self.textNoticeType.frame)+15;
            selectedNoticeType = @"3";
            selectedClass = [[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"id"] intValue];
        }
    }
    else if([self.pickerFlag isEqualToString:@"class"])
    {
       
        NSLog(@"结果 %@", [[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
        [self.textNoticeTo setText:[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedClass = [[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"id"] intValue];
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"notice"])
    {
        return listNoticeType.count;
    }
    else if([self.pickerFlag isEqualToString:@"class"])
    {
        return listClass.count;
    }
    return 0;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"notice"])
    {
        return [listNoticeType objectAtIndex:row];
    }
    else if([self.pickerFlag isEqualToString:@"class"])
    {
        return [[listClass objectAtIndex:row] objectForKey:@"name"];
    }
    return @"";
}
#pragma mark --- END of picker view delegate ---

@end


