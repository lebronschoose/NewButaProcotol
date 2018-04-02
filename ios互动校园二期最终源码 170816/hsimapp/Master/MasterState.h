//
//  MasterState.h
//  dyhAutoApp
//
//  Created by apple on 15/5/29.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MAINSTATE
{
    emStateNone         = 0,
    emStateHasLogin     = 1,
    emStateHasEnterIM   = 2,
};

@interface MasterState : NSObject

@property(nonatomic, assign)BOOL    isNetWorkOK;
@property(nonatomic, assign)int     msgUnConfirm;
@property(nonatomic, assign)int     destServer;
@property(nonatomic, assign)BOOL    isFirstTimeLoginIMServer;
@property(nonatomic, assign)BOOL    permitPlayMsgSound;
@property(nonatomic, assign)BOOL    pushDetail;
@property(assign, nonatomic)BOOL    withLoginView;

@property(nonatomic, retain)NSString    *deviceToken;
@property(nonatomic, retain)NSDate      *lastActiveTime;

+(MasterState *)sharedInstance;

- (void)setMainState:(enum MAINSTATE)state;
- (enum MAINSTATE)mainState;

- (void)msgIncrease;
- (void)msgDecrease;
- (void)msgClear;


- (void)push1ViewController:(id)vc;
- (void)pop1ViewController:(id)vc;
- (void)dumpViewController;

@end
