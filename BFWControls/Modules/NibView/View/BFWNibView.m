//
//  BFWNibView.m
//
//  Created by Tom Brodhurst-Hill on 6/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWNibView.h"
#import <BFWControls/BFWControls-Swift.h>

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

@end
