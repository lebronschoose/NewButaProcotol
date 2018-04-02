//
//  ViewControllerChat.m
//  HSIMApp
//
//  Created by han on 14/1/15.
//  Copyright (c) 2014年 han. All rights reserved.
//

//ChatMessageTableViewController 学习怎么调整uitableview聊天自动往上跑
//FaceChatDemo 学习怎么增加支持qq聊天表情
//MessageList 学习怎么使用emoj
//HBTalkBubble 学习怎么中聊天中显示图片
//气泡 学习怎么录音发送语音

#import "ViewControllerChat.h"
#import "IQKeyboardManager.h"
#import "ViewControllerFriendDetail.h"
#import "ViewControllerGroupDetail.h"
#import "MasterURL.h"
#import "HSMessageObject.h"
#import "CellChatMessage.h"
#import "UIImageView+WebCache.h"

#define MEDIAVIEW_HEIGHT            120

#define scroll2end                  @"scroll2end"

@interface ViewControllerChat ()

@end

@implementation ViewControllerChat

#pragma mark - Normals

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        UIImageView * image = [[UIImageView alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [IQKeyboardManager sharedManager].enable = NO;
    fitIOS7;
    if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && [[[UIDevice currentDevice] systemVersion] doubleValue] <= 7.0)
    {
        RegisterMsg(UIKeyboardWillChangeFrameNotification, changeKeyBoard);
        RegisterMsg(UIKeyboardDidChangeFrameNotification, changedKeyBoard);
    }
    else
    {
        RegisterMsg(UIKeyboardWillShowNotification, keyBoardWillShow);
        RegisterMsg(UIKeyboardWillHideNotification, keyBoardWillHide);
    }
    nibHasLoadCellChatMsg = NO;
    
    [self setOfTarget:_Master.currentChatUser];
    if(self.ofTarget == nil)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    BOOL bWithRightButton = YES;
    if([Master isP2PChat:self.ofTarget.specialChatID.intValue])
    {
        [_HSCore signMessageReadByUserID:self.ofTarget.DDNumber];
    }
    else
    {
        [_HSCore signMessageReadByChatID:self.ofTarget.specialChatID];
        if([Master isSysNotify:self.ofTarget.specialChatID.intValue])
        {
            [self.inputToolBarView setHidden:YES];
            bWithRightButton = NO;
        }
    }
    if(bWithRightButton)
    {
        
        UIButton *bb = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bb.frame = CGRectMake(0, 0, 60, 50);
        [bb setBackgroundImage:[UIImage imageNamed:@"icon-allTalk.png"] forState:UIControlStateNormal];
        [bb addTarget:self action:@selector(onBtUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:bb];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           
                                           target:nil action:nil];
        
        negativeSpacer.width = -10;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        
//        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    firstTime = YES;
    self.msgRecords = [[NSMutableArray alloc] init];
    [self loadMsgList];
    
    self.mediaImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectImage:)];
    [self.mediaImage addGestureRecognizer:tapImage];
    self.mediaLocation.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectLocation:)];
    [self.mediaLocation addGestureRecognizer:tapLocation];
    
    //[_HSCore dumpMessage];
    
    self.navigationItem.title = self.ofTarget.nickName;
    CareMsg(scroll2end);
    CareMsg(hsNotificationNewMsg);
    CareMsg(hsNotificationUserReceived);
    CareMsg(hsNotificationNeedShowDetail);
    CareMsg(hsNotificationMsgUpdateChatList);
    NSLog(@"1frame of last view: %f,%f %f,%f", self.view.frame.origin.x, self.view.frame.origin.y,
          self.view.frame.size.width, self.view.frame.size.height);
}

