//
//  MyQuestionViewController.m
//  hsimapp
//
//  Created by dingding on 2018/1/16.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "QustionRecordViewController.h"

@interface MyQuestionViewController ()<UITextViewDelegate>
{
     UILabel * label;
    UIView * backview;
     UIView * contentView;
    UIButton * Quesionbtn;
    UIButton * NewQuestionbtn;
//    UIView * HsImView;
    UITextView * HsImtv;
    UITextField * InputTF;
    NSString * chooseString;
}

@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"问题反馈";
    chooseString = @"1";
    
    backview  = [UIView new];
    backview.backgroundColor = [UIColor colorFromHexString:@"#E6E6E6"];
    [self.view addSubview:backview];
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
        make.left.top.equalTo(@10);
    }];
    
    UILabel * titleLabel = [UILabel new];
      titleLabel.text = @"为了尽快解决您的问题，请在发生问题或再次发生问题时，立即提交反馈";
    titleLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:12];
//    titleLabel.backgroundColor = [UIColor redColor];
     [backview addSubview:titleLabel];
    titleLabel.preferredMaxLayoutWidth = ScreenWidth - 30 - 10;
    [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backview).offset(5);
        //        make.height.equalTo(@35);
        make.left.equalTo(backview).offset(5);
        make.right.mas_equalTo(-30.0);
    }];
    
    UIButton * cancelBtn = [UIButton new];
    [cancelBtn addTarget:self action:@selector(TouchCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    [backview addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.top.equalTo(backview).offset(5);
        make.right.mas_equalTo(backview.mas_right).offset(-5);
    }];
    
    contentView  = [[UIView alloc]initWithFrame:CGRectMake(5, 60, ScreenWidth-10, ScreenHeight - backview.height)];
//    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, ScreenHeight - backview.height));
//        make.top.equalTo(backview.mas_bottom).offset(5);
//         make.left.equalTo(self.view).offset(5);
//    }];
    Quesionbtn = [[UIButton alloc]init];
    Quesionbtn.tag = 100;
    [Quesionbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [Quesionbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    Quesionbtn.selected = YES;
    [Quesionbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:Quesionbtn];
    [Quesionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(-5);
        make.left.mas_equalTo(20);
        
    }];
    
    UILabel * SchoolInlabel = [[UILabel alloc]init];
    SchoolInlabel.text = @"遇到问题";
    [contentView addSubview:SchoolInlabel];
    [SchoolInlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(Quesionbtn);
        make.left.equalTo(Quesionbtn.mas_right).with.offset(2);
    }];
    
    NewQuestionbtn = [[UIButton alloc]init];
    NewQuestionbtn.tag = 101;
    [NewQuestionbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [NewQuestionbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [NewQuestionbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    [contentView addSubview:NewQuestionbtn];
    [NewQuestionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(Quesionbtn);
        make.left.equalTo(SchoolInlabel.mas_right).offset(40);
    }];
    //
    UILabel * HsimApplabel = [[UILabel alloc]init];
    HsimApplabel.text = @"新功能建议";
    [contentView addSubview:HsimApplabel];
    [HsimApplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NewQuestionbtn);
        make.left.equalTo(NewQuestionbtn.mas_right).offset(2);
    }];
    
    InputTF = [[UITextField alloc]init];
    InputTF.layer.borderWidth = 1.0;
    InputTF.placeholder = @"手机号码";
    InputTF.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:InputTF];
    [InputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
        make.left.equalTo(@10);
        make.bottom.equalTo(HsimApplabel.mas_top).offset(70);
    }];
//    HsImView = [[UIView alloc]init];
//    [contentView addSubview:HsImView];
//    [HsImView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(140, 5, 60, 5));
//    }];

    HsImtv = [[UITextView alloc]init];
    HsImtv.layer.borderWidth = 1.0;
    HsImtv.font = [UIFont systemFontOfSize:15];
//    [HsImtv becomeFirstResponder];
    HsImtv.delegate = self;
    [contentView addSubview:HsImtv];
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    label.enabled = NO;
    label.text = @"请输入内容..40字以内";
    label.font =  [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    [HsImtv addSubview:label];

    [HsImtv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, ScreenHeight - 260));
        make.top.mas_equalTo(InputTF).offset(45);
        make.left.equalTo(@10);
    }];


    UIButton * confrimBtn = [[UIButton alloc]init];
    confrimBtn.layer.cornerRadius = 5;
    confrimBtn.backgroundColor = MAINCOLOR;
    [confrimBtn addTarget:self action:@selector(ConfrimAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimBtn];
    [confrimBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confrimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
        make.left.equalTo(@10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];

    
  UIButton *   rightbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(-20, 0, 80, 34);
    rightbtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightbtn setTitle:@"我的反馈" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    
    
}
-(void)TouchCancel
{
  
    [UIView animateWithDuration:10.0f animations:^{
        [backview removeFromSuperview];
        
    } completion:^(BOOL finished) {
        contentView.y = 5;
    }];
}

-(void)ConfrimAction
{
    if([Master isMobileNumber:InputTF.text] == NO)
    {
        [self showMessage:@"请填写正确的手机号码"];
        
        return;
    }
    if (HsImtv.text.length == 0 ) {
        [self showMessage:@"问题不能为空"];
        return;
    }
    if (HsImtv.text.length >40) {
        [self showMessage:@"问题格式错误"];
        return;
    }
    
    [self SendSchoolMethods];
    
}

-(void)SelectedSchoolAction:(UIButton *)btn
{
    if (btn.tag == 100) {
        if (btn.selected == YES) {
            NSLog(@"已选中");
        }else
        {
            Quesionbtn.selected = YES;
            NewQuestionbtn.selected = NO;
            chooseString = @"1";
            
        }
    }else
    {
        if (btn.selected == YES) {
            NSLog(@"已选中");
        }else
        {
            Quesionbtn.selected = NO;
            NewQuestionbtn.selected = YES;
            chooseString = @"2";
        }
    }
}
-(void)rightBtnClick
{
    NSLog(@"我要反馈");
    QustionRecordViewController * want = [[QustionRecordViewController alloc]init];
    [self.navigationController pushViewController:want animated:YES];

}

- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}

-(void)SendSchoolMethods
{
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setValue:[HSAppData getCheckCode]  forKey:@"checkcode"];
    [postdic setValue:chooseString forKey:@"asktype"];
    [postdic setValue:@"1" forKey:@"time"];
    [postdic setValue:HsImtv.text forKey:@"content"];
    [postdic setValue:InputTF.text forKey:@"contact"];
    [self PostAPI:@"postOpinionForm" andParams:postdic success:^(NSDictionary * dict) {
        NSLog(@"postdic is %@",dict);
        NSLog(@"str is %@",dict[@"str"]);
        NSNumber * ret = dict[@"str"];
        NSString * errorString = dict[@"ret"];
        if ([ret integerValue] == 0) {
            [self showMessage:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            if ([NSString isBlankString:errorString]) {
                [self showMessage:@"提交失败"];
            }else
            {
                [self showMessage:errorString];
            }
        }
    }];

}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = NO;
//}

@end
