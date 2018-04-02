//
//  HSImageScrollView.h
//  dyhAutoApp
//
//  Created by apple on 15/9/22.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICPageControlPosition)
{
    ICPageControlPosition_TopLeft,
    ICPageControlPosition_TopCenter,
    ICPageControlPosition_TopRight,
    ICPageControlPosition_BottomLeft,
    ICPageControlPosition_BottomCenter,
    ICPageControlPosition_BottomRight
};

@protocol HSImageScrollViewDelegate;

@interface HSImageScrollView : UIView
@property (nonatomic, assign) id<HSImageScrollViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoScroll;  // default is YES, set NO to turn off autoScroll
@property (nonatomic, assign) NSUInteger scrollInterval;    // scroll interval, unit: second, default is 2 seconds
@property (nonatomic, assign) ICPageControlPosition pageControlPosition;    // pageControl position, defautl is bottomright
@property (nonatomic, assign) BOOL hidePageControl; // hide pageControl, default is NO

/**
 *  Init image player
 *
 *  @param imageURLs   NSURL array, image path
 *  @param placeholder placeholder image
 *  @param delegate    delegate
 *  @deprecated use - (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate instead
 */
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<HSImageScrollViewDelegate>)delegate DEPRECATED_ATTRIBUTE;

/**
 *  Init image player
 *
 *  @param imageURLs   NSURL array, image path
 *  @param placeholder placeholder image
 *  @param delegate    delegate
 *  @param edgeInsets  scroll view edgeInsets
 *  @deprecated use - (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets instead
 */
- (void)initWithImageURLs:(NSArray *)imageURLs placeholder:(UIImage *)placeholder delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets DEPRECATED_ATTRIBUTE;

/**
 *  Init image player
 *
 *  @param count
 *  @param delegate
 */
- (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate;

/**
 *  Init image player
 *
 *  @param count
 *  @param delegate
 *  @param edgeInsets scroll view edgeInsets
 */
- (void)initWithCount:(NSInteger)count delegate:(id<HSImageScrollViewDelegate>)delegate edgeInsets:(UIEdgeInsets)edgeInsets;
@end

@protocol HSImageScrollViewDelegate <NSObject>

@required
/**
 *  Init imageview
 *
 *  @param hsImageScrollView HSImageScrollView object
 *  @param imageView       UIImageView object
 *  @param index           index of imageview
 */
- (NSString *)hsImageScrollView:(HSImageScrollView *)hsImageScrollView imageForItemAtIndex:(NSInteger)index;

@optional
/**
 *  Tap ImageView action
 *
 *  @param hsImageScrollView HSImageScrollView object
 *  @param index           index of imageview
 *  @param imageURL        image url
 *  @deprecated use - (void)hsImageScrollView:(HSImageScrollView *)hsImageScrollView didTapAtIndex:(NSInteger)index instead
 */
- (void)hsImageScrollView:(HSImageScrollView *)hsImageScrollView didTapAtIndex:(NSInteger)index imageURL:(NSURL *)imageURL DEPRECATED_ATTRIBUTE;

/**
 *  Tap ImageView action
 *
 *  @param hsImageScrollView HSImageScrollView object
 *  @param index           index of imageview
 */
- (void)hsImageScrollView:(HSImageScrollView *)hsImageScrollView didTapAtIndex:(NSInteger)index;
@end

