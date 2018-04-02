//
//  ViewControllerLegal.h
//  hsimapp
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerLegal : RootViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btBack;

- (IBAction)onBack:(id)sender;
@end
