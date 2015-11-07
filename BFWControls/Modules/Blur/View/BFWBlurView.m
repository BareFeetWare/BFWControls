//
//  BFWBlurView.m
//
//  Created by Tom Brodhurst-Hill on 13/10/2015.
//

#import "BFWBlurView.h"
#import "UIImageEffects.h"
#import "UIImage+BFW.h"

@interface BFWBlurView ()

@end

@implementation BFWBlurView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _blurRadius = 10.0;
}

#pragma mark - accessors

- (void)setBlurRadius:(CGFloat)blurRadius {
    _blurRadius = blurRadius;
    [self setNeedsDisplay];
}

- (UIImage *)blurredImage {
    UIImage *blurredImage = nil;
    NSArray *subviews = self.superview.subviews;
    NSUInteger selfIndex = [subviews indexOfObject:self];
    if (selfIndex > 0) {
        UIView *previousView = subviews[selfIndex - 1];
        UIImage *contentImage = [UIImage imageOfView:previousView
                                                size:self.bounds.size];
        blurredImage = [UIImageEffects imageByApplyingBlurToImage:contentImage
                                                       withRadius:self.blurRadius
                                                        tintColor:self.backgroundColor
                                            saturationDeltaFactor:1.8
                                                        maskImage:nil];
    }
    return blurredImage;
}

#pragma mark - UIView

#if TARGET_INTERFACE_BUILDER
// Dont draw anything, so it is transparent.
#else
- (void)drawRect:(CGRect)rect {
    UIImage *image = [self blurredImage];
    [image drawInRect:self.bounds];
}
#endif

@end
