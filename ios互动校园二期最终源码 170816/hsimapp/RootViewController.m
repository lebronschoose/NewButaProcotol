//
//  RootViewController.m
//  dyhAutoApp
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "RootViewController.h"

#define TIP_IMAGE

#ifdef TIP_IMAGE
#import "EGOImageView.h"
#endif

#define DEBUG_GAP       0.0
#define BOTTOM_PICKER_VIEW_HEIGHT       ([[UIScreen mainScreen] bounds].size.width - 60.0)
#define TITLE_FONTSIZE  17.0
#define ARROWICONSIZE   16.0

typedef int(^MessageBlock)();

@interface RootViewController() <UIPickerViewDelegate>
{
    UIButton *btHideTip;
    UITextView *tipTitle;
    UITextView *tipText;
    
    BOOL popWhenWaitingDone;
    BOOL runBlockWhenWaitingDone;
    MessageBlock blockOfMessage;
    
#ifdef TIP_IMAGE
    EGOImageView *tipImage;
#endif
    UIWebView *tipWebView;
    
    UILabel *labelTitle;
    UIImageView *arrowLeft, *arrowRight;
    BOOL isPicking;
    int pickerType; // 0x01 : middle, 0x02 : bottom
    NSString *pickerTitle, *pickerFinishTitle;
    UIPickerView *rootDataPicker;
    UIView *rootPickerView;
}
@end

@implementation RootViewController

- (id)init
{
    NSLog(@"ViewController: %@ - init", self);
    
    if ((self = [super init]))
    {
        pickerType = 0;
        popWhenWaitingDone = NO;
    }
    return self;
}

