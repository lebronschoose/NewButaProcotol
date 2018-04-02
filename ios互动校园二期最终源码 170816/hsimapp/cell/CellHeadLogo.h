//
//  CellHeadLogo.h
//  dyhAutoApp
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "CellRoot.h"
#import "CellHeadLogo.h"
#import "EGOImageView.h"

@interface CellHeadLogo : CellRoot<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btSetLogo;
@property (weak, nonatomic) IBOutlet EGOImageView *theLogo;
@property (weak, nonatomic) IBOutlet UIButton *btProgress;

@property (retain, nonatomic) NSString *uploadUUID; // 用来根upload的request对接， ‘0’:自己的头像，‘r’开头，其他图片，
@property (retain, nonatomic) NSNumber *uploadType; // 1 : 用户头像 2 ： 聊天图片
@property (retain, nonatomic) id param; // 群号，当type＝4时

@property (weak, nonatomic) RootViewController *parent;
@property (retain, nonatomic) UIPopoverController *thePopoverController;
- (IBAction)onBtProgress:(id)sender;
- (IBAction)onBtSetLogo:(id)sender;

@property (retain, nonatomic) NSString *imageNameString;

-(void)setUserLogo;
-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL;

@end