-(void)onSelectLocation:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"view logo...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    [_Master setCurrentChatUser:nil];
    
    if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && [[[UIDevice currentDevice] systemVersion] doubleValue] <= 6.0)
    {
        RemoveMsg(UIKeyboardWillChangeFrameNotification);
        RemoveMsg(UIKeyboardDidChangeFrameNotification);
    }
    else
    {
        RemoveMsg(UIKeyboardWillShowNotification);
        RemoveMsg(UIKeyboardWillHideNotification);
    }
}

-(void)onNotifyMsg:(NSNotification *)notification
{
    [super onNotifyMsg:notification];
    
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationNetworkOK])
    {
    }
    else if([msg isEqualToString:hsNotificationNewMsg])
    {
        HSMessageObject* aMessage = notification.object;
        if(aMessage == nil || aMessage.messageFrom == nil) return;
        
        int chatID = [aMessage.messageChatID intValue];
        if([Master isP2PChat:chatID])
        {
            NSLog(@"from %@, cur:%@, user: %@", aMessage.messageFrom, _Master.currentChatUser.DDNumber, [HSAppData getAccount]);
            if([aMessage.messageFrom isEqualToString:_Master.currentChatUser.DDNumber] ||
               [aMessage.messageFrom isEqualToString:[HSAppData getAccount]])
            {
                [_HSCore signMessageReadByUserID:aMessage.messageFrom];
                [_HSCore constructBadge];
                NSLog(@"new msg coming... reload. chatID = %d", chatID);
            }
        }
        else if([Master isPublicGroup:chatID] || [Master isGroup:chatID])
        {
            if(chatID == [_Master.currentChatUser.specialChatID intValue])
            {
                [_HSCore signMessageReadByChatID:[NSNumber numberWithInt:chatID]];
                [_HSCore constructBadge];
                NSLog(@"new msg coming... reload. chatID = %d", chatID);
            }
        }
        
        [self loadMsgList];
        [self refreshList];
    }
    else if([msg isEqualToString:hsNotificationNeedShowDetail])
    {
        // 从storyboard创建MainViewController
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewControllerFriendDetail *mainViewController = (ViewControllerFriendDetail*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerFriendDetail"];
        [mainViewController setTransObj:@{@"user": notification.object, @"chatid":self.ofTarget.specialChatID, @"showButton": @"yes"}];
        [self.navigationController pushViewController:mainViewController animated:YES];
    }
    else if([msg isEqualToString:hsNotificationMsgUpdateChatList] || [msg isEqualToString:hsNotificationUserReceived])
    {
        [self loadMsgList];
        [self refreshList];
    }
    else if([msg isEqualToString:scroll2end])
    {
        if(self.msgRecords.count <= 0) return;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecords.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        NSLog(@"scrolll over");
    }
}

-(void)refreshList
{
    [self.tableView reloadData];
    if(self.msgRecords.count <= 0) return;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecords.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
//    CGSize size = self.tableView.contentSize;
//    CGPoint offset = self.tableView.contentOffset;
//    
//    CGPoint ptInput = self.inputToolBarView.frame.origin;
//    offset.y = size.height - ptInput.y - INSETS;
//    [self.tableView setContentOffset:offset];
//    NSLog(@"SET OFFSET TO: %f", offset.y);
    NSLog(@"refresh over");
}

