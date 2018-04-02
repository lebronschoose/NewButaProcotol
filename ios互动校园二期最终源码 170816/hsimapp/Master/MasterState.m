//
//  MasterState.m
//  dyhAutoApp
//
//  Created by apple on 15/5/29.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "MasterState.h"

@interface MasterState()
{
    enum    MAINSTATE mainState;
    NSMutableArray *listViewController;
}
@end

@implementation MasterState

static MasterState *sharedInstance;

/**
 * The runtime sends initialize to each class in a program exactly one time just before the class,
 * or any class that inherits from it, is sent its first message from within the program. (Thus the
 * method may never be invoked if the class is not used.) The runtime sends the initialize message to
 * classes in a thread-safe manner. Superclasses receive this message before their subclasses.
 *
 * This method may also be called directly (assumably by accident), hence the safety mechanism.
 **/
+(void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        
        sharedInstance = [[MasterState alloc] init];
    }
}

+(MasterState *)sharedInstance
{
    return sharedInstance;
}

-(id)init
{
    if (sharedInstance != nil)
    {
        return nil;
    }
    
    if ((self = [super init]))
    {
        [self setIsNetWorkOK:NO];
        
        [self setMainState:emStateNone];
        [self setDestServer:LOGIN];
        [self setIsFirstTimeLoginIMServer:YES];
        [self setPermitPlayMsgSound:YES];
        [self setPushDetail:YES];
        [self setMsgUnConfirm:100];
        [self setWithLoginView:NO];
        
        listViewController = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setMainState:(enum MAINSTATE)state
{
    NSArray *stateStr = @[@"emStateNone", @"emStateHasLogin", @"emStateHasEnterIM"];
    mainState = state;
    NSLog(@"--- 转换场景到 %d - %@： %@", state, [stateStr objectAtIndex:state], [NSThread callStackSymbols]);
}

- (enum MAINSTATE)mainState
{
    return mainState;
}

-(void)push1ViewController:(id)vc
{
    [listViewController addObject:vc];
}

-(void)pop1ViewController:(id)vc
{
    [listViewController removeObject:vc];
}

-(void)dumpViewController
{
    NSLog(@"--------------------------------------------");
    int nCount = 0;
    for(id vc in listViewController)
    {
        nCount++;
        NSLog(@"%d - %@", nCount, vc);
    }
    NSLog(@"--------------------------------------------");
}

-(void)msgIncrease
{
    [self setMsgUnConfirm:self.msgUnConfirm + 1];
}

-(void)msgDecrease
{
    [self setMsgUnConfirm:self.msgUnConfirm - 1];
}

-(void)msgClear
{
    [self setMsgUnConfirm:0];
}


@end
