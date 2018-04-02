//
//  ViewControllerRegister1.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerRegister1.h"

@interface ViewControllerRegister1 ()

@end

@implementation ViewControllerRegister1

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    roundIt(self.btNext);
    roundIt(self.btBack);
    
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

- (IBAction)onNext:(id)sender
{
    if([Master isMobileNumber:self.textPhone.text] == NO)
    {
        [self showMessage:@"请填写正确的手机号码"];
//        [Master messageBox:@"请填写正确的手机号码" withTitle:@"手机号码错误" withOkText:@"确定"];
        return;
    }
    
    [self runAPI:@"SendRegSms" andParams:@{@"phone": self.textPhone.text} success:^(NSDictionary * dict) {
        NSString *str = [dict objectForKey:@"str"];
        NSNumber *ret = [dict objectForKey:@"ret"];
        if(ret.intValue != 0)
        {
            [self showMessage:str];
        }
        else
        {
            [self showBlockMessage:str delay:1.0f andThen:^{
                [self showSegueWithObject:@{@"phone": self.textPhone.text} Identifier:@"showReg2"];
            }];
        }
    }];
}

- (IBAction)btBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
