//
//  WantQAViewController.m
//  hsimapp
//
//  Created by dingding on 17/9/14.
//  Copyright © 2017年 dayihua .inc. All rights reserved.
//

#import "WantQAViewController.h"

@interface WantQAViewController ()<UITextViewDelegate>
{
    UILabel * label;
    UILabel * label1;
    UITextView * SchoolIntv;
    UIView * HsImView;
    UITextView * HsImtv;
    UIButton * rightbtn;
    UIButton * SchoolInbtn;
    UIButton * HsimAppInbtn;
    UITextField * InputTF;
    UIButton * Quesionbtn;
    UIButton * NewQuestionbtn;
    BOOL  isSchool;
    NSString * chooseString;
    
}

@end

@implementation WantQAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"家长咨询";
    chooseString = @"1";
    isSchool = YES;
     SchoolInbtn = [[UIButton alloc]init];
    SchoolInbtn.tag = 100;
    [SchoolInbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [SchoolInbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    SchoolInbtn.selected = YES;
    [SchoolInbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SchoolInbtn];
    [SchoolInbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(20);
        make.left.offset(5);
    }];
    
    UILabel * SchoolInlabel = [[UILabel alloc]init];
    SchoolInlabel.text = @"学校内部咨询";
    [self.view addSubview:SchoolInlabel];
    [SchoolInlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(SchoolInbtn);
        make.left.equalTo(SchoolInbtn.mas_right).with.offset(2);
    }];
    
     HsimAppInbtn = [[UIButton alloc]init];
    HsimAppInbtn.tag = 101;
    [HsimAppInbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [HsimAppInbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [HsimAppInbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    [self.view addSubview:HsimAppInbtn];
    
//
    UILabel * HsimApplabel = [[UILabel alloc]init];
    HsimApplabel.text = @"互动校园咨询";
    [self.view addSubview:HsimApplabel];
    [HsimApplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(HsimAppInbtn);
        make.right.equalTo(self.view).offset(-2);
    }];
    
    [HsimAppInbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(20);
        make.right.equalTo(HsimApplabel.mas_left).offset(-2);
    }];

    SchoolIntv = [[UITextView alloc]init];
    SchoolIntv.layer.borderWidth = 1.0;
    SchoolIntv.tag = 101;
    SchoolIntv.font = [UIFont systemFontOfSize:15];
//    [SchoolIntv becomeFirstResponder];
    SchoolIntv.delegate = self;
    [self.view addSubview:SchoolIntv];
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    label1.enabled = NO;
    label1.text = @"请输入内容..";
    label1.font =  [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor lightGrayColor];
    [SchoolIntv addSubview:label1];

    [SchoolIntv mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(80,5,80,5));
    }];
    
    
    HsImView = [[UIView alloc]init];
    HsImView.hidden = YES;
    [self.view addSubview:HsImView];
    [HsImView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(70, 5, 60, 5));
    }];
    
    HsImtv = [[UITextView alloc]init];
    HsImtv.layer.borderWidth = 1.0;
    HsImtv.font = [UIFont systemFontOfSize:15];
