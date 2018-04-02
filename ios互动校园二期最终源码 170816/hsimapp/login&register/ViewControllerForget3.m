//
//  ViewControllerForget3.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerForget3.h"
#import "ViewControllerForget1.h"

@interface ViewControllerForget3 ()
{
    BOOL    isShowPassword;
    NSString *phone, *sms;
}
@end

@implementation ViewControllerForget3

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isShowPassword = NO;
    phone = [self.transObj objectForKey:@"phone"];
    sms = [self.transObj objectForKey:@"sms"];
    
    roundIt(self.btRegister);
    
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

- (IBAction)onSetNewPassword:(id)sender
{
    if(self.textPassword.text.length < 6)
    {
        [self showMessage:@"密码长度至少为6位。"];
        return;
    }
    Waiting(TIMEOUT, @"waitingforget");
    [_Master SubmitTo:@"doForget" andParams:@{@"password":self.textPassword.text, @"verify": sms, @"phone": phone}  success:^(NSDictionary * dict) {
        StopWaiting;
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
                    if([temp isKindOfClass:[ViewControllerForget1 class]])
                    {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }];
        }
    } failed:^{
        NSLog(@"failed.");
        [self showMessage:@"提交错误，请重新尝试."];
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
