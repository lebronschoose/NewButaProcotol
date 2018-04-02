//
//  AppDelegate.m
//  hsimapp
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerIntro.h"
#import "ViewControllerLogin.h"
#import "KeyCenter.h"
#import <AgoraSignalKit/AgoraSignalKit.h>

@interface AppDelegate ()<UIApplicationDelegate, CLLocationManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        UINavigationBar *bar = [UINavigationBar appearance];
        //设置显示的颜色
        UIColor *color = MAINDEEPCOLOR;//[UIColor colorWithRed:237/255.0 green:112/255.0 blue:23/255.0 alpha:1.0];
        bar.barTintColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
        bar.barTintColor = MAINCOLOR;
        //设置字体颜色
        bar.tintColor = [UIColor whiteColor];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //或者用这个都行
        //    [bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
        
        //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0]];
        
        UIColor *selColor = color;//[UIColor colorWithRed:0/255.0 green:180/255.0 blue:47/255.0 alpha:1.0];
        [[UITabBar appearance] setTintColor:selColor];
        UIColor *selTextColor = color;//[UIColor colorWithRed:0/255.0 green:140/255.0 blue:47/255.0 alpha:1.0];
        [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: selTextColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        //[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//         [WXApi registerApp:MXWechatAPPID withDescription:@"微信支付"];
        AgoraAPI *signalEngine = [AgoraAPI getInstanceWithoutMedia:[KeyCenter appId]];
        signalEngine.onLog = ^(NSString *txt){
            NSLog(@"%@", txt);
    };

//    if ([_HSData getObjectById:@"firstLaunch"] == nil)
//    {
//        [_Master getServerInfo];
////        NSLog(@"第一次启动");
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ViewControllerIntro * vc = [story instantiateViewControllerWithIdentifier:@"ViewControllerIntro"];
//        [vc setBAutoMode:YES];
//        self.window.rootViewController = vc;
//
//        [_HSData putObject:[NSDictionary dictionaryWithObjectsAndKeys:@"first", @"first", nil] withId:@"firstLaunch"];
//    }
//    else
//    {
//
//        NSString *loginIP = [HSAppData getNewLoginServerIP];
////        NSLog(@"loginIP is %@",loginIP);
//        if(loginIP == nil || loginIP.length <= 0)
//        {
//            [_Master getServerInfo];
//
            ViewControllerLogin *vcLogin = [story instantiateViewControllerWithIdentifier:@"ViewControllerLogin"];
            self.window.rootViewController = vcLogin;
//
//        }
//        else
//        {
//            NSString *checkcode = [HSAppData getCheckCode];
//            if(checkcode == nil || checkcode.length <= 0)
//            {
//                ViewControllerLogin *vcLogin = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLogin"];
//                self.window.rootViewController = vcLogin;
//            }
//            else
//            {
//                [_Master reloadOffline];
//                [glState setDestServer:IM];
//                [glState setMainState:emStateHasLogin];
//                [_Master reqLoginIM];
//            }
//        }
//    }
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [glState setLastActiveTime:[NSDate dateWithTimeIntervalSince1970:0]];
    [_Master disconnectIMServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [_Master reqResetBadgeOnServer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark APNS zone

//每次唤醒
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Did Become Active");
    //每次醒来都需要去判断是否得到device token
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    //hide the badge
    NSLog(@"the badge number is  %ld",  (long)[[UIApplication sharedApplication] applicationIconBadgeNumber]);
    NSLog(@"the application  badge number is  %ld",  (long)application.applicationIconBadgeNumber);
    //application.applicationIconBadgeNumber += 1;
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
}

#pragma mark -
#pragma mark - Getting Device token for Notification support
//向服务器申请发送token 判断事前有没有发送过
- (void)registerForRemoteNotificationToGetToken
{
    //注册Device Token, 需要注册remote notification
    if(glState.deviceToken == nil)   //如果没有注册到令牌 则重新发送注册请求
    {
        NSLog(@"Registering for push notifications...");
        // IOS8 新系统需要使用新的代码咯
        if(isIOS8)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil]];
            
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            //这里还是原来的代码
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
        
    }
}


//允许的话 自动回调的函数
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //将device token转换为字符串
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    //modify the token, remove the  "<, >"
    NSLog(@"deviceTokenStr  lentgh:  %lu  ->%@", (unsigned long)[deviceTokenStr length], [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)]);
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    NSLog(@"deviceTokenStr = %@", deviceTokenStr);
    
    NSString *str = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [glState setDeviceToken:str];
    NSLog(@"Device Token=%@", str);
    [_Master reqUploadDeviceToken];
}

//获取远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}


/// location

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%f 纬度:%f", newLocation.coordinate.longitude, newLocation.coordinate.latitude]);
//    [_Master setLocationLon:newLocation.coordinate.longitude];
//    [_Master setLocationLat:newLocation.coordinate.latitude];
    //    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    //     {
    //         for (CLPlacemark * placemark in placemarks)
    //         {
    //             NSDictionary *test = [placemark addressDictionary];
    //             // ZNLog(@"=======%@------", test)
    //             // _localLbel.text =  [test objectForKey:@"City"];
    //
    //             NSString *locationProvince = [test objectForKey:@"State"];
    //             NSString *locationCity = [test objectForKey:@"City"];//[self getCityName:[test objectForKey:@"City"]];
    //             if(locationCity != nil)
    //             {
    //                 NSLog(@"定位:%@, %@", locationProvince, locationCity);
    //                 [_Master saveProvince:locationProvince];
    //                 [_Master saveCity:locationCity];
    //                 PostMessage(hsMsgNewLocation, nil);
    //             }
    //         }
    //     }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if(isIOS8)
            {
                if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
                {
                    [locationManager requestWhenInUseAuthorization];
                }
            }
            break;
        default:
            
            break;
    }
}

-(void)startLocation
{
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        if(isIOS8)
        {
            [locationManager requestAlwaysAuthorization];
        }
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}


@end
