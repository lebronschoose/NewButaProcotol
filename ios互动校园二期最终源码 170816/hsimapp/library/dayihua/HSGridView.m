//
//  HSGridView.m
//  dyhAutoApp
//
//  Created by apple on 15/9/22.
//  Copyright © 2015年 dayihua. All rights reserved.
//

#import "HSGridView.h"

#define kTagIcon    2000
#define kTagTitle   3000
#define kTagBadge   4000

@interface HSGridView()
{
    int badgeCount[1000];
}

@end
@implementation HSGridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (id)init
{
    self = [super init];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        for(int i = 0; i < 1000; i++)
        {
            badgeCount[i] = 0;
        }
    }
    return self;
}

-(CGFloat)initWithCount:(NSInteger)count delegate:(id<HSGridViewDelegate>)delegate autoHeight:(BOOL)autoHeight
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(delegate == nil)
    {
        NSLog(@"HSGridViewDelegate == nil!!!");
        return 0;
    }
    self.delegate = delegate;
    
    UIEdgeInsets insets = [self.delegate edgeInsets:self];
    CGFloat height = insets.top + insets.bottom;
    if(count > 0)
    {
        int colPerRow = (int)[self.delegate numberOfColumnsOfHSGridView:self];
        CGFloat hGap = [self.delegate horizonalGap:self];
        CGFloat vGap = [self.delegate verticalGap:self];
        
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        // w,h size of icon
        CGFloat w = (width - insets.left - insets.right - (colPerRow - 1) * hGap) / colPerRow;
        CGFloat h = w;
        CGFloat titleYGap = 10.0;
        CGFloat titleXGap = 20.0;
        CGFloat labelHeight = 20.0;
        for (int i = 0; i < count; i++)
        {
            int row = (int)(i / (double)colPerRow);
            int col = i % colPerRow;
            // x,y position of icon
            CGFloat x = insets.left + col * hGap + col * w;
            CGFloat y = insets.top + row * vGap + row * h;
//            NSLog(@"%f grid item: %d %d, (%f, %f)(%f : %f)", width, row, col, x, y, w, h);
            
            UIImageView *e = (UIImageView *)[self viewWithTag:kTagIcon + i];
            if(e == nil)
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.tag = kTagIcon + i;
                imageView.userInteractionEnabled = YES;
                imageView.translatesAutoresizingMaskIntoConstraints = NO;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
                
                [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:w]];
                [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:h]];
                
                [self.delegate hsGridView:self loadImageForItem:imageView index:i];
                [self addSubview:imageView];
            }
            else
            {
                [self.delegate hsGridView:self loadImageForItem:e index:i];
            }
            
            UILabel *l = (UILabel *)[self viewWithTag:kTagTitle + i];
            if(l == nil)
            {
                UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(x - titleXGap, y + h + titleYGap, w + 2 * titleXGap, labelHeight)];
                lableTitle.translatesAutoresizingMaskIntoConstraints = NO;
                [lableTitle setFont:[UIFont systemFontOfSize:14.0]];
                //            [lableTitle setTextAlignment:NSTextAlignmentCenter];
                [lableTitle setTextColor:[UIColor grayColor]];
                lableTitle.tag = kTagTitle + i;
                [self.delegate hsGridView:self loadTitleForItem:lableTitle index:i];
                [self addSubview:lableTitle];
            }
            else
            {
                [self.delegate hsGridView:self loadTitleForItem:l index:i];
            }
            
            UILabel *b = (UILabel *)[self viewWithTag:kTagBadge + i];
            if(b == nil)
            {
                UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x + w, y, 26, 26)];// - titleXGap, y + h + titleYGap, w + 2 * titleXGap, labelHeight)];
                labelTitle.backgroundColor = [UIColor clearColor];
                labelTitle.layer.backgroundColor = [UIColor redColor].CGColor;
                labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
                [labelTitle setFont:[UIFont systemFontOfSize:10.0]];
                [labelTitle setTextAlignment:NSTextAlignmentCenter];
                [labelTitle setTextColor:[UIColor whiteColor]];
                labelTitle.tag = kTagBadge + i;
                labelTitle.text = @"";
                [labelTitle setHidden:YES];
                
                [[labelTitle layer] setMasksToBounds:YES];
                [[labelTitle layer] setCornerRadius:8.0];
                
                [self addSubview:labelTitle];
            }
            else
            {
                [self.delegate hsGridView:self loadTitleForItem:l index:i];
            }
        }
        
        // constraint
        NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
        for (int i = kTagIcon; i < kTagIcon + count; i++)
        {
            NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i - kTagIcon];
            UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
            [viewsDictionary setObject:imageView forKey:imageViewName];
        }
        
        for (int i = kTagTitle; i < kTagTitle + count; i++)
        {
            NSString *titleName = [NSString stringWithFormat:@"gridTitle%d", i - kTagTitle];
            UILabel *title = (UILabel *)[self viewWithTag:i];
            [viewsDictionary setObject:title forKey:titleName];
        }
        
        for (int i = kTagBadge; i < kTagBadge + count; i++)
        {
            NSString *badgeName = [NSString stringWithFormat:@"gridBadge%d", i - kTagBadge];
            UILabel *badge = (UILabel *)[self viewWithTag:i];
            [viewsDictionary setObject:badge forKey:badgeName];
        }
        
        for (int i = 0; i < count; i++)
        {
            NSString *constraintsString = [NSString stringWithFormat:@"V:[imageView%d]-%f-[gridTitle%d]", i, titleYGap, i];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintsString
                                                                         options:NSLayoutFormatAlignAllCenterX
                                                                         metrics:nil
                                                                           views:viewsDictionary]];
          
            UIImageView *icon = (UIImageView *)[self viewWithTag:kTagIcon + i];
            UILabel *badge = (UILabel *)[self viewWithTag:kTagBadge + i];
            CGFloat badgeSize = 16.0;
            NSLayoutConstraint *badgeConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:icon attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-6.0];
            [self addConstraint:badgeConstraint];
            badgeConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:icon attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0];
            [self addConstraint:badgeConstraint];
            
            badgeConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:badgeSize];
            [self addConstraint:badgeConstraint];
            badgeConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:badgeSize];
            [self addConstraint:badgeConstraint];
        }
        
        int rows = (int)(count / (double)colPerRow);
        if(count % colPerRow != 0) rows++;
        height += rows * h;
        height += (rows - 1) * vGap;
        
        NSMutableString *vString = [NSMutableString string];
        [vString appendFormat:@"V:|-%f-", insets.top];
        for (int i = 0; i < rows; i++)
        {
            NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i * colPerRow];
            
            if(i == 0) // no vGap
            {
                [vString appendFormat:@"[%@]", imageViewName];
            }
            else
            {
                [vString appendFormat:@"-%f-[%@]", vGap, imageViewName];
            }
        }
