//
//  UIView+BFWCopy.h
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BFWCopy)

- (NSBundle *)bundle;
- (CGSize)sizeFromNib;
- (UIView *)viewFromNib;
- (UIView *)subviewMatchingView:(UIView *)view;
- (UIView *)copyWithSubviews:(NSArray *)subviews
          includeConstraints:(BOOL)includeConstraints;
- (void)copySubviews:(NSArray *)subviews
  includeConstraints:(BOOL)includeConstraints;
- (void)copyConstraintsFromView:(UIView *)view;
- (void)copyPropertiesFromView:(UIView *)view;
- (void)copyAnimatablePropertiesFromView:(UIView *)fromView;

@end
