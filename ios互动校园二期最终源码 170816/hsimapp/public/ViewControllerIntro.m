//
//  ViewControllerIntro.m
//  dyhAutoApp
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import "ViewControllerIntro.h"

@interface ViewControllerIntro ()<HSImageScrollViewDelegate>
{
    BOOL isFirstTimeShow;
}
@end

@implementation ViewControllerIntro

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    isFirstTimeShow = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    // 因为viewDidLoad里面的hsImageScrollView宽度没有最终确定，还是320，而在iphone6，plus下是375，414
    if(isFirstTimeShow == YES)
    {
        isFirstTimeShow = NO;
        
//        NSLog(@"view width = %.f, scroll view width = %.f", self.view.frame.size.width, self.hsImageScrollView.frame.size.width);
        
        NSArray* constrains = self.hsImageScrollView.constraints;
        for (NSLayoutConstraint* constraint in constrains)
        {
            if (constraint.firstAttribute == NSLayoutAttributeHeight)
            {
                // 调整hsImageScrollView的高度，否则width不是320到时候会变形
                constraint.constant = self.hsImageScrollView.frame.size.height * self.hsImageScrollView.frame.size.width / 320.0;
                CGRect frame = self.hsImageScrollView.frame;
                frame.size.height = constraint.constant;
                [self.hsImageScrollView setFrame:frame];
                break;
            }
        }
        
        [self.hsImageScrollView initWithCount:3 delegate:self];
        self.hsImageScrollView.scrollInterval = 30.0f;
        self.hsImageScrollView.autoScroll = NO;
        
        // adjust pageControl position
        self.hsImageScrollView.pageControlPosition = ICPageControlPosition_BottomCenter;
        
        // hide pageControl or not
        self.hsImageScrollView.hidePageControl = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - HSImageScrollViewDelegate
- (NSString *)hsImageScrollView:(HSImageScrollView *)hsImageScrollView imageForItemAtIndex:(NSInteger)index
{
    NSString *strURL = [NSString stringWithFormat:@"intro_%ld", index + 1];
    return  strURL;
}

- (void)hsImageScrollView:(HSImageScrollView *)hsImageScrollView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    
    if(index != 2) return;
    
    if(self.bAutoMode)
    {
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
