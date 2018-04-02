//
//  ViewControllerInput.m
//  hsimapp
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerInput.h"

@interface ViewControllerInput ()
{
    NSNumber *inputType;
}
@end

@implementation ViewControllerInput

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    fitIOS7;
    roundIt(self.btOK);
    inputType = self.transObj;
    switch (inputType.intValue)
    {
        case emChangeNickName:
            self.navigationItem.title = @"修改昵称";
            break;
        case emChangeEmail:
            self.navigationItem.title = @"电子邮箱";
            [self.textInput setKeyboardType:UIKeyboardTypeEmailAddress];
            break;
        case emChangeMobile:
            self.navigationItem.title = @"手机号码";
            [self.textInput setKeyboardType:UIKeyboardTypeNumberPad];
            break;
        case emChangeSignText:
            self.navigationItem.title = @"个性签名";
            break;
        case emChangeRealName:
            self.navigationItem.title = @"真实姓名";
            break;
            
        default:
            self.navigationItem.title = @"未知操作";
            break;
    }
    CareMsg(hsNotificationUserUpdateOK);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationUserUpdateOK])
    {
        StopWaiting;
        [self showCloseMessage:@"修改成功" andDelay:1.0f];
    }
}

-(IBAction)waitingEnd:(id)sender
{
    NSLog(@"%@ - waitingEnd for tag:%@", self, self.waitingTag);
    if([self.waitingTag isEqualToString:@"updatetext"])
    {
        [self showMessage:@"请求超时，请检查网络连接或稍后再试"];
    }
    StopWaiting;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onOK:(id)sender
{
    if([self.textInput.text isEqualToString:@""] || [self.textInput.text length] == 0)
    {
        [Master messageBox:@"输入无效." withTitle:@"输入错误" withOkText:@"确定"];
        return;
    }
    switch (inputType.intValue)
    {
        case emChangeNickName:
        case emChangeEmail:
        case emChangeMobile:
        case emChangeSignText:
        case emChangeRealName:
            Waiting(TIMEOUT, @"updatetext");
            [_Master reqUpdateUserText:[self.textInput text] ofType:inputType.intValue];
            break;
        default:
            break;
    }
}
@end
