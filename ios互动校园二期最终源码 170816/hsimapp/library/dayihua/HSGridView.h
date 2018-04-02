//
//  HSGridView.h
//  dyhAutoApp
//
//  Created by apple on 15/9/22.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSGridViewDelegate;

@interface HSGridView : UIView

@property (nonatomic, assign) id<HSGridViewDelegate>delegate;

- (void)setBadgeCount:(int)count forItem:(int)index;

-(CGFloat)initWithCount:(NSInteger)count delegate:(id<HSGridViewDelegate>)delegate autoHeight:(BOOL)autoHeight;

@end

@protocol HSGridViewDelegate <NSObject>

@required
/**
 *  Init imageview
 *
 *  @param hsImageScrollView HSImageScrollView object
 *  @param imageView       UIImageView object
 *  @param index           index of imageview
 */
- (void)hsGridView:(HSGridView *)hsGridView loadImageForItem:(UIImageView *)imageView index:(NSInteger)index;
- (void)hsGridView:(HSGridView *)hsGridView loadTitleForItem:(UILabel *)labelTitle index:(NSInteger)index;

/**
 *
 */
- (NSInteger)numberOfColumnsOfHSGridView:(HSGridView *)hsGridView;
- (UIEdgeInsets)edgeInsets:(HSGridView *)hsGridView;
- (CGFloat)horizonalGap:(HSGridView *)hsGridView;
- (CGFloat)verticalGap:(HSGridView *)hsGridView;

@optional
/**
 *  Tap ImageView action
 *
 *  @param hsImageScrollView HSImageScrollView object
 *  @param index           index of imageview
 */
- (void)hsGridView:(HSGridView *)hsGridView didTapAtIndex:(NSInteger)index;

@end