//        [vString appendFormat:@"-%f-|", insets.bottom];
        
//        for (NSLayoutConstraint *c in self.constraints)
//        {
//            NSLog(@"%@", c.description);
//        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vString
                                                                     options:NSLayoutFormatAlignAllLeft
                                                                     metrics:nil
                                                                       views:viewsDictionary]];
        
//        for (NSLayoutConstraint *c in self.constraints)
//        {
//            NSLog(@"%@", c.description);
//        }
        /// horizonal constraint string
        for (int i = 0; i < rows; i++)
        {
            NSMutableString *hString = [NSMutableString string];
            [hString appendFormat:@"H:|-%f-", insets.left];
            int imageViewCount = 0;
            for(int j = 0; j < colPerRow; j++)
            {
                if(i * colPerRow + j >= count) break;
                imageViewCount++;
                NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i * colPerRow + j];
                
                if(j == 0) // no vGap
                {
                    [hString appendFormat:@"[%@]", imageViewName];
                }
                else
                {
                    [hString appendFormat:@"-%f-[%@]", hGap, imageViewName];
                }
            }
//            [hString appendFormat:@"-%f-|", insets.right];
            if(imageViewCount != 0)
            {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hString
                                                                             options:NSLayoutFormatAlignAllTop
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
            }
        }
        // the label text height
        height += (rows - 1) * (titleYGap + labelHeight);
    }
    
    if(autoHeight)
    {
        for (NSLayoutConstraint* constraint in self.constraints)
        {
            if (constraint.firstAttribute == NSLayoutAttributeHeight)
            {
                // 调整hsImageScrollView的高度，否则width不是320到时候会变形
                constraint.constant = height;
                CGRect frame = self.frame;
                frame.size.height = constraint.constant;
                [self setFrame:frame];
                break;
            }
        }
    }
    return height;
}

- (void)setBadgeCount:(int)count forItem:(int)index
{
    UILabel *badge = (UILabel *)[self viewWithTag:kTagBadge + index];
    
    if(count <= 0)
    {
        [badge setText:@""];
        [badge setHidden:YES];
    }
    else if(count >= 100)
    {
        [badge setText:@"..."];
        [badge setHidden:NO];
    }
    else
    {
        [badge setText:[NSString stringWithFormat:@"%d", count]];
        [badge setHidden:NO];
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger index = imageView.tag - kTagIcon;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsGridView:didTapAtIndex:)])
    {
        
        [self.delegate hsGridView:self didTapAtIndex:index];
    }
}

@end
