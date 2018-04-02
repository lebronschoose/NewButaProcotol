//
//  THSegmentedPager.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "THSegmentedPager.h"
#import "THSegmentedPageViewControllerDelegate.h"
#import "ViewControllerNotify.h"
#import "ViewControllerMessage.h"
#import "ViewControllerGroup.h"
#import "ViewControllerFList.h"

@interface THSegmentedPager ()
@property (strong, nonatomic)UIPageViewController *pageViewController;
@end

@implementation THSegmentedPager

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Init PageViewController
    [self initViews];
    
    CareMsg(msgUpdageSegBadge);
    CareMsg(hsNotificationMsgBadge);
}

- (void)initViews
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    self.pageControl.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    self.pageControl.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    self.pageControl.font = [UIFont boldSystemFontOfSize:17];
    self.pageControl.selectionIndicatorColor = MAINDEEPCOLOR;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectedTextColor = MAINDEEPCOLOR;
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.pageControl.showVerticalDivider = YES;
    
    NSMutableArray *pages = [NSMutableArray new];
    
    int i = 1;
    {
        // Create a new view controller and pass suitable data.
        ViewControllerNotify *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerNotify"];
        [viewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:viewController];
        i++;
    }
    {
        // Create a new view controller and pass suitable data.
        ViewControllerMessage *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerMessage"];
        [viewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:viewController];
        i++;
    }
    {
        // Create a new view controller and pass suitable data.
        ViewControllerGroup *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerGroup"];
        [viewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:viewController];
        i++;
    }
    {
        // Create a new view controller and pass suitable data.
        ViewControllerFList *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerFList"];
        [viewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:viewController];
        i++;
    }
    [self.pageControl setSectionTitles:[NSArray arrayWithObjects:@"消息", @"会话", @"群聊", @"通讯录", nil]];
    
    //    for (int i = 1; i < 5; i++)
    //    {
    //        // Create a new view controller and pass suitable data.
    //        SamplePagedViewController *pagedViewController = [pager.storyboard instantiateViewControllerWithIdentifier:@"SamplePagedViewController"];
    //        [pagedViewController setViewTitle:[NSString stringWithFormat:@"Page %d",i]];
    //        [pagedViewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
    //        [pages addObject:pagedViewController];
    //    }
    [self setPages:pages];
    
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgUpdageSegBadge])
    {
        NSNumber *nb = notification.object;
        if(nb != nil)
        {
            int cc = nb.intValue;
            [self.pageControl setBadge:(int)(cc % 100) ofIndex:(int)(cc  / 100.0)];
            [self.pageControl setNeedsDisplay];
        }
    }
    else if([msg isEqualToString:hsNotificationMsgBadge])
    {
        NSLog(@"msgTest arrival... %@", self);
        [self updateSegBadge];
    }
}

- (void)updateSegBadge
{
    int nNotifyCount = [_HSCore badgeCountOfNotify];
    int nMessageCount = [_HSCore badgeCountOfChat];
    SetSegBadge(0, nNotifyCount);
    SetSegBadge(1, nMessageCount);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.pages count] > 0)
    {
        //        [self.pageViewController setViewControllers:@[self.pages[0]]
        //                                          direction:UIPageViewControllerNavigationDirectionForward
        //                                           animated:NO
        //                                         completion:NULL];
        [self.pageViewController setViewControllers:@[self.pages[[self.pageControl selectedSegmentIndex]]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
        
        
        //        __weak UIPageViewController* pvcw = self.pageViewController;
        //        id page = self.pages[[self.pageControl selectedSegmentIndex]];
        //        [self.pageViewController setViewControllers:@[page]
        //                                          direction:UIPageViewControllerNavigationDirectionForward
        //                                           animated:YES completion:^(BOOL finished)
        //        {
        //            UIPageViewController* pvcs = pvcw;
        //            if (!pvcs)return;
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [pvcs setViewControllers:@[page]
        //                               direction:UIPageViewControllerNavigationDirectionForward
        //                                animated:NO completion:nil];
        //            });
        //        }];
        //
        //
        //
        
        [self updateSegBadge];
    }
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (IBAction)onTest:(id)sender
{
    [_HSCore dumpAccount];
    [_HSCore dumpMessage];
    [_HSCore dumpGroup];
    [_HSCore dumpFriend];
    [_HSCore dumpChatID];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index < [self.pages count])
    {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
}

@end
