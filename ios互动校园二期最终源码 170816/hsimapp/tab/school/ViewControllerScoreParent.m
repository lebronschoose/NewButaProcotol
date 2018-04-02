//
//  ViewControllerScoreParent.m
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerScoreParent.h"
#include "CellScore.h"

@interface ViewControllerScoreParent ()
{
    NSMutableArray *listExam;
    NSMutableArray *listScore;
    int selectedExam;
}
@end

@implementation ViewControllerScoreParent

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
//    listScore = [[JsonObject jsonForAPI:@"getSoreByExamAndStudent"] objectForKey:@"scorelist"];
    
    listExam = [[NSMutableArray alloc] init];
    listScore = [[NSMutableArray alloc] init];
    
    [self.textExam setEnabled:NO];
    [self.textExam setTextColor:[UIColor grayColor]];
    [self loadExams];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExams
{
    [listExam removeAllObjects];
    [listScore removeAllObjects];
    [self.textExam setText:@"选择考试"];
    [self reloadData];
    
    [self.textExam setEnabled:NO];
    [self.textExam setTextColor:[UIColor grayColor]];
    
    [self runAPI:@"getExamByClass" andParams:@{@"checkcode": [HSAppData getCheckCode], @"classid": [NSNumber numberWithInt:[HSAppData getClassid]]} success:^(NSDictionary * dict) {
        NSLog(@"getExamByClass is %@",dict);
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
    [self runAPI:@"getScoreByExamAndStudent" andParams:@{@"checkcode": [HSAppData getCheckCode], @"uid": NN(0), @"examid": [[listExam objectAtIndex:selectedExam] objectForKey:@"id"]} success:^(NSDictionary * dict) {
        NSLog(@"getScoreByExamAndStudent is %@",dict);
        listScore = [dict objectForKey:@"scorelist"];
        if (listScore.count == 0) {
            [self showMessage:@"无数据"];
        }else
        {
             [self reloadData];
        }
       
    }];
}

- (void)reloadData
{
    if(!self.textExam.enabled) return;
    [self.tableView reloadData];
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
    if(textField == self.textExam)
    {
        [self startMiddlePicker:@"exam" ofTitle:@"点击选择考试" andFinish:@"点击确定"];
        return NO;
    }
    return YES;
}

#pragma mark --- picker view delegate ---

- (void)endPickItem
{
    NSLog(@"结果 %@", [[listExam objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]);
    [self.textExam setText:[[listExam objectAtIndex:[self selectedRowInComponent:0]] objectForKey:@"name"]];
    selectedExam = (int)[self selectedRowInComponent:0];
    [self loadScores];


}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [listExam count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[listExam objectAtIndex:row] objectForKey:@"name"];
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
    NSString * tempstring;
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
