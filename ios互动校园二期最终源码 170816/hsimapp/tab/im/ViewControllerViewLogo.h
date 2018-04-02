//
//  ViewControllerViewLogo.h
//  dyhAutoApp
//
//  Created by apple on 15/6/27.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "EGOImageView.h"

@interface ViewControllerViewLogo : RootViewController

@property(retain, nonatomic) id param;
@property (weak, nonatomic) IBOutlet EGOImageView *theLogo;
@property (weak, nonatomic) IBOutlet UILabel *lableBytes;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@end
