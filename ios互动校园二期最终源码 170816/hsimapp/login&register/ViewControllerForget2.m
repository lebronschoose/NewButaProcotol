//
//  ViewControllerForget2.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerForget2.h"

#define COUNTER 60

@interface ViewControllerForget2 ()
{
    NSTimer *tickCounter;
    int ticked;
    
    NSString *phone;
}
@end

@implementation ViewControllerForget2

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    roundIt(self.btNext);
    roundIt(self.btGetSMS);
    
    roundcycle(self.labelTIP1);
    roundcycle(self.labelTIP2);
    roundcycle(self.labelTIP3);
    
    phone = [self.transObj objectForKey:@"phone"];
    ticked = COUNTER;
    [self onTick:nil];
    tickCounter = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
}

- (IBAction)onTick:(id)sender
{
    if(ticked == 0)
    {
        [tickCounter invalidate];
        ticked = COUNTER;
        
        [self.btGetSMS setBackgroundColor:MAINDEEPCOLOR];
        [self.btGetSMS setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    else
    {
        [self.btGetSMS setBackgroundColor:[UIColor lightGrayColor]];
        self.btGetSMS.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)", ticked - 1];
        [self.btGetSMS setTitle:[NSString stringWithFormat:@"重新获取(%d)", ticked - 1] forState:UIControlStateNormal];
    }
    ticked--;
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

- (IBAction)onNext:(id)sender
{
    if(self.textSMS.text.length != 6)
    {
        [self showMessage:@"请填写正确的短信验证码"];
    }
    else
    {
        [self showSegueWithObject:@{@"sms": self.textSMS.text, @"phone": phone} Identifier:@"showForget3"];
    }
}

- (IBAction)onGetSMS:(id)sender
{
    if(ticked != COUNTER) return;
    
    [self runAPI:@"getForgetSmsCode" andParams:@{@"phone": phone} success:^(NSDictionary * dict) {
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

@end