-(void)loadMsgList
{
    self.msgRecords = [_HSCore fetchMessageListWithUser:self.ofTarget.DDNumber byPages:1 ofChatID:self.ofTarget.specialChatID];
    NSLog(@"self.msgrecords is %ld",self.msgRecords.count);
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"touch: %@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        [self endInput];
        NSLog(@"click in cell");
        // to let the didselectrowatindexpath run
        return NO;
    }
    else if([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
    {
        return NO;
    }
    else if([NSStringFromClass([touch.view class]) isEqualToString:@"UITextField"])
    {
        return NO;
    }
    NSLog(@"click no cell.");
    [self endInput];
    return  YES;
}

#pragma mark - 键盘处理
-(void)adjustTableView
{
    CGPoint ptInput = self.inputToolBarView.frame.origin;
    // 首先把tableview的大小调整到占除了键盘刚好剩余区域
    CGRect frame = self.tableView.frame;
    CGFloat old = frame.size.height;
    CGPoint offset = self.tableView.contentOffset;
    frame.size.height = ptInput.y - INSETS - frame.origin.y;
    [self.tableView setFrame:frame];
    
    
    CGFloat sub = old - frame.size.height;
    offset.y += sub;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecords.count - 1 inSection:0]];
    if(cell != nil)
    {
        CGRect frameCell = cell.frame;
        CGFloat cellBottom = frameCell.origin.y + frameCell.size.height;
        
        CGFloat needMove = cellBottom - ptInput.y;
        if(needMove > 0)
        {
            [UIView animateWithDuration:0.5 animations:^{
                //self.tableView.transform = CGAffineTransformIdentity;
                [self.tableView setContentOffset:offset];
                //self.tableView.transform = CGAffineTransformMakeTranslation(0, -needMove);
            }];
        }
    }
}

- (void)keyBoardWillShow:(NSNotification *)note
{
    NSLog(@"3frame of last view: %f,%f %f,%f", self.view.frame.origin.x, self.view.frame.origin.y,
          self.view.frame.size.width, self.view.frame.size.height);
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.mediaView setHidden:YES];
        self.inputToolBarView.transform = CGAffineTransformMakeTranslation(0, ty);
        [self adjustTableView];
    }];
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.inputToolBarView.transform = CGAffineTransformIdentity;
        [self adjustTableView];
    }];
}

-(void)endInput
{
    [self.view endEditing:YES];
    
    NSLog(@"hide input media.");
    self.inputToolBarView.transform = CGAffineTransformIdentity;
    //[self adjustTableView];
    [self.mediaView setHidden:YES];
}

- (IBAction)onSelectMedia:(id)sender
{
    [self.view endEditing:YES];
    [self endInput];
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"发送图片" delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:@"拍照"
                                        otherButtonTitles:@"从相册中选择",
                       nil];
    [as showInView:self.view];
    
    
//    [self.view endEditing:YES];
//    if(self.mediaView.hidden == YES)
//    {
//        NSLog(@"show input media.");
//        [UIView animateWithDuration:0.2 animations:^{
//            self.inputToolBarView.transform = CGAffineTransformMakeTranslation(0, -MEDIAVIEW_HEIGHT);
//            //[self adjustTableView];
//            [self.mediaView setHidden:NO];
//        }];
//    }
}


-(void)dumpPosition
{
    CGRect frame = self.tableView.frame;
    CGSize size = self.tableView.contentSize;
    UIEdgeInsets inset = self.tableView.contentInset;
    CGPoint offset = self.tableView.contentOffset;
    
    NSLog(@"%f, %f,   %f, %f, %f, %f", offset.x, offset.y,  size.width, size.height, frame.origin.y, inset.bottom);
}

#pragma mark ----键盘高度变化------

#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    NSLog(@"deltaY:%f",deltaY);
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top-deltaY, 0, 0, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}