- (void)runAPI:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess
{
    Waiting(TIMEOUT, @"waitingHTTPGet");
    [_Master reqJsonFor:api andParams:params success:^(NSDictionary * dict) {
        StopWaiting;
        blockSuccess(dict);
    } failed:^{
        StopWaiting;
        NSLog(@"faile.d");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
}

-(void)PostAPI:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess
{
    Waiting(TIMEOUT, @"waitingHTTPGet");
    [_Master SubmitTo:api andParams:params success:^(NSDictionary * dict) {
        StopWaiting;
        blockSuccess(dict);
    } failed:^{
        StopWaiting;
        NSLog(@"faile.d");
        [self showMessage:@"请求失败，请重新尝试."];
    }];
}




- (void)viewDidLoad
{
    fitIOS7;
//   ReturnNAVI
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    [returnButtonItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSFontAttributeName:[UIFont systemFontOfSize:15]
                                      } forState:UIControlStateNormal];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    NSLog(@"ViewController: %@ - viewDidLoad", self);
    [glState push1ViewController:[NSString stringWithFormat:@"%@", self]];
    
    waitingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    waitingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    CGSize scrSize = self.view.frame.size;
    [waitingIndicator setCenter:CGPointMake(scrSize.width / 2, scrSize.height / 2)];
    [self.view addSubview:waitingIndicator];
    
    CGRect frame = [[UIScreen mainScreen] bounds];// self.view.frame;
    {
        labelMessage = [[UILabel alloc] initWithFrame:frame];
        rounds(labelMessage);
        [labelMessage setBackgroundColor:[UIColor colorWithRed:12/255.0 green:68/255.0 blue:0 alpha:1.0]];
        [labelMessage setTextColor:[UIColor whiteColor]];
        [labelMessage setTextAlignment:NSTextAlignmentCenter];
        labelMessage.layer.zPosition = 999;
        [labelMessage setHidden:YES];
        [self.view addSubview:labelMessage];
    }
    {
        /// show text tip
        viewTip = [[UIView alloc] initWithFrame:self.view.frame];
        [viewTip setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        viewTip.layer.zPosition = 999;
        [viewTip setHidden:YES];
        [self.view addSubview:viewTip];
        
        UIView *tv = [[UIView alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 40, frame.size.width)];
        [tv setBackgroundColor:[UIColor whiteColor]];
        [tv.layer setMasksToBounds:YES];
        tv.layer.cornerRadius = 5.0;
        [viewTip addSubview:tv];
        
        UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 36, frame.size.width - 40, 1)];
        [lv setBackgroundColor:[UIColor grayColor]];
        [tv addSubview:lv];
        
        btHideTip = [UIButton buttonWithType:0];
        [btHideTip setFrame:CGRectMake(tv.frame.size.width - 60, 4, 56, 30)];
        [btHideTip setTitle:@"关闭" forState:UIControlStateNormal];
        [btHideTip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btHideTip addTarget:self action:@selector(onHideTip) forControlEvents:UIControlEventTouchUpInside];
        [tv addSubview:btHideTip];
        
        tipTitle = [[UITextView alloc] initWithFrame:CGRectMake(60, 0, frame.size.width - 40 - 120, 30)];
        [tipTitle setFont:[UIFont systemFontOfSize:19]];
        [tipTitle setTextAlignment:NSTextAlignmentCenter];
        [tipTitle setUserInteractionEnabled:NO];
        [tv addSubview:tipTitle];
        
        CGFloat b = 12.0;
        tipText = [[UITextView alloc] initWithFrame:CGRectMake(b, 36 + b, frame.size.width - 40 - 2 * b, frame.size.width - 40 - 2 * b)];
        //    [tipText setBackgroundColor:[UIColor redColor]];
        [tipText setHidden:YES];    [tipText setUserInteractionEnabled:NO];
        [tv addSubview:tipText];
        
#ifdef TIP_IMAGE
        tipImage = [[EGOImageView alloc] initWithFrame:CGRectMake(b, 36 + b, frame.size.width - 40 - 2 * b, frame.size.width - 40 - 2 * b)];
        //    [tipImage setBackgroundColor:[UIColor redColor]];
        [tipImage setHidden:YES];
        [tv addSubview:tipImage];
#endif
        
        tipWebView = [[UIWebView alloc] initWithFrame:CGRectMake(b, 36 + b, frame.size.width - 40 - 2 * b, frame.size.width - 40 - 2 * b)];
        //    [tipWebView setBackgroundColor:[UIColor redColor]];
        [tipWebView setHidden:YES];
        [tv addSubview:tipWebView];
    }
    {
        waitingCover = [[UIView alloc] init];
        [waitingCover setFrame:self.view.frame];
        [waitingCover setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        waitingCover.layer.zPosition = 900;
        [waitingCover setHidden:YES];
        [self.view addSubview:waitingCover];
        
        waitingCover.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelPickItem:)];
        [waitingCover addGestureRecognizer:singleTap];
    }
    {
        // bottom picker view
        /*
         |-----------------------------------------|
         |                                         |
         |                                         |
         |                                         |
         |                                         |
         |-----------------------------------------|
         |             ⇈ 二年级二班 ⇈                |
         |-----------------------------------------|
         |                                         |
         |                                         |
         |                                         |
         |                                         |
         |               pickerView                |
         |                                         |
         |                                         |
         |                                         |
         |                                         |
         |                                         |
         |-----------------------------------------|
         */
        isPicking = NO;
        
        rootPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, BOTTOM_PICKER_VIEW_HEIGHT)];
//        [rootPickerView setHidden:YES];
        [rootPickerView setBackgroundColor:MAINCOLOR];
        rootPickerView.layer.zPosition = 901;
        
        UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40.0)];
        [viewTitle setBackgroundColor:MAINDEEPCOLOR];
        [rootPickerView addSubview:viewTitle];
        
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100.0, 20.0)];
        [labelTitle setTextColor:[UIColor whiteColor]];
//        [labelTitle setBackgroundColor:[UIColor redColor]];
        [labelTitle setFont:[UIFont systemFontOfSize:TITLE_FONTSIZE]];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [viewTitle addSubview:labelTitle];
        
        arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, (40 - ARROWICONSIZE) / 2.0, ARROWICONSIZE, ARROWICONSIZE)];
        [arrowLeft setImage:[UIImage imageNamed:@"arrowup"]];
        [viewTitle addSubview:arrowLeft];
        arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(0, (40 - ARROWICONSIZE) / 2.0, ARROWICONSIZE, ARROWICONSIZE)];
        [arrowRight setImage:[UIImage imageNamed:@"arrowup"]];
        [viewTitle addSubview:arrowRight];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 1.0)];
        [viewLine setBackgroundColor:[UIColor lightGrayColor]];
        [rootPickerView addSubview:viewLine];
        
        rootDataPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 41, frame.size.width, BOTTOM_PICKER_VIEW_HEIGHT - 41)];
        rootDataPicker.delegate = self;
