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

// Init in Objective C so it can return a replacement for self.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NibView *nibView = (NibView *)[(NibView *)self replacedByNibViewForInit];
        if (nibView != self) {
            nibView.frame = super.frame;
            self = nibView;
        }
    }
    return self;
}

@end
