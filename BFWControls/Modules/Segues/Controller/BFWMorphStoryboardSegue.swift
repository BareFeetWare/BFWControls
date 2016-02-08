//
//  BFWMorphStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

#import "BFWMorphStoryboardSegue.h"
#import "UIView+BFWCopy.h"

@interface BFWMorphStoryboardSegue : UIStoryboardSegue

@property (nonatomic, weak) IBOutlet UIView *fromView;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

@end

@implementation BFWMorphStoryboardSegue

#pragma mark - init

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        _duration = 1.0;
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

#pragma mark - move to another class

- (NSArray *)constraintsReplacingConstraints:(NSArray *)oldConstraints
                                       views:(NSArray *)oldViews
                                   withViews:(NSArray *)views
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint *oldConstraint in oldConstraints) {
        UIView *firstItem = oldConstraint.firstItem;
        UIView *secondItem = oldConstraint.secondItem;
        BOOL didReplace = NO;
        if ([oldViews containsObject:firstItem]) {
            firstItem = views[[oldViews indexOfObject:firstItem]];
            didReplace = YES;
        }
        if ([oldViews containsObject:secondItem]) {
            secondItem = views[[oldViews indexOfObject:secondItem]];
            didReplace = YES;
        }
        if (didReplace) {
            NSLayoutConstraint *constraint;
            constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                      attribute:oldConstraint.firstAttribute
                                                      relatedBy:oldConstraint.relation
                                                         toItem:secondItem
                                                      attribute:oldConstraint.secondAttribute
                                                     multiplier:oldConstraint.multiplier
                                                       constant:oldConstraint.constant];
            [constraints addObject:constraint];
        }
    }
    return [constraints copy];
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
                               includeConstraints:YES];
            [morphingView copySubviews:cell.contentView.subviews
                    includeConstraints:YES];
        } else {
            morphingView = [self.fromView copyWithSubviews:self.fromView.subviews
                                        includeConstraints:YES];
        }
        [sourceVCView addSubview:morphingView];
        contentView = morphingView;
    } else {
        morphingView = self.fromView;
        contentView = cell.contentView;
        // TODO: finish
    }

    // Add destination constraints, which will animate frames when layout is updated, inside animation block below.
    NSMutableArray *sourceConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *destinationConstraints = [[NSMutableArray alloc] init];
    NSMutableArray *sourceSubviews = [[NSMutableArray alloc] init];
    NSMutableArray *destinationSubviews = [[NSMutableArray alloc] init];
    [sourceConstraints addObjectsFromArray:sourceVCView.constraints];
    [destinationConstraints addObjectsFromArray:destinationVCView.constraints];
    [sourceSubviews addObject:sourceVCView]; // TODO: add top/bottom guides
    [destinationSubviews addObject:destinationVCView]; // TODO: add top/bottom guides
    for (UIView *sourceSubview in contentView.subviews) {
        UIView *destinationSubview = [destinationVCView subviewMatchingView:sourceSubview];
        if (destinationSubview && sourceSubview.tag == 1) { // testing using tag
            [sourceSubviews addObject:sourceSubview];
            [destinationSubviews addObject:destinationSubview];
            for (NSLayoutConstraint *constraint in sourceVCView.constraints) {
                if (constraint.firstItem == sourceSubview || constraint.secondItem == sourceSubview) {
                    [sourceConstraints addObject:constraint];
                }
            }
            for (NSLayoutConstraint *constraint in destinationVCView.constraints) {
                if (constraint.firstItem == destinationSubview || constraint.secondItem == destinationSubview) {
                    [destinationConstraints addObject:constraint];
                }
            }
        }
    }
    NSArray *constraints = [self constraintsReplacingConstraints:destinationConstraints
                                                           views:destinationSubviews
                                                       withViews:sourceSubviews];
    [NSLayoutConstraint deactivateConstraints:sourceConstraints];
    [NSLayoutConstraint activateConstraints:constraints];
    
    [UIView animateWithDuration:self.duration
                          delay:0.0
                        options:self.animationOptions
                     animations:^{
//                         morphingView.frame = sourceVCView.bounds;
                         [morphingView setNeedsLayout];
                         [morphingView layoutIfNeeded];
                         if (cell) {
                             contentView.frame = morphingView.bounds;
                         }
                         for (UIView *subview in contentView.subviews) {
                             UIView *destinationSubview = [destinationVCView subviewMatchingView:subview];
                             if (destinationSubview) {
//                                 subview.frame = destinationSubview.frame;
                                 
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
