//
//  NCLoginPassWordModifyViewController.m
//  e百福
//
//  Created by dingdingsmac on 16/1/29.
//  Copyright © 2016年 ncrcc. All rights reserved.
//

#import "NCLoginPassWordModifyViewController.h"

@interface NCLoginPassWordModifyViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *ComfrimBtn;
@property (weak, nonatomic) IBOutlet UIView *NowPassWordView;
@property (weak, nonatomic) IBOutlet UIView *NewPassWordView;
@property (weak, nonatomic) IBOutlet UIView *AgainPassWordView;
@property (weak, nonatomic) IBOutlet UITextField *NowTF;
@property (weak, nonatomic) IBOutlet UITextField *NewTF;
@property (weak, nonatomic) IBOutlet UITextField *AgainTF;


@end

@implementation NCLoginPassWordModifyViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ReturnNAVI;
    self.title = @"登录密码修改";
    self.ComfrimBtn.layer.cornerRadius = 20;
    self.NowTF.delegate = self;
    self.NewTF.delegate = self;
    self.AgainTF.delegate = self;
    // Do any additional setup after loading the view from its nib.
}


-(void)SendLoginPassWordModifyMethods
{
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setObject:[HSAppData getCheckCode] forKey:@"checkcode"];
    [postdic setObject:_NowTF.text forKey:@"old_password"];
    [postdic setObject:_NewTF.text forKey:@"new_password"];
    [_Master SubmitTo:@"changePW" andParams:postdic success:^(NSDictionary * dict) {
        NSLog(@"dict is %@",dict);
        if ([dict[@"ret"] integerValue] == 0 ) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            kAlert(dict[@"str"]);
        }
    } failed:^{
        
    }];
}

- (IBAction)ComFrimAction:(id)sender {
  
    if (_NewTF.text.length<6) {
        kAlert(@"当前密码不能小于6位");
    }else if (_NowTF.text.length<6)
    {
        kAlert(@"新密码不能小于6位");
    }else if (_AgainTF.text.length<6)
    {
        kAlert(@"确认密码不能小于6位");
    }else if ([_NewTF.text isEqualToString:_AgainTF.text] == NO)
    {
        kAlert(@"两次输入的密码不一致");
    }
    else if ([_NewTF.text isEqualToString:_NowTF.text])
    {
        kAlert(@"新旧密码不能一样");
    }
    else
    {
        [self SendLoginPassWordModifyMethods];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:16];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //            [alert show];
        return NO;
    }
    return YES;
    
}


-(void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
