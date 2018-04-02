//
//  CellHeadLogo.m
//  dyhAutoApp
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "CellHeadLogo.h"
#import "MasterURL.h"
#import "EGOCache.h"

@interface CellHeadLogo()
{
    UIImage *selectedImage;
}
@end

@implementation CellHeadLogo

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self.theLogo.layer setMasksToBounds:YES];
    [self.theLogo.layer setCornerRadius:5.0];//self.theLogo.frame.size.height / 8.0];
    
    self.theLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewLogo:)];
    [self.theLogo addGestureRecognizer:singleTap];
    
    [self.btProgress.layer setMasksToBounds:YES];
    [self.btProgress.layer setCornerRadius:5.0];//self.btProgress.frame.size.height / 8.0];
    
//    [self.btSetLogo.layer setMasksToBounds:YES];
//    [self.btSetLogo.layer setCornerRadius:4.0];//self.btSetLogo.frame.size.height / 2.0];
    
    self.btSetLogo.hidden = YES;
    
    [self hideButton];
    [self setUploadUUID:@"0"];
    
}

-(void)onViewLogo:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"view logo...");
//    HSUserObject *aUser = self.param;
//    [self.parent showSegueWithObject:aUser.DDNumber Identifier:@"showViewLogo"];
     [self setUserLogo];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hideButton
{
//    [self.btSetLogo setHidden:NO];
    [self.btProgress setTitle:@"" forState:UIControlStateNormal];
    [self.btProgress setHidden:YES];
    //[self.btProgress setAlpha:0];
}

-(void)showButton
{
//    [self.btSetLogo setHidden:YES];
//    //[self.btProgress setAlpha:0.65];
    [self.btProgress setHidden:NO];
}

-(void)loadImage:(NSString *)defaultLog andURL:(NSString *)imgURL
{
    if(defaultLog != nil)
    {
        [self.theLogo setDefaultImage:defaultLog];
    }
    if(imgURL == nil) return;
    [self setImageNameString:imgURL]; // save it for fether use, click to view detail image etc.
    
    [self.theLogo setImageURL:[NSURL URLWithString:imgURL]];
}

-(void)loadImageByImage:(UIImage *)image andURL:(NSString *)imgURL
{
    if(image != nil)
    {
        [self.theLogo setImage:image];
    }
    if(imgURL == nil) return;
    [self setImageNameString:imgURL]; // save it for fether use, click to view detail image etc.
//    NSLog(@"[NSURL URLWithString:imgURL] is %@",[NSURL URLWithString:imgURL]);
    [self.theLogo setImageURL:[NSURL URLWithString:imgURL]];
}

-(void)setUserLogo
{
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"设置头像" delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:@"拍照"
                                        otherButtonTitles:@"从相册中选择",
                       nil];
    [as showInView:self.parent.view];
}

- (IBAction)onBtSetLogo:(id)sender
{
    [self setUserLogo];
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
            [self.parent.navigationController presentViewController:imgPicker animated:YES completion:^{
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
                    [self.parent presentViewController:m_imagePicker animated:YES completion:nil];
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
                    
                    [self.thePopoverController presentPopoverFromRect:CGRectMake(0, 0, 500, 300) inView:self.parent.
                     view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!"
                                                                  delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                }
                /*
                 // We are using an iPad
                 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                 imagePickerController.delegate = self;
                 UIPopoverController *popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                 popoverController.delegate = self;
                 [popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
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
        [self.parent.navigationController dismissViewControllerAnimated:YES completion:^{
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
    
    selectedImage = image;
    
    [self uploadImage:selectedImage];
}

- (void)uploadImage:(UIImage *)image
{
    if(image == nil) return;
    
    [_Master uploadFile:image withUUID:@"0" andType:1 andP:_Master.mySelf.DDNumber start:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self.theLogo setImage:[userInfo objectForKey:@"image"]];
            [self.btProgress setTitle:@"%0" forState:UIControlStateNormal];
            [self showButton];
        }
    } progress:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            NSProgress *uploadProgress = [dict objectForKey:@"progress"];
            NSString *title = [NSString stringWithFormat:@"%.1f%%", (float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount * 100];
            //        NSString *title = [NSString stringWithFormat:@"%lld/%lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount];
            [self.btProgress setTitle:title forState:UIControlStateNormal];
            [self showButton];
        }
    } finish:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self hideButton];
            NSDictionary *resDict = [dict objectForKey:@"response"];
//            NSString *imageURL = [resDict objectForKey:@"thumbName"];
//            NSString * NewString;
//            if ([imageURL hasPrefix:@"."]) {
//                NewString = [imageURL substringWithRange:NSMakeRange(0, 1)];
//            }else
//            {
//                NewString = imageURL;
//            }
//            NSLog(@"image url: %@", [MasterURL urlOfUserLogo:_Master.mySelf.DDNumber]);
            
            
            int error = [[resDict objectForKey:@"error"] intValue];
            if(error != 0)
            {
                [MasterUtils messageBox:[resDict objectForKey:@"errorMsg"] withTitle:@"错误" withOkText:@"确定" from:self];
                return;
            }
             
//            [Master removeLogoFor:nil];
            [self loadImageByImage:[userInfo objectForKey:@"image"] andURL:[MasterURL urlOfUserLogo:_Master.mySelf.DDNumber]];
            [_Master reqUpdateUserText:@"" ofType:0];
            PostMessage(hsNotificationSelfDataReceived, nil);
        }
    } error:^(NSDictionary *dict) {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        NSString *uuid = [userInfo objectForKey:@"uploadUUID"];
        if([uuid isEqualToString:self.uploadUUID])
        {
            [self.btProgress setTitle:@"点击重试" forState:UIControlStateNormal];
            [self showButton];
            [self.btSetLogo setHidden:NO];
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
        [self uploadImage:selectedImage];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.parent.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
        else
        {
            [self.thePopoverController dismissPopoverAnimated:YES];
        }
    }
    else
    {
        [self.parent.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
