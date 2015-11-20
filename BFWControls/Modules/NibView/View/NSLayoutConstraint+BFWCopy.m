//
//  NSLayoutConstraint+BFWCopy.m
//
//  Created by Tom Brodhurst-Hill on 20/11/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "NSLayoutConstraint+BFWCopy.h"

@implementation NSLayoutConstraint (BFWCopy)

- (NSLayoutConstraint *)constraintWithMultiplier:(CGFloat)multiplier
{
    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                              attribute:self.firstAttribute
                                              relatedBy:self.relation
                                                 toItem:self.secondItem
                                              attribute:self.secondAttribute
                                             multiplier:multiplier
                                               constant:self.constant];
    return constraint;
}

@end
