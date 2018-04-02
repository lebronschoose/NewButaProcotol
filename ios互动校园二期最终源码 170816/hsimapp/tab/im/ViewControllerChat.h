//
//  ViewControllerChat.h
//  dyhAutoApp
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface ViewControllerChat : RootViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UIPopoverControllerDelegate>
{
    BOOL firstTime, nibHasLoadCellChatMsg;
}
@property (retain, nonatomic) UIPopoverController *thePopoverController;

@property (nonatomic, retain) HSUserObject *ofTarget;

@property (nonatomic, retain) NSMutableArray *msgRecords;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputToolBarView;
@property (weak, nonatomic) IBOutlet UITextField *inputMsgText;

@property (weak, nonatomic) IBOutlet UIView *mediaView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet UIImageView *mediaLocation;

//@property (weak, nonatomic) IBOutlet UIView *inputToolBarView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UITextField *inputMsgText;


- (IBAction)onSwitchVoice:(id)sender;
- (IBAction)onInputEmotion:(id)sender;
- (IBAction)onSelectMedia:(id)sender;

@end