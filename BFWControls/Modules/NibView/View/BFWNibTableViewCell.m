//
//  BFWNibTableViewCell.m
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//
//  Replaces an instance of UITableViewCell in a storyboard or xib with the full subview structure from its own xib.
//

#import "BFWNibTableViewCell.h"
#import <BFWControls/BFWControls-Swift.h>

@implementation BFWNibTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        if (super.subviews.count == 0) { // Prevents loading nib in nib itself.
        if (super.tag != 1) {
            UIView *nibView = [super viewFromNib];
            nibView.tag = 1;
            nibView.frame = super.frame;
            self = (BFWNibTableViewCell *)nibView;
        }
    }
    return self;
}

@end
