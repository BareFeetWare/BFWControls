//
//  BFWMorphStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

#import "BFWMorphStoryboardSegue.h"

@implementation UIView (BFWMorph)

- (UIView *)subviewMatchingView:(UIView *)view {
    UIView *matchingSubview = nil;
    for (UIView *subview in self.subviews) {
        if (subview.tag != 0 && subview.tag == view.tag) {
            matchingSubview = subview;
        } else if ([subview isKindOfClass:[UILabel class]] && [view isKindOfClass:[UILabel class]]) {
            UILabel *possibleLabel = (UILabel *)subview;
            UILabel *subviewLabel = (UILabel *)view;
            if ([possibleLabel.text isEqualToString:subviewLabel.text]) {
                matchingSubview = subview;
            }
        }
        if (matchingSubview) {
            break;
        }
    }
    return matchingSubview;
}

- (UIView *)copyWithSubviews:(NSArray *)subviews {
    UIView *copiedView = [[UIView alloc] initWithFrame:self.frame];
    [copiedView copyPropertiesFromView:self];
    [copiedView copySubviews:subviews];
    return copiedView;
}

- (void)copySubviews:(NSArray *)subviews {
    for (UIView* subview in subviews) {
        UIView *copiedSubview = [[[subview class] alloc] initWithFrame:subview.frame];
        [self addSubview:copiedSubview];
        [copiedSubview copyPropertiesFromView:subview];
    }
}

- (void)copyPropertiesFromView:(UIView *)view {
    [self copyAnimatablePropertiesFromView:view];
    self.tag = view.tag;
    self.userInteractionEnabled = view.userInteractionEnabled;
}

- (void)copyAnimatablePropertiesFromView:(UIView *)fromView {
    self.frame = fromView.frame;
    self.alpha = fromView.alpha;
    if (fromView.backgroundColor) {
        self.backgroundColor = fromView.backgroundColor;
    }
    self.transform = fromView.transform;
}

@end

@implementation UILabel (BFWMorph)

- (void)copyPropertiesFromView:(UILabel*)view {
    [super copyPropertiesFromView:view];
    if ([view isKindOfClass:[UILabel class]]) {
        self.text = view.text;
        self.font = view.font;
        self.textColor = view.textColor;
        self.shadowColor = view.shadowColor;
        self.shadowOffset = view.shadowOffset;
        self.textAlignment = view.textAlignment;
        self.lineBreakMode = view.lineBreakMode;
        self.attributedText = view.attributedText;
        self.highlightedTextColor = view.highlightedTextColor;
        self.numberOfLines = view.enabled;
        self.adjustsFontSizeToFitWidth = view.adjustsFontSizeToFitWidth;
        self.baselineAdjustment = view.baselineAdjustment;
        self.minimumScaleFactor = view.minimumScaleFactor;
        self.preferredMaxLayoutWidth = view.preferredMaxLayoutWidth;
        self.highlighted = view.highlighted;
        self.enabled = view.enabled;
        self.tintColor = view.tintColor;
    }
}

@end

@implementation UIImageView (BFWMorph)

- (void)copyPropertiesFromView:(UIImageView*)view {
    [super copyPropertiesFromView:view];
    if ([view isKindOfClass:[UIImageView class]]) {
        self.image = view.image;
        self.highlightedImage = view.highlightedImage;
        self.highlighted = view.highlighted;
        self.animationImages = view.animationImages;
    }
}

@end

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
            morphingView = [cell copyWithSubviews:nil];
            [morphingView copySubviews:cell.contentView.subviews];
        } else {
            morphingView = [self.fromView copyWithSubviews:self.fromView.subviews];
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
