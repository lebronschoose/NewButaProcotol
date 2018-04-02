//
//  CellRoot.m
//  dyhAutoApp
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "CellRoot.h"

@implementation CellRoot

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)registerMsg:(NSString *)msg
{
    CareMsg(msg);
}


-(BOOL)bindMsg:(NSString *)msg by:(id)observer
{
    if(regMsgList == nil)
    {
        regMsgList = [[NSMutableArray alloc] init];
    }
    if([regMsgList containsObject:msg] == YES) return NO;
    
//    NSLog(@"CellRootNotify: %@ - Bind Msg:'%@'", self, msg);
    [regMsgList addObject:msg];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(onNotifyMsg:) name:msg object:nil];
    return YES;
}

-(void)dealloc
{
//    NSLog(@"CellRoot: %@ - dealloc", self);
    for(NSString *msg in regMsgList)
    {
        RemoveMsg(msg);
//        NSLog(@"CellRootNotify: %@ - Remove Msg:'%@'", self, msg);
    }
    [regMsgList removeAllObjects];
}

-(void)onNotifyMsg:(NSNotification *)notification
{
//    NSLog(@"CellRootNotify: %s - deal Msg:'%@'", object_getClassName(self), notification.name);
}

@end
