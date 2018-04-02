//
//  ViewControllerRegister3.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerRegister3.h"
#import "ViewControllerRegister1.h"

@interface ViewControllerRegister3 ()
{
    BOOL    isShowPassword;
    NSString *phone;
}
@end

@implementation ViewControllerRegister3

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isShowPassword = NO;
    phone = [self.transObj objectForKey:@"phone"];
    
    roundIt(self.btRegister);
    roundIt(self.viewCert);
    roundIt(self.viewInput);
    roundIt(self.btGetSMS);
    
    roundcycle(self.labelTIP1);
    roundcycle(self.labelTIP2);
    roundcycle(self.labelTIP3);
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

- (IBAction)onGetSMS:(id)sender
{
    if([Master isMobileNumber:self.textPhone.text] == NO)
    {
        [self showMessage:@"请填写正确的手机号码"];
        //        [Master messageBox:@"请填写正确的手机号码" withTitle:@"手机号码错误" withOkText:@"确定"];
        return;
    }
    
    [self runAPI:@"sendbindsms" andParams:@{@"phone": phone, @"bindphone": self.textPhone.text} success:^(NSDictionary * dict) {
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue != 0)
        {
            [self showMessage:str];
        }
        else
        {
            [self showMessage:str];
        }
    }];
}

- (IBAction)onRegister:(id)sender
{
    if([Master isMobileNumber:self.textPhone.text] == NO)
    {
        [self showMessage:@"请填写正确的手机号码"];
        return;
    }
    if(self.textSMS.text.length != 6)
    {
        [self showMessage:@"请填写正确的短信验证码"];
        return;
    }
    if(self.textPassword.text.length < 6)
    {
        [self showMessage:@"密码长度至少为6位。"];
        return;
    }
    
    [self runAPI:@"doregister" andParams:@{@"phone": phone, @"bindphone": self.textPhone.text, @"password": self.textPassword.text, @"bindsms": self.textSMS.text} success:^(NSDictionary * dict) {
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue != 0)
        {
            [self showMessage:str];
        }
        else
        {
            [self showBlockMessage:str delay:1.0f andThen:^{
                for(id temp in self.navigationController.viewControllers)
                {
                    if([temp isKindOfClass:[ViewControllerRegister1 class]])
                    {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }];
        }
    }];
}

- (IBAction)onShowPassword:(id)sender
{
    isShowPassword = !isShowPassword;
    
    self.textPassword.secureTextEntry = !isShowPassword;
    if(isShowPassword)
    {
        self.btShowPassword.alpha = 1.0;
    }
    else
    {
        self.btShowPassword.alpha = 0.25;
    }
}

@end
