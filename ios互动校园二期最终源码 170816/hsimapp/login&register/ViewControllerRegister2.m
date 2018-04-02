//
//  ViewControllerRegister2.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerRegister2.h"

#define COUNTER 60

@interface ViewControllerRegister2 ()
{
    NSTimer *tickCounter;
    int ticked;
    NSString *phone;
}
@end

@implementation ViewControllerRegister2

- (void)viewDidLoad
{
    [super viewDidLoad];
    phone = [self.transObj objectForKey:@"phone"];
    // Do any additional setup after loading the view.
    roundIt(self.btNext);
    roundIt(self.btGetSMS);
    
    roundcycle(self.labelTIP1);
    roundcycle(self.labelTIP2);
    roundcycle(self.labelTIP3);
    
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
        ticked--;
    }
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
        [self runAPI:@"Verifyregsms" andParams:@{@"phone": phone, @"sms":self.textSMS.text} success:^(NSDictionary * dict) {
            NSString *str = [dict objectForKey:@"str"];
            NSNumber *ret = [dict objectForKey:@"ret"];
            if(ret.intValue != 0)
            {
                [self showMessage:str];
            }
            else
            {
                [self showBlockMessage:str delay:1.0f andThen:^{
                    [self showSegueWithObject:@{@"phone": phone, @"sms":self.textSMS.text} Identifier:@"showReg3"];
                }];
            }
        }];
    }
}

- (IBAction)onGetSMS:(id)sender
{
    if(ticked != COUNTER) return;
    
    [self runAPI:@"SendRegSms" andParams:@{@"phone": phone} success:^(NSDictionary * dict) {
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue != 0)
        {
            [self showMessage:str];
        }
        else
        {
            [self showMessage:str];
            tickCounter = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
        }
    }];
}
@end
