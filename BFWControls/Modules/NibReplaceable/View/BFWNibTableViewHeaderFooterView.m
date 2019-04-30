//
//  BFWNibTableViewHeaderFooterView.m
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 30/4/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//

#import "BFWNibTableViewHeaderFooterView.h"
#import <BFWControls/BFWControls-Swift.h>

@implementation BFWNibTableViewHeaderFooterView

/// Init in Objective C so it can return a replacement for self.
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    return [(NibTableViewHeaderFooterView *)self replacedByNibViewForInit];
}

@end
