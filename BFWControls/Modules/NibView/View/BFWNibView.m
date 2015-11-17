//
//  BFWNibView.m
//
//  Created by Tom Brodhurst-Hill on 6/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWNibView.h"
#import "UIView+BFWCopy.h"

@implementation BFWNibView

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

- (CGSize)intrinsicContentSize {
    // TODO: cache per class
    return [self sizeFromNib];
}

@end
