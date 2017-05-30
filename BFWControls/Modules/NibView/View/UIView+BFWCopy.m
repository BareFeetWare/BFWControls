//
//  UIView+BFWCopy.m
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

#import "UIView+BFWCopy.h"

@implementation UIView (BFWCopy)

#pragma mark - class methods

+ (NSBundle *)bundle {
    BOOL isInterfaceBuilder;
#if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
    isInterfaceBuilder = YES;
#else
    isInterfaceBuilder = NO;
#endif
    NSBundle *bundle = isInterfaceBuilder
    ? [NSBundle bundleForClass:self]
    // TODO: Dynamic strings:
    : [self.moduleName isEqualToString:@"BFWControls"]
    ? [NSBundle bundleWithIdentifier:@"com.barefeetware.BFWControls"]
    : [NSBundle mainBundle];
    return bundle;
}

+ (NSArray *)classNameComponents {
    NSString *fullClassName = NSStringFromClass(self);
    return [fullClassName componentsSeparatedByString:@"."];
}

+ (NSString *)nibName {
    // Remove the <ProjectName>. prefix that Swift adds:
    return self.classNameComponents.lastObject;
}

+ (NSString *)moduleName {
    NSArray* components = self.classNameComponents;
    return components.count > 1
    ? components.firstObject
    : nil;
}

+ (CGSize)sizeFromNib {
    NSArray *nibViews = [[self bundle] loadNibNamed:[self nibName] owner:nil options:nil];
    UIView *nibView = nibViews.firstObject;
    CGSize size = nibView.frame.size;
    return size;
}

#pragma mark - instance methods

- (void)copyConstraintsFromView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints;
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
    NSString *nibName = [[self class] nibName];
    NSArray *nibViews = [[[self class] bundle] loadNibNamed:nibName owner:nil options:nil];
    UIView *nibView = nil;
    for (UIView *view in nibViews) {
        if ([view isKindOfClass:[self class]]) {
            nibView = view;
            break;
        }
    }
    if (!nibView) {
        NSLog(@"**** error: Could not find an instance of class \"%@\" in \"%@\" xib", NSStringFromClass([self class]), nibName);
    } else {
        [nibView copyPropertiesFromView:self];
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
        [copiedSubview copySubviews:subview.subviews
                 includeConstraints:includeConstraints];
    }
}

- (void)copyPropertiesFromView:(UIView *)view {
    [self copyAnimatablePropertiesFromView:view];
    self.frame = view.frame;
    self.tag = view.tag;
    self.userInteractionEnabled = view.userInteractionEnabled;
    self.hidden = view.hidden;
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
