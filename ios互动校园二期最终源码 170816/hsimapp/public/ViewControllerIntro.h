//
//  ViewControllerIntro.h
//  dyhAutoApp
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RootViewController.h"
#import "HSImageScrollView.h"

@interface ViewControllerIntro : UIViewController

@property (nonatomic, assign) BOOL bAutoMode;

@property (weak, nonatomic) IBOutlet HSImageScrollView *hsImageScrollView;

@end
