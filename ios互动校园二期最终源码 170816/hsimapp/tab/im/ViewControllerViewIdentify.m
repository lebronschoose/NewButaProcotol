//
//  ViewControllerViewIdentify.m
//  hsimapp
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerViewIdentify.h"

@interface ViewControllerViewIdentify ()
{
    HSUserObject *ofUser;
    HSMessageObject *ofMessage;
}
@end

@implementation ViewControllerViewIdentify

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    roundIt(self.btAgree);
    roundIt(self.btRefuse);
    
    ofMessage = self.transObj;
    if(ofMessage == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([ofMessage isHasOperate] == YES)
    {
        [self.btAgree setHidden:YES];
        [self.btRefuse setHidden:YES];
    }
    else
    {
        [self.btAgree setHidden:NO];
        [self.btRefuse setHidden:NO];
    }
    if([_Master reqUserData:ofMessage.messageFrom ofType:2 oldFlag:0 ofChatID:0])
    {
        Waiting(TIMEOUT, @"waitinguserdetail");
    }
    CareMsg(hsNotificationSearchFriendRet);
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
    if([msg isEqualToString:hsNotificationSearchFriendRet])
    {
        ofUser = notification.object;
        if(ofUser == nil)
        {
            [self showMessage:@"没有找到该用户.请检查您的输入."];
            return;
        }
        else
        {
            [self.labelName setText:ofUser.nickName];
            [self.labelText setText:ofUser.signText];
        }
    }
}

-(IBAction)waitingEnd:(id)sender
{
    if([self.waitingTag isEqualToString:@"waitinguserdetail"])
    {
        [self showMessage:@"请求超时，请检查网络连接或稍后再试"];
    }
    StopWaiting;
}

- (IBAction)onAgree:(id)sender
{
    [_HSCore disableMessageOperation:ofMessage];
    [self.btAgree setHidden:YES];
    [self.btRefuse setHidden:YES];
    
    [_Master reqReplyAddFriend:YES ofUser:ofMessage.messageFrom];
    [self showMessage:@"验证通过.已成功添加到通讯录."];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRefuse:(id)sender
{
    [_HSCore disableMessageOperation:ofMessage];
    [self.btAgree setHidden:YES];
    [self.btRefuse setHidden:YES];
    
    [_Master reqReplyAddFriend:NO ofUser:ofMessage.messageFrom];
    [self showMessage:@"已拒绝请求."];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