//    [HsImtv becomeFirstResponder];
    HsImtv.delegate = self;
    HsImtv.tag = 102;
    [HsImView addSubview:HsImtv];
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    label.enabled = NO;
    label.text = @"请输入内容..40字以内";
    label.font =  [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    [HsImtv addSubview:label];

    [HsImtv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HsImView).with.insets(UIEdgeInsetsMake(5,5,100,5));
    }];
    
     Quesionbtn = [[UIButton alloc]init];
    Quesionbtn.tag = 102;
    [Quesionbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [Quesionbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [Quesionbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    Quesionbtn.selected = YES;
    [HsImView addSubview:Quesionbtn];
    [Quesionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(HsImtv.mas_bottom).offset(5);
        make.left.offset(5);
    }];
    
    UILabel * Quesionlabel = [[UILabel alloc]init];
    Quesionlabel.text = @"遇到问题";
    [HsImView addSubview:Quesionlabel];
    [Quesionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(Quesionbtn);
        make.left.equalTo(Quesionbtn.mas_right).with.offset(2);
    }];
    
     NewQuestionbtn = [[UIButton alloc]init];
    NewQuestionbtn.tag = 103;
    [NewQuestionbtn addTarget:self action:@selector(SelectedSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    [NewQuestionbtn setImage:[UIImage imageNamed:@"FinalUnSelected"] forState:UIControlStateNormal];
    [NewQuestionbtn setImage:[UIImage imageNamed:@"FinalSelected"] forState:UIControlStateSelected];
    [HsImView addSubview:NewQuestionbtn];
    [NewQuestionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(Quesionbtn);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(Quesionlabel.mas_right).offset(40);
    }];
    //
    UILabel * NewQuestionbtnlabel = [[UILabel alloc]init];
    NewQuestionbtnlabel.text = @"新功能建议";
    [HsImView addSubview:NewQuestionbtnlabel];
    [NewQuestionbtnlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NewQuestionbtn);
        make.left.equalTo(NewQuestionbtn.mas_right).offset(2);
    }];

    InputTF = [[UITextField alloc]init];
    InputTF.layer.borderWidth = 1.0;
    InputTF.placeholder = @"手机号码";
    InputTF.font = [UIFont systemFontOfSize:14];
    [HsImView addSubview:InputTF];
    [InputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
        make.left.equalTo(@10);
        make.bottom.equalTo(HsImView.mas_bottom).offset(-10);
    }];
    
    UIButton * confrimBtn = [[UIButton alloc]init];
    confrimBtn.layer.cornerRadius = 5;
    confrimBtn.backgroundColor = MAINCOLOR;
    [confrimBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimBtn];
    [confrimBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confrimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
        make.left.equalTo(@10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    
//    rightbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightbtn.frame = CGRectMake(0, 0, 50, 34);
//    rightbtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightbtn setTitle:@"提交" forState:UIControlStateNormal];
//    [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    

}

-(void)SelectedSchoolAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            {
                if (btn.selected == YES) {
                    NSLog(@"已选中");
                }else
                {
                    SchoolIntv.hidden = NO;
                    HsImView.hidden = YES;
                    HsimAppInbtn.selected = NO;
                    SchoolInbtn.selected = YES;
                    isSchool = YES;
                }
            }
            break;
        case 101:
        {
            if (btn.selected == YES) {
                NSLog(@"已选中");
            }else
            {
                SchoolIntv.hidden = YES;
                HsImView.hidden = NO;
                HsimAppInbtn.selected = YES;
                SchoolInbtn.selected = NO;
                isSchool = NO;
            }
        }
            break;
        case 102:
        {
            if (btn.selected == YES) {
                NSLog(@"已选中");
            }else
            {
                Quesionbtn.selected = YES;
                NewQuestionbtn.selected = NO;
                chooseString = @"1";
            }

        }
            break;
        case 103:
        {
            if (btn.selected == YES) {
                NSLog(@"已选中");
            }else
            {
                NewQuestionbtn.selected = YES;
                Quesionbtn.selected = NO;
                chooseString = @"2";
            }

        }
            break;
            
        default:
            break;
    }

}

-(void)rightBtnClick
{
    if (isSchool == YES) {
        NSLog(@"学校内部");
        if (SchoolIntv.text.length == 0) {
            [self showMessage:@"问题不能为空"];
            return;
        }
        [self InschoolAction];
    }else
    {
        if (HsImtv.text.length == 0) {
            [self showMessage:@"问题不能为空"];
            return;
        }
        if (HsImtv.text.length >40) {
            [self showMessage:@"问题格式错误"];
            return;
        }
        if([Master isMobileNumber:InputTF.text] == NO)
        {
            [self showMessage:@"请填写正确的手机号码"];
            
            return;
        }
        NSLog(@"互动校园咨询");
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
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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

}

-(void)InschoolAction
{
        NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
        [postdic setValue:[HSAppData getCheckCode]  forKey:@"checkcode"];
        [postdic setValue:@"0" forKey:@"who"];
        [postdic setValue:SchoolIntv.text forKey:@"question"];
        [self PostAPI:@"postQA" andParams:postdic success:^(NSDictionary * dict) {
            NSLog(@"postQAdict is %@",dict);
            NSNumber * ret = dict[@"str"];
            NSString * errorString = dict[@"ret"];
            if ([ret integerValue] == 0) {
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
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
            rightbtn.userInteractionEnabled = YES;
            NSLog(@"postQAString is %@",dict[@"str"]);
    
        }];

}

-(void)TouchKeyBorad
{
    [SchoolIntv resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewDidChange:(UITextView *)textView{
    if (textView.tag == 101) {
        if ([textView.text length] == 0) {
            [label1 setHidden:NO];
        }else{
            [label1 setHidden:YES];
        }
    }else
    {
        if ([textView.text length] == 0) {
            [label setHidden:NO];
        }else{
            [label setHidden:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
