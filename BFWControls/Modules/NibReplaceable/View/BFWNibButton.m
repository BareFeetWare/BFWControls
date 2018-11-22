//
//  BFWNibButton.m
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 20/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

#import "BFWNibButton.h"
#import <BFWControls/BFWControls-Swift.h>

@implementation BFWNibButton

/// Init in Objective C so it can return a replacement for self.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [(NibButton *)self replacedByNibViewForInit];
}

@end
