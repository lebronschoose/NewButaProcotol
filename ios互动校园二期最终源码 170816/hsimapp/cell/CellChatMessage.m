//
//  CellChatMessage.m
//  dyhAutoApp
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "CellChatMessage.h"
#import "ViewControllerViewLogo.h"
#import "ViewControllerWeb.h"
#import "MasterURL.h"
#import "ViewControllerChat.h"
#import "ViewControllerQA.h"
#import "ViewControllerHomework.h"
#import "ViewControllerScoreParent.h"

@interface CellChatMessage()
{
    NSArray *pList;
}

@end
@implementation CellChatMessage

#define IMAGE_WIDTH             120
#define IMAGE_HEIGHT            120

+(CGFloat)heightForMessage:(id)obj showNickName:(BOOL)isShowNickName
{
    HSMessageObject *aMessage = (HSMessageObject *)obj;
    
    if(aMessage.messageType.intValue == kWCMessageTypeImage)
    {
        CGSize contentSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
        BOOL isOutMsg = [_Master.mySelf.DDNumber isEqualToString:aMessage.messageFrom];
        BOOL bHideNickName = (!isShowNickName || isOutMsg);
        int hb = 10;
        return (bHideNickName ? 17 : 32) - hb + contentSize.height + 2 * hb + 6 + 8;
    }
    else// if(aMessage.messageType.intValue == kWCMessageTypePlain)
    {
        CGSize contentSize = [CellChatMessage sizeForText:aMessage.messageContent];
        BOOL isOutMsg = [_Master.mySelf.DDNumber isEqualToString:aMessage.messageFrom];
        BOOL bHideNickName = (!isShowNickName || isOutMsg);
        int hb = 10;
        return (bHideNickName ? 17 : 32) - hb + contentSize.height + 2 * hb + 6 + 8;
    }
    return 44;
}

+(CGSize)sizeForText:(NSString *)message
{
    CGRect rx = [UIScreen mainScreen ].bounds;
    
    /*
     ---------------------------------------------------------------------------------
     |      8
     |   |------   |------------------------
     |-8-|     |   |
     |   |  36 |   | 8 |我们大家一起做游戏。
     |   |-----| 8 |------------------------
     |      8
     |-------------------------------------------------------------------------------------------------
     */
    
    CGSize textSize = [message sizeWithFont:[UIFont systemFontOfSize:15]
                          constrainedToSize:CGSizeMake((rx.size.width - INSETS - HEAD_SIZE - INSETS - INSETS - INSETS - HEAD_SIZE - INSETS - 32), rx.size.height)
                              lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self setUploadType:NN(2)];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)onClickChatLogo:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"click user logo.");
    if(self.ofUser != nil)
    {
        PostMessage(hsNotificationNeedShowDetail, self.ofUser);
    }
}