//        [rootDataPicker setBackgroundColor:[UIColor redColor]];
        [rootPickerView addSubview:rootDataPicker];
        
        [self.view addSubview:rootPickerView];
        
        viewTitle.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPickItem:)];
        [viewTitle addGestureRecognizer:singleTap];
    }
}

-(void)onCancelPickItem:(UIGestureRecognizer *)gestureRecognizer
{
    if(isPicking)
    {
        isPicking = !isPicking;
        [self drawBottomPicker];
    }
}


-(void)onPickItem:(UIGestureRecognizer *)gestureRecognizer
{
    isPicking = !isPicking;
    [self drawBottomPicker];
}

- (void)drawBottomPicker
{
    [self.view endEditing:YES];
    
    [self updatePickerTitle];
    if(pickerType & 0x01)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];//self.view.frame;
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat hStatus = rectStatus.size.height;
        CGRect rectNav = self.navigationController.navigationBar.frame;
        CGFloat hNav = rectNav.size.height;
        CGRect rectTab = self.tabBarController.tabBar.frame;
        CGFloat hTab = rectTab.size.height;
        
        CGFloat h = BOTTOM_PICKER_VIEW_HEIGHT;
        CGFloat y = frame.size.height - h;
        
        if(self.navigationController != nil)
        {
            NSLog(@"with nav bar");
            y -= hNav;
            y -= hStatus;
        }
        if(self.tabBarController != nil && !self.tabBarController.tabBar.isHidden)
        {
            NSLog(@"with tab bar");
            y -= hTab;
        }
        if(isPicking)
        {
            NSLog(@"Start Pick");
            [arrowLeft setImage:[UIImage imageNamed:@"arrowdown"]];
            [arrowRight setImage:[UIImage imageNamed:@"arrowdown"]];
            
            [UIView setAnimationDelegate:self];
            [UIView beginAnimations:@"move" context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:0.15];
            //动画的内容
            CGRect vf = rootPickerView.frame;
            vf.origin.y = y / 2.0 - DEBUG_GAP;
            [rootPickerView setFrame:vf];
            //动画结束
            [UIView commitAnimations];
            [waitingCover setHidden:NO];
        }
        else
        {
            NSLog(@"End Pick");
            [arrowLeft setImage:[UIImage imageNamed:@"arrowup"]];
            [arrowRight setImage:[UIImage imageNamed:@"arrowup"]];
            
            [UIView setAnimationDelegate:self];
            [UIView beginAnimations:@"move" context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:0.15];
            //动画的内容
            CGRect vf = rootPickerView.frame;
            vf.origin.y = y + h - DEBUG_GAP;
            [rootPickerView setFrame:vf];
            //动画结束
            [UIView commitAnimations];
            [waitingCover setHidden:YES];
        }
    }
    if(pickerType & 0x02)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];//self.view.frame;
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat hStatus = rectStatus.size.height;
        CGRect rectNav = self.navigationController.navigationBar.frame;
        CGFloat hNav = rectNav.size.height;
        CGRect rectTab = self.tabBarController.tabBar.frame;
        CGFloat hTab = rectTab.size.height;
        
        CGFloat h = BOTTOM_PICKER_VIEW_HEIGHT;
        CGFloat y = frame.size.height - h;
        
        if(self.navigationController != nil)
        {
            NSLog(@"with nav bar");
            y -= hNav;
            y -= hStatus;
        }
        if(self.tabBarController != nil && !self.tabBarController.tabBar.isHidden)
        {
            NSLog(@"with tab bar");
            y -= hTab;
        }
        if(isPicking)
        {
            NSLog(@"Start Pick");
            [arrowLeft setImage:[UIImage imageNamed:@"arrowdown"]];
            [arrowRight setImage:[UIImage imageNamed:@"arrowdown"]];
            
            [UIView setAnimationDelegate:self];
            [UIView beginAnimations:@"move" context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:0.15];
            //动画的内容
            CGRect vf = rootPickerView.frame;
            vf.origin.y = y - DEBUG_GAP;
            [rootPickerView setFrame:vf];
            //动画结束
            [UIView commitAnimations];
            [waitingCover setHidden:NO];
        }
        else
        {
            NSLog(@"End Pick");
            [arrowLeft setImage:[UIImage imageNamed:@"arrowup"]];
            [arrowRight setImage:[UIImage imageNamed:@"arrowup"]];
            
            [UIView setAnimationDelegate:self];
            [UIView beginAnimations:@"move" context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:0.15];
            //动画的内容
            CGRect vf = rootPickerView.frame;
            vf.origin.y = y + h - 40.0 - DEBUG_GAP;
            [rootPickerView setFrame:vf];
            //动画结束
            [UIView commitAnimations];
            [waitingCover setHidden:YES];
        }
    }
    
    if(isPicking)
    {
        [self startPickItem];
    }
    else
    {
        if([self pickerView:rootDataPicker numberOfRowsInComponent:0] > 0)
        {
            [self endPickItem];
        }
    }
}

