//
//  UIView+BFW.h
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BFW)

- (NSBundle *)bundle;
- (UIView *)viewFromNib;
- (UIView *)subviewMatchingView:(UIView *)view;
- (UIView *)copyWithoutSubviews;
- (UIView *)copyWithSubviews:(NSArray *)subviews;
- (void)copyConstraintsFromView:(UIView *)view;
- (void)copySubviews:(NSArray *)subviews;
- (void)copyPropertiesFromView:(UIView *)view;
- (void)copyAnimatablePropertiesFromView:(UIView *)fromView;

@end
