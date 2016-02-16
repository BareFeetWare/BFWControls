//
//  UIView+BFWCopy.m
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

#import "UIView+BFWCopy.h"

@implementation UIView (BFWCopy)

#pragma mark - class methods

+ (NSBundle *)bundle
{
#if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
    NSBundle *bundle = [NSBundle bundleForClass:self];
#else
    NSBundle *bundle = [NSBundle mainBundle];
#endif
    return bundle;
}

+ (NSString *)nibName {
    NSString *fullClassName = NSStringFromClass(self);
    
    // Remove the <ProjectName>. prefix that Swift adds:
    NSString *className = [fullClassName componentsSeparatedByString:@"."].lastObject;
    
    return className;
}

+ (CGSize)sizeFromNib {
    NSArray *nibViews = [[self bundle] loadNibNamed:[self nibName] owner:nil options:nil];
    UIView *nibView = nibViews.firstObject;
    CGSize size = nibView.frame.size;
    return size;
}

#pragma mark - instance methods

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
            NSLayoutConstraint *copiedConstraint;
            copiedConstraint = [NSLayoutConstraint constraintWithItem:firstItem
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
    for (UILayoutConstraintAxis axis = UILayoutConstraintAxisHorizontal; axis <= UILayoutConstraintAxisVertical; axis += UILayoutConstraintAxisVertical - UILayoutConstraintAxisHorizontal) {
        [self setContentCompressionResistancePriority:[view contentCompressionResistancePriorityForAxis:axis] forAxis:axis];
        [self setContentHuggingPriority:[view contentHuggingPriorityForAxis:axis] forAxis:axis];
    }
}

- (UIView *)viewFromNib {
    UIView *nibView = self;
    BOOL hasAlreadyLoadedFromNib = self.subviews.count > 0; // TODO: More rubust test.
    if (!hasAlreadyLoadedFromNib) {
        NSString *nibName = [[self class] nibName];
        NSArray *nibViews = [[[self class] bundle] loadNibNamed:[[self class] nibName] owner:nil options:nil];
        nibView = nibViews.firstObject;
        if (![nibView isKindOfClass:[self class]]) {
            NSLog(@"**** error: first view in \"%@\" xib is class \"%@\", which is not the expected class \"%@\"", nibName, NSStringFromClass([nibView class]), NSStringFromClass([self class]));
            nibView = nil;
        }
        nibView.frame = self.frame;
        nibView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        [nibView copyConstraintsFromView:self];
    }
    return nibView;
}

- (instancetype)copy {
    UIView *copiedView = [[[self class] alloc] initWithFrame:self.frame];
    [copiedView copyPropertiesFromView:self];
    return copiedView;
}

- (UIView *)copyWithSubviews:(NSArray *)subviews
          includeConstraints:(BOOL)includeConstraints {
    UIView *copiedView = [self copy];
    [copiedView copySubviews:subviews
          includeConstraints:includeConstraints];
    return copiedView;
}

- (void)copySubviews:(NSArray *)subviews
  includeConstraints:(BOOL)includeConstraints
{
    for (UIView* subview in subviews) {
        UIView *copiedSubview = [[[subview class] alloc] initWithFrame:subview.frame];
        [self addSubview:copiedSubview];
        [copiedSubview copyPropertiesFromView:subview];
        if (includeConstraints) {
            [copiedSubview copyConstraintsFromView:subview];
        }
    }
}

- (void)copyPropertiesFromView:(UIView *)view {
    [self copyAnimatablePropertiesFromView:view];
    self.frame = view.frame;
    self.tag = view.tag;
    self.userInteractionEnabled = view.userInteractionEnabled;
}

- (void)copyAnimatablePropertiesFromView:(UIView *)view {
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
        self.numberOfLines = view.numberOfLines;
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
