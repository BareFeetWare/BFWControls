//
//  UIImage+BFW.h
//
//  Created by Tom Brodhurst-Hill on 5/03/12.
//  Copyright (c) 2012 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

#import <UIKit/UIKit.h>

@interface UIImage (BFW)

- (UIImage*)maskWithImage:(UIImage*)maskImage;
+ (UIImage*)imageOfView:(UIView*)view size:(CGSize)size;

@end
