//
//  ViewControllerScoreTeacher.m
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerScoreTeacher.h"
#include "CellScore.h"

@interface ViewControllerScoreTeacher ()
{
    NSMutableArray *listScore;
    NSMutableArray *allScores;
    NSArray *listClass;
    NSMutableArray *listExam;
    
    int selectedClass;
    int selectedExam;
    int selectedCourse;
    
    NSMutableArray *listCourse;
}
@end

@implementation ViewControllerScoreTeacher

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // Do any additional setup after loading the view.
//    listExam = [[JsonObject jsonForAPI:@"getExamByClass"] objectForKey:@"examlist"];
//    listScore = [[JsonObject jsonForAPI:@"getSoreByExamAndClass"] objectForKey:@"scorelist"];
//    listClass = [[JsonObject jsonForAPI:@"getClassList"] objectForKey:@"classlist"];
    
    listExam = [[NSMutableArray alloc] init];
    listScore = [[NSMutableArray alloc] init];
    allScores = [[NSMutableArray alloc] init];
    listCourse = [[NSMutableArray alloc] init];
    
    [self.textClass setEnabled:NO];
    [self.textExam setEnabled:NO];
    [self.textCourse setEnabled:NO];
    [self.textClass setTextColor:[UIColor grayColor]];
    [self.textExam setTextColor:[UIColor grayColor]];
    [self.textCourse setTextColor:[UIColor grayColor]];
    
    self.bottomConstraint.constant = 44;
    [self runAPI:@"getClassList" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        listClass = [dict objectForKey:@"classlist"];
        if(listClass.count > 0)
        {
            [self.textClass setEnabled:YES];
            [self.textClass setTextColor:MAINCOLOR];
            selectedClass = 0;
            [self.textClass setText:[[listClass objectAtIndex:0] objectForKey:@"name"]];
            [self loadExams];
        }
    }];
}

- (void)loadExams
{
    [listExam removeAllObjects];
    [listScore removeAllObjects];
    [allScores removeAllObjects];
    [listCourse removeAllObjects];
    selectedCourse = 0;
    [self.textExam setText:@"选择考试"];
    [self.textCourse setText:@"按科目查看"];
    [self reloadData];
    
    [self.textExam setEnabled:NO];
    [self.textExam setTextColor:[UIColor grayColor]];
    [self.textCourse setEnabled:NO];
    [self.textCourse setTextColor:[UIColor grayColor]];
    
    [self runAPI:@"getExamByClass" andParams:@{@"checkcode": [HSAppData getCheckCode], @"classid": [[listClass objectAtIndex:selectedClass] objectForKey:@"id"]} success:^(NSDictionary * dict) {
        NSLog(@"dict is %@",dict);
        listExam = [dict objectForKey:@"examlist"];
        if(listExam.count > 0)
        {
            selectedExam = 0;
            [self.textExam setEnabled:YES];
            [self.textExam setTextColor:MAINCOLOR];
            [self.textExam setText:[[listExam objectAtIndex:0] objectForKey:@"name"]];
            [self loadScores];
        }
    }];
}

- (void)loadScores
{
    [self runAPI:@"getScoreByExamAndClass" andParams:@{@"checkcode": [HSAppData getCheckCode], @"classid": [[listClass objectAtIndex:selectedClass] objectForKey:@"id"], @"examid": [[listExam objectAtIndex:selectedExam] objectForKey:@"id"]} success:^(NSDictionary * dict) {
        NSLog(@"getScoreByExamAndClassdict is %@",dict);
        allScores = [dict objectForKey:@"scorelist"];
        [self.textCourse setEnabled:YES];
        [self.textCourse setTextColor:MAINCOLOR];
        [self.textCourse setText:@"全部科目"];
        selectedCourse = 0;
        
        [listCourse addObject:@{@"id": NN(0), @"name": @"全部科目"}];
        NSMutableDictionary *dictCourse = [[NSMutableDictionary alloc] init];
        for(NSDictionary *d in allScores)
        {
            [dictCourse setObject:[d objectForKey:@"course"] forKey:[d objectForKey:@"courseid"]];
        }
        NSArray *keys = [dictCourse allKeys];
        for(id key in keys)
        {
            [listCourse addObject:@{@"id": key, @"name": [dictCourse objectForKey:key]}];
        }
        if (allScores.count == 0) {
            [self showMessage:@"无数据"];
        }else
        {
        [self reloadData];
        }
    }];
}

- (void)reloadData
{
    if(!self.textClass.enabled) return;
    if(!self.textExam.enabled) return;
    if(!self.textCourse.enabled) return;
    
    [listScore removeAllObjects];
    NSLog(@"selectedCourse is %d",selectedCourse);
    if(selectedCourse == 0)
    {
        [listScore addObjectsFromArray:allScores];
    }
    else
    {
        NSNumber *courseID = [[listCourse objectAtIndex:selectedCourse] objectForKey:@"id"];
        for(id score in allScores)
        {
            NSNumber *cid = [score objectForKey:@"courseid"];
            if(cid.intValue == courseID.intValue)
            {
                [listScore addObject:score];
            }
        }
    }
    [self.tableView reloadData];
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
    if(textField == self.textClass)
    {
        [self startMiddlePicker:@"class" ofTitle:@"点击选择班级" andFinish:@"点击确定"];
    }
    if(textField == self.textExam)
    {
        [self startMiddlePicker:@"exam" ofTitle:@"点击选择考试" andFinish:@"点击确定"];
    }
    if(textField == self.textCourse)
    {
        [self startMiddlePicker:@"course" ofTitle:@"点击选择科目" andFinish:@"点击确定"];
    }
    return NO;
}

#pragma mark --- picker view delegate ---

- (void)endPickItem
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        NSLog(@"结果 %@", [[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
        [self.textClass setText:[[listClass objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedClass = (int)[self selectedRowInComponent:0];
        [self loadExams];
    }
    else if([self.pickerFlag isEqualToString:@"exam"])
    {
        NSLog(@"结果 %@", [[listExam objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
        [self.textExam setText:[[listExam objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedExam = (int)[self selectedRowInComponent:0];
        [self loadScores];
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        NSLog(@"结果 %@", [[listCourse objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
        [self.textCourse setText:[[listCourse objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
        selectedCourse = (int)[self selectedRowInComponent:0];
        
        [self reloadData];
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        return [listClass count];
    }
    else if([self.pickerFlag isEqualToString:@"exam"])
    {
        return [listExam count];
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        return [listCourse count];
    }
    return 0;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.pickerFlag isEqualToString:@"class"])
    {
        return [[listClass objectAtIndex:row] objectForKey:@"name"];
    }
    else if([self.pickerFlag isEqualToString:@"exam"])
    {
        return [[listExam objectAtIndex:row] objectForKey:@"name"];
    }
    else if([self.pickerFlag isEqualToString:@"course"])
    {
        return [[listCourse objectAtIndex:row] objectForKey:@"name"];
    }
    return @"";
}
#pragma mark --- END of picker view delegate ---

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listScore.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellScore";
    CellScore *cell = (CellScore *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellScore alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    NSDictionary *dict = [listScore objectAtIndex:indexPath.row];
    NSString * tempstring   ;
    if ([NSString isBlankString:[dict objectForKey:@"student"]]) {
        tempstring =@"";
    }else
    {
        tempstring = [dict objectForKey:@"student"];
    }
    [cell.labelName setText:tempstring];
    [cell.labelCourse setText:[dict objectForKey:@"course"]];
    [cell.labelScore setText:[NSString stringWithFormat:@"%@", [dict objectForKey:@"score"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
