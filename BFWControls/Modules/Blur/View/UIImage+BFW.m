//
//  UIImage+BFW.m
//
//  Created by Tom Brodhurst-Hill on 5/03/12.
//  Copyright (c) 2012 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

#import "UIImage+BFW.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (BFW)

/// Adapted from http://iphonedevelopertips.com/cocoa/how-to-mask-an-image.html
- (UIImage*)maskWithImage:(UIImage*)maskImage
{
	CGImageRef maskRef = maskImage.CGImage; 
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([self CGImage], mask);
	return [UIImage imageWithCGImage:masked];
}

+ (UIImage*)imageOfView:(UIView*)view
                   size:(CGSize)size
{
	BOOL isOpaque = NO;
	CGFloat scale = [[UIScreen mainScreen] scale];
	UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
