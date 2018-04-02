//
//  ViewControllerIdentify.m
//  hsimapp
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerIdentify.h"

@interface ViewControllerIdentify ()
{
    HSUserObject *ofUser;
}
@end

@implementation ViewControllerIdentify

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ofUser = self.transObj;
    if(ofUser != nil)
    {
        
        [self.labelName setText:ofUser.nickName];
        [self.labelText setText:ofUser.signText];
    }
    CareMsg(hsNotificationAddFriendRet);
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

-(void)onNotifyMsg:(NSNotification *)notification
{
    [super onNotifyMsg:notification];
    
    StopWaiting;
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationAddFriendRet])
    {
        [Master messageBox:@"请等待对方回应." withTitle:@"消息发送成功" withOkText:@"确定"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)waitingEnd:(id)sender
{
    if([self.waitingTag isEqualToString:@"waitingaddfriend"])
    {
        [self showMessage:@"请求超时，请检查网络连接或稍后再试"];
    }
    else if([self.waitingTag isEqualToString:@"waitSwitchTestMode"])
    {
        
    }
    StopWaiting;
}

- (IBAction)onAdd:(id)sender
{
    if([_Master reqAddFriend:ofUser.DDNumber ofMsg:self.textIdentify.text])
    {
        Waiting(TIMEOUT, @"waitingaddfriend");
    }
}

@end