- (void)startPickItem
{
    
}

- (void)endPickItem
{
    
}

- (void)setSelectRow:(NSInteger)index InComponent:(NSInteger)component
{
    [rootDataPicker selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [rootDataPicker selectedRowInComponent:component];
}

- (void)startMiddlePicker:(NSString *)flag ofTitle:(NSString *)title andFinish:(NSString *)finishTitle
{
    self.pickerFlag = flag;
    pickerTitle = title;
    pickerFinishTitle = finishTitle;
    
    pickerType |= 0x01;
    isPicking = YES;
    [rootPickerView setHidden:NO];
    [rootDataPicker selectRow:0 inComponent:0 animated:NO];
    [self drawBottomPicker];
    
    [rootDataPicker reloadAllComponents];
}

- (void)startBottomPicker:(NSString *)flag ofTitle:(NSString *)title andFinish:(NSString *)finishTitle
{
    self.pickerFlag = flag;
    pickerTitle = title;
    pickerFinishTitle = finishTitle;
    
    pickerType |= 0x02;
    [rootPickerView setHidden:NO];
    [rootDataPicker selectRow:0 inComponent:0 animated:NO];
    [self drawBottomPicker];
    
    [rootDataPicker reloadAllComponents];
}

- (void)reloadPicker
{
    [self updatePickerTitle];
    [rootDataPicker reloadAllComponents];
}

- (void)updatePickerTitle
{
    NSString *title = pickerTitle;
    if(isPicking)
    {
        title = pickerFinishTitle;
    }
    
    NSInteger count = [self pickerView:rootDataPicker numberOfRowsInComponent:0];
    if(count > 0)
    {
        NSInteger sel = [rootDataPicker selectedRowInComponent:0];
        title = [self pickerView:rootDataPicker titleForRow:sel forComponent:0];
    }
    
    [labelTitle setText:title];
    CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:TITLE_FONTSIZE] constrainedToSize:CGSizeMake(320.0, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = labelTitle.frame;
    frame.origin.x = self.view.frame.size.width / 2.0 - textSize.width / 2.0;
    frame.size.width = textSize.width;
    [labelTitle setFrame:frame];
    
    CGRect lf = CGRectMake(frame.origin.x - ARROWICONSIZE - 6, arrowLeft.frame.origin.y, ARROWICONSIZE, ARROWICONSIZE);
    [arrowLeft setFrame:lf];
    CGRect lr = CGRectMake(frame.origin.x + frame.size.width + 6, arrowRight.frame.origin.y, ARROWICONSIZE, ARROWICONSIZE);
    [arrowRight setFrame:lr];
}

#pragma mark --- picker view delegate ---

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        // pickerLabel.minimumFontSize = 8.;
        //        pickerLabel.minimumScaleFactor = 10.0;
        //        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:24]];
        
        [pickerLabel setTextColor:[UIColor whiteColor]];//[UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

// 选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"-- picker %@ select %ld", self.pickerFlag, [rootDataPicker selectedRowInComponent:component]);
}


