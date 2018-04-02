//
//  ViewControllerSearchFriend.m
//  hsimapp
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerSearchFriend.h"

@interface ViewControllerSearchFriend ()

@end

@implementation ViewControllerSearchFriend

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    roundIt(self.btSearch);
    
    CareMsg(@"UpdateUserInfo");
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
    if([msg isEqualToString:@"UpdateUserInfo"])
    {
        HSUserObject *aUser = notification.object;
        if(aUser == nil)
        {
            [self showMessage:@"没有找到该用户.请检查您的输入."];
            return;
        }
        NSLog(@"search friend: %@", aUser.nickName);
        [self showSegueWithObject:@{@"user":aUser, @"chatid": NN(-9999), @"showButton": @"yes"} Identifier:@"showFriendDetail"];
    }
}

-(IBAction)waitingEnd:(id)sender
{
    NSLog(@"%@ - waitingEnd for tag:%@", self, self.waitingTag);
    if([self.waitingTag isEqualToString:@"searchFriend"])
    {
        [self showMessage:@"请求超时，请检查网络连接或稍后再试"];
    }
    StopWaiting;
}

- (IBAction)onSearch:(id)sender
{
//    NSString *account = self.textAccount.text;
//    if(![HSCoreData bIsValidUserID:account])
//    {
//        [Master messageBox:@"帐号名称只可包含数字,字母及-_@." withTitle:@"无效的帐号名称" withOkText:@"确定"];
//        return;
//    }
      NSString * jsonString = [NSString stringWithFormat:@"{\"type\":%d,\"account\":\"%@\"}",3,self.textAccount.text];
    [[IMnetMethod ShareInstance] getReturnPackFrom:jsonString BY:ImpGetUserInfoReq];
//    if([_Master reqUserData:account ofType:1 oldFlag:0 ofChatID:0])
//    {
//        Waiting(TIMEOUT, @"searchFriend");
//    }
}

@end