-(void)onClickChatItem:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"on click chat message - %@", self.clickLinkURL);
    if(self.clickLinkURL.length > 1)
    {
        // 从storyboard创建MainViewController
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewControllerWeb *theView = (ViewControllerWeb *)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerWeb"];
//        [theView setCommonMode:YES];
        [theView setTransObj:self.clickLinkURL];
//        [theView setTheTitle:@"私车管家"];
        [self.parent.navigationController pushViewController:theView animated:YES];
    }
    else
    {
        if(pList != nil && pList.count == 9)
        {
            NSNumber *type = [pList objectAtIndex:1];
            switch (type.intValue)
            {
                case 1:
                case 2:
                case 3:
                {
                    ViewControllerWeb *viewController = (ViewControllerWeb *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewControllerWeb"];
                    [viewController setTransObj:@{@"title": @"校园公告", @"url": [MasterURL APIFor:@"notice" with:[pList objectAtIndex:5], nil]}];
                    [self.parent.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case 10:
                {
                    ViewControllerHomework *viewController = (ViewControllerHomework *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewControllerHomework"];
                    [self.parent.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case 20:
                {
                    ViewControllerScoreParent *viewController = (ViewControllerScoreParent *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewControllerScoreParent"];
                    [self.parent.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case 30:
                {
                    ViewControllerQA *viewController = (ViewControllerQA *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewControllerQA"];
                    [self.parent.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
}

-(void)onClickChatImage:(UIGestureRecognizer *)gestureRecognizer
{
    // 从storyboard创建MainViewController
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewControllerViewLogo *mainViewController = (ViewControllerViewLogo *)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerViewLogo"];
    [mainViewController setTransObj:self.ofMessage.messageContent];
    
    [self.parent.navigationController pushViewController:mainViewController animated:YES];
}

/*
 ---------------------------------------------------------------------------------
 |      8
 |   |------   |------------------------
 |-8-|     |   |
 |   |  36 |   | 8 |我们大家一起做游戏。
 |   |-----| 8 |------------------------
 |      8
 |-------------------------------------------------------------------------------------------------
 */

-(void)layoutSubviews
{
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChatLogo:)];
    self.userLogo.userInteractionEnabled = YES;
    [self.userLogo addGestureRecognizer:singleTap2];
    
    BOOL isOutMsg = [self.ofMessage.messageFrom isEqualToString:_Master.mySelf.DDNumber];
    BOOL bHideNickName = YES;
    if(!isOutMsg && self.ofMessage.messageChatID.intValue != 0)
    {
        bHideNickName = ![_HSCore isShowNickOfChatID:self.ofMessage.messageChatID];
    }
    [self.userNickName setHidden:bHideNickName];
    
    if(self.ofMessage.messageType.intValue == kWCMessageTypeImage)
    {
        [self setUploadType:NN(2)];
        [self setUploadUUID:self.ofMessage.uploadUUID];
    }
    
    self.clickLinkURL = @"";
    
    self.bubble.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChatItem:)];
    [self.bubble addGestureRecognizer:singleTap];
    
    CGRect frame;
    if(self.ofMessage.messageType.intValue == kWCMessageTypePlain ||
       self.ofMessage.messageType.intValue == kWCMessageTypeP2PAuthration ||
       self.ofMessage.messageType.intValue == kWCMessageTypeP2PAuthrationOK ||
       self.ofMessage.messageType.intValue == kWCMessageTypeP2PAuthrationReject ||
       self.ofMessage.messageType.intValue == kWCMessageTypeP2PDelete ||
       self.ofMessage.messageType.intValue == kWCMessageTypeP2PRefuse ||
       self.ofMessage.messageType.intValue == kWCMessageTypeSystemNotifyNormal)
    {
        [self.chatImage setHidden:YES];
        [self.btProgress setHidden:YES];
        [self.labelMessage setHidden:NO];
        
        [self.labelMessage setTextColor:[UIColor blackColor]];
        if([Master isSysNotify:self.ofMessage.messageChatID.intValue])
        {
            pList = [self.ofMessage.messageContent componentsSeparatedByString:@"##&##"];
            if(pList.count > 1)
            {
                NSString *clickType = [pList objectAtIndex:0];
                if([clickType isEqualToString:@"URL"])
                {
                    self.labelMessage.text = [pList objectAtIndex:2];
                    [self setClickLinkURL:[pList objectAtIndex:1]];
                    [self.labelMessage setTextColor:[UIColor blueColor]];
                }
                else if([clickType isEqualToString:@"FUN"])
                {
                    self.labelMessage.text = [NSString stringWithFormat:@"%@ - %@ (%@)", [pList objectAtIndex:2], [pList objectAtIndex:3], [pList objectAtIndex:8]];
                    [self.labelMessage setTextColor:[UIColor blueColor]];
                }
                else
                {
                    self.labelMessage.text = [pList objectAtIndex:1];
                }
            }
            else self.labelMessage.text = self.ofMessage.messageContent;
        }
        else
        {
            if (self.ofMessage.messageContent.length == 0) {
                self.labelMessage.text = @"我通过了你的请求 现在我们已经是好友了。";
            }else
            {
            self.labelMessage.text = self.ofMessage.messageContent;
            }
        }
        CGSize contentSize = [CellChatMessage sizeForText:self.labelMessage.text];
        if(isOutMsg)
        {
            [self.bubble setImage:[[UIImage imageNamed:@"SendBubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            //NSLog(@"contentView %f,%f, %f, %f", self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
            [self.userLogo setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE, INSETS, HEAD_SIZE, HEAD_SIZE)];
            
            int wb = 8, hb = 10;
            [self.labelMessage setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE - INSETS - INSETS - 2 - contentSize.width, bHideNickName ? 17 : 32, contentSize.width, contentSize.height)];
            [self.bubble setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE - INSETS - INSETS - contentSize.width - wb - 8, (bHideNickName ? 17 : 32) - hb, contentSize.width + 2 * wb + 14, contentSize.height + 2 * hb + 6)];
            
            frame = self.bubble.frame;
        }
        else
        {
            [self.bubble setImage:[[UIImage imageNamed:@"RecvBubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            [self.userLogo setFrame:CGRectMake(INSETS, INSETS, HEAD_SIZE, HEAD_SIZE)];
            
            int wb = 8, hb = 10;
            [self.labelMessage setFrame:CGRectMake(INSETS + HEAD_SIZE + INSETS + INSETS + 2, bHideNickName ? 17 : 32, contentSize.width, contentSize.height)];
            [self.bubble setFrame:CGRectMake(INSETS + HEAD_SIZE + INSETS - wb, (bHideNickName ? 17 : 32) - hb, contentSize.width + 2 * wb + 14, contentSize.height + 2 * hb + 6)];
        }
    }
    else if(self.ofMessage.messageType.intValue == kWCMessageTypeImage)
    {
        [self.chatImage setHidden:NO];
        [self.btProgress setHidden:YES];
        [self.labelMessage setHidden:YES];
        
        self.chatImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChatImage:)];
        [self.chatImage addGestureRecognizer:tapImage];
        
        CGSize contentSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
        if(isOutMsg)
        {
            [self.bubble setImage:[[UIImage imageNamed:@"SendBubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            //NSLog(@"contentView %f,%f, %f, %f", self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
            [self.userLogo setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE, INSETS, HEAD_SIZE, HEAD_SIZE)];
            
            int wb = 8, hb = 10;
            [self.chatImage setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE - INSETS - INSETS - 2 - contentSize.width, bHideNickName ? 17 : 32, contentSize.width, contentSize.height)];
            [self.btProgress setFrame:self.chatImage.frame];
            [self.bubble setFrame:CGRectMake(self.contentView.frame.size.width - INSETS - HEAD_SIZE - INSETS - INSETS - contentSize.width - wb - 8, (bHideNickName ? 17 : 32) - hb, contentSize.width + 2 * wb + 14, contentSize.height + 2 * hb + 6)];
            
            frame = self.bubble.frame;
            
            switch (self.ofMessage.messageState.intValue)
            {
                case kWCMessageImageReady:
                case kWCMessageImageSending:
                case kWCMessageImageSuccess:
                case kWCMessageImageFailed:
                    [self.btProgress setHidden:NO];
                    [self.chatImage setImage:[UIImage imageNamed:self.ofMessage.bindImagePath]];
                    if(self.ofMessage.messageState.intValue == kWCMessageImageReady)
                    {
                        [self.chatImage setImage:[UIImage imageNamed:self.ofMessage.bindImagePath]];
                        [self uploadImageWithPath:self.ofMessage.bindImagePath];
                    }
                    else if(self.ofMessage.messageState.intValue == kWCMessageImageSuccess)
                    {
                        [self.btProgress setHidden:YES];
                    }
                    else if(self.ofMessage.messageState.intValue == kWCMessageImageFailed)
                    {
                        long long size = [Master fileSizeAtPath:self.ofMessage.bindImagePath];
                        if(size <= 0)
                        {
                            [self.btProgress setTitle:@"图片已过期" forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self.btProgress setTitle:@"点击重试" forState:UIControlStateNormal];
                        }
                        [self.btProgress setHidden:NO];
                    }
                    break;
                    
                default:
                    [self loadChatImage:@"defaultImage" andURL:[MasterURL APIFor:@"chatImage" with:self.ofMessage.messageContent, nil]];
                    break;
            }
        }
        else
        {
            [self.bubble setImage:[[UIImage imageNamed:@"RecvBubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            [self.userLogo setFrame:CGRectMake(INSETS, INSETS, HEAD_SIZE, HEAD_SIZE)];
            
            int wb = 8, hb = 10;
            [self.chatImage setFrame:CGRectMake(INSETS + HEAD_SIZE + INSETS + INSETS + 2, bHideNickName ? 17 : 32, contentSize.width, contentSize.height)];
            [self.bubble setFrame:CGRectMake(INSETS + HEAD_SIZE + INSETS - wb, (bHideNickName ? 17 : 32) - hb, contentSize.width + 2 * wb + 14, contentSize.height + 2 * hb + 6)];
            
            [self loadChatImage:self.ofMessage.messageContent andURL:[MasterURL APIFor:@"chatImage" with:self.ofMessage.messageContent, nil]];
        }
    }
    
    if(isOutMsg)
    {
        switch (self.ofMessage.messageState.intValue)
        {
            case kWCMessageImageFailed:
                [self.sendingIcon setHidden:YES];
                [self.btSendAgain setHidden:YES];
                break;
            case kWCMessageImageSending:
            case kWCMessageImageSuccess:
            case kWCMessageTextSending:
                [self.sendingIcon setHidden:NO];
                [self.btSendAgain setHidden:YES];
                
                frame.origin.x = frame.origin.x - 4 - 20;
                frame.origin.y = frame.origin.y + (frame.size.height - 20) / 2.0 - 2;
                frame.size.width = 20;
                frame.size.height = 20;
                [self.sendingIcon setFrame:frame];
                [self.sendingIcon startAnimating];
                break;
            case kWCMessageTextSuccess:
                [self.sendingIcon setHidden:YES];
                [self.btSendAgain setHidden:YES];
                break;
            case kWCMessageTextFailed:
                [self.sendingIcon setHidden:YES];
                [self.btSendAgain setHidden:NO];
                
                frame.origin.x = frame.origin.x - 4 - 20;
                frame.origin.y = frame.origin.y + (frame.size.height - 20) / 2.0 - 2;
                frame.size.width = 20;
                frame.size.height = 20;
                [self.btSendAgain setFrame:frame];
                break;
                
            default:
                break;
        }
    }
    else
    {
        [self.sendingIcon setHidden:YES];
        [self.btSendAgain setHidden:YES];
    }
}

-(void)uploadImageWithPath:(NSString *)imagePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        NSData *picData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage imageWithData:picData];
        if(image)
        {
            [self uploadImage:image];
        }
    }
}

- (void)uploadImage:(UIImage *)image
{
    if(image == nil) return;
    
    [_Master uploadFile:image withUUID:self.uploadUUID andType:2 andP:[NSString stringWithFormat:@"%d", 0] start:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self.chatImage setImage:[userInfo objectForKey:@"image"]];
            [self.btProgress setTitle:@"%0" forState:UIControlStateNormal];
            [self.btProgress setHidden:NO];
        }
    } progress:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            NSNumber *progress = [userInfo objectForKey:@"progress"];
            [self.btProgress setTitle:[NSString stringWithFormat:@"%d%%", progress.intValue] forState:UIControlStateNormal];
            [self.btProgress setHidden:NO];
        }
    } finish:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self.btProgress setHidden:YES];
            NSDictionary *resDict = [dict objectForKey:@"response"];
            NSString *imageURL = [resDict objectForKey:@"thumbName"];
//            NSLog(@"image url: %@", imageURL);
            int error = [[userInfo objectForKey:@"error"] intValue];
            if(error != 0)
            {
                [self.btProgress setTitle:@"点击重试" forState:UIControlStateNormal];
                [self.btProgress setHidden:NO];
                
                [MasterUtils messageBox:[userInfo objectForKey:@"errorMsg"] withTitle:@"错误" withOkText:@"确定" from:self];
                return;
            }
            
            [self.ofMessage setMessageContent:imageURL];
            [_HSCore updateMessageContentForMessageOfTimeFlag:self.ofMessage.messageTimeFlag and:imageURL];
            [self loadChatImage:self.ofMessage.bindImagePath andURL:[MasterURL APIFor:@"chatImage" with:self.ofMessage.messageContent, nil]];
            
            [_HSCore pushUnSendMsg:self.ofMessage.messageTimeFlag ofChatID:self.ofMessage.messageChatID];
            [_Master reqSendChatMsg:self.ofMessage];
            [glState msgIncrease];
        }
    } error:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self.btProgress setTitle:@"点击重试" forState:UIControlStateNormal];
            [self.btProgress setHidden:NO];
        }
    }];
}

- (IBAction)onBtProgress:(id)sender
{
    NSString *title = self.btProgress.titleLabel.text;
    if(title.length <= 0)
    {
//        NSLog(@"open detail logo to see....");
    }
    else if([title isEqualToString:@"点击重试"])
    {
        [self uploadImageWithPath:self.ofMessage.bindImagePath];
    }
}

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL
{
    if(defaultLog != nil)
    {
        [self.userLogo setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    [self setImageNameString:imgURL]; // save it for fether use, click to view detail image etc.
    
    [self.userLogo setImageURL:[NSURL URLWithString:imgURL]];
}

-(void)loadChatImage:(NSString *)defaultLog andURL:(NSString *)imgURL
{
    if(defaultLog != nil)
    {
        [self.chatImage setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    [self setChatImageString:imgURL]; // save it for fether use, click to view detail image etc.
    
    [self.chatImage setImageURL:[NSURL URLWithString:imgURL]];
}

- (IBAction)onSendAgain:(id)sender
{
//    NSLog(@"resend button click");
    if(self.ofMessage.messageState.intValue != kWCMessageTextFailed) return;
    [_HSCore signMessageState:[self.ofMessage.messageTimeFlag intValue] ofState:0];
    [_HSCore pushUnSendMsg:self.ofMessage.messageTimeFlag ofChatID:self.ofMessage.messageChatID];
    [_Master reqSendChatMsg:[self ofMessage]];
}

@end
