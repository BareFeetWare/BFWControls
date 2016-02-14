//
//  UIView+BFWCopy.h
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BFWCopy)

#pragma mark - class methods

+ (NSBundle *)bundle;
+ (CGSize)sizeFromNib;

#pragma mark - instance methods

- (UIView *)viewFromNib;
- (UIView *)copyWithSubviews:(NSArray *)subviews
          includeConstraints:(BOOL)includeConstraints;
- (void)copySubviews:(NSArray *)subviews
  includeConstraints:(BOOL)includeConstraints;
- (void)copyConstraintsFromView:(UIView *)view;
- (void)copyPropertiesFromView:(UIView *)view;
- (void)copyAnimatablePropertiesFromView:(UIView *)fromView;

@end
