//
//  BFWMorphStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

#import "BFWMorphStoryboardSegue.h"
#import "UIView+BFWCopy.h"

@implementation BFWMorphStoryboardSegue

#pragma mark - init

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        _duration = 5.0;
        _animationOptions = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

#pragma mark - accessors

- (UIView *)fromView {
    if (!_fromView) {
        _fromView = self.sourceViewController.view;
    }
    return _fromView;
}

#pragma mark - UIStoryboardSegue

- (void)perform {
    UIViewController *destinationViewController = self.destinationViewController;
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)destinationViewController;
        destinationViewController = navigationController.viewControllers.firstObject;
    }
    UIView *destinationVCView = destinationViewController.view;
    UIView *sourceVCView = self.sourceViewController.view;
    
    // Force frames to match constraints, in case misplaced.
    [destinationVCView setNeedsLayout];
    [destinationVCView layoutIfNeeded];
    
    destinationVCView.frame = sourceVCView.frame;
    
    UITableViewCell *cell = nil;
    if ([self.fromView isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell *)self.fromView;
        cell.selected = NO;
    }
    
    UIView *morphingView = nil;
    UIView *contentView = nil;
    BOOL isMorphingCopy = YES;
    if (isMorphingCopy) {
        // Create a copy of the view hierarchy for morphing, so the original is not changed.
        if (cell) {
            morphingView = [cell copyWithSubviews:nil
                               includeConstraints:NO];
            [morphingView copySubviews:cell.contentView.subviews
                    includeConstraints:NO];
        } else {
            morphingView = [self.fromView copyWithSubviews:self.fromView.subviews
                                        includeConstraints:NO];
        }
        [sourceVCView addSubview:morphingView];
        contentView = morphingView;
    } else {
        morphingView = self.fromView;
        contentView = cell.contentView;
        // TODO: finish
    }

    [UIView animateWithDuration:self.duration
                          delay:0.0
                        options:self.animationOptions
                     animations:^{
                         morphingView.frame = sourceVCView.bounds;
                         if (cell) {
                             contentView.frame = morphingView.bounds;
                         }
                         for (UIView *subview in contentView.subviews) {
                             UIView *destinationSubview = [destinationVCView subviewMatchingView:subview];
                             if (destinationSubview) {
                                 subview.frame = destinationSubview.frame;
                                 [subview copyAnimatablePropertiesFromView:destinationSubview];
                             } else {
                                 subview.alpha = 0.0;
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [self.sourceViewController.navigationController pushViewController:destinationViewController
                                                                                   animated:NO];
                         if (isMorphingCopy) {
                             [morphingView removeFromSuperview];
//                             morphingView.hidden = YES; // Keep it for reverse animation?
                         }
                     }
     ];
}

@end
