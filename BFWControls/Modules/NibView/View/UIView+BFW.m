//
//  UIView+BFW.m
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

#import "UIView+BFW.h"

@implementation UIView (BFW)

- (NSBundle *)bundle
{
#if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#else
    NSBundle *bundle = [NSBundle mainBundle];
#endif
    return bundle;
}

- (void)copyConstraintsFromView:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        id firstItem = constraint.firstItem;
        id secondItem = constraint.secondItem;
        if (firstItem) {
            if (firstItem == view) {
                firstItem = self;
            }
            if (secondItem == view) {
                secondItem = self;
            }
            NSLayoutConstraint *copiedConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                                attribute:constraint.firstAttribute
                                                                                relatedBy:constraint.relation
                                                                                   toItem:secondItem
                                                                                attribute:constraint.secondAttribute
                                                                               multiplier:constraint.multiplier
                                                                                 constant:constraint.constant];
            [self addConstraint:copiedConstraint];
        }
        else {
            NSLog(@"copyConstraintsFromView: error: firstItem == nil");
        }
    }
}

- (UIView *)viewFromNib {
    UIView *nibView = self;
    BOOL hasAlreadyLoadedFromNib = self.subviews.count > 0; // TODO: More rubust test.
    if (!hasAlreadyLoadedFromNib) {
        NSArray *nibViews = [self.bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        nibView = nibViews.firstObject;
        nibView.frame = self.frame;
        nibView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        [nibView copyConstraintsFromView:self];
    }
    return nibView;
}

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

- (UIView *)copyWithoutSubviews {
    UIView *copiedView = [[[self class] alloc] initWithFrame:self.frame];
    [copiedView copyPropertiesFromView:self];
    return copiedView;
}

- (UIView *)copyWithSubviews:(NSArray *)subviews {
    UIView *copiedView = [self copyWithoutSubviews];
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
    self.frame = view.frame;
}

- (void)copyAnimatablePropertiesFromView:(UIView *)view {
//    self.frame = view.frame;
    self.alpha = view.alpha;
    if (view.backgroundColor) {
        self.backgroundColor = view.backgroundColor;
    }
    self.transform = view.transform;
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
