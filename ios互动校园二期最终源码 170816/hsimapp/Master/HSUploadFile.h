//
//  HSUploadFile.h
//  hsimapp
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol HSUploadFileDelegate <NSObject>

@required
- (void)onUploadStart:(NSString *)name;
- (void)onUploading:(NSString *)name;
- (void)onUploadFinish:(NSString *)name;
- (void)onUploadError;

// for debug
- (void)devicePowerOnSignal:(NSString *)name;
- (void)devicePowerOffSignal:(NSString *)name;

// about node state
- (void)deviceStateChangedDistance:(NSString *)name;
- (void)deviceStateChangedBridge:(NSString *)name;
- (void)deviceNameUpdatedAtIndex:(NSInteger)index;

// about device state
- (void)deviceStateChangedLight:(NSInteger)index;
- (void)deviceStateChangedPower:(NSDictionary *)dict;
// of outlet device
- (void)deviceStateChangedCDS:(NSString *)name;

- (void)devicesChanged;
@end


@interface HSUploadFile : NSObject

@end
