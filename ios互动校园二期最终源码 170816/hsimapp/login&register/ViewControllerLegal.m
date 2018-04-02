//
//  ViewControllerLegal.m
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerLegal.h"

@interface ViewControllerLegal ()

@end

@implementation ViewControllerLegal

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    roundIt(self.btBack);
    NSString *url = [NSString stringWithFormat:@"%@/cfg/%@", [HSAppData getDomain], URL_LEGAL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
