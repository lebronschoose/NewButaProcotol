//
//  HSImageScrollView.m
//  dyhAutoApp
//
//  Created by apple on 15/9/22.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import "HSImageScrollView.h"
#import "EGOImageView.h"

#define kStartTag   1000
#define kDefaultScrollInterval  2

@interface HSImageScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pageControlConstraints;
@end

@implementation HSImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.scrollInterval = kDefaultScrollInterval;
    
    // scrollview
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    
    self.scrollView.delegate = self;
    
    // UIPageControl
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.numberOfPages = self.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    NSArray *pageControlVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    NSArray *pageControlHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pageControl]-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    self.pageControlConstraints = [NSMutableArray arrayWithArray:pageControlVConstraints];
    [self.pageControlConstraints addObjectsFromArray:pageControlHConstraints];
    
    [self addConstraints:self.pageControlConstraints];
}

// @deprecated use - (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate instead
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<HSImageScrollViewDelegate>)delegate
{
    [self initWithCount:imageURLs.count delegate:delegate edgeInsets:UIEdgeInsetsZero];
}

// @deprecated use - (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets instead
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets
{
    [self initWithCount:imageURLs.count delegate:delegate edgeInsets:edgeInsets];
}

- (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate
{
    [self initWithCount:count delegate:delegate edgeInsets:UIEdgeInsetsZero];
}

- (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets
{
    self.count = count;
    self.delegate = delegate;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%d-[scrollView]-%d-|", (int)edgeInsets.top, (int)edgeInsets.bottom]
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"scrollView": self.scrollView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[scrollView]-%d-|", (int)edgeInsets.left, (int)edgeInsets.right]
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:@{@"scrollView": self.scrollView}]];
    
    if (count == 0)
    {
        return;
    }
    
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    
    CGFloat startX = self.scrollView.bounds.origin.x;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - edgeInsets.left - edgeInsets.right;
    CGFloat height = self.bounds.size.height - edgeInsets.top - edgeInsets.bottom;
    
    for(id sub in self.subviews)
    {
        if([sub isKindOfClass:[EGOImageView class]])
        {
            EGOImageView *e = (EGOImageView *)sub;
            [e removeFromSuperview];
        }
    }
    NSLog(@"hsImageScrollView width = %.f, bounds = %.f", self.scrollView.frame.size.width, self.bounds.size.width);
    for (int i = 0; i < count; i++)
    {
        EGOImageView *e = (EGOImageView *)[self viewWithTag:kStartTag + i];
        if(e == nil)
        {
            startX = i * width;
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(startX, 0, width, height+44)];
//            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.tag = kStartTag + i;
            imageView.userInteractionEnabled = YES;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
            
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height+44]];
            
            [imageView setPlaceholderImage:[UIImage imageNamed:@"webbg"]];
            NSString *urlString = [self.delegate hsImageScrollView:self imageForItemAtIndex:i];
            if([urlString rangeOfString:@"://"].location != NSNotFound)
            {
                [imageView setImageURL:[NSURL URLWithString:urlString]];
            }
            else
            {
                [imageView setImage:[UIImage imageNamed:urlString]];
            }
            
            [self.scrollView addSubview:imageView];
        }
        else
        {
            NSString *urlString = [self.delegate hsImageScrollView:self imageForItemAtIndex:i];
            if([urlString rangeOfString:@"://"].location != NSNotFound)
            {
                [e setImageURL:[NSURL URLWithString:urlString]];
            }
            else
            {
                [e setImage:[UIImage imageNamed:urlString]];
            }
        }
    }
    
    // constraint
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *imageViewNames = [NSMutableArray array];
    for (int i = kStartTag; i < kStartTag + count; i++)
    {
        NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i - kStartTag];
        [imageViewNames addObject:imageViewName];
        
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:i];
        [viewsDictionary setObject:imageView forKey:imageViewName];
    }
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[%@]-0-|", [imageViewNames objectAtIndex:0]]
                                                                            options:kNilOptions
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
    
    NSMutableString *hConstraintString = [NSMutableString string];
    [hConstraintString appendString:@"H:|-0"];
    for (NSString *imageViewName in imageViewNames)
    {
        [hConstraintString appendFormat:@"-[%@]-0", imageViewName];
    }
    [hConstraintString appendString:@"-|"];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintString
                                                                            options:NSLayoutFormatAlignAllTop
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
    
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * count, self.scrollView.frame.size.height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger index = imageView.tag - kStartTag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsImageScrollView:didTapAtIndex:)])
    {
        [self.delegate hsImageScrollView:self didTapAtIndex:index];
    }
}

#pragma mark - auto scroll
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll)
    {
        if (!self.autoScrollTimer || !self.autoScrollTimer.isValid)
        {
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
        }
    }
    else
    {
        if (self.autoScrollTimer && self.autoScrollTimer.isValid)
        {
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
        }
    }
}

- (void)setScrollInterval:(NSUInteger)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    if (self.autoScrollTimer && self.autoScrollTimer.isValid)
    {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
}

- (void)handleScrollTimer:(NSTimer *)timer
{
    if (self.count == 0)
    {
        return;
    }
    
    NSInteger currentPage = self.pageControl.currentPage;
    NSInteger nextPage = currentPage + 1;
    if (nextPage == self.count)
    {
        nextPage = 0;
    }
    
    BOOL animated = YES;
    if (nextPage == 0)
    {
        animated = NO;
    }
    
    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:(nextPage + kStartTag)];
    [self.scrollView scrollRectToVisible:imageView.frame animated:animated];
    
    self.pageControl.currentPage = nextPage;
}

#pragma mark - scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // disable v direction scroll
    if (scrollView.contentOffset.y > 0)
    {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // when user scrolls manually, stop timer and start timer again to avoid next scroll immediatelly
    if (self.autoScrollTimer && self.autoScrollTimer.isValid)
    {
        [self.autoScrollTimer invalidate];
    }
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
    
    // update UIPageControl
    CGRect visiableRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, [[UIScreen mainScreen] bounds].size.width, scrollView.bounds.size.height);
    NSInteger currentIndex = 0;
    for (UIImageView *imageView in scrollView.subviews)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            if (CGRectContainsRect(visiableRect, imageView.frame))
            {
                currentIndex = imageView.tag - kStartTag;
                break;
            }
        }
    }
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    [_pageControl setCurrentPage:page];
    
//    self.pageControl.currentPage = currentIndex;
}
 
#pragma mark -
- (void)setPageControlPosition:(ICPageControlPosition)pageControlPosition
{
    NSString *vFormat = nil;
    NSString *hFormat = nil;
    
    switch (pageControlPosition)
    {
        case ICPageControlPosition_TopLeft:
        {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case ICPageControlPosition_TopCenter:
        {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case ICPageControlPosition_TopRight:
        {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        case ICPageControlPosition_BottomLeft:
        {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case ICPageControlPosition_BottomCenter:
        {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case ICPageControlPosition_BottomRight:
        {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        default:
            break;
    }
    
    [self removeConstraints:self.pageControlConstraints];
    
    NSArray *pageControlVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    NSArray *pageControlHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    [self.pageControlConstraints removeAllObjects];
    [self.pageControlConstraints addObjectsFromArray:pageControlVConstraints];
    [self.pageControlConstraints addObjectsFromArray:pageControlHConstraints];
    
    [self addConstraints:self.pageControlConstraints];
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    self.pageControl.hidden = hidePageControl;
}

@end


