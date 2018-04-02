//
//  ViewControllerForget1.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerForget1.h"

@interface ViewControllerForget1 ()

@end

@implementation ViewControllerForget1

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    roundIt(self.btNext);
    roundIt(self.btBack);
    
    roundcycle(self.labelTIP1);
    roundcycle(self.labelTIP2);
    roundcycle(self.labelTIP3);
    
    if ([_PushType isEqualToString:@"Service"]) {
        self.btBack.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
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
    if([Master isMobileNumber:self.textPhone.text] == NO)
    {
        [self showMessage:@"请填写正确的手机号码"];
        return;
    }
    
    [self runAPI:@"getForgetSmsCode" andParams:@{@"phone": self.textPhone.text} success:^(NSDictionary * dict) {
        NSLog(@"dicString is %@",dict[@"str"]);
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue != 0)
        {
            [self showMessage:str];
        }
        else
        {
            [self showBlockMessage:str delay:1.0f andThen:^{
                [self showSegueWithObject:@{@"phone": self.textPhone.text} Identifier:@"showForget2"];
            }];
        }
    }];
}

- (IBAction)btBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