-(void)changedKeyBoard:(NSNotification *)aNotifacation
{
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top-deltaY, 0, 0, 0)];
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}
#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self endInput];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.inputMsgText.text length] == 0) return NO;
    
    HSMessageObject *aMessage = [[HSMessageObject alloc] init];
    [aMessage setMessageState:[NSNumber numberWithInt:kWCMessageTextSending]];
    [aMessage setMessageChatID:self.ofTarget.specialChatID];
    [aMessage setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    [aMessage setMessageFrom:_Master.mySelf.DDNumber];
    [aMessage setMessageTo:self.ofTarget.DDNumber];
    [aMessage setMessageDate:[NSDate date]];
    [aMessage setMessageContent:self.inputMsgText.text];
    [aMessage setMessageTimeFlag:[NSNumber numberWithInt:arc4random()]];
    [aMessage setBindImagePath:@""];
    [aMessage setUploadUUID:@""];
    [_HSCore saveMessage2DB:aMessage ofRead:YES isReloadIM:YES];
    [_HSCore pushUnSendMsg:aMessage.messageTimeFlag ofChatID:aMessage.messageChatID];
    
    [_Master reqSendChatMsg:aMessage];
    
    [glState msgIncrease];
    self.inputMsgText.text = @"";
    return YES;
}
////
#pragma mark - Table View Data Source

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgRecords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSIMessageObject *aIMessage = [self.msgRecords objectAtIndex:[self.msgRecords count] - indexPath.row - 1];
    HSMessageObject *aMessage = aIMessage.message;
    
    BOOL isOutMsg = [aMessage.messageFrom isEqualToString:_Master.mySelf.DDNumber];
    BOOL bHideNickName = YES;
    if(!isOutMsg && aMessage.messageChatID.intValue != 0)
    {
        bHideNickName = ![_HSCore isShowNickOfChatID:aMessage.messageChatID];
    }
    CGFloat height = [CellChatMessage heightForMessage:aMessage showNickName:!bHideNickName];
    //NSLog(@"height for row:%ld - %f, (%@", (long)indexPath.row, height, aChatMessage.message.messageContent);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellChatMessage";
    if(!nibHasLoadCellChatMsg)
    {
        UINib *nib = [UINib nibWithNibName:@"CellChatMessage" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        nibHasLoadCellChatMsg = YES;
    }
    CellChatMessage *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellChatMessage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setParent:self];
    
    [cell.imgLevel setHidden:YES];
    HSIMessageObject *aIMessage = [self.msgRecords objectAtIndex:[self.msgRecords count] - indexPath.row - 1];
    HSMessageObject *aMessage = aIMessage.message;
    HSUserObject *aUser = aIMessage.user;
    
    if(aUser == nil)
    {
        if([Master isP2PChat:[aMessage.messageChatID intValue]])
        {
            [_Master reqUserData:aMessage.messageFrom ofType:4 oldFlag:0 ofChatID:[aMessage.messageChatID intValue]];
        }
        else if([Master isPublicGroup:[aMessage.messageChatID intValue]] || [Master isGroup:[aMessage.messageChatID intValue]])
        {
            [_Master reqUserData:aMessage.messageFrom ofType:3 oldFlag:0 ofChatID:[aMessage.messageChatID intValue]];
        }
    }
    if(aUser != nil)
    {
        if([Master isPublicGroup:[aMessage.messageChatID intValue]] || [Master isGroup:[aMessage.messageChatID intValue]])
        {
            [cell setOfUser:aUser];
        }
        if(![aUser.DDNumber isEqualToString:_Master.mySelf.DDNumber])
        {
            [cell.imgLevel setHidden:NO];
        }
        [cell loadImage:@"defaultlogo" andURL:[MasterURL urlOfUserLogo:aUser.DDNumber]];
        cell.userNickName.text = aUser.nickName;
        [cell setOfMessage:aMessage];
        [aUser checkUpdate:4];
    }
    else if([Master isSysNotify:self.ofTarget.specialChatID.intValue])
    {
        [cell.userLogo setImage:[UIImage imageNamed:@"sysnotify"]];
        cell.userNickName.text = @"系统消息";
        [cell setOfMessage:aMessage];
    }
    NSLog(@"cell over");
    return cell;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        //end of loading
//        dispatch_sync(dispatch_get_main_queue(), ^(){
//            if(firstTime)
//            {
//                firstTime = NO;
//                if(self.msgRecords.count <= 0) return;
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgRecords.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//            }
//        });
        
        if(firstTime)
        {
            firstTime = NO;
            PostMessage(scroll2end, nil);
        }
    }
}

- (IBAction)onSwitchVoice:(id)sender
{
}