//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)onHideTip
{
    [tipText setHidden:YES];
    
#ifdef TIP_IMAGE
    [tipImage setHidden:YES];
#endif
    [tipWebView setHidden:YES];
    [viewTip setHidden:YES];
}

#pragma mark   ----触摸取消输入----
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"ViewController: %@ - viewWillAppear", self);
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"ViewController: %@ - viewDidAppear", self);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"ViewController: %@ - viewWillDisappear", self);
    
}

- (void)viewDidDisappear:(BOOL)animated
{
//    NSLog(@"ViewController: %@ - viewDidDisappear", self);
    if(waitingTimer != nil)
    {
        NSLog(@"ViewController: %@ - ********* a timer alived...", self);
    }
}

- (void)showSegueWithObject:(id)transObj Identifier:(NSString *)identifier
{
    if([self isEqual:transObj])
    {
        NSLog(@"************* retain self operation. trans **************");
    }
    
    // 不使用self.transObj和self.extraObj来传递参数trans, extra
    // 否则如果参数是self的话，会把self retain导致dealloc不调用
    //        [self setTransObj:trans];
    //        [self setExtraObj:extra];
    //        [self performSegueWithIdentifier:identifier sender:self];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:transObj, @"transObj", nil];
    [self performSegueWithIdentifier:identifier sender:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController* vc = segue.destinationViewController;
    
    if([sender isKindOfClass:[NSDictionary class]] || [sender isKindOfClass:[NSMutableDictionary class]])
    {
        NSDictionary *dict = sender;
        [vc setValue:[dict objectForKey:@"transObj"] forKey:@"transObj"];
    }
    else
    {
        NSLog(@"===========root view controller sender isn't a dictionary.");
    }
}

- (BOOL)bindMsg:(NSString *)msg by:(id)observer
{
    if(regMsgList == nil)
    {
        regMsgList = [[NSMutableArray alloc] init];
    }
    if([regMsgList containsObject:msg] == YES) return NO;
    
    NSLog(@"Notify: %@ - Bind Msg:'%@'", self, msg);
    [regMsgList addObject:msg];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(onNotifyMsg:) name:msg object:nil];
    return YES;
}

- (void)ignoreMsg:(NSString *)msg
{
    RemoveMsg(msg);
    [regMsgList removeObject:msg];
}

- (void)dealloc
{
    NSLog(@"ViewController: %@ - dealloc", self);
    [glState pop1ViewController:[NSString stringWithFormat:@"%@", self]];
    
    for(NSString *msg in regMsgList)
    {
        RemoveMsg(msg);
        NSLog(@"Notify: %@ - Remove Msg:'%@'", self, msg);
    }
    [regMsgList removeAllObjects];
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSLog(@"Notify: %@ - deal Msg:'%@'", self, notification.name);
}

- (IBAction)waitingEnd:(id)sender
{
    NSLog(@"Timer: %@ - Waiting time out for tag:'%@'", self, self.waitingTag);
    if([self.waitingTag isEqualToString:@"showmessage"])
    {
        if(popWhenWaitingDone)
        {
            popWhenWaitingDone = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        if(runBlockWhenWaitingDone && blockOfMessage != nil)
        {
            runBlockWhenWaitingDone = NO;
            blockOfMessage();
        }
    }
    else if([self.waitingTag isEqualToString:@"waitingHTTPGet"])
    {
        [self showMessage:@"请求失败，请重新尝试."];
    }
    [self stopWaiting];
}

- (void)startWaiting:(double)elapse forTag:(NSString *)tag
{
    [self stopWaiting];
    
    NSLog(@"Timer: %@ - Start waiting for tag:'%@'", self, tag);
    waitingTimer = [NSTimer scheduledTimerWithTimeInterval:elapse target:self selector:@selector(waitingEnd:) userInfo:nil repeats:NO];
    
    [self setWaitingTag:tag];
    [waitingCover setHidden:NO];
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:NO];
    [waitingIndicator startAnimating];
}

