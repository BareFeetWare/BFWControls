//
//  BFWMorphStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

#import "BFWMorphStoryboardSegue.h"
#import "UIView+BFW.h"

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
//    [destinationVCView setNeedsLayout];
//    [destinationVCView layoutIfNeeded];
//    
//    destinationVCView.frame = sourceVCView.frame;
    
    UITableViewCell *cell = nil;
    if ([self.fromView isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell *)self.fromView;
        cell.selected = NO;
    }
    
//    UIView *morphingView = nil;
    UIView *contentView = nil;
    contentView = sourceVCView;
//    BOOL isMorphingCopy = YES;
//    if (isMorphingCopy) {
//        // Create a copy of the view hierarchy for morphing, so the original is not changed.
//        if (cell) {
//            morphingView = [cell copyWithSubviews:nil];
//            [morphingView copySubviews:cell.contentView.subviews];
//        } else {
//            morphingView = [self.fromView copyWithSubviews:self.fromView.subviews];
//        }
//        [sourceVCView addSubview:morphingView];
//        contentView = morphingView;
//    } else {
//        morphingView = self.fromView;
//        contentView = cell.contentView;
//        // TODO: finish
//    }

    [self.sourceViewController.navigationController pushViewController:destinationViewController
                                                              animated:NO];

    [destinationVCView setNeedsLayout];
    [destinationVCView layoutIfNeeded];

    // Start destination views to be the same as the source views
    NSMutableArray *restoreViewArray = [[NSMutableArray alloc] init];
    NSMutableArray *restoreConstraintsArray = [[NSMutableArray alloc] init];
    for (UIView *destinationSubview in destinationVCView.subviews) {
        NSLog(@"destinationSubview.constraints = %@", destinationSubview.constraints);
        UIView *restoreView = [destinationSubview copyWithSubviews:nil includeConstraints:NO];
        [restoreViewArray addObject:restoreView];
        [restoreConstraintsArray addObject:destinationSubview.constraints];
        UIView *subview = [contentView subviewMatchingView:destinationSubview];
        if (subview) {
//            destinationSubview.frame = subview.frame;
            NSLog(@"removeConstraints:%@", destinationSubview.constraints);
            [destinationSubview removeConstraints:destinationSubview.constraints];
            [destinationSubview copyConstraintsFromView:subview];
            NSLog(@"copiedConstraints = %@", destinationSubview.constraints);
            [destinationSubview copyAnimatablePropertiesFromView:subview];
        }
    }

    [destinationVCView setNeedsLayout];
    [destinationVCView layoutIfNeeded];

    for (UIView *destinationSubview in destinationVCView.subviews) {
        NSUInteger index = [destinationVCView.subviews indexOfObject:destinationSubview];
        [destinationSubview removeConstraints:destinationSubview.constraints];
        [destinationSubview addConstraints:restoreConstraintsArray[index]];
//        UIView *restoreView = restoreViewArray[index];
//        [destinationSubview copyAnimatablePropertiesFromView:restoreView];
    }

    [UIView animateWithDuration:self.duration
                          delay:0.0
                        options:self.animationOptions
                     animations:^{
//                         morphingView.frame = sourceVCView.bounds;
//                         [destinationVCView setNeedsUpdateConstraints];
                         [destinationVCView setNeedsLayout];
                         [destinationVCView layoutIfNeeded];
//                         if (cell) {
//                             contentView.frame = morphingView.bounds;
//                         }
//                         for (UIView *subview in contentView.subviews) {
//                             UIView *destinationSubview = [destinationVCView subviewMatchingView:subview];
//                             if (destinationSubview) {
//                                 [subview copyAnimatablePropertiesFromView:destinationSubview];
//                             } else {
//                                 subview.alpha = 0.0;
//                             }
//                         }
                         for (UIView *destinationSubview in destinationVCView.subviews) {
                             NSUInteger index = [destinationVCView.subviews indexOfObject:destinationSubview];
//                             [destinationSubview removeConstraints:destinationSubview.constraints];
//                             [destinationSubview addConstraints:restoreConstraintsArray[index]];
                             UIView *restoreView = restoreViewArray[index];
                             [destinationSubview copyAnimatablePropertiesFromView:restoreView];
                         }
                     }
                     completion:^(BOOL finished) {
//                         if (isMorphingCopy) {
//                             [morphingView removeFromSuperview];
////                             morphingView.hidden = YES; // Keep it for reverse animation?
//                         }
                     }
     ];
}

@end
