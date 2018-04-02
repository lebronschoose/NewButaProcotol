//
//  RootViewController.h
//  dyhAutoApp
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define fitIOS7             if(isIOS7)\
{\
self.navigationController.navigationBar.translucent = NO;\
}

@interface RootViewController : UIViewController
{
    NSMutableArray *regMsgList;
    
    UIView *viewTip;
    UILabel *labelMessage;
    
    UIView *waitingCover;
    UIActivityIndicatorView* waitingIndicator;
    NSTimer *waitingTimer;
}

@property(nonatomic, retain) id transObj;

@property(nonatomic, retain) NSString *waitingTag;
@property(nonatomic, retain) NSString *pickerFlag;

- (void)showSegueWithObject:(id)transObj Identifier:(NSString *)identifier;

- (void)startWaiting:(double)elapse forTag:(NSString *)tag;
- (void)stopWaiting;
- (IBAction)waitingEnd:(id)sender;

- (void)ignoreMsg:(NSString *)msg;
- (BOOL)bindMsg:(NSString *)msg by:(id)observer;
- (void)onNotifyMsg:(NSNotification *)notification;

- (void)onHideTip;
- (void)startMiddlePicker:(NSString *)flag ofTitle:(NSString *)title andFinish:(NSString *)finishTitle;
- (void)startBottomPicker:(NSString *)flag ofTitle:(NSString *)title andFinish:(NSString *)finishTitle;

- (void)showMessage:(NSString *)message;
- (void)showCloseMessage:(NSString *)message andDelay:(float)seconds;
- (void)showBlockMessage:(NSString *)message delay:(float)seconds andThen:(void(^)())blockThen;
- (void)showTipText:(NSString *)text title:(NSString *)title size:(CGFloat)size;
- (void)showTipText:(NSString *)text title:(NSString *)title size:(CGFloat)size align:(NSTextAlignment)align color:(UIColor *)color;
- (void)showTipImage:(NSString *)image title:(NSString *)title;
- (void)showTipWebImage:(NSString *)imageUrl title:(NSString *)title;
- (void)showTipWeb:(NSString *)url title:(NSString *)title;
- (void)showTipWebString:(NSString *)htmlString title:(NSString *)title;

- (void)startPickItem;
- (void)endPickItem;
- (void)reloadPicker;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)setSelectRow:(NSInteger)index InComponent:(NSInteger)component;

- (void)runAPI:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess;
- (void)PostAPI:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess;

@end
