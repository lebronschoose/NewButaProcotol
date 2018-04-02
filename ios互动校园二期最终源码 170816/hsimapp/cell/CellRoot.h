//
//  CellRoot.h
//  dyhAutoApp
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellRoot : UITableViewCell
{
    NSMutableArray *regMsgList;
}

-(void)registerMsg:(NSString *)msg;

-(BOOL)bindMsg:(NSString *)msg by:(id)observer;
-(void)onNotifyMsg:(NSNotification *)notification;

@end
