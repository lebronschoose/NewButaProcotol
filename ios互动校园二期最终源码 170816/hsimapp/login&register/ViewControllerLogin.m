//
//  ViewControllerLogin.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerLogin.h"
#import "IMnetMethod.h"

@interface ViewControllerLogin ()<UIAlertViewDelegate, UITextFieldDelegate>
{
    UIAlertView *msgBoxUpdateApp;
    BOOL isAgree;
}

@end

@implementation ViewControllerLogin

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [glState setWithLoginView:YES];
    
    isAgree = YES;
    
    roundIt(self.imgLogo);
    roundIt(self.btLogin);
    roundIt(self.viewInput);
    
//    [self.textAccount setText:@"13000000004"];
//    [self.textPassword setText:@"123456"];
    
    [self.textAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    CareMsg(msgLoginStatus);
    CareMsg(msgLoginIMStatus);
    CareMsg(@"GETACCECSOBJ");
    CareMsg(@"LoginSucessce");
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

- (IBAction)onBtRegister:(id)sender
{
}

- (IBAction)onBtForget:(id)sender
{
}

- (IBAction)onBtLegal:(id)sender
{
}

- (IBAction)onBtAgree:(id)sender
{
    isAgree = !isAgree;
    if(isAgree)
    {
        [self.btAgree setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btAgree setImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
    }
}

-(IBAction)waitingEnd:(id)sender
{
    NSLog(@"ViewControllerLogin - waitingEnd for tag:%@", self.waitingTag);
    if([self.waitingTag isEqualToString:@"waitLogin"])
    {
        [HSAppData setDomain:@""];
        [_Master getServerInfo];
        [self showMessage:@"登录超时，请检查网络连接或稍后再试"];
    }
    else if([self.waitingTag isEqualToString:@"waitSwitchTestMode"])
    {
        
    }
    StopWaiting;
}

-(void)onNotifyMsg:(NSNotification *)notification
{
    [super onNotifyMsg:notification];
    
    StopWaiting;
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgLoginStatus])
    {
        NSNumber *ret = notification.object;
        switch ([ret intValue])
        {
            case D_OK:
                // 登录成功im后才算成功登录
                //[self.navigationController popViewControllerAnimated:NO];
                [self performSegueWithIdentifier:@"showMainWindow" sender:nil];
                break;
                
            case D_NOIMSERVER:
                [self showMessage:@"服务器尚未开启"];
                break;
            case D_NOTEXISTUSER:
                [self showMessage:@"用户不存在"];
                break;
            case D_WRONGPASSWORD:
                [self showMessage:@"密码错误"];
                break;
                
            default:
                [self showMessage:[NSString stringWithFormat:@"未知错误:%@", ret]];
                break;
        }
    }
    else if([msg isEqualToString:msgLoginIMStatus])
    {
        NSNumber *ret = notification.object;
        
        switch ([ret intValue])
        {
            case D_OK:
                // 登录成功
                [self.navigationController popViewControllerAnimated:NO];
                break;
                
            case D_VERSIONCANUSE:
                [MasterUtils messageBox:@"当前app版本太旧，但仍然可以使用。" withTitle:@"已发布新版本" withOkText:@"确定" from:self];
                break;
            case D_VERSIONUPDATE:
                msgBoxUpdateApp = [MasterUtils messageBox:@"已发布新版本，当前版本已无法继续使用，点击更新。" withTitle:@"已发布新版本" withOkText:@"确定" from:self];
                break;
                
            default:
                dispatch_async(dispatch_get_main_queue(), ^{
                     [MasterUtils messageBox:@"未知错误" withTitle:@"登录失败" withOkText:@"确定" from:self];
                });

               
                break;
        }
    }    else if([msg isEqualToString:@"GETACCECSOBJ"])
    {
        NSDictionary * dic = notification.object;
        NSLog(@"dictoken is %@",dic[@"token"]);
        NSMutableDictionary * pdic = [NSMutableDictionary dictionary];
        [pdic setObject:@"test_account9" forKey:@"account"];
        [pdic setObject:@"12345" forKey:@"psw"];
        
        [pdic setObject:[NSNumber numberWithInteger:1] forKey:@"term"];
        [pdic setObject:dic[@"token"] forKey:@"token"];
        NSData *data =    [NSJSONSerialization dataWithJSONObject:pdic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * poststring =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[IMnetMethod ShareInstance]getReturnPackFrom:poststring BY:ImpLoginReq];
    }else if ([msg isEqualToString:@"LoginSucessce"])
    {
        [self performSegueWithIdentifier:@"showMainWindow" sender:nil];
        NSLog(@"登录成功,跳回到首页进行请求");
    }

}


- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"accout changed.");
    if(textField == self.textAccount)
    {
        if(self.textAccount.text.length == 11)
        {
            NSLog(@"1111 load logo for %@", self.textAccount.text);
            [self.imgLogo setImageURL:[NSURL URLWithString:[MasterURL urlOfUserLogo:self.textAccount.text]]];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == nil) return;
    if(alertView == msgBoxUpdateApp)
    {
        switch (buttonIndex)
        {
            case 0:
                if(1)
                {
                    // 设置个变量，在login里面显示这个窗口，而且打开app store
                    
                    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/hu-dong-xiao-yuan/id847422747?mt=8"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                break;
            case 1:
                break;
            default:
                break;
        }
    }
}
- (IBAction)ShowPWDAction:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        _textPassword.secureTextEntry = NO;
    }else
    {
        sender.selected = NO;
        _textPassword.secureTextEntry = YES;
    }
    
}

- (IBAction)onBtLogin:(id)sender
{

//    IMStop(nil);
//    if(!isAgree)
//    {
//        [self showMessage:@"请先确定同意我们的用户协议!"];
//        return;
//    }
//    [_Master disconnectIMServer];
//    [_Master reqLogin:self.textAccount.text andPassword:self.textPassword.text];
//    Waiting(TIMEOUT, @"waitLogin");
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"test_account9" forKey:@"account"];
    [dic setObject:@"12345" forKey:@"psw"];
    
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"term"];
    //    [dic setObject:@"1" forKey:@"term"];
    NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * poststring =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[IMnetMethod ShareInstance]ConnectAccess:poststring];

}

@end
