//
//  ViewControllerWeb.h
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "RootViewController.h"

@interface ViewControllerWeb : RootViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(copy,nonatomic) NSString * urlString;

@end
