//
//  ViewControllerViewLogo.m
//  hsimapp
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerViewLogo.h"
#import "MasterURL.h"

@interface ViewControllerViewLogo ()
{
    BOOL isNaviBarHidden;
}
@end

@implementation ViewControllerViewLogo
// 设置UIScrollView中要缩放的视图

@synthesize sv;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.self.theLogo;
}


// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.theLogo.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                      scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setParam:self.transObj];
    [self.theLogo setUserInteractionEnabled:YES];
    [self.theLogo setMultipleTouchEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    [self.theLogo addGestureRecognizer:singleTap];
    
    CGFloat widthRatio = 1;
    CGFloat heightRatio = 1;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    [sv setMinimumZoomScale:initialZoom];
    [sv setMaximumZoomScale:5];
    // 设置UIScrollView初始化缩放级别
    [sv setZoomScale:initialZoom];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    isNaviBarHidden = YES;
    [self.lableBytes setText:@""];
    CareMsg(msgEGOImageLoadProgress);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    if(self.param == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([self.param isKindOfClass:[NSString class]])
    {
        NSString *param = self.param;
        NSString *url = [MasterURL APIFor:@"chatHDImage" with:param, nil];
        if(url != nil)
        {
            NSString *cachePath = [self.theLogo cachePathForURL:[NSURL URLWithString:[MasterURL APIFor:@"chatImage" with:param, nil]]];
            if(cachePath != nil)
            {
                UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
                if(image != nil)
                {
                    [self.theLogo setPlaceholderImage:image];
                    [self.theLogo setImage:image];
                }
            }
            
            [self.theLogo setImageURL:[NSURL URLWithString:url]];
        }
        else
        {
            NSString *account = self.param;
            NSString *cachePath = [self.theLogo cachePathForURL:[NSURL URLWithString:[MasterURL urlOfUserLogo:account]]];
            if(cachePath != nil)
            {
                UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
                if(image != nil)
                {
                    [self.theLogo setPlaceholderImage:image];
                    [self.theLogo setImage:image];
                }
            }
            
            [self.theLogo setImageURL:[NSURL URLWithString:[MasterURL urlOfUserHDLogo:account]]];
        }
    }
    else if([self.param isKindOfClass:[NSNumber class]])
    {
        NSNumber *groupID = self.param;
        NSString *cachePath = [self.theLogo cachePathForURL:[NSURL URLWithString:[MasterURL urlOfGroupLogo:groupID]]];
        if(cachePath != nil)
        {
            UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
            if(image != nil)
            {
                [self.theLogo setPlaceholderImage:image];
                [self.theLogo setImage:image];
            }
        }
        
        [self.theLogo setImageURL:[NSURL URLWithString:[MasterURL urlOfGroupHDLogo:groupID]]];
    }
}

-(void)onNotifyMsg:(NSNotification *)notification
{
    [super onNotifyMsg:notification];
    
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgEGOImageLoadProgress])
    {
        EGOImageView *imageView = notification.object;
        if(imageView == self.theLogo)
        {
            if(imageView.bytesReceived.longLongValue == 0)
            {
                [self.lableBytes setHidden:YES];
            }
            else
            {
                [self.lableBytes setHidden:NO];
                long long recv = imageView.bytesReceived.longLongValue;
                if(recv < 1024)
                {
                    [self.lableBytes setText:[NSString stringWithFormat:@"正在加载... %lld bytes", recv]];
                }
                else if(recv < 1024 * 1024)
                {
                    [self.lableBytes setText:[NSString stringWithFormat:@"正在加载... %.1f kb", (float)recv / 1024.0]];
                }
                else
                {
                    [self.lableBytes setText:[NSString stringWithFormat:@"正在加载... %.1f Mb", (float)recv / (1024.0 * 1024.0)]];
                }
            }
        }
    }
}

#pragma mark   ----触摸取消输入----
-(void)imageClicked:(id)sender
{
    isNaviBarHidden = !isNaviBarHidden;
    
    [[UIApplication sharedApplication] setStatusBarHidden:isNaviBarHidden];
    [[self navigationController] setNavigationBarHidden:isNaviBarHidden animated:YES];
}

@end
