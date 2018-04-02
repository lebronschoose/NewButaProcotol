//
//  EGOImageView.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <CommonCrypto/CommonDigest.h>
#import "EGOImageView.h"
#import "EGOImageLoader.h"
#import "EGOCache.h"

@implementation EGOImageView
@synthesize imageURL, placeholderImage, delegate;

- (id)initWithPlaceholderImage:(UIImage*)anImage
{
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate
{
	if((self = [super initWithImage:anImage]))
    {
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
	}
	
	return self;
}

-(void)setDefaultImage:(NSString *)defaultImage
{
    if(defaultImage == nil) return;
    
    UIImage *image = [UIImage imageNamed:defaultImage];
    [self setPlaceholderImage:image];
    [self setImage:[UIImage imageNamed:defaultImage]];
}

+(void)removeCacheForURL:(NSURL *)aURL
{
    [[EGOImageLoader sharedImageLoader] clearCacheForURL:aURL];
}

-(NSString *)cachePathForURL:(NSURL *)aURL
{
    return [[EGOImageLoader sharedImageLoader] getCachePathForURL:aURL];
}

- (void)setImageURL:(NSURL *)aURL
{
    if(imageURL)
    {
        [[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
        [imageURL release];
        imageURL = nil;
    }
    
    if(!aURL)
    {
        self.image = self.placeholderImage;
        imageURL = nil;
        return;
    }
    NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?r=%d", aURL.absoluteString, arc4random() % 10000]];
    imageURL = [newURL retain];
    //else
    //{
    //    imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?r=%d", aURL.absoluteString, arc4random() % 10000]];// [aURL retain];
    //}
    
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
    UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:newURL shouldLoadWithObserver:self];
    
    if(anImage)
    {
        self.image = anImage;
        
        // trigger the delegate callback if the image was found in the cache
        if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
        {
            [self.delegate imageViewLoadedImage:self];
            
        }
    }
    else
    {
        self.image = self.placeholderImage;
    }
}
/*
- (void)setImageURL:(NSURL *)aURL
{
	if(imageURL)
    {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	if(!aURL)
    {
		self.image = self.placeholderImage;
		imageURL = nil;
		return;
	}
    else
    {
		imageURL = [aURL retain];
	}

	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
	if(anImage)
    {
		self.image = anImage;
      
		// trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
        {
			[self.delegate imageViewLoadedImage:self];
          
		}
	}
    else
    {
		self.image = self.placeholderImage;
	}
}*/

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad
{
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

-(void)imageLoaderProgress:(NSNotification *)notification
{
    self.bytesReceived = [[notification userInfo] objectForKey:@"received"];
    if(self.bytesReceived == nil) return;
    
    NSNotification* notification2 = [NSNotification notificationWithName:msgEGOImageLoadProgress
                                                                 object:self
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification2 waitUntilDone:YES];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;

	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
	self.image = anImage;
	[self setNeedsDisplay];
 	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
    {
		[self.delegate imageViewLoadedImage:self];
	}
    
    [self setBytesReceived:[NSNumber numberWithLongLong:0]];
    NSNotification* notification2 = [NSNotification notificationWithName:msgEGOImageLoadProgress
                                                                  object:self
                                                                userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification2 waitUntilDone:YES];
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)])
    {
		[self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
    }
    
    [self setBytesReceived:[NSNumber numberWithLongLong:0]];
    NSNotification* notification2 = [NSNotification notificationWithName:msgEGOImageLoadProgress
                                                                  object:self
                                                                userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification2 waitUntilDone:YES];
}

#pragma mark -
- (void)dealloc
{
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.delegate = nil;
	self.imageURL = nil;
	self.placeholderImage = nil;
    [super dealloc];
}

@end
