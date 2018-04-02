//
//  CellNotice.m
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "CellNotice.h"

@implementation CellNotice

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    roundIt(self.backView);
    roundIt(self.webView);
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        // 方法一
        CGFloat webViewHeight = [self.webView sizeThatFits:CGSizeZero].height;
        
        // 方法二
//        CGFloat webViewHeight = self.webView.scrollView.contentSize.height;
//        
//        // 方法三 （不推荐使用，当webView.scalesPageToFit = YES计算的高度不准确）
//        CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        
        
        if(self.webView.frame.size.height != webViewHeight)
        {
            if(self.indexPath && self.delegate && [self.delegate respondsToSelector:@selector(updateCell:height:ofIndexPath:)])
            {
                [self.delegate updateCell:self height:webViewHeight ofIndexPath:self.indexPath];
            }
        }
    }
}

- (void)dealloc
{
//    NSLog(@"%@ dealloc", self);
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