- (IBAction)onInputEmotion:(id)sender
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += 200;
    
    self.tableView.contentInset = insets;
}
//上拉加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float sub = contentHeight - offset;
    if ((scrollView.frame.size.height - sub) > 20)
    {
        //如果上拉距离超过20p，则加载更多数据
        //[self loadMoreData];//此处在view底部加载更多数据
    }
}

- (IBAction)onBtUserInfo:(id)sender
{
    if([Master isPublicGroup:self.ofTarget.specialChatID.intValue])
    {
        for(UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[ViewControllerGroupDetail class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        HSPublicGroupObject *aGroup = [_HSCore groupFromDB:self.ofTarget.specialChatID];
        
        // 从storyboard创建MainViewController
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewControllerGroupDetail *mainViewController = (ViewControllerGroupDetail*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerGroupDetail"];
        [mainViewController setTransObj:aGroup];
        [self.navigationController pushViewController:mainViewController animated:YES];
    }
    else
    {
        for(UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[ViewControllerFriendDetail class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        
        // 从storyboard创建MainViewController
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewControllerFriendDetail *mainViewController = (ViewControllerFriendDetail*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerFriendDetail"];
        [mainViewController setTransObj:@{@"user": self.ofTarget, @"chatid":self.ofTarget.specialChatID, @"showButton": @"yes"}];
        [self.navigationController pushViewController:mainViewController animated:YES];
    }
}

-(void)onSelectImage:(UIGestureRecognizer *)gestureRecognizer
{
    [self endInput];
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"发送图片" delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:@"拍照"
                                        otherButtonTitles:@"从相册中选择",
                       nil];
    [as showInView:self.view];
}
#pragma mark ----------ActionSheet 按钮点击-------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            break;
        }
        case 1:
            //搞一张
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    m_imagePicker.delegate = self;
                    //        [m_imagePicker.navigationBar.subviews];
                    [m_imagePicker setAllowsEditing:YES];
                    //m_imagePicker.allowsImageEditing = NO;
                    [self presentViewController:m_imagePicker animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:
                                          @"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    m_imagePicker.delegate = self;
                    [m_imagePicker setAllowsEditing:YES];
                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:m_imagePicker];
                    [self setThePopoverController:popover];
                    
                    [self.thePopoverController presentPopoverFromRect:CGRectMake(0, 0, 500, 300) inView:self.
                     view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!"
                                                                  delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //
            CATransition *trans = [CATransition animation];
            [trans setDuration:0.25f];
            [trans setType:@"flip"];
            [trans setSubtype:kCATransitionFromLeft];
            
        }];
    }
    else //
    {
        CATransition *trans = [CATransition animation];
        [trans setDuration:0.25f];
        [trans setType:@"flip"];
        [trans setSubtype:kCATransitionFromLeft];
        
        [self.thePopoverController dismissPopoverAnimated:YES];
    }
    NSString *imagePath = [_Master image2File:image ofType:NN(2)];
    
    HSMessageObject *aMessage = [[HSMessageObject alloc] init];
    [aMessage setMessageState:[NSNumber numberWithInt:kWCMessageImageReady]];
    [aMessage setMessageChatID:self.ofTarget.specialChatID];
    [aMessage setMessageType:[NSNumber numberWithInt:kWCMessageTypeImage]];
    [aMessage setMessageFrom:_Master.mySelf.DDNumber];
    [aMessage setMessageTo:self.ofTarget.DDNumber];
    [aMessage setMessageDate:[NSDate date]];
    [aMessage setMessageContent:self.inputMsgText.text];
    [aMessage setMessageTimeFlag:[NSNumber numberWithInt:arc4random()]];
    [aMessage setBindImagePath:imagePath];
    [aMessage setUploadUUID:[NSString stringWithFormat:@"u_%@", aMessage.messageTimeFlag]];
    [_HSCore saveMessage2DB:aMessage ofRead:YES isReloadIM:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
        else
        {
            [self.thePopoverController dismissPopoverAnimated:YES];
        }
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

@end
