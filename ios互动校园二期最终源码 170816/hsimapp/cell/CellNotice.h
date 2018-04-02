//
//  CellNotice.h
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellNotice;
@protocol CellNoticeDelegate <NSObject>
@required
- (void)updateCell:(CellNotice *)cell height:(CGFloat)height ofIndexPath:(NSIndexPath *)indexPath;
@end

@interface CellNotice : UITableViewCell
@property (nonatomic, assign) id<CellNoticeDelegate>delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelViews;

@end