- (void)stopWaiting
{
    if([waitingIndicator isAnimating])
    {
        NSLog(@"Timer: %@ - Stop waiting for tag:'%@'", self, self.waitingTag);
        [self setWaitingTag:@""];
        [waitingTimer invalidate];
        waitingTimer= nil;
        
        [waitingCover setHidden:YES];
        [labelMessage setHidden:YES];
        [self.view setUserInteractionEnabled:YES];
        [waitingIndicator stopAnimating];
    }
}

- (void)showMessage:(NSString *)message
{
    CGSize textSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320.0, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    textSize.height += 20.0;
    textSize.width += 40.0;
    CGRect frame = CGRectMake((self.view.frame.size.width - textSize.width) / 2.0, (self.view.frame.size.height - textSize.height) / 2.0, textSize.width, textSize.height);
    [labelMessage setFrame:frame];
    [labelMessage setText:message];
    rounds(labelMessage);
    [self startWaiting:1.0 forTag:@"showmessage"];
    
    [labelMessage setHidden:NO];
    [waitingCover setHidden:YES];
    [waitingIndicator setHidden:YES];
}

- (void)showCloseMessage:(NSString *)message andDelay:(float)seconds
{
    CGSize textSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320.0, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    textSize.height += 20.0;
    textSize.width += 40.0;
    CGRect frame = CGRectMake((self.view.frame.size.width - textSize.width) / 2.0, (self.view.frame.size.height - textSize.height) / 2.0, textSize.width, textSize.height);
    [labelMessage setFrame:frame];
    [labelMessage setText:message];
    rounds(labelMessage);
    
    [self startWaiting:seconds forTag:@"showmessage"];
    
    [labelMessage setHidden:NO];
    [waitingCover setHidden:YES];
    [waitingIndicator setHidden:YES];
    popWhenWaitingDone = YES;
}

- (void)showBlockMessage:(NSString *)message delay:(float)seconds andThen:(void(^)())blockThen
{
    CGSize textSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320.0, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    textSize.height += 20.0;
    textSize.width += 40.0;
    CGRect frame = CGRectMake((self.view.frame.size.width - textSize.width) / 2.0, (self.view.frame.size.height - textSize.height) / 2.0, textSize.width, textSize.height);
    [labelMessage setFrame:frame];
    [labelMessage setText:message];
    rounds(labelMessage);
    
    [self startWaiting:seconds forTag:@"showmessage"];
    
    [labelMessage setHidden:NO];
    [waitingCover setHidden:YES];
    [waitingIndicator setHidden:YES];
    runBlockWhenWaitingDone = YES;
    blockOfMessage = (MessageBlock)blockThen;
}

- (void)showTipText:(NSString *)text title:(NSString *)title size:(CGFloat)size
{
    [self showTipText:text title:title size:size align:NSTextAlignmentLeft color:[UIColor blackColor]];
}

- (void)showTipText:(NSString *)text title:(NSString *)title size:(CGFloat)size align:(NSTextAlignment)align color:(UIColor *)color
{
    [tipTitle setText:title];
    [tipText setFont:[UIFont systemFontOfSize:size]];
    [tipText setTextAlignment:align];
    [tipText setTextColor:color];
    [tipText setText:text];
    [tipText setHidden:NO];
    [viewTip setHidden:NO];
}

- (void)showTipImage:(NSString *)image title:(NSString *)title
{
#ifdef TIP_IMAGE
    [tipTitle setText:title];
    [tipImage setImage:[UIImage imageNamed:image]];
    [tipImage setHidden:NO];
    [viewTip setHidden:NO];
#endif
}

- (void)showTipWebImage:(NSString *)imageUrl title:(NSString *)title
{
#ifdef TIP_IMAGE
    [tipTitle setText:title];
    [tipImage setImageURL:[NSURL URLWithString:imageUrl]];
    [tipImage setHidden:NO];
    [viewTip setHidden:NO];
#endif
}

- (void)showTipWeb:(NSString *)url title:(NSString *)title
{
    [tipTitle setText:title];
    [tipWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [tipWebView setHidden:NO];
    [viewTip setHidden:NO];
}

- (void)showTipWebString:(NSString *)htmlString title:(NSString *)title
{
    [tipTitle setText:title];
    [tipWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [tipWebView setHidden:NO];
    [viewTip setHidden:NO];
}

@end
