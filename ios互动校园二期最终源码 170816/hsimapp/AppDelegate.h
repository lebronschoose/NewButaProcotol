//
//  AppDelegate.h
//  hsimapp
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager* locationManager;
    Reachability  *hostReach;
}

@property (strong, nonatomic) UIWindow *window;


@end

