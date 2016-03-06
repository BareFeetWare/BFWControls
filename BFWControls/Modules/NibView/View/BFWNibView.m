//
//  BFWNibView.m
//
//  Created by Tom Brodhurst-Hill on 6/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWNibView.h"
#import "UIView+BFWCopy.h"

@implementation BFWNibView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (super.subviews.count == 0) { // Prevents loading nib in nib itself.
            UIView *nibView = [super viewFromNib];
            nibView.frame = super.frame;
            self = (BFWNibView *)nibView;
        }
    }
    return self;
}

/// Replaces an instance of view in a storyboard or xib with the full subview structure from its own xib.
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    return [self viewFromNib];
}

#pragma mark - Caching

+ (NSMutableDictionary *)sizeForKeyDictionary {
    static NSMutableDictionary *sizeForKeyDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizeForKeyDictionary = [[NSMutableDictionary alloc] init];
    });
    return sizeForKeyDictionary;
}

#pragma mark - UIView

- (CGSize)intrinsicContentSize {
    CGSize size;
    NSString *key = NSStringFromClass([self class]);
    NSMutableDictionary *sizeForKeyDictionary = [[self class] sizeForKeyDictionary];
    NSString *sizeString = sizeForKeyDictionary[key];
    if (sizeString) {
        size = CGSizeFromString(sizeString);
    } else {
        size = [[self class] sizeFromNib];
        sizeForKeyDictionary[key] = NSStringFromCGSize(size);
    }
    return size;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // If storyboard instance is "default" (nil) then use the backgroundColor already set in xib or awakeFromNib (ie don't set it again).
    if (backgroundColor) {
        [super setBackgroundColor:backgroundColor];
    }
}

@end
