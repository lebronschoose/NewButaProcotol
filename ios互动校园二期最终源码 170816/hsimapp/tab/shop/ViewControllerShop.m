//
//  ViewControllerShop.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerShop.h"

@interface ViewControllerShop ()
{
    NSArray *listClass;
}
@end

@implementation ViewControllerShop

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    //[self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //            ((UIScrollView *)subView).bounces = NO; //去掉UIWebView的底图
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO]; //右侧的滚动条
            
            for (UIView *scrollview in subView.subviews)
            {
                if ([scrollview isKindOfClass:[UIImageView class]])
                {
                    scrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }

    [self reloadData];
       CareMsg(msgDataNeedRefresh);
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgDataNeedRefresh])
    {
        [self reloadData];
    }
}
#pragma mark --- picker view delegate ---

- (void)reloadData
{
//    NSNumber *classid = NN(0);
    if([_Master isTeacher])
    {

        NSString * string = [NSString stringWithFormat:@"%@/Album/index/checkcode/%@",[HSAppData getDomain],[HSAppData getCheckCode]];
        
//        NSString * string = @"http://192.168.5.107/Album/index/checkcode/04F8F809B1F9D4483BA930E6174230.html";
//          NSString * string = @"http://192.168.5.107/Album/index/checkcode/04F8F809B1F9D4483BA930E6174230.html";
        string = [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//        NSLog(@"Albumstring is %@",string);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:string]];

        [self.webView loadRequest:request];
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"%@/Album/index/checkcode/%@/classid/0.html", [HSAppData getDomain], [HSAppData getCheckCode]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"webview.url is %@",[webView.request.URL absoluteString]);
    Waiting(5.0, @"waitingloadweb");
}

-(void)viewWillDisappear:(BOOL)animated
{
    StopWaiting;
}

-(IBAction)waitingEnd:(id)sender
{
    if([self.waitingTag isEqualToString:@"waitingloadweb"])
    {
        StopWaiting;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    StopWaiting;
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"response code2: %@", response.description);
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    
//    NSLog(@"response code3: %@", error.description);
//}

@end